# https://haystack.deepset.ai/tutorials/01_basic_qa_pipeline

import re
import json
import logging
import pydantic
import pyodbc
from typing import Any, Dict, List, Optional
from pydantic import BaseModel
from pydantic import ValidationError
from colorama import Fore
from haystack import component
from haystack import Pipeline
from haystack.components.builders import PromptBuilder
from haystack.components.generators import OpenAIGenerator

logging.basicConfig()
logging.getLogger("canals.pipeline.pipeline").setLevel(logging.DEBUG)


@component
class SQLExecutor:
    def __init__(self, connection_string: str):
        self.connection_string = connection_string
        self.conn = None

    def connect(self):
        try:
            self.conn = pyodbc.connect(self.connection_string)
            print("Connection established.")
        except Exception as e:
            print(f"Failed to connect to the database: {e}")
            return {"result_error": str(e)}

    # Define the component output
    @component.output_types(result_data=Dict[str, Any], result_error=Optional[str])
    def run(self, llm_replies: List[str]):

        print(f"llm_replies:={llm_replies}")

        if self.conn is None:
            print("connecting...")
            self.connect()
            if self.conn is None:
                print("failed to connect")
                return {
                    "result_error": "Could not establish a connection to the database."
                }
            print("connected")

        try:
            llm_reply = llm_replies[0]
            match = re.search(r"<sql>(.*?)</sql>", llm_reply, re.DOTALL)
            if match:
                sql_statement = match.group(1).strip()
                print(f"sql_statement: {sql_statement}")
            else:
                return {"result_error:": "No SQL statement found in the response."}

            cursor = self.conn.cursor()
            cursor.execute(sql_statement)
            if cursor.description is not None:
                print("got results...")
                columns = [column[0] for column in cursor.description]
                results = [dict(zip(columns, row)) for row in cursor.fetchall()]
                cursor.close()
                return {"result_data": results}
            else:
                print("no results")
                cursor.commit()
                cursor.close()
                return {"result_data": None}
        except Exception as e:
            print(f"error: {e}")
            return {"result_error": str(e)}

    def __del__(self):
        if self.conn:
            self.conn.close()
            print("Connection closed.")


connection_string = (
    "DRIVER={ODBC Driver 18 for SQL Server};"
    "SERVER=SOFTCAWSRV;"
    "DATABASE=stocksniper;"
    "UID=StockSniper;"
    "PWD=^sT0cK$N!p3r#2023!;"
    "Encrypt=no;"
)

sql_executor = SQLExecutor(connection_string)

prompt_template = """
Use this query: {{query}}.
Create SQL Server compatible sql statements which will be executed against a sql server database to return data from the database.
When you generate sql statements, ensure they can be easily identified be placing the sql statement between the tags <sql> and </sql>.
Answer the query completely and accurately.
{% if result_error %}
  You submitted a query that returned an error: {{result_error}}.
  Create a sql statement to schema information or data from the appropiates tables.
  You may only create sql statements that select data or schema information.
  You may not perform updates, inserts, or deletes.
{% endif %}
{% if result_data %}
  You submitted a query that returned results: {{result_data}}.
  Check the results to see if they provide the information necessary to answer the query completely and accurately.
  If you cannot fully answer the query, refine the sql statemnt or create a new sql statemnt and try again.
  You may only create sql statements that select data.
  You may not perform updates, inserts, or deletes.
{% endif %}
"""

prompt_builder = PromptBuilder(template=prompt_template)

# generator = OpenAIGenerator()
generator = OpenAIGenerator(model="gpt-4")

pipeline = Pipeline(max_loops_allowed=10)

# Add components to your pipeline
pipeline.add_component(instance=prompt_builder, name="prompt_builder")
pipeline.add_component(instance=generator, name="llm")
pipeline.add_component(instance=sql_executor, name="sql_executor")

# Now, connect the components to each other
pipeline.connect("prompt_builder", "llm")
pipeline.connect("llm", "sql_executor")
# If a component has more than one output or input, explicitly specify the connections:
pipeline.connect("sql_executor.result_data", "prompt_builder.result_data")
pipeline.connect("sql_executor.result_error", "prompt_builder.result_error")

pipeline.draw("006.auto.correct.pipeline.png")

user_query = """find the best stocks in which to invest"""
result = pipeline.run({"prompt_builder": {"query": user_query}})

valid_reply = result["sql_executor"]["result_data"]
print(valid_reply)
