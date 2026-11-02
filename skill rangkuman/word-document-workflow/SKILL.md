---
name: word-document-workflow
description: Create and validate Word DOCX documents.
compatibility: Hermes Agent and OpenCode; Windows-friendly workflow
metadata:
  version: "1.0.0"
  origin: "original interoperability skill"
---

# Word Document Workflow

## Mission
Handle `.docx` and `.dotx` document operations. Own file structure and document-production mechanics, not the subject-matter correctness of the content.

## When to activate
- Create, read, inspect, revise, compare, or validate a Word document.
- Preserve tables, headings, sections, headers/footers, page numbering, images, and styles during edits.
- Produce a DOCX deliverable from an approved brief or source.

## Routing boundaries
- `technical-prd-architect` owns PRD content and requirement quality.
- `academic-manuscript-reviewer` owns research methodology, citations, and scientific claims.
- `creative-content-reviewer` owns visual communication and editorial direction.
- This skill owns DOCX structure, styles, layout mechanics, and file validation.

## Workflow
1. Identify the input file, target output, requested scope, and whether the original may be edited.
2. Inspect document structure before editing: sections, paragraph styles, tables, headers/footers, images, fields, comments, tracked changes, hyperlinks, and embedded objects.
3. Preserve the original. Write a new version unless the user explicitly authorizes in-place replacement.
4. Use `python-docx` for supported structural edits. Do not assume it preserves every advanced Word feature.
5. Keep semantic styles (Title, Heading 1/2/3, Normal, Caption, List) instead of formatting every paragraph manually.
6. For tables, preserve header meaning, column order, units, and data. Avoid splitting key rows across pages where practical.
7. Preserve images and captions; do not silently substitute or flatten editable elements.
8. If tracked changes, comments, complex fields, SmartArt, or advanced layout features are material, inspect OOXML or use Microsoft Word/LibreOffice where available. State tool limitations.
9. Validate the resulting DOCX by reopening it, checking paragraph/table counts and critical content, and rendering to PDF or images when a renderer is available.
10. Report exactly what changed, what was preserved, what could not be validated, and the output path.

## Quality gates
- No missing sections, headings, table rows, images, or required text.
- Page size, margins, orientation, section breaks, headers/footers, and page numbers match the brief.
- Styles are consistent and accessible; heading hierarchy is logical.
- No obvious clipping, blank pages, broken links, or overflow in rendered output.
- Source facts and numbers are not rewritten unless requested and supported.

## Dependencies and limitations
- `python-docx` handles common DOCX structures; it is not a full Microsoft Word rendering engine.
- LibreOffice may be used for headless rendering/conversion if installed.
- Do not claim visual validation if only the DOCX package structure was inspected.
- Do not promise preservation of unsupported OOXML features without a round-trip test.

## Output
Provide the requested DOCX plus a concise validation note. Include an edit summary and unresolved limitations. Do not overwrite the source by default.
