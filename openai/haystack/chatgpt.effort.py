from haystack import Pipeline
from haystack.nodes import TextConverter, PDFToTextConverter, PreProcessor, PromptNode, SQLDatabase, SQLRetriever
from haystack.document_stores import InMemoryDocumentStore
from sqlalchemy import create_engine
import pyodbc

# Step 1: Set up the Document Store
document_store = InMemoryDocumentStore()

# Step 2: Initialize the SQLAlchemy engine for SQL Server
# Replace the connection string with your SQL Server details
connection_string = (
    "DRIVER={ODBC Driver 17 for SQL Server};"
    "SERVER=your_server_name;"
    "DATABASE=your_database_name;"
    "UID=your_username;"
    "PWD=your_password"
)
engine = create_engine(f"mssql+pyodbc:///?odbc_connect={connection_string}")

# Step 3: Create the SQL Retriever
sql_retriever = SQLRetriever(document_store=document_store, db_connection=engine)

# Step 4: Create the PromptNode for natural language processing
prompt_node = PromptNode(model_name_or_path="deepset/roberta-base-squad2", use_gpu=False)

# Step 5: Create the Pipeline
pipeline = Pipeline()
pipeline.add_node(component=sql_retriever, name="SQLRetriever", inputs=["Query"])
pipeline.add_node(component=prompt_node, name="PromptNode", inputs=["SQLRetriever"])

# Step 6: Load your database schema documents into the Document Store
# You would load your schema documents (tables, views, functions, etc.) here
documents = [
    {"content": "CREATE TABLE Customers (CustomerID int, CustomerName varchar(255), ContactName varchar(255), Country varchar(255));"},
    {"content": "CREATE TABLE Orders (OrderID int, CustomerID int, EmployeeID int, OrderDate date);"},
    # Add more schema documents as needed
]
document_store.write_documents(documents)

# Step 7: Define a function to handle the user query
def handle_user_query(query):
    # Run the query through the pipeline
    result = pipeline.run(query=query)
    return result['answers'][0].answer

# Step 8: Main loop to interact with the user
while True:
    user_query = input("Ask your question: ")
    if user_query.lower() in ["exit", "quit"]:
        break
    answer = handle_user_query(user_query)
    print(f"Answer: {answer}")
