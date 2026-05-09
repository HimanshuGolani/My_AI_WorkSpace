# Architecture Decision Record (ADR)

<!-- One entry per decision. Newest on top. -->

---

## [SETUP] Memory System Initialized
**Status:** Accepted
**Context:** Copilot loses context on every IDE restart
**Decision:** Persistent markdown-based memory system in .copilot-agents/
**Consequences:** All agents read memory on boot; all tasks write back to memory
**Alternatives Considered:** External DB (too complex), Copilot built-in memory (unreliable)

---
