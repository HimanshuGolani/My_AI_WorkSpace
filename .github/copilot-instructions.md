# Copilot Persistent Memory System
> Auto-loaded by GitHub Copilot every session. Do NOT rename this file.

---

## MANDATORY BOOT SEQUENCE

On every session start, before responding to ANYTHING, read these files in order:

1. `.copilot-agents/orchestrator.md`
2. `.copilot-agents/memory/project-context.md`
3. `.copilot-agents/memory/architecture.md`
4. `.copilot-agents/memory/conventions.md`
5. `.copilot-agents/memory/decisions.md`
6. `.copilot-agents/memory/known-issues.md`
7. `.copilot-agents/memory/session-log.md`
8. `.copilot-agents/memory/agent-state.md`

After completing all 8 steps confirm with:
> "Memory restored. [Project name] loaded. Last task: [last session-log entry]. Ready."

---

## AGENT REGISTRY

| Agent | File | When |
|---|---|---|
| Cloud Migration | `agents/cloud-migration-agent.md` | AWS/Azure migration tasks |
| Java Migration | `agents/java-migration-agent.md` | Java version upgrades/downgrades |
| Spring Agent | `agents/spring-agent.md` | Spring Boot, Spring AI, Spring Cloud |
| Backend Agent | `agents/backend-agent.md` | General backend, APIs, DB, infra |

## SUB-AGENTS (auto-fired — user never needs to trigger manually)

| Sub-Agent | File | Fires When |
|---|---|---|
| Dependency Analyzer | `agents/sub-agents/dependency-analyzer.md` | Any migration or new feature |
| Test Writer | `agents/sub-agents/test-writer.md` | Any code written or changed |
| Security Auditor | `agents/sub-agents/security-auditor.md` | Auth, data, APIs touched |
| API Designer | `agents/sub-agents/api-designer.md` | New endpoint or contract |
| DB Optimizer | `agents/sub-agents/db-optimizer.md` | DB schema or query change |
| Code Reviewer | `agents/sub-agents/code-reviewer.md` | After every code generation |

---

## MEMORY WRITE-BACK RULES

| Trigger | File |
|---|---|
| New architectural decision | `memory/decisions.md` |
| New coding pattern | `memory/conventions.md` |
| Bug found or resolved | `memory/known-issues.md` |
| Task completed | `memory/session-log.md` |
| Session growing long | `memory/agent-state.md` |

Session log format:
```
## [YYYY-MM-DD HH:MM] — summary
- Agent: primary agent used
- Sub-Agents Fired: list
- Task: what was done
- Outcome: result
- Next: next step
```

---

## GLOBAL RULES

- NEVER violate `memory/conventions.md`
- NEVER re-ask a decision already in `memory/decisions.md`
- ALWAYS check `memory/known-issues.md` before touching related code
- ALWAYS fire sub-agents automatically — never wait to be asked
- `!memory` → print full memory summary
- `!agent <name>` → switch agent
- `!log` → append to session-log.md
- `!state` → print agent-state.md
