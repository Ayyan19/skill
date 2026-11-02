---
name: pdf-document-workflow
description: Inspect, transform, OCR, and validate PDF files.
compatibility: Hermes Agent and OpenCode; Windows-friendly workflow
metadata:
  version: "1.0.0"
  origin: "original interoperability skill"
---

# PDF Document Workflow

## Mission
Handle PDF file operations: extraction, inspection, creation, page manipulation, OCR, form handling, and output validation. Subject-matter review remains with the relevant domain skill.

## When to activate
- Read, search, extract, compare, or summarize PDF contents.
- Create a PDF from approved content.
- Merge, split, rotate, reorder, or extract pages.
- Inspect scanned PDFs, forms, annotations, metadata, or embedded images.

## Routing boundaries
- `academic-manuscript-reviewer` owns scientific interpretation and reference validity.
- `technical-prd-architect` owns product specification content.
- `creative-content-reviewer` owns visual critique and communication design.
- This skill owns PDF processing and output integrity.

## Workflow
1. Determine whether the PDF is born-digital, scanned, mixed, encrypted, form-based, or image-heavy.
2. Record page count, page sizes, rotation, metadata, encryption status, and whether text is selectable.
3. For text extraction, choose a parser suitable for layout/tables; do not treat extraction order as guaranteed reading order.
4. For scanned pages, use OCR only when available. Identify OCR language and preserve the original scan.
5. For page manipulation, preserve page order and orientation unless the user asks otherwise.
6. For form filling, distinguish AcroForm fields from static page artwork. Confirm field names and appearance behavior.
7. For PDF creation, use a reproducible renderer or PDF library. Embed suitable fonts and preserve Unicode text.
8. For merging or splitting, write to a new output file and compare input/output page counts and page order.
9. Reopen the output and inspect metadata, text extraction, page geometry, and visual samples.
10. Report whether OCR, visual inspection, form appearance, signatures, and accessibility were actually validated.

## Quality gates
- Page count and order match the requested operation.
- No missing, duplicated, blank, or unexpectedly rotated pages.
- Text is searchable when expected; OCR confidence limitations are disclosed.
- Fonts and Unicode characters render correctly.
- Links, bookmarks, annotations, form fields, and metadata are preserved where required.
- Digital signatures are not represented as valid after modification unless revalidation proves so.

## Dependencies and limitations
- Common options include `pypdf`, `PyMuPDF`, `pdfplumber`, ReportLab, and Tesseract OCR.
- OCR and table extraction are probabilistic; verify critical numbers against page images.
- Editing a signed PDF can invalidate its signature.
- Do not claim PDF/A, PDF/UA, accessibility, or signature compliance without the corresponding validation.

## Output
Create a new file by default. State the exact operations performed and any checks not run.
