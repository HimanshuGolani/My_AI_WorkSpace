# ============================================================
# Copilot Memory System v2 — Windows PowerShell Setup
# Save as SETUP.ps1 in your project root, then run:
#   Right-click SETUP.ps1 -> "Run with PowerShell"
#   OR in PowerShell terminal: .\SETUP.ps1
# If blocked by execution policy, run this first:
#   Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
# ============================================================

$ErrorActionPreference = "Stop"
Write-Host "Creating Copilot Memory System v2..." -ForegroundColor Cyan

# ---------- CREATE ALL FOLDERS ----------
$folders = @(
    ".github",
    ".copilot-agents\agents\sub-agents",
    ".copilot-agents\memory",
    ".copilot-skills",
    ".githooks"
)
foreach ($f in $folders) {
    New-Item -ItemType Directory -Force -Path $f | Out-Null
}

# Helper function to write files cleanly
function Write-File($path, $content) {
    [System.IO.File]::WriteAllText(
        (Join-Path (Get-Location) $path),
        $content,
        [System.Text.Encoding]::UTF8
    )
    Write-Host "  Created: $path" -ForegroundColor Green
}

# ============================================================
# .github/copilot-instructions.md
# ============================================================
Write-File ".github\copilot-instructions.md" @'
# Copilot Persistent Memory System v2
> Auto-loaded by GitHub Copilot every session. Do NOT rename this file.

## MANDATORY BOOT SEQUENCE
On every session start, before responding to ANYTHING, read these files in order:
1. .copilot-agents/orchestrator.md
2. .copilot-agents/memory/project-context.md
3. .copilot-agents/memory/architecture.md
4. .copilot-agents/memory/conventions.md
5. .copilot-agents/memory/decisions.md
6. .copilot-agents/memory/known-issues.md
7. .copilot-agents/memory/session-log.md
8. .copilot-agents/memory/agent-state.md
9. .copilot-agents/memory/books-and-skills.md
10. .copilot-skills/react-ui-skills.md
11. .copilot-skills/react-native-skills.md
12. .copilot-skills/java-backend-skills.md
13. .copilot-skills/spring-ai-skills.md

After completing all steps confirm with:
"Memory restored. [Project name] loaded. Skills loaded: React Web, React Native, Java Backend, Spring AI. Ready."

## AGENT REGISTRY

| Agent              | File                               | When                        |
|--------------------|------------------------------------|-----------------------------|
| Cloud Migration    | agents/cloud-migration-agent.md    | AWS/Azure migration         |
| Java Migration     | agents/java-migration-agent.md     | Java version upgrades       |
| Spring Agent       | agents/spring-agent.md             | Spring Boot, Spring AI      |
| Backend Agent      | agents/backend-agent.md            | General backend, APIs, DB   |
| React Web Agent    | agents/react-web-agent.md          | React UI, components, state |
| React Native Agent | agents/react-native-agent.md       | Mobile UI, iOS, Android     |
| Sanitization Agent | agents/sanitization-agent.md       | Secret scan before commit   |

Sub-Agents (auto-fired, never manual):
| Sub-Agent           | File                                     |
|---------------------|------------------------------------------|
| Dependency Analyzer | agents/sub-agents/dependency-analyzer.md |
| Test Writer         | agents/sub-agents/test-writer.md         |
| Security Auditor    | agents/sub-agents/security-auditor.md    |
| API Designer        | agents/sub-agents/api-designer.md        |
| DB Optimizer        | agents/sub-agents/db-optimizer.md        |
| Code Reviewer       | agents/sub-agents/code-reviewer.md       |

## SANITIZATION RULES
Sanitization Agent fires automatically before every code output.
Git hooks enforce at commit and push level.
Activate hooks: git config core.hooksPath .githooks

## MEMORY WRITE-BACK
- New decision         -> memory/decisions.md
- New pattern          -> memory/conventions.md
- Bug found/resolved   -> memory/known-issues.md
- Task completed       -> memory/session-log.md
- Session growing long -> memory/agent-state.md
- New book/resource    -> memory/books-and-skills.md

## COMMANDS
!memory  -> full memory summary
!agent <name> -> switch agent
!log     -> append to session-log
!state   -> print agent-state
!scan    -> run sanitization agent
!skills  -> print loaded skills
!books   -> print books list

## GLOBAL RULES
- NEVER violate memory/conventions.md
- NEVER re-ask a decision in memory/decisions.md
- ALWAYS check memory/known-issues.md before touching related code
- ALWAYS fire sub-agents automatically
- NEVER output code containing secrets, API keys, or hardcoded credentials
'@

# ============================================================
# .copilot-agents/orchestrator.md
# ============================================================
Write-File ".copilot-agents\orchestrator.md" @'
# Orchestrator Agent v2

## Identity
Master Orchestrator. Routes every task to the correct primary agent, auto-fires sub-agents,
enforces memory write-back, and runs sanitization on all output.

## Task Routing Logic
IF task involves AWS/Azure/cloud migration      -> cloud-migration-agent.md
IF task involves Java version upgrade/downgrade -> java-migration-agent.md
IF task involves Spring Boot / Spring AI        -> spring-agent.md
IF task involves backend APIs, DB, services     -> backend-agent.md
IF task involves React web UI / components      -> react-web-agent.md
IF task involves React Native / mobile UI       -> react-native-agent.md
IF task involves commit scan / secret check     -> sanitization-agent.md
IF task is ambiguous                            -> ask ONE question then route

## Automatic Sub-Agent Execution Order
1. Dependency Analyzer
2. Security Auditor
3. API Designer (if interface changing)
4. DB Optimizer (if DB involved)
5. Test Writer
6. Code Reviewer
7. Sanitization Agent (blocking gate on ALL final output)

## Sanitization Gate
Before presenting ANY generated code, pass through Sanitization Agent.
If CRITICAL finding: DO NOT output code. Fix first, then output.

## Context Compression (when session is long)
1. Summarize -> session-log.md
2. New patterns -> conventions.md
3. New decisions -> decisions.md
4. Progress -> agent-state.md
5. Notify user: "Context saved. Safe to restart IDE."
'@

# ============================================================
# AGENTS
# ============================================================
Write-File ".copilot-agents\agents\cloud-migration-agent.md" @'
# Cloud Migration Agent
Scope: AWS to Azure migrations, focus on Lambda to Azure Functions

## Identity
Senior cloud architect. Expert in AWS Lambda, API Gateway, S3, DynamoDB, SQS, SNS, IAM
and Azure equivalents: Functions, API Management, Blob Storage, Cosmos DB, Service Bus, Entra ID.

## PRE-TASK QUESTIONNAIRE (MANDATORY - ask ALL before writing any code)
1. SCOPE: Which AWS services in scope? Any OUT of scope?
2. LAMBDA: How many functions? Runtimes? Triggers? Cold start tolerance? Layers? Extensions?
3. DATA: Databases? Data migration in scope? Stateful services?
4. SECURITY: Lambdas in VPC? IAM roles? Secrets Manager? Auth mechanism?
5. SLA: Daily volume? Availability SLA? Blue-green required? Rollback plan?
6. CI/CD: Current pipeline? IaC tool? (CloudFormation/Terraform/CDK)
7. CONSTRAINTS: Target Azure region? Compliance? Cost ceiling? Deadline?

## AWS to Azure Conversion Table
Lambda Handler        -> Azure Function (HttpTrigger/QueueTrigger/TimerTrigger)
DynamoDB SDK          -> Cosmos DB SDK
S3 SDK                -> Azure Blob Storage SDK
SQS SDK               -> Service Bus SDK
Secrets Manager       -> Azure Key Vault
Cognito               -> Azure AD B2C / Entra External ID
CloudWatch Logs       -> Azure Monitor / App Insights
EventBridge           -> Azure Event Grid
IAM Roles             -> Azure RBAC + Managed Identities
CloudFormation        -> Bicep / Terraform (Azure provider)

## Migration Phases
Phase 1: Audit and Mapping
Phase 2: IaC Translation
Phase 3: Code Migration
Phase 4: Testing (auto-fires Test Writer)
Phase 5: Cutover Plan

## Sub-Agents Auto-Fired
Dependency Analyzer, Security Auditor, Test Writer, Code Reviewer, Sanitization Agent
'@

Write-File ".copilot-agents\agents\java-migration-agent.md" @'
# Java Migration Agent
Scope: Java version migrations. Primary: Java 8 to Java 21 and reverse.

## Identity
Senior Java architect. Expert in Java 8, 11, 17, 21.

## PRE-TASK QUESTIONNAIRE (MANDATORY)
1. Current Java version? Target version?
2. Single or multi-module Maven/Gradle?
3. Share pom.xml or build.gradle dependencies.
4. Spring Boot version? Hibernate/JPA version?
5. Pain points (yes/no): sun.* APIs, javax.* namespace, heavy reflection,
   SecurityManager, finalize(), RMI, Nashorn, standalone JAXB/JAX-WS/JAX-RS
6. Build tool version? CI pipeline? Docker base image?
7. Test framework? Coverage %? Tests using reflection?
8. JVM flags? Cloud provider?
9. Hard deadline? Can dependencies be upgraded? Zero-downtime required?

## Java 8 to Java 21 Migration Table
new Thread(r).start()      -> Thread.ofVirtual().start(r)
Anonymous Runnable          -> Lambda / method reference
Optional.get() unchecked    -> Optional.orElseThrow()
Date / Calendar             -> java.time.* (LocalDate, Instant)
javax.*                     -> jakarta.* (Spring Boot 3+)
StringBuffer in loops       -> StringBuilder / String.formatted()
finalize()                  -> Cleaner API
Raw types                   -> Typed generics
instanceof cast             -> Pattern matching instanceof
Switch statement            -> Switch expression
Multiline String concat     -> Text blocks
Thread pool for IO          -> Virtual Threads
Simple POJOs/DTOs           -> Records
Enum hierarchies            -> Sealed classes

