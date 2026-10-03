# AuditQuest — Question Paper Quality Auditor

An editable local web app for auditing question papers. It extracts questions and marks, verifies numbering, flags likely duplicate questions, classifies Bloom's taxonomy levels, maps provisional course outcomes, measures syllabus coverage, and saves downloadable reports.

## Run it

1. Open a terminal in this folder.
2. Install dependencies: `pip install -r requirements.txt`
3. Start the app: `uvicorn app:app --host 127.0.0.1 --port 8011`
4. Open `http://127.0.0.1:8011` in a browser.

## Paper format it understands

Use numbered questions such as `1. Explain normalization. (10 marks)` or `Q2) Design an ER diagram. [15]`. Add a line such as `Total Marks: 100` to validate the total. A text-based PDF, DOCX, TXT, or Markdown file can be uploaded.

For syllabus coverage, use one unit per line in the optional field, for example:

```
Unit 1: database concepts, DBMS, data models
Unit 2: relational model, ER diagram, normalization
Unit 3: SQL queries, joins, transactions
```

The local duplicate and mapping logic is deliberately transparent and heuristic-based. For production, replace these functions in `app.py` with an embedding model and your institution's CO/syllabus data.
