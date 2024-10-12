from haystack import Document

def get_schema_docs(file_path = "stocksniper.schema.sql"):
    with open(file_path, 'r', encoding='utf-8') as file:
        content = file.read()
    raw_documents = content.split('\nGO\n')
    documents = []
    for doc in raw_documents:
        if any(doc.startswith(prefix) for prefix in ["/******", "SET", "USE"]) or not doc.strip():
            continue
        documents.append(Document(content=doc.strip()))
    return documents
