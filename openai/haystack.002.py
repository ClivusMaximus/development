# https://haystack.deepset.ai/tutorials/27_first_rag_pipeline

from haystack import Document
from haystack.document_stores.in_memory import InMemoryDocumentStore
from haystack.components.embedders import SentenceTransformersDocumentEmbedder
from haystack.components.embedders import SentenceTransformersTextEmbedder
from haystack.components.retrievers.in_memory import InMemoryEmbeddingRetriever
from haystack.components.builders import PromptBuilder
from haystack.components.generators import OpenAIGenerator
from haystack import Pipeline

def get_docs(file_path):
    with open(file_path, 'r', encoding='utf-8') as file:
        content = file.read()
    raw_documents = content.split('\nGO\n')
    documents = []
    for doc in raw_documents:
        if any(doc.startswith(prefix) for prefix in ["/******", "SET", "USE"]) or not doc.strip():
            continue
        documents.append(Document(content=doc.strip()))
    return documents

file_path = "stocksniper.schema.sql"

# fetch the data
docs = get_docs(file_path)

# document store
document_store = InMemoryDocumentStore()
# document embedder (for documents)
doc_embedder = SentenceTransformersDocumentEmbedder(model="sentence-transformers/all-MiniLM-L6-v2")
# download the document embedding model
doc_embedder.warm_up()

# create embeddings
docs_with_embeddings = doc_embedder.run(docs)
# write the embeddings to the document store
document_store.write_documents(docs_with_embeddings["documents"])

# text embedder (for user query)
text_embedder = SentenceTransformersTextEmbedder(model="sentence-transformers/all-MiniLM-L6-v2")

# document retriever
retriever = InMemoryEmbeddingRetriever(document_store)

# template prompt
template = """
Given the following SQL Server database schema, answer the question.

Context:
{% for document in documents %}
    {{ document.content }}
{% endfor %}

Question: {{question}}
Answer:
"""
prompt_builder = PromptBuilder(template=template)

# the generator using OpenAI's GPT-3.5-turbo model
generator = OpenAIGenerator(model="gpt-3.5-turbo")

# the pipeline

basic_rag_pipeline = Pipeline()
# Add components to your pipeline
basic_rag_pipeline.add_component("text_embedder", text_embedder)
basic_rag_pipeline.add_component("retriever", retriever)
basic_rag_pipeline.add_component("prompt_builder", prompt_builder)
basic_rag_pipeline.add_component("llm", generator)

# Now, connect the components to each other
basic_rag_pipeline.connect("text_embedder.embedding", "retriever.query_embedding")
basic_rag_pipeline.connect("retriever", "prompt_builder.documents")
basic_rag_pipeline.connect("prompt_builder", "llm")

basic_rag_pipeline.draw("002.rag.pipeline.png")

question = "What SQL would I use to select the best three stocks to pick?"
response = basic_rag_pipeline.run({"text_embedder": {"text": question}, "prompt_builder": {"question": question}})
print(response["llm"]["replies"][0])

yaml = basic_rag_pipeline.dumps
print(yaml)
