from openai import OpenAI
import pyodbc  # You can use pymssql if you prefer
import re

connection_string = (
    "DRIVER={ODBC Driver 18 for SQL Server};"
    "SERVER=SOFTCAWSRV;"
    "DATABASE=stocksniper;"
    "UID=StockSniper;"
    "PWD=^sT0cK$N!p3r#2023!;"
    "Encrypt=no;"
)


# Function to connect to the database
def connect_db():
    try:
        conn = pyodbc.connect(connection_string)
        return conn
    except Exception as e:
        print("Database connection failed:", e)
        return None


# Function to extract SQL statements from LLM response
def extract_sql(response):
    # Find all SQL queries enclosed in <SQL></SQL> tags
    pattern = r"<SQL>(.*?)</SQL>"
    matches = re.findall(pattern, response, re.DOTALL | re.IGNORECASE)
    sql_queries = [match.strip() for match in matches]
    return sql_queries if sql_queries else None


# Function to execute SQL query
def execute_sql(conn, query):
    try:
        cursor = conn.cursor()
        cursor.execute(query)
        # Fetch all results
        columns = [column[0] for column in cursor.description]
        rows = cursor.fetchall()
        # Convert results to a list of dictionaries
        results = [dict(zip(columns, row)) for row in rows]
        return results
    except Exception as e:
        return f"Error executing SQL query: {e}"


# Function to extract the final answer from LLM response
def extract_answer(response):
    # Find the final answer enclosed in <ANSWER></ANSWER> tags
    pattern = r"<ANSWER>(.*?)</ANSWER>"
    match = re.search(pattern, response, re.DOTALL | re.IGNORECASE)
    if match:
        answer = match.group(1).strip()
        return answer
    else:
        return None


# Main function
def main():
    # user_query = input("Please enter your query: ")
    user_query = "Which three top stock picks?"

    conn = connect_db()
    if not conn:
        return

    # Initialize conversation history
    conversation = [
        {
            "role": "system",
            "content": (
                "You are an assistant that helps generate SQL Server database queries in order to answer a user question. "
                "You do not know the database schema, first generate SQL queries to retrieve the necessary database schema information. "
                "The default schema is dbo. "
                "Provide all SQL queries enclosed within `<SQL></SQL>` tags. "
                "**Do not make up any data or assume query results.** "
                "**Wait for the actual query results before providing the final answer.** "
                "Once you have the actual query results, use them to formulate the final answer, "
                "and provide it enclosed within `<ANSWER></ANSWER>` tags, so the system can recognize it and stop processing."
            )
        },
        {"role": "user", "content": user_query}
    ]

    client = OpenAI()

    while True:
        # Send conversation to the LLM
        response = client.chat.completions.create(
            model="gpt-4",  # or another model you have access to
            messages=conversation,
        )

        assistant_message = response.choices[0].message.content
        print("Assistant:", assistant_message)

        # Check if the assistant has provided the final answer
        final_answer = extract_answer(assistant_message)
        if final_answer:
            # Assistant has provided the final answer
            print("Final Answer:", final_answer)
            break

        # Extract SQL queries from the assistant's response
        sql_queries = extract_sql(assistant_message)

        if sql_queries:
            for sql_query in sql_queries:
                print("Extracted SQL Query:", sql_query)

                # Optional: Add safety checks to prevent dangerous queries
                allowed_statements = ["select"]  # Include statements that are safe
                if not any(
                    sql_query.strip().lower().startswith(stmt)
                    for stmt in allowed_statements
                ):
                    print("Only SELECT statements are allowed for safety.")
                    break

                # Execute SQL query
                results = execute_sql(conn, sql_query)

                if isinstance(results, str) and results.startswith("Error"):
                    # If there was an error, inform the assistant
                    conversation.append(
                        {"role": "assistant", "content": assistant_message}
                    )
                    conversation.append(
                        {
                            "role": "user",
                            "content": f"The query failed with error: {results}",
                        }
                    )
                    break
                else:
                    # Send the results back to the assistant
                    conversation.append(
                        {"role": "assistant", "content": assistant_message}
                    )
                    # Convert results to string before sending
                    results_str = str(results)
                    conversation.append(
                        {
                            "role": "user",
                            "content": f"The query returned the following results: {results_str}",
                        }
                    )
        else:
            # No SQL query or final answer found
            print("No SQL query or final answer found in the assistant's response.")
            # Optionally, you can decide to prompt the assistant further or exit
            break


if __name__ == "__main__":
    main()
