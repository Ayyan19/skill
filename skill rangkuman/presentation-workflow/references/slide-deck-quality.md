# Slide Deck Structure and Quality Reference

## File structure
A PPTX is an OOXML package containing presentation relationships, slide XML, layouts, masters, themes, media, notes, and possibly embedded workbooks or objects.

## Preservation risks
- Rebuilding a deck from extracted text can lose animations, transitions, embedded media, notes, custom layouts, and chart editability.
- Fonts may substitute on systems without the original typefaces.
- Different renderers may wrap text and position objects differently.
- Rendering is necessary to validate visual layout; XML inspection alone cannot prove the deck looks correct.

## Validation sampling
For a large deck, inspect title slide, section dividers, dense data slides, slides with tables/charts, and the final slide. Inspect every slide when the output is high stakes or the brief requires full QA.


## Official documentation
- python-pptx: https://python-pptx.readthedocs.io/en/latest/
