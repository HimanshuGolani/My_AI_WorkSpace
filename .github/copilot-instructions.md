# Copilot Persistent Memory System v2
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
9. `.copilot-agents/memory/books-and-skills.md`
10. `.copilot-skills/react-ui-skills.md`
11. `.copilot-skills/react-native-skills.md`
12. `.copilot-skills/java-backend-skills.md`
13. `.copilot-skills/spring-ai-skills.md`

After completing all steps confirm with:
> "Memory restored. [Project name] loaded. Skills loaded: React Web, React Native, Java Backend, Spring AI. Ready."

---

## AGENT REGISTRY

### Primary Agents

| Agent | File | When |
|---|---|---|
| Cloud Migration | `agents/cloud-migration-agent.md` | AWS/Azure migration tasks |
| Java Migration | `agents/java-migration-agent.md` | Java version upgrades/downgrades |
| Spring Agent | `agents/spring-agent.md` | Spring Boot, Spring AI, Spring Cloud |
| Backend Agent | `agents/backend-agent.md` | General backend, APIs, DB, infra |
| React Web Agent | `agents/react-web-agent.md` | React web UI, components, state, styling |
| React Native Agent | `agents/react-native-agent.md` | Mobile UI, iOS, Android, Expo |
| Sanitization Agent | `agents/sanitization-agent.md` | Pre-commit/push secret and security scan |

### Sub-Agents (auto-fired — never triggered manually)

| Sub-Agent | File | Fires When |
|---|---|---|
| Dependency Analyzer | `agents/sub-agents/dependency-analyzer.md` | Any migration or new feature |
| Test Writer | `agents/sub-agents/test-writer.md` | Any code written or changed |
| Security Auditor | `agents/sub-agents/security-auditor.md` | Auth, data, APIs touched |
| API Designer | `agents/sub-agents/api-designer.md` | New endpoint or contract |
| DB Optimizer | `agents/sub-agents/db-optimizer.md` | DB schema or query change |
| Code Reviewer | `agents/sub-agents/code-reviewer.md` | After every code generation |

---

## SKILLS SYSTEM

Skills in `.copilot-skills/` are reference libraries of proven patterns, component recipes, and idioms.
They are loaded at boot and used automatically by the relevant primary agent.
The agent does NOT ask you to choose a skill — it applies the best one for the task.

---

## SANITIZATION RULES

The Sanitization Agent fires automatically:
- Before EVERY code generation output (inline scan)
- When user says `!scan` (manual trigger)
- Before any file touches auth, env vars, config, or CI/CD

The `.githooks/pre-commit` and `.githooks/pre-push` scripts enforce this at the git layer.
To activate hooks run: `git config core.hooksPath .githooks`

---

## MEMORY WRITE-BACK RULES

| Trigger | File |
|---|---|
| New architectural decision | `memory/decisions.md` |
| New coding pattern | `memory/conventions.md` |
| Bug found or resolved | `memory/known-issues.md` |
| Task completed | `memory/session-log.md` |
| Session growing long | `memory/agent-state.md` |
| New book/resource learned | `memory/books-and-skills.md` |

---

## GLOBAL RULES

- NEVER violate `memory/conventions.md`
- NEVER re-ask a decision already in `memory/decisions.md`
- ALWAYS check `memory/known-issues.md` before touching related code
- ALWAYS fire sub-agents automatically
- NEVER output code that contains secrets, API keys, or hardcoded credentials
- `!memory` → full memory summary
- `!agent <name>` → switch agent
- `!log` → append to session-log
- `!state` → print agent-state
- `!scan` → run sanitization agent on current output
- `!skills` → print loaded skills summary
- `!books` → print books and resources list