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


model = "gpt-4o"
connection_string = "mssql+pyodbc://stocksniper:^sT0cK$N!p3r#2023!@softcawsrv:1433/stocksniper?driver=ODBC Driver 18 for SQL Server&Encrypt=no"
sql_top_k = 5

template = """
You are an MS SQL expert. 
Given an input question, first create a syntactically correct MS SQL query to run, then look at the results of the query and return the answer to the input question.
Unless the user specifies in the question a specific number of examples to obtain, query for at most {top_k} results using the TOP clause as per MS SQL. 
You can order the results to return the most informative data in the database.
Never query for all columns from a table. 
You must query only the columns that are needed to answer the question. 
Wrap each column name in square brackets ([]) to denote them as delimited identifiers.
Pay attention to use only the column names you can see in the tables below. 
Be careful to not query for columns that do not exist. 
Also, pay attention to which column is in which table.
Pay attention to use CAST(GETDATE() as date) function to get the current date, if the question involves "today".
Never generate a SQLQuery that performs an INSERT, DELETE or UPDATE operation on the database.

Use the following format:

Question: "Question here"
SQLQuery: "SQL Query to run"
SQLResult: "Result of the SQLQuery"
Answer: "Final answer here"

Only use the following tables:
{table_info}

Question: {input}
"""

llm = ChatOpenAI(model=model)
db = SQLDatabase.from_uri(connection_string)

table_info = db.get_table_info()
table_names = db.get_usable_table_names()

input_variables = ["input", "table_info", "top_k"]

sql_query_prompt = PromptTemplate(input_variables=input_variables, template=template)

chain = create_sql_query_chain(llm, db, prompt=sql_query_prompt)

# Example usage of the chain
input_question = "What table should I use to get financial data that indicates a company is doing well?"
inputs = {
    "input": input_question,
    "table_info": table_info,
    "top_k": sql_top_k
}

response = chain.invoke(inputs)
print("Generated SQL Query and Answer:")
print(response)
