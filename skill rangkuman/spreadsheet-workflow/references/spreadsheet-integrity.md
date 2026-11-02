# Spreadsheet Integrity Reference

## Data integrity
- Treat IDs and codes as text where leading zeros matter.
- Preserve date/time timezone assumptions and Excel date serial semantics.
- Distinguish blank, zero, NA, and not-applicable values.
- Record source, transformation, filters, aggregation, and row counts.

## Formula integrity
- Inspect formulas and cached values separately.
- `openpyxl` does not calculate formulas; use a compatible spreadsheet engine for recalculation.
- Check formula consistency down ranges and look for hard-coded values mixed into formula columns.
- Do not rewrite formulas without understanding workbook dependencies.

## Workbook feature risks
Macros, external links, pivot caches, slicers, charts, data validation, conditional formatting, and advanced Excel functions may not survive every library round trip. Test with the intended target application.


## Official documentation
- openpyxl: https://openpyxl.readthedocs.io/en/stable/
