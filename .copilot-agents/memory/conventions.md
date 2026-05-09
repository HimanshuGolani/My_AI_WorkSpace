# Coding Conventions

## Style
- Java 21, Spring Boot 3.x
- Checkstyle + Spotless

## Naming
- Classes: PascalCase
- Methods/variables: camelCase
- Constants: UPPER_SNAKE_CASE
- DB tables/columns: snake_case
- Packages: lowercase.dotted

## Patterns In Use
<!-- List active design patterns -->

## Patterns to AVOID
<!-- Banned patterns -->

## Error Handling
- All exceptions logged at ERROR with full context
- Custom exception hierarchy under exception/ package
- Global handler via @RestControllerAdvice

## Testing
- JUnit 5, Mockito, AssertJ, Testcontainers
- Coverage target: 80% minimum

## Git
- Branches: feature/, fix/, chore/
- Commits: conventional commits format
