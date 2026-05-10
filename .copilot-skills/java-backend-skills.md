# Java Backend Skills
Ready-made Java idioms, Spring recipes, and common backend patterns.

---

## SKILL: Generic API Response Wrapper
```java
public record ApiResponse<T>(T data, PageMeta meta, List<ApiError> errors) {
  public static <T> ApiResponse<T> ok(T data) {
    return new ApiResponse<>(data, null, List.of());
  }
  public static <T> ApiResponse<T> paged(T data, long total, int page, int size) {
    return new ApiResponse<>(data, new PageMeta(total, page, size), List.of());
  }
  public static <T> ApiResponse<T> error(String code, String message) {
    return new ApiResponse<>(null, null, List.of(new ApiError(code, message, null)));
  }
}
public record PageMeta(long total, int page, int size) {}
public record ApiError(String code, String message, String field) {}
```

---

## SKILL: Global Exception Handler
```java
@RestControllerAdvice
@Slf4j
public class GlobalExceptionHandler {
  @ExceptionHandler(ResourceNotFoundException.class)
  public ResponseEntity<ApiResponse<?>> notFound(ResourceNotFoundException ex) {
    log.warn("Resource not found: {}", ex.getMessage());
    return ResponseEntity.status(HttpStatus.NOT_FOUND).body(ApiResponse.error("RESOURCE_NOT_FOUND", ex.getMessage()));
  }
  @ExceptionHandler(MethodArgumentNotValidException.class)
  public ResponseEntity<ApiResponse<?>> validation(MethodArgumentNotValidException ex) {
    var errors = ex.getBindingResult().getFieldErrors().stream()
        .map(e -> new ApiError("VALIDATION_ERROR", e.getDefaultMessage(), e.getField())).toList();
    return ResponseEntity.badRequest().body(new ApiResponse<>(null, null, errors));
  }
  @ExceptionHandler(Exception.class)
  public ResponseEntity<ApiResponse<?>> generic(Exception ex) {
    log.error("Unhandled exception", ex);
    return ResponseEntity.internalServerError().body(ApiResponse.error("INTERNAL_ERROR", "An unexpected error occurred"));
  }
}
```

---

## SKILL: Base Entity (JPA)
```java
@MappedSuperclass
@EntityListeners(AuditingEntityListener.class)
public abstract class BaseEntity {
  @Id @GeneratedValue(strategy = GenerationType.UUID)
  private UUID id;
  @CreatedDate
  private Instant createdAt;
  @LastModifiedDate
  private Instant updatedAt;
  @Column(name = "deleted_at")
  private Instant deletedAt;
  public boolean isDeleted() { return deletedAt != null; }
  public void softDelete() { this.deletedAt = Instant.now(); }
}
```

---

## SKILL: Paginated Repository Pattern
```java
public interface PagedResult<T> {
  List<T> content();
  long totalElements();
  int totalPages();
  int currentPage();
}
// In service:
public PagedResult<UserDto> getUsers(int page, int size, String sort) {
  var pageable = PageRequest.of(page, size, Sort.by(sort));
  var result = userRepository.findAll(pageable);
  return new PagedResultImpl<>(result.map(userMapper::toDto));
}
```

---

## SKILL: Idempotent REST Controller Template
```java
@RestController
@RequestMapping("/api/v1/resources")
@Validated
@Slf4j
public class ResourceController {
  private final ResourceService service;
  public ResourceController(ResourceService service) { this.service = service; }

  @GetMapping
  public ResponseEntity<ApiResponse<Page<ResourceDto>>> list(
      @RequestParam(defaultValue = "0") int page,
      @RequestParam(defaultValue = "20") int size) {
    return ResponseEntity.ok(ApiResponse.paged(service.list(page, size), 0, page, size));
  }

  @PostMapping
  public ResponseEntity<ApiResponse<ResourceDto>> create(
      @Valid @RequestBody CreateResourceRequest req,
      @RequestHeader(value = "Idempotency-Key", required = false) String idempotencyKey) {
    log.info("Creating resource, idempotency-key={}", idempotencyKey);
    return ResponseEntity.status(HttpStatus.CREATED).body(ApiResponse.ok(service.create(req, idempotencyKey)));
  }
}
```