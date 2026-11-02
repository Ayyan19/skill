---
name: spreadsheet-workflow
description: Create and audit XLSX workbooks and CSV data.
compatibility: Hermes Agent and OpenCode; Windows-friendly workflow
metadata:
  version: "1.0.0"
  origin: "original interoperability skill"
---

# Spreadsheet Workflow

## Mission
Handle workbook and tabular-data operations. Preserve formulas, values, units, sheet structure, formatting, validations, named ranges, and source provenance. Domain interpretation belongs to the relevant reviewer.

## When to activate
- Create, read, inspect, revise, compare, or validate `.xlsx`, `.xlsm`, `.xltx`, `.csv`, or `.tsv`.
- Build calculation sheets, BOMs, schedules, data dictionaries, and structured tables.
- Diagnose formula errors, broken references, missing data, or workbook integrity issues.

## Routing boundaries
- `academic-manuscript-reviewer` owns research-data provenance, statistics, and scientific interpretation.
- `kicad-pcb-reviewer` owns electronic BOM technical suitability.
- `technical-prd-architect` owns product cost assumptions and requirement matrices.
- This skill owns workbook mechanics and spreadsheet integrity.

## Workflow
1. Identify workbook format, sheet names, hidden sheets, named ranges, tables, filters, merged cells, validations, charts, external links, and macros.
2. Preserve the original. For `.xlsm`, retain VBA content and verify the chosen library supports the required features; do not save as `.xlsx` accidentally.
3. Inspect formulas and cached values separately. A library that writes formulas may not calculate them.
4. Preserve units, precision, date systems, identifiers with leading zeros, and explicit missing-value semantics.
5. For transformations, document input columns, output columns, row counts, filters, deduplication, and aggregation rules.
6. Use formulas only where they improve auditability; document formula logic and avoid unexplained hard-coded constants.
7. Check formula references, circular references, error cells, broken external links, and inconsistent formulas down columns.
8. Recalculate with Excel or LibreOffice only if available and approved; do not claim recalculation when only formulas were written.
9. Validate workbook structure, key formulas, row/column counts, and representative values after saving.
10. Report all changes, calculation status, and limitations.

## Quality gates
- No unintended row/column loss, reordering, or truncation.
- Identifiers, dates, numeric precision, and units preserved.
- Formula cells remain formulas; cached values are not mistaken for fresh results.
- Data validation, conditional formatting, tables, charts, and named ranges preserved where required.
- No hidden sheet or macro content silently removed.
- Output opens and recalculates in a target spreadsheet application when this is part of acceptance.

## Dependencies and limitations
- `openpyxl` is suitable for many `.xlsx` workflows but does not calculate formulas.
- CSV has no formatting, formulas, sheets, or data types; preserve a schema/data dictionary separately.
- Excel-specific features may not round-trip through non-Excel libraries.
- Formula compatibility differs among Excel, LibreOffice, and other engines.

## Output
Provide a new workbook or data file by default, plus a concise audit note stating formula recalculation and compatibility status.
