# Source and License Notes

## Included upstream skills

### obra/superpowers
- Repository: https://github.com/obra/superpowers
- Selected skills: `systematic-debugging`, `requesting-code-review`, `verification-before-completion`, `writing-plans`
- Upstream repository license: MIT.
- Installer copies the repository `LICENSE` file into each selected skill directory as `UPSTREAM-LICENSE.txt`.
- The installer records the resolved source ref and archive SHA-256 in the installation log.

### muratcankoylan/Agent-Skills-for-Context-Engineering
- Repository: https://github.com/muratcankoylan/Agent-Skills-for-Context-Engineering
- Selected skills: `context-optimization`, `context-compression`, `filesystem-context`
- Upstream repository license: MIT.
- Installer copies the repository `LICENSE` file into each selected skill directory as `UPSTREAM-LICENSE.txt`.
- The installer records the resolved source ref and archive SHA-256 in the installation log.

## Anthropic document skills excluded

The upstream `anthropics/skills` repository states that `docx`, `pdf`, `pptx`, and `xlsx` are source-available rather than open source. Their individual `LICENSE.txt` files contain additional restrictions against retaining copies outside Anthropic services, copying/reproducing, derivative works, and redistribution.

This package therefore does **not** download or copy those four skill folders. Instead it includes four independently authored interoperability skills:
- `word-document-workflow`
- `pdf-document-workflow`
- `spreadsheet-workflow`
- `presentation-workflow`

They preserve the requested file-operation capabilities but are not Anthropic's official skills and are not derived from their source.

Official references:
- Anthropic repository README: https://github.com/anthropics/skills
- DOCX license: https://github.com/anthropics/skills/blob/main/skills/docx/LICENSE.txt
- PDF license: https://github.com/anthropics/skills/blob/main/skills/pdf/LICENSE.txt
- XLSX license: https://github.com/anthropics/skills/blob/main/skills/xlsx/LICENSE.txt
- PPTX license: https://github.com/anthropics/skills/blob/main/skills/pptx/LICENSE.txt

## Important distinction

The package installer downloads upstream source folders when run. It does not execute downloaded scripts. Read each skill's supporting files before invoking any helper script. Archive SHA-256 is a transport/integrity record; it is not a cryptographic signature or independent proof of upstream authorship.