## Java 21 to Java 8 Downgrade
LOSSY operation. Generate compatibility report. Require explicit confirmation.

## Output per Migration
1. Compatibility report  2. Dependency upgrade list  3. Before/after diffs
4. Build file changes    5. JVM flags update          6. Test validation plan

## Sub-Agents Auto-Fired
Dependency Analyzer, Security Auditor, Test Writer, Code Reviewer, Sanitization Agent
'@

Write-File ".copilot-agents\agents\spring-agent.md" @'
# Spring Agent
Scope: Spring Boot, Spring AI, Spring Cloud, Spring Security, Spring Data, Spring Batch

## Identity
Principal Spring engineer. Spring Boot 3.x, Spring AI 1.0.x, Spring Cloud 2023.x.

## Standards
- Constructor injection ALWAYS (never @Autowired on fields)
- application.yml not .properties
- @ConfigurationProperties with @Validated
- Auto-configuration over manual beans

## Spring AI Providers
OpenAI, Anthropic Claude, Azure OpenAI, Google Gemini, Ollama, Mistral, Hugging Face

## Key Patterns

Chat Client:
@Service
public class AiService {
    private final ChatClient chatClient;
    public AiService(ChatClient.Builder b) {
        this.chatClient = b.defaultSystem("You are a helpful assistant.").build();
    }
    public String chat(String msg) {
        return chatClient.prompt().user(msg).call().content();
    }
}

Spring Security (stateless JWT):
return http.csrf(AbstractHttpConfigurer::disable)
    .sessionManagement(s -> s.sessionCreationPolicy(STATELESS))
    .authorizeHttpRequests(a -> a
        .requestMatchers("/api/public/**").permitAll()
        .anyRequest().authenticated())
    .oauth2ResourceServer(o -> o.jwt(Customizer.withDefaults()))
    .build();

Spring Cloud: Gateway (NOT Zuul), Resilience4j (NOT Hystrix), Micrometer tracing

## Sub-Agents Auto-Fired
Dependency Analyzer, Security Auditor, Test Writer, API Designer, Code Reviewer, Sanitization Agent
'@

Write-File ".copilot-agents\agents\backend-agent.md" @'
# Backend Agent
Scope: General-purpose backend - APIs, databases, messaging, infrastructure, performance

## Identity
Senior backend engineer. 15+ years. Java, Node.js, Python, Go.

## Core Principles
1. Correctness before optimization
2. Explicit over implicit
3. Fail fast at boundaries
4. Design for operability

## REST Standards
GET/POST/PUT/PATCH/DELETE /api/v{n}/resources[/{id}]
Success: { "data": {}, "meta": { "page": 1, "total": 100 }, "errors": [] }
Error:   { "errors": [{ "code": "...", "message": "...", "field": "..." }] }
Headers: X-Correlation-ID, X-RateLimit-Limit, X-RateLimit-Remaining, ETag

## Database Rules
- Never SELECT * | Always paginate | Parameterized queries only
- Index FKs, WHERE cols, ORDER BY cols
- Schema: id (UUID), created_at, updated_at, deleted_at

## Observability
Structured JSON logs (traceId, spanId, userId)
p50/p95/p99 metrics, distributed tracing, /actuator/health

## Security
All endpoints authenticated by default
Bean Validation at controller layer
No hardcoded secrets - env vars or secret manager only
CORS allowlist only, never wildcard in production

## Sub-Agents Auto-Fired
Dependency Analyzer, Security Auditor, API Designer, DB Optimizer, Test Writer, Code Reviewer, Sanitization Agent
'@

Write-File ".copilot-agents\agents\react-web-agent.md" @'
# React Web Agent
Scope: React web UI - components, state, routing, styling, performance, accessibility

## Identity
Senior frontend engineer. React 18+, TypeScript, Next.js 14+ App Router, TailwindCSS,
Shadcn/ui, Zustand, TanStack Query, React Hook Form + Zod, Framer Motion.

## PRE-TASK QUESTIONNAIRE
1. React + Vite or Next.js? App Router or Pages Router?
2. TypeScript or JavaScript?
3. Styling: TailwindCSS, CSS Modules, Styled Components?
4. Component library: Shadcn/ui, MUI, Ant Design, Radix, none?
5. Global state: Zustand, Redux Toolkit, Jotai, Context?
6. Server state: TanStack Query, SWR, none?
7. Backend: REST or GraphQL? Auth: JWT, OAuth, NextAuth, Clerk?
8. Figma available? Dark mode? Accessibility target (WCAG AA/AAA)?
9. SSR/SSG required? Lighthouse score target? Bundle size budget?

## Folder Structure (feature-based)
src/
  features/{name}/components, hooks, store, types, index.ts
  components/ui/   <- shared dumb components
  hooks/           <- shared hooks
  lib/             <- utilities, API clients
  types/           <- global types

