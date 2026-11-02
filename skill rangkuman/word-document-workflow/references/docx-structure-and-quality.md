# DOCX Structure and Quality Reference

## Common OOXML parts
- `word/document.xml`: main document body.
- `word/styles.xml`: paragraph and character styles.
- `word/numbering.xml`: list definitions.
- `word/header*.xml` and `word/footer*.xml`: section headers and footers.
- `word/media/`: embedded images.
- `word/comments.xml` and revision markup: comments and tracked changes where present.

## Practical inspection
Use a DOCX-aware library for structure, then render when visual correctness matters. ZIP/XML inspection can reveal missing parts but cannot prove that Word renders the document correctly.

## Preservation risks
- Rebuilding a document from extracted plain text can lose section layout, page breaks, fields, comments, tracked changes, and anchored objects.
- Saving through a library that does not support a feature may drop or alter that feature.
- Never assume identical rendering across Microsoft Word, LibreOffice, and web viewers.


## Official documentation
- python-docx: https://python-docx.readthedocs.io/en/latest/
