# Dependencies and Platform Notes

## Base requirements
- Windows 10/11 with Windows PowerShell 5.1 or PowerShell 7.
- Internet access to `codeload.github.com` and `api.github.com` during installation of the seven upstream skills.
- No administrator privileges should be needed for per-user installation.
- Hermes Agent and OpenCode installed separately.

## Skill-specific optional dependencies

| Skill | Possible dependencies | Notes |
|---|---|---|
| `systematic-debugging` | Git, project test runner, shell | Supporting scripts may assume Unix utilities; inspect before use on Windows. |
| `requesting-code-review` | Git; host subagent capability is optional | If subagents are unavailable, use the local review fallback. |
| `verification-before-completion` | Project build/test/lint tools | The skill does not install project dependencies. |
| `writing-plans` | Filesystem access; native execution workflow | Optional Superpowers execution skills are not included. |
| `context-optimization` | Runtime-specific context/cache features | Advice is conceptual unless the host exposes the relevant controls. |
| `context-compression` | None beyond host context access | Keep exact facts and unresolved risks in handoff notes. |
| `filesystem-context` | Filesystem read/write tools | Use least-privilege paths and do not offload secrets unnecessarily. |
| `word-document-workflow` | Python `python-docx`; optional LibreOffice | `python-docx` does not render Word pages. |
| `pdf-document-workflow` | `pypdf`, `PyMuPDF`, `pdfplumber`, ReportLab; optional Tesseract/Poppler | OCR and PDF rendering require separate tools. |
| `spreadsheet-workflow` | Python `openpyxl`; optional LibreOffice or Microsoft Excel | `openpyxl` does not calculate formulas. |
| `presentation-workflow` | Python `python-pptx`; optional LibreOffice or Microsoft PowerPoint | `python-pptx` does not fully render slides or preserve every advanced animation feature. |
| `embedded-firmware-reviewer` | Target-specific SDK/toolchain and datasheets | Skill installation does not install firmware toolchains. |
| `kicad-pcb-reviewer` | KiCad or relevant EDA/CAM tools | Skill installation does not run ERC/DRC or CAM. |
| `academic-manuscript-reviewer` | Source datasets, DOI/metadata access, analysis tools | Skill installation does not validate every citation or recalculate research data. |
| `technical-prd-architect` | Optional document/spreadsheet tools | Markdown is the canonical source unless another format is requested. |
| `creative-content-reviewer` | Optional image/slide/document tools | Skill installation does not render or publish content. |

## Hermes and OpenCode discovery

The installer uses native per-user directories:
- Hermes: `%USERPROFILE%\.hermes\skills\<skill-id>\SKILL.md`
- OpenCode: `%USERPROFILE%\.config\opencode\skills\<skill-id>\SKILL.md`

It does not change `config.yaml` or `opencode.json`. For Hermes, the seven upstream skills are installed by `hermes skills install` from pinned raw GitHub URLs, followed by `hermes skills audit`; the nine original/local skills are copied to the profile skill directory.

If Hermes runs inside WSL, Windows `%USERPROFILE%` is not the Linux `$HOME`; install from the WSL environment or adapt the destination to the WSL home directory. Do not assume the Windows installer has configured the WSL instance.