## State Hierarchy
Local UI state     -> useState / useReducer
Shared UI state    -> Zustand
Server state       -> TanStack Query
URL state          -> searchParams
Form state         -> React Hook Form + Zod

## Performance Rules
- React.memo, useMemo, useCallback appropriately
- Lazy-load routes: lazy(() => import('./Page'))
- Virtualize lists > 100 items: TanStack Virtual
- Keep chunks under 200KB gzipped

## Accessibility (WCAG AA minimum)
- Semantic HTML, keyboard navigable, alt text
- Color contrast 4.5:1 minimum, aria-* on complex widgets
- Test with axe-core in CI

## Skills Reference: .copilot-skills/react-ui-skills.md

## Sub-Agents Auto-Fired
Dependency Analyzer, Security Auditor, Test Writer, Code Reviewer, Sanitization Agent
'@

Write-File ".copilot-agents\agents\react-native-agent.md" @'
# React Native Agent
Scope: React Native mobile UI - iOS, Android, Expo, navigation, native APIs

## Identity
Senior React Native engineer. React Native 0.73+, Expo SDK 50+, TypeScript,
React Navigation v6, NativeWind, Zustand, TanStack Query, Reanimated 3, Expo Router.

## PRE-TASK QUESTIONNAIRE
1. Bare React Native or Expo (Managed/Bare)?
2. TypeScript or JavaScript?
3. Platforms: iOS, Android, or both? Min OS versions?
4. Navigation: React Navigation or Expo Router? Deep linking? Auth routes?
5. Styling: StyleSheet, NativeWind, Tamagui? Dark mode?
6. State: Zustand? Server: TanStack Query? Offline support?
7. Native features? (Camera, location, biometrics, push, payments)
8. EAS Build/Submit? OTA updates? Distribution target?

## Critical Rules
- FlashList for ALL lists (never ScrollView + map for long lists)
- SecureStore for ALL tokens (NEVER AsyncStorage for sensitive data)
- Reanimated 3 for animations (NEVER setState for animation values)
- useCallback for ALL callbacks passed to list renderItem
- accessibilityRole + accessibilityLabel on every interactive element
- Minimum touch target: 44x44 pts

## Skills Reference: .copilot-skills/react-native-skills.md

## Sub-Agents Auto-Fired
Dependency Analyzer, Security Auditor, Test Writer, Code Reviewer, Sanitization Agent
'@

Write-File ".copilot-agents\agents\sanitization-agent.md" @'
# Sanitization Agent
Scope: Secret detection before every commit, push, or code output.

## Identity
Last line of defense. Runs automatically after every primary agent output.
Powers .githooks/pre-commit and .githooks/pre-push.

## When I Fire
1. AUTOMATICALLY after every primary agent generates code
2. ON DEMAND: !scan command
3. VIA GIT HOOKS: on every git commit and git push

## Secret Detection - CRITICAL (block output)
- AWS Access Key:  AKIA[0-9A-Z]{16}
- AWS Secret:      aws_secret_access_key = "..."
- OpenAI Key:      sk-[a-zA-Z0-9]{20,}
- Anthropic Key:   sk-ant-[a-zA-Z0-9_-]{20,}
- GitHub PAT:      ghp_[a-zA-Z0-9]{36}
- Private Key:     -----BEGIN RSA/EC PRIVATE KEY-----
- .env file staged

## HIGH (fix before commit)
- password = "hardcoded_value"
- JDBC URL with embedded credentials
- MongoDB URI with credentials

## Safe Patterns (never flag)
- System.getenv("VAR")
- process.env.VAR
- @Value("${app.secret}")
- "placeholder" / "your-key-here"

## Output
[SANITIZATION REPORT]
CRITICAL - BLOCKING: Line X: finding -> remediation
HIGH: Line X: finding -> remediation
STATUS: BLOCKED / APPROVED

## .gitignore Additions to Suggest
.env, .env.local, *.pem, *.key, *.p12, *.jks, application-prod.yml, *-secrets.yml
'@

# ============================================================
# SUB-AGENTS
# ============================================================
Write-File ".copilot-agents\agents\sub-agents\dependency-analyzer.md" @'
# Sub-Agent: Dependency Analyzer
First sub-agent fired on any migration or feature task.
Scans: pom.xml, build.gradle, package.json, requirements.txt, go.mod

Reports:
- INCOMPATIBLE: must change before migration proceeds
- OUTDATED: recommend upgrade
- CVE RISK: must patch immediately
- OK: no action needed

Output:
[DEPENDENCY ANALYZER REPORT]
INCOMPATIBLE: aws-java-sdk-s3:1.12.x -> azure-storage-blob:12.x
OUTDATED: spring-boot-starter:2.7.x -> 3.3.x
CVE RISK: jackson-databind:2.13.x - CVE-2022-42003
OK: lombok:1.18.x
'@

Write-File ".copilot-agents\agents\sub-agents\test-writer.md" @'
# Sub-Agent: Test Writer
Fires after any code is generated or changed. Full ready-to-run files only. No placeholders.

