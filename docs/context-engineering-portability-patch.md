# Context Engineering Standalone Portability Patch

This bundle installs only `context-optimization`, `context-compression`, and `filesystem-context` from the larger MIT-licensed collection.

The upstream skills refer to sibling skills such as `context-fundamentals`, `context-degradation`, `self-managed-context`, `multi-agent-patterns`, `latent-briefing`, `evaluation`, `memory-systems`, and `tool-design`. Those siblings are intentionally not included in this 16-skill selection.

The installer appends a portability note to each selected context skill:
- If a referenced sibling is not installed, use a host-native fallback and disclose the limitation.
- Do not imply that a missing sibling skill was loaded.
- Do not invent context utilization, token counts, cache-hit rates, or measured quality results.
- Treat numeric thresholds and performance targets as heuristics to evaluate, not guarantees.
- Preserve active debugging errors, exact values, user constraints, evidence, and unresolved risks during compression.
- Use only host capabilities that actually exist; skills do not create KV-cache controls, context masking hooks, or compaction APIs.
