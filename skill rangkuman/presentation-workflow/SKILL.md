---
name: presentation-workflow
description: Create and validate PowerPoint PPTX decks.
compatibility: Hermes Agent and OpenCode; Windows-friendly workflow
metadata:
  version: "1.0.0"
  origin: "original interoperability skill"
---

# Presentation Workflow

## Mission
Handle PowerPoint file operations and slide-deck structure. Storytelling, visual direction, and communication quality belong to the relevant content skill.

## When to activate
- Create, read, inspect, revise, or validate `.pptx` and `.potx`.
- Reorganize slides, edit text, add charts/tables/images, or apply a theme.
- Prepare a presentation for screen, projection, or print/PDF delivery.

## Routing boundaries
- `creative-content-reviewer` owns narrative, art direction, visual hierarchy, brand consistency, and critique.
- `technical-prd-architect` owns technical PRD content and requirement accuracy.
- `academic-manuscript-reviewer` owns scientific claims and research evidence.
- This skill owns PPTX structure, editable slide elements, and export validation.

## Workflow
1. Confirm audience, purpose, slide count, aspect ratio, brand constraints, required content, and whether the deck is a new artifact or a revision.
2. Inventory the deck: slide count, layouts, masters, themes, notes, charts, tables, images, embedded media, and hidden slides.
3. Preserve the source deck. Create a new revision unless in-place editing is explicitly approved.
4. Use editable text, shapes, tables, and charts where appropriate; avoid flattening all content into images unless requested.
5. Maintain consistent slide size, margins, typography, alignment, colors, and reusable layouts.
6. Keep each slide focused on one primary message. Preserve source data and units in charts.
7. Verify image aspect ratios, crop, transparency, and resolution. Keep logos and supplied assets faithful.
8. Check speaker notes, hyperlinks, chart data, alt text, reading order, and slide titles when required.
9. Reopen the PPTX and render to PDF/images when a renderer is available. Inspect representative and high-risk slides for clipping, overflow, font substitution, and broken media.
10. Report structural checks separately from visual rendering checks.

## Quality gates
- No unintended slide loss, reorder, duplicate, or hidden slide changes.
- Slide dimensions and layout match the brief.
- Text and objects remain editable where expected.
- No clipped text, off-canvas objects, stretched images, or broken fonts in rendered output.
- Charts preserve source values, labels, units, and legends.
- Accessibility and reading order are checked when requested.

## Dependencies and limitations
- `python-pptx` supports common PowerPoint operations but is not a full PowerPoint rendering engine.
- LibreOffice or Microsoft PowerPoint may be used for rendering/round-trip checks if installed.
- Complex animations, transitions, embedded objects, and some chart features may not round-trip through Python libraries.
- Do not claim visual QA if no slide render was inspected.

## Output
Provide the PPTX and, if requested, a PDF preview. State what was rendered and what remains unverified.