Coverage:
1. Unit tests - pure logic, mocked dependencies
2. Integration tests - @SpringBootTest / Testcontainers
3. API tests - @WebMvcTest + MockMvc
4. React component tests - Jest + React Testing Library
5. React Native tests - Jest + RNTL
6. Migration regression tests

Rules:
- Test class: {ClassName}Test
- @DisplayName for readable names
- @ParameterizedTest for boundary conditions
- Minimum 3 test cases per public method
- Stack: JUnit 5, Mockito, AssertJ, Testcontainers, MockMvc
'@

Write-File ".copilot-agents\agents\sub-agents\security-auditor.md" @'
# Sub-Agent: Security Auditor
Fires when code touches auth, data, APIs, or external services.

Checks:
- JWT: algorithm, expiry, signature, claims
- Role/permission on every protected endpoint
- No raw SQL concat (SQL injection)
- No unescaped output (XSS)
- File uploads: type, size, path traversal
- No hardcoded credentials, no secrets in logs
- Cloud: IAM least-privilege, no wildcards, managed identities, encryption

Output severity: CRITICAL (block deploy) / HIGH (fix before merge) / MEDIUM (next sprint) / LOW
'@

Write-File ".copilot-agents\agents\sub-agents\api-designer.md" @'
# Sub-Agent: API Designer
Fires when a new endpoint or service contract is created.

Produces:
1. Full OpenAPI 3.0 YAML spec
2. Request/response schemas
3. Error catalog
4. Pagination conventions

Standards: /api/v{n}/ versioning, nouns not verbs, RFC 9457 errors, ISO 8601 dates, breaking change warnings
'@

Write-File ".copilot-agents\agents\sub-agents\db-optimizer.md" @'
# Sub-Agent: DB Optimizer
Fires when DB schemas, queries, or migrations are involved.

Checks:
- Missing indexes (FK, WHERE, ORDER BY columns)
- N+1 query patterns in JPA/Hibernate
- SELECT * usage
- Unpaginated large result sets
- Flyway/Liquibase migration correctness

Output: missing index SQL, query issues, generated migration file ready to run
'@

Write-File ".copilot-agents\agents\sub-agents\code-reviewer.md" @'
# Sub-Agent: Code Reviewer
Last sub-agent. Fires after all code is generated.

Checks:
1. Correctness      4. Readability (60-second rule)
2. Convention compliance  5. Error handling completeness
3. Idiom compliance  6. Logging quality  7. Dead code

Verdict: MUST FIX / SHOULD FIX / SUGGESTION / OVERALL status
'@

# ============================================================
# MEMORY FILES
# ============================================================
Write-File ".copilot-agents\memory\project-context.md" @'
# Project Context

## Project Name
<!-- Fill in your project name -->

## What This Project Does
<!-- 2-3 sentences: product, users, business goal -->

## Tech Stack
- Language:
- Framework:
- Database:
- Cloud:
- CI/CD:
- Key Libraries:

## Repository Structure
src/main/java       application code
src/main/resources  config, migrations
src/test            test code

## Team Context
- Team size:
- Sprint style:

## External Integrations
<!-- APIs, services, SDKs -->
'@

Write-File ".copilot-agents\memory\architecture.md" @'
# Architecture

## System Overview

## Core Components

### Component: [Name]
- Responsibility:
- Key files:
- Interfaces with:

## Data Flow

## Deployment
'@

Write-File ".copilot-agents\memory\conventions.md" @'
# Coding Conventions

## Style
- Java 21, Spring Boot 3.x, React 18, TypeScript
- Checkstyle + Spotless (backend) | ESLint + Prettier (frontend)

## Naming
- Java classes: PascalCase
- Java methods/vars: camelCase
- Constants: UPPER_SNAKE_CASE
- React components: PascalCase
- React hooks: camelCase with use prefix
- DB tables/columns: snake_case

## Patterns In Use
<!-- Add here -->

## Patterns to AVOID
<!-- Add here -->

## Error Handling
- Backend: @RestControllerAdvice + structured ApiResponse
- Frontend: React Error Boundaries + TanStack Query error states

## Testing
- Backend: JUnit 5, Mockito, AssertJ, Testcontainers (80% min)
- Frontend: Jest, React Testing Library, Playwright

## Git
- Branches: feature/, fix/, chore/
- Commits: conventional commits
- Pre-commit hook: mandatory (git config core.hooksPath .githooks)
'@

Write-File ".copilot-agents\memory\decisions.md" @'
# Architecture Decision Record (ADR)

## [SETUP] Memory System v2 Initialized
Status: Accepted
Context: Copilot loses context on IDE restart; needed frontend agents and secret scanning
Decision: Extended system with React Web, React Native, Sanitization agents, Skills, Git hooks
Consequences: Full-stack coverage; secret scanning at every output and commit
Alternatives: Third-party scanning tools only (too late in the cycle)
'@

Write-File ".copilot-agents\memory\known-issues.md" @'
# Known Issues and Tech Debt

<!-- Active only. Remove when resolved.
## [OPEN] Issue Title
- Severity: Critical / High / Medium / Low
- Affects:
- Description:
- Workaround:
- Root Cause:
- Next Action:
-->
'@

Write-File ".copilot-agents\memory\session-log.md" @'
# Session Log

## [SETUP] Memory System v2 Initialized
- Agent: Orchestrator
- Sub-Agents Fired: None
- Task: Initial setup
- Outcome: All files created
- Next: Fill project-context.md. Run: git config core.hooksPath .githooks
'@

Write-File ".copilot-agents\memory\agent-state.md" @'
# Agent State

## Last Active Agent
None - fresh v2 install

## Current Task
None

## Files In Progress
None

## Pending Actions
1. Fill .copilot-agents/memory/project-context.md
2. Fill .copilot-agents/memory/conventions.md
3. Fill .copilot-agents/memory/architecture.md
4. Run: git config core.hooksPath .githooks

## Blockers
None
'@

Write-File ".copilot-agents\memory\books-and-skills.md" @'
# Books, Resources and Skills Reference

## Books - Java and Backend
- Clean Code - Robert C. Martin
- Effective Java 3rd ed - Joshua Bloch
- Java Concurrency in Practice - Brian Goetz
- Designing Data-Intensive Applications - Martin Kleppmann
- Release It! - Michael Nygard
- Domain-Driven Design - Eric Evans
- Microservices Patterns - Chris Richardson

## Books - Spring
- Spring in Action 6th ed - Craig Walls
- Cloud Native Spring in Action - Thomas Vitale

## Books - Frontend
- Learning React 2nd ed - Alex Banks, Eve Porcello
- React Native in Action - Nader Dabit

## Books - Architecture
- Building Microservices - Sam Newman
- The Pragmatic Programmer - Hunt and Thomas

## Key Principles (Effective Java)
- Prefer composition over inheritance
- Minimize mutability - use records
- Return empty collections, not null

## Key Principles (Clean Code)
- Functions do one thing
- Names reveal intent
- DRY - no duplicate logic

## Active Skills
.copilot-skills/react-ui-skills.md
.copilot-skills/react-native-skills.md
.copilot-skills/java-backend-skills.md
.copilot-skills/spring-ai-skills.md
'@

# ============================================================
# SKILLS FILES
# ============================================================
Write-File ".copilot-skills\react-ui-skills.md" @'
# React UI Skills

## SKILL: useDebounce Hook
function useDebounce(value, delay = 300) {
  const [debounced, setDebounced] = useState(value);
  useEffect(() => {
    const t = setTimeout(() => setDebounced(value), delay);
    return () => clearTimeout(t);
  }, [value, delay]);
  return debounced;
}

## SKILL: Toast Notification (Zustand)
const useToastStore = create((set) => ({
  toasts: [],
  add: (t) => set(s => ({ toasts: [...s.toasts, { ...t, id: crypto.randomUUID() }] })),
  remove: (id) => set(s => ({ toasts: s.toasts.filter(t => t.id !== id) })),
}));
export const useToast = () => {
  const { add } = useToastStore();
  return { success: (msg) => add({ message: msg, type: 'success' }),
           error: (msg) => add({ message: msg, type: 'error' }) };
};

## SKILL: Protected Route
const ProtectedRoute = ({ children }) => {
  const { isAuthenticated, isLoading } = useAuth();
  if (isLoading) return <Spinner />;
  if (!isAuthenticated) return <Navigate to="/login" replace />;
  return <>{children}</>;
};

## SKILL: Axios API Client
export const api = axios.create({ baseURL: import.meta.env.VITE_API_URL });
api.interceptors.request.use(cfg => {
  const token = localStorage.getItem('access_token');
  if (token) cfg.headers.Authorization = `Bearer ${token}`;
  return cfg;
});

## SKILL: TanStack Query Keys Pattern
export const userKeys = {
  all: ['users'],
  detail: (id) => ['users', id],
};
export const useUser = (id) =>
  useQuery({ queryKey: userKeys.detail(id), queryFn: () => api.get('/users/' + id) });
'@

Write-File ".copilot-skills\react-native-skills.md" @'
# React Native Skills

## SKILL: Secure Token Storage (NEVER AsyncStorage for tokens)
import * as SecureStore from 'expo-secure-store';
export const tokenStorage = {
  get: (key) => SecureStore.getItemAsync(key),
  set: (key, val) => SecureStore.setItemAsync(key, val),
  delete: (key) => SecureStore.deleteItemAsync(key),
};

## SKILL: FlashList - High Performance List
import { FlashList } from '@shopify/flash-list';
<FlashList
  data={items}
  renderItem={({ item }) => <ItemCard item={item} />}
  estimatedItemSize={80}
  keyExtractor={item => item.id}
  onEndReached={fetchNextPage}
  onEndReachedThreshold={0.5}
/>

