# PDF Processing Reference

## Select the method by document type
- Born-digital text PDF: text extraction and layout-aware inspection.
- Scanned PDF: page images plus OCR; retain page-level references.
- Tables: use table-aware extraction and verify against rendered pages.
- Forms: inspect form field dictionaries and appearance streams.
- Mixed/image-heavy: inspect selected page images rather than relying only on extracted text.

## Integrity checks
- Compare page counts before and after.
- Check page boxes and rotation.
- Inspect first, middle, last, and every critical page after transformation.
- Confirm output opens in an independent PDF reader when possible.
- Record whether metadata, bookmarks, links, annotations, and form fields were preserved.


## Official documentation
- pypdf: https://pypdf.readthedocs.io/en/stable/
- PyMuPDF: https://pymupdf.readthedocs.io/en/latest/
- ReportLab: https://docs.reportlab.com/
