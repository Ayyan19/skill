# Superpowers Standalone Portability Patch

This package installs only four selected skill directories from `obra/superpowers`; it does not install the full Superpowers plugin, bootstrap prompt, or the rest of the Superpowers skill set.

The installer applies the following small compatibility edits to the downloaded local copies:

1. `systematic-debugging`: the optional `test-driven-development` skill is not part of the selected 16. Use the host's native test framework to create a minimal failing reproduction; do not pretend the missing skill is installed. The included `verification-before-completion` skill is available as a standalone skill.
2. `requesting-code-review`: use a subagent only if the host exposes a suitable independent subagent. Otherwise conduct a scoped in-session review using the bundled `code-reviewer.md` template and disclose that it was not an independent review. Code-review findings do not grant permission to modify source files.
3. `writing-plans`: `brainstorming`, `using-git-worktrees`, `subagent-driven-development`, and `executing-plans` are not part of this selected set. Use a concise requirements/discovery step and the host's native sequential workflow. Use a worktree only when appropriate and authorized. Do not block a plan solely because an optional Superpowers execution skill is absent.
4. Cross-references to `superpowers:verification-before-completion` are changed to the standalone skill ID `verification-before-completion`.

The patch does not change the underlying root-cause, code-review, verification, or planning methods. It only makes unavailable integrations explicit and preserves the host's approval and safety boundaries.