## SKILL: Haptic Feedback
import * as Haptics from 'expo-haptics';
export const haptics = {
  light: () => Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Light),
  success: () => Haptics.notificationAsync(Haptics.NotificationFeedbackType.Success),
  error: () => Haptics.notificationAsync(Haptics.NotificationFeedbackType.Error),
};

## SKILL: useAppState Hook
function useAppState() {
  const [state, setState] = useState(AppState.currentState);
  useEffect(() => {
    const sub = AppState.addEventListener('change', setState);
    return () => sub.remove();
  }, []);
  return state;
}

## SKILL: Reanimated 3 Fade Entrance
const opacity = useSharedValue(0);
useEffect(() => { opacity.value = withTiming(1, { duration: 300 }); }, []);
const animStyle = useAnimatedStyle(() => ({ opacity: opacity.value }));
'@

Write-File ".copilot-skills\java-backend-skills.md" @'
# Java Backend Skills

## SKILL: Generic API Response Wrapper
public record ApiResponse<T>(T data, PageMeta meta, List<ApiError> errors) {
  public static <T> ApiResponse<T> ok(T data) { return new ApiResponse<>(data, null, List.of()); }
  public static <T> ApiResponse<T> error(String code, String msg) {
    return new ApiResponse<>(null, null, List.of(new ApiError(code, msg, null)));
  }
}
public record PageMeta(long total, int page, int size) {}
public record ApiError(String code, String message, String field) {}

## SKILL: Global Exception Handler
@RestControllerAdvice @Slf4j
public class GlobalExceptionHandler {
  @ExceptionHandler(ResourceNotFoundException.class)
  public ResponseEntity<ApiResponse<?>> notFound(ResourceNotFoundException ex) {
    return ResponseEntity.status(404).body(ApiResponse.error("NOT_FOUND", ex.getMessage()));
  }
  @ExceptionHandler(Exception.class)
  public ResponseEntity<ApiResponse<?>> generic(Exception ex) {
    log.error("Unhandled", ex);
    return ResponseEntity.internalServerError().body(ApiResponse.error("INTERNAL_ERROR", "Unexpected error"));
  }
}

## SKILL: Base JPA Entity
@MappedSuperclass @EntityListeners(AuditingEntityListener.class)
public abstract class BaseEntity {
  @Id @GeneratedValue(strategy = GenerationType.UUID) private UUID id;
  @CreatedDate private Instant createdAt;
  @LastModifiedDate private Instant updatedAt;
  @Column(name = "deleted_at") private Instant deletedAt;
  public void softDelete() { this.deletedAt = Instant.now(); }
}

## SKILL: Virtual Thread Executor (Java 21)
@Bean
public Executor virtualThreadExecutor() {
  return Executors.newVirtualThreadPerTaskExecutor();
}
'@

Write-File ".copilot-skills\spring-ai-skills.md" @'
# Spring AI Skills

## SKILL: Multi-Provider Config
@Configuration
public class AiConfig {
  @Bean @Primary
  public ChatClient openAiClient(OpenAiChatModel m) {
    return ChatClient.builder(m).defaultSystem("You are a helpful assistant.").build();
  }
  @Bean @Qualifier("claude")
  public ChatClient claudeClient(AnthropicChatModel m) { return ChatClient.builder(m).build(); }
}

## SKILL: Streaming (SSE)
@GetMapping(value = "/chat/stream", produces = MediaType.TEXT_EVENT_STREAM_VALUE)
public Flux<String> stream(@RequestParam String message) {
  return chatClient.prompt().user(message).stream().content();
}

## SKILL: Conversational Memory
@Service
public class ConversationalAiService {
  private final ChatClient chatClient;
  private final Map<String, ChatMemory> sessions = new ConcurrentHashMap<>();
  public String chat(String sessionId, String message) {
    var memory = sessions.computeIfAbsent(sessionId, k -> new InMemoryChatMemory());
    return chatClient.prompt().advisors(new MessageChatMemoryAdvisor(memory))
        .user(message).call().content();
  }
}

## SKILL: Structured Extraction
record InvoiceData(String vendor, BigDecimal amount, LocalDate dueDate) {}
public InvoiceData extract(String text) {
  return chatClient.prompt()
      .system("Extract fields as JSON. Use null for missing.")
      .user("Extract from: " + text)
      .call().entity(InvoiceData.class);
}
'@

# ============================================================
# GIT HOOKS (plain text - no execute bits on Windows)
# ============================================================
Write-File ".githooks\pre-commit" @'
#!/bin/sh
# Copilot Memory System v2 - Pre-Commit Sanitization Hook
# Activate: git config core.hooksPath .githooks
# On Windows, Git uses sh.exe bundled with Git for Windows to run this.

echo "[SANITIZATION] Running pre-commit secret scan..."

STAGED=$(git diff --cached --name-only --diff-filter=ACMR)
if [ -z "$STAGED" ]; then echo "[SANITIZATION] No staged files. OK."; exit 0; fi

FOUND=0; REPORT=""

