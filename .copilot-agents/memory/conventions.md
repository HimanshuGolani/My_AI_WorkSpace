# Coding Conventions

## Style
- Java 21, Spring Boot 3.x, React 18, TypeScript
- Checkstyle + Spotless (backend) · ESLint + Prettier (frontend)

## Naming
- Java classes: PascalCase
- Java methods/vars: camelCase
- Constants: UPPER_SNAKE_CASE
- React components: PascalCase
- React hooks: camelCase with use prefix
- DB tables/columns: snake_case

## Patterns In Use

## Patterns to AVOID

## Error Handling
- Backend: @RestControllerAdvice, structured error response
- Frontend: React Error Boundaries, TanStack Query error states

## Testing
- Backend: JUnit 5, Mockito, AssertJ, Testcontainers
- Frontend: Jest, React Testing Library, Playwright (e2e)
- Coverage: 80% minimum

## Git
- Branches: feature/, fix/, chore/
- Commits: conventional commits
- Pre-commit: sanitization hook mandatory