# https://haystack.deepset.ai/tutorials/40_building_chat_application_with_function_calling

from haystack.dataclasses import ChatMessage
from haystack.components.generators.chat import OpenAIChatGenerator
from haystack.components.generators.utils import print_streaming_chunk
from haystack import Pipeline, Document
from haystack.document_stores.in_memory import InMemoryDocumentStore
from haystack.components.writers import DocumentWriter
from haystack.components.embedders import SentenceTransformersDocumentEmbedder
from haystack.components.embedders import SentenceTransformersTextEmbedder
from haystack.components.retrievers.in_memory import InMemoryEmbeddingRetriever
from haystack.components.builders import PromptBuilder
from haystack.components.generators import OpenAIGenerator
import gradio as gr
import json

messages = [
    ChatMessage.from_system(
        "Always respond in German even if some input data is in other languages."
    ),
    ChatMessage.from_user("What's Natural Language Processing? Be brief."),
]

chat_generator = OpenAIChatGenerator(model="gpt-3.5-turbo")
chat_generator.run(messages=messages)

chat_generator = OpenAIChatGenerator(
    model="gpt-3.5-turbo", streaming_callback=print_streaming_chunk
)
response = chat_generator.run(messages=messages)


documents = [
    Document(content="My name is Jean and I live in Paris."),
    Document(content="My name is Mark and I live in Berlin."),
    Document(content="My name is Giorgio and I live in Rome."),
    Document(content="My name is Marta and I live in Madrid."),
    Document(content="My name is Harry and I live in London."),
]

document_store = InMemoryDocumentStore()

indexing_pipeline = Pipeline()
indexing_pipeline.add_component(
    instance=SentenceTransformersDocumentEmbedder(
        model="sentence-transformers/all-MiniLM-L6-v2"
    ),
    name="doc_embedder",
)
indexing_pipeline.add_component(
    instance=DocumentWriter(document_store=document_store), name="doc_writer"
)

indexing_pipeline.connect("doc_embedder.documents", "doc_writer.documents")

indexing_pipeline.draw("004.indexing.pipeline.png")

indexing_pipeline.run({"doc_embedder": {"documents": documents}})


template = """
Answer the questions based on the given context.

Context:
{% for document in documents %}
    {{ document.content }}
{% endfor %}
Question: {{ question }}
Answer:
"""
rag_pipe = Pipeline()
rag_pipe.add_component(
    "embedder",
    SentenceTransformersTextEmbedder(model="sentence-transformers/all-MiniLM-L6-v2"),
)
rag_pipe.add_component(
    "retriever", InMemoryEmbeddingRetriever(document_store=document_store)
)
rag_pipe.add_component("prompt_builder", PromptBuilder(template=template))
rag_pipe.add_component("llm", OpenAIGenerator(model="gpt-3.5-turbo"))
rag_pipe.connect("embedder.embedding", "retriever.query_embedding")
rag_pipe.connect("retriever", "prompt_builder.documents")
rag_pipe.connect("prompt_builder", "llm")

rag_pipe.draw("004.rag.pipeline.png")

query = "Where does Mark live?"
rag_pipe.run({"embedder": {"text": query}, "prompt_builder": {"question": query}})


def rag_pipeline_func(query: str):
    result = rag_pipe.run(
        {"embedder": {"text": query}, "prompt_builder": {"question": query}}
    )
    return {"reply": result["llm"]["replies"][0]}


WEATHER_INFO = {
    "Berlin": {"weather": "mostly sunny", "temperature": 7, "unit": "celsius"},
    "Paris": {"weather": "mostly cloudy", "temperature": 8, "unit": "celsius"},
    "Rome": {"weather": "sunny", "temperature": 14, "unit": "celsius"},
    "Madrid": {"weather": "sunny", "temperature": 10, "unit": "celsius"},
    "London": {"weather": "cloudy", "temperature": 9, "unit": "celsius"},
}


def get_current_weather(location: str):
    if location in WEATHER_INFO:
        return WEATHER_INFO[location]

    # fallback data
    else:
        return {"weather": "sunny", "temperature": 21.8, "unit": "fahrenheit"}


tools = [
    {
        "type": "function",
        "function": {
            "name": "rag_pipeline_func",
            "description": "Get information about where people live",
            "parameters": {
                "type": "object",
                "properties": {
                    "query": {
                        "type": "string",
                        "description": "The query to use in the search. Infer this from the user's message. It should be a question or a statement",
                    }
                },
                "required": ["query"],
            },
        },
    },
    {
        "type": "function",
        "function": {
            "name": "get_current_weather",
            "description": "Get the current weather",
            "parameters": {
                "type": "object",
                "properties": {
                    "location": {
                        "type": "string",
                        "description": "The city and state, e.g. San Francisco, CA",
                    }
                },
                "required": ["location"],
            },
        },
    },
]

messages = [
    ChatMessage.from_system(
        "Don't make assumptions about what values to plug into functions. Ask for clarification if a user request is ambiguous."
    ),
    ChatMessage.from_user("Can you tell me where Mark lives?"),
]

chat_generator = OpenAIChatGenerator(
    model="gpt-3.5-turbo", streaming_callback=print_streaming_chunk
)
response = chat_generator.run(messages=messages, generation_kwargs={"tools": tools})

print(f"Response: {response}")

## Parse function calling information
function_call = json.loads(response["replies"][0].content)[0]
function_name = function_call["function"]["name"]
function_args = json.loads(function_call["function"]["arguments"])
print("Function Name:", function_name)
print("Function Arguments:", function_args)

## Find the correspoding function and call it with the given arguments
available_functions = {
    "rag_pipeline_func": rag_pipeline_func,
    "get_current_weather": get_current_weather,
}
function_to_call = available_functions[function_name]
function_response = function_to_call(**function_args)
print("Function Response:", function_response)

function_message = ChatMessage.from_function(
    content=json.dumps(function_response), name=function_name
)
messages.append(function_message)

response = chat_generator.run(messages=messages, generation_kwargs={"tools": tools})

print(f"Response: {response}")