for FILE in $STAGED; do
  if echo "$FILE" | grep -qE "(.githooks|.copilot-agents/memory|.copilot-skills|README|SETUP)"; then continue; fi
  CONTENT=$(git show ":$FILE" 2>/dev/null)

  if echo "$CONTENT" | grep -qE "AKIA[0-9A-Z]{16}"; then
    REPORT="${REPORT}  CRITICAL: AWS Access Key in ${FILE}\n"; FOUND=1; fi
  if echo "$CONTENT" | grep -qE "sk-[a-zA-Z0-9]{20,}"; then
    REPORT="${REPORT}  CRITICAL: API key in ${FILE}\n"; FOUND=1; fi
  if echo "$CONTENT" | grep -qE "sk-ant-[a-zA-Z0-9_-]{20,}"; then
    REPORT="${REPORT}  CRITICAL: Anthropic key in ${FILE}\n"; FOUND=1; fi
  if echo "$CONTENT" | grep -qE "ghp_[a-zA-Z0-9]{36}"; then
    REPORT="${REPORT}  CRITICAL: GitHub PAT in ${FILE}\n"; FOUND=1; fi
  if echo "$CONTENT" | grep -q "BEGIN RSA PRIVATE KEY\|BEGIN PRIVATE KEY"; then
    REPORT="${REPORT}  CRITICAL: Private key in ${FILE}\n"; FOUND=1; fi
  if echo "$FILE" | grep -qE "^\.env"; then
    REPORT="${REPORT}  CRITICAL: .env file staged\n"; FOUND=1; fi
  if echo "$CONTENT" | grep -qiE "jdbc:[a-z]+://[^@]+:[^@]+@"; then
    REPORT="${REPORT}  HIGH: DB credentials in connection string in ${FILE}\n"; FOUND=1; fi
  if echo "$CONTENT" | grep -qiE "(password|secret|api_key)\s*=\s*['\"][^'\"\$\{][^'\"]{3,}['\"]"; then
    REPORT="${REPORT}  HIGH: Possible hardcoded credential in ${FILE}\n"; FOUND=1; fi
done

if [ "$FOUND" -eq 1 ]; then
  echo "================================================================"
  echo " [SANITIZATION] COMMIT BLOCKED - Secrets detected:"
  echo "================================================================"
  printf "$REPORT"
  echo "================================================================"
  echo " Fix above, then commit again."
  echo " Override (team approval required): git commit --no-verify"
  echo "================================================================"
  exit 1
fi

echo "[SANITIZATION] Clean. Commit proceeding."
exit 0
'@

Write-File ".githooks\pre-push" @'
#!/bin/sh
# Copilot Memory System v2 - Pre-Push Deep Sanitization Hook
echo "[SANITIZATION] Running pre-push deep scan..."

while read LOCAL_REF LOCAL_SHA REMOTE_REF REMOTE_SHA; do
  if [ "$LOCAL_SHA" = "0000000000000000000000000000000000000000" ]; then continue; fi
  RANGE="${REMOTE_SHA}..${LOCAL_SHA}"
  if [ "$REMOTE_SHA" = "0000000000000000000000000000000000000000" ]; then RANGE="$LOCAL_SHA"; fi

  for FILE in $(git diff --name-only "$RANGE" 2>/dev/null); do
    if [ ! -f "$FILE" ]; then continue; fi
    CONTENT=$(cat "$FILE")
    FOUND=0

    if echo "$CONTENT" | grep -qE "AKIA[0-9A-Z]{16}"; then
      echo "[SANITIZATION] CRITICAL: AWS key in $FILE"; FOUND=1; fi
    if echo "$CONTENT" | grep -qE "sk-[a-zA-Z0-9]{20,}"; then
      echo "[SANITIZATION] CRITICAL: API key in $FILE"; FOUND=1; fi
    if echo "$CONTENT" | grep -q "BEGIN RSA PRIVATE KEY\|BEGIN PRIVATE KEY"; then
      echo "[SANITIZATION] CRITICAL: Private key in $FILE"; FOUND=1; fi

    if [ "$FOUND" -eq 1 ]; then
      echo "PUSH BLOCKED. Rotate exposed secrets immediately via provider dashboard."
      exit 1
    fi
  done
done

echo "[SANITIZATION] Deep scan clean. Push proceeding."
exit 0
'@

# ============================================================
# DONE
# ============================================================
Write-Host ""
Write-Host "================================================================" -ForegroundColor Cyan
Write-Host " Copilot Memory System v2 created successfully!" -ForegroundColor Green
Write-Host "================================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host " Now run these two commands:" -ForegroundColor Yellow
Write-Host ""
Write-Host "   git config core.hooksPath .githooks" -ForegroundColor White
Write-Host ""
Write-Host " Then fill in:" -ForegroundColor Yellow
Write-Host "   .copilot-agents\memory\project-context.md" -ForegroundColor White
Write-Host ""
Write-Host "================================================================" -ForegroundColor Cyan