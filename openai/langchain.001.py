## pip install --upgrade langchain
## pip install --upgrade langchain-core
## pip install --upgrade langchain-openai
## pip install --upgrade langchain-community
## pip install --upgrade faiss-gpu
## pip install --upgrade faiss-cpu
## pip install --upgrade pyodbc
## pip install --upgrade sqlalchemy

## https://python.langchain.com/docs/tutorials/

import re
from langchain_community.utilities import SQLDatabase
from langchain_openai import ChatOpenAI
from langchain.chains import create_sql_query_chain
from langchain_community.tools.sql_database.tool import QuerySQLDataBaseTool
from langchain.schema.runnable import RunnableLambda
from langchain.chains.base import Chain
from operator import itemgetter
from langchain_core.output_parsers import StrOutputParser
from langchain_core.prompts import PromptTemplate
from langchain_core.runnables import RunnablePassthrough, RunnableBranch


def condition_has_sql(inputs):
    condition_has_sql_output = inputs.get("has_sql", False)
    print(f"condition_has_sql_output: {condition_has_sql_output}")
    return condition_has_sql_output


# Create a chain that handles the case when no SQL is present
def handle_no_sql(inputs):
    print("Handling non-SQL response.")
    # Set default values for 'query' and 'result'
    inputs["query"] = "No SQL query generated."
    inputs["result"] = "N/A"
    return inputs


def extract_sql_and_print(inputs):
    response = inputs.get("response", "")
    # Match content inside ```sql\n ... \n```
    matches = re.findall(r"```sql\n(.*?)```", response, re.DOTALL)
    if matches:
        sql_query = matches[0].strip()
        has_sql = True
    else:
        # If no code block, try to extract any SELECT statement
        sql_match = re.search(r"(SELECT.*)", response, re.DOTALL | re.IGNORECASE)
        if sql_match:
            sql_query = sql_match.group(1).strip()
            has_sql = True
        else:
            sql_query = ""  # No SQL query found
            has_sql = False
    print("Generated SQL Query:\n", sql_query)
    inputs["query"] = sql_query
    inputs["has_sql"] = has_sql
    return inputs


def print_and_pass(inputs):
    print("Output from LLM:\n\n", inputs)
    return inputs


def format_prompt(query_result):
    answer_prompt_input = {
        "question": query_result.get("question",""), 
        "query": query_result.get("query",""), 
        "result": query_result.get("result","")
        }
    return answer_prompt.format(**answer_prompt_input)


answer_prompt = PromptTemplate.from_template(
    """
Given the following user question, corresponding SQL query, and SQL result, answer the user question.
Question: {question}
SQL Query: {query}
SQL Result: {result}
Answer: 
"""
)

llm = ChatOpenAI(model="gpt-4o")
db = SQLDatabase.from_uri(
    "mssql+pyodbc://stocksniper:^sT0cK$N!p3r#2023!@softcawsrv:1433/stocksniper?driver=ODBC Driver 18 for SQL Server&Encrypt=no"
)

table_info = db.get_usable_table_names()

write_query = create_sql_query_chain(llm, db)
execute_query = QuerySQLDataBaseTool(db=db)
extract_sql = RunnableLambda(func=extract_sql_and_print)
output_to_console = RunnableLambda(func=print_and_pass)
handle_no_sql_chain = RunnableLambda(func=handle_no_sql)


def execute_query_and_update(inputs):
    query = inputs.get("query", "")
    query_result = execute_query.run({"query": query})
    inputs["result"] = query_result
    return inputs


# execute_query_branch = itemgetter("query") | execute_query
execute_query_branch = RunnableLambda(func=execute_query_and_update)

handle_no_sql_chain = RunnableLambda(func=handle_no_sql)

runnable_branch = RunnableBranch(
    (condition_has_sql, execute_query_branch), handle_no_sql_chain
)

runnable_pass_through = RunnablePassthrough.assign(
    question=itemgetter("question")
).assign(response=write_query)

chain = (
    runnable_pass_through
    | extract_sql
    | runnable_branch
    | output_to_console
    | RunnableLambda(format_prompt)
    | print_and_pass
    | llm
    | StrOutputParser()
)

result = chain.invoke({"question": "Please tell me a little about the database?"})

print("\n\nresult:\n", result)
