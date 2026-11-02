# Skill Integration and Routing Policy

Version: 2.0.0  
Scope: the 16 skills in this package

## 1. Routing principles

1. Select the narrowest skill that owns the user's actual task.
2. Load only the skill needed for the current step; add a second domain skill only when the task crosses a real boundary.
3. A file-format skill owns file mechanics; a domain skill owns the meaning and correctness of the content.
4. Universal verification applies at completion, but it does not replace domain-specific verification.
5. A skill's review recommendation is not permission to modify files, publish content, order hardware, or perform physical tests.
6. If a referenced skill or tool is not installed/available, use a safe native fallback and disclose the limitation. Never pretend a missing integration ran.

## 2. Ownership matrix

| Skill | Owns | Does not own |
|---|---|---|
| `systematic-debugging` | Root-cause investigation for bugs and unexpected behavior | Domain-specific electrical/PCB certification; automatic permission to edit |
| `requesting-code-review` | Review of code changes/diffs and implementation quality | PCB layout review, academic peer review, visual design critique |
| `verification-before-completion` | Evidence gate before completion/success claims | Replacing the relevant test, DRC, CAM, statistical, or visual validation |
| `writing-plans` | Multi-step implementation plan for a defined specification | Product discovery/PRD authorship; permission to implement |
| `context-optimization` | Token/context budget, retrieval scope, masking/caching/partitioning concepts | Durable handoff summary wording or file-based offloading |
| `context-compression` | Summaries and handoff state preserving decisions, evidence, and next actions | Generic token optimization or storing raw artifacts without summarizing |
| `filesystem-context` | Durable files, scratchpads, large-output offloading, selective retrieval | Cross-session semantic memory or conversation-summary design |
| `word-document-workflow` | DOCX/DOTX structure, editing, rendering, validation | Scientific or product-content correctness |
| `pdf-document-workflow` | PDF extraction, OCR, page operations, forms, creation, validation | Scientific or product-content correctness |
| `spreadsheet-workflow` | XLSX/CSV mechanics, formulas, workbook integrity | Research statistical interpretation or electronic component suitability |
| `presentation-workflow` | PPTX structure, editable elements, slide export validation | Creative direction, narrative quality, factual validation |
| `embedded-firmware-reviewer` | Firmware architecture, MCU behavior, peripherals, timing, electrical interfaces, bring-up evidence | Detailed PCB artwork/fabrication audit |
| `kicad-pcb-reviewer` | Schematics, PCB layout, footprints, stackup, power paths, DFM/DFA and CAM | Firmware source-code review |
| `academic-manuscript-reviewer` | Research design, data provenance, statistics, calculations, references, manuscript claims | General PRD or marketing content |
| `technical-prd-architect` | Product discovery, requirements, architecture proposals, PRD quality and traceability | Actual implementation or final engineering certification |
| `creative-content-reviewer` | Visual communication, creative direction, copy, branding, presentation critique | Low-level PPTX file operations or technical truth validation |

## 3. Cross-skill routing examples

### Firmware bug on a physical device
1. `systematic-debugging` for evidence-led root-cause investigation.
2. `embedded-firmware-reviewer` for MCU, code, timing, peripheral, and electrical interface analysis.
3. `verification-before-completion` before stating the issue is fixed.
4. `requesting-code-review` only if a code diff is available and a code review is useful.

### PCB manufacturing or schematic issue
1. `kicad-pcb-reviewer` is primary.
2. `embedded-firmware-reviewer` only if the issue crosses into firmware or MCU behavior.
3. `verification-before-completion` before declaring ERC/DRC/CAM or validation passed.

### Academic manuscript in DOCX/PDF with data workbook
1. `academic-manuscript-reviewer` owns methodology, calculations, references, and claims.
2. `word-document-workflow` or `pdf-document-workflow` handles file operations.
3. `spreadsheet-workflow` handles workbook mechanics.
4. `verification-before-completion` applies to final claims.
Do not let a file-format skill silently rewrite scientific claims.

### PRD with DOCX and XLSX deliverables
1. `technical-prd-architect` owns product and technical requirements.
2. `word-document-workflow` creates or edits the DOCX.
3. `spreadsheet-workflow` handles requirements matrices, BOMs, and risk registers.
4. `writing-plans` is for the subsequent implementation plan, not a replacement for the PRD.

### Presentation or LinkedIn content
1. `creative-content-reviewer` owns content, audience, tone, visual direction, and design critique.
2. `presentation-workflow` handles PPTX structure and rendering.
3. `word-document-workflow` handles supporting DOCX documents if required.

### Long coding task
1. `writing-plans` creates an implementation plan from an agreed specification.
2. `systematic-debugging` is activated if unexpected behavior appears.
3. `requesting-code-review` reviews code changes when a suitable review path exists.
4. `verification-before-completion` is the final evidence gate.
5. `context-compression` and `filesystem-context` are used only when the task genuinely needs handoff or durable offloading.

## 4. Context skill boundaries

- Use `context-optimization` to decide what context should be retrieved, masked, compacted, or kept stable.
- Use `context-compression` to write a concise but faithful handoff summary. Preserve exact identifiers, values, decisions, errors, and unresolved risks.
- Use `filesystem-context` when the durable artifact itself should live in files and be retrieved selectively.
- Do not load all three automatically. Choose the operation that matches the current failure or goal.

## 5. Domain approval and safety precedence

The following boundaries remain in force even when another skill recommends action:
- Firmware source edits require explicit approval when the domain skill says so.
- Flashing, erasing, changing fuses, energizing a power stage, moving a motor, battery/BMS changes, or high-voltage/high-current tests require separate approval.
- PCB source edits, rule changes, CAM release, supplier upload, and board orders require their own approval.
- Manuscript edits and changes to research data/results require approval.
- Existing creative source files and live publishing require approval.
- File-format conversion or output creation must not overwrite source files by default.

## 6. Completion reporting

When reporting completion, state:
- which skill/domain workflow was used;
- files changed or created;
- commands/checks actually run;
- evidence and results;
- checks not run or blocked;
- unresolved assumptions and next action.

Never infer that a task is complete merely because a file exists or an agent reports success.
