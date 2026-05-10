# Architecture Decision Record (ADR)

---

## [SETUP] Memory System v2 Initialized
**Status:** Accepted
**Context:** Copilot loses context on IDE restart; needed frontend agents and secret scanning
**Decision:** Extended system with React Web, React Native, Sanitization agents, Skills library, and git hooks
**Consequences:** Full-stack coverage; secret scanning at every output and commit
**Alternatives Considered:** Third-party secret scanning only (too late in cycle)

---