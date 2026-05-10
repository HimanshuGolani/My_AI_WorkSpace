# Spring AI Skills
Ready-made Spring AI patterns, multi-provider setup, RAG, and agentic patterns.

---

## SKILL: Multi-Provider Chat Client Config
```java
@Configuration
public class AiConfig {
  // Primary: OpenAI
  @Bean @Primary
  public ChatClient openAiChatClient(OpenAiChatModel model) {
    return ChatClient.builder(model)
        .defaultSystem("You are a helpful assistant.")
        .defaultAdvisors(new MessageChatMemoryAdvisor(new InMemoryChatMemory()))
        .build();
  }
  // Fallback: Anthropic Claude
  @Bean @Qualifier("claude")
  public ChatClient claudeChatClient(AnthropicChatModel model) {
    return ChatClient.builder(model).build();
  }
}
```

---

## SKILL: Streaming Chat Response
```java
@GetMapping(value = "/chat/stream", produces = MediaType.TEXT_EVENT_STREAM_VALUE)
public Flux<String> streamChat(@RequestParam String message) {
  return chatClient.prompt()
      .user(message)
      .stream()
      .content();
}
```

---

## SKILL: Document Ingestion Pipeline (RAG)
```java
@Service
public class DocumentIngestionService {
  private final VectorStore vectorStore;
  private final TokenTextSplitter splitter = new TokenTextSplitter(512, 64);

  public void ingest(Resource resource) {
    var reader = new PdfDocumentReaderConfig.Builder().build();
    var docs = new PagePdfDocumentReader(resource, reader).get();
    var chunks = splitter.apply(docs);
    // Enrich with metadata
    chunks.forEach(doc -> doc.getMetadata().put("source", resource.getFilename()));
    vectorStore.add(chunks);
  }
}
```

---

## SKILL: Conversational Memory with Session
```java
@Service
public class ConversationalAiService {
  private final ChatClient chatClient;
  private final Map<String, ChatMemory> sessions = new ConcurrentHashMap<>();

  public String chat(String sessionId, String message) {
    var memory = sessions.computeIfAbsent(sessionId, k -> new InMemoryChatMemory());
    return chatClient.prompt()
        .advisors(new MessageChatMemoryAdvisor(memory))
        .user(message)
        .call()
        .content();
  }
}
```

---

## SKILL: Structured Extraction from Unstructured Text
```java
record InvoiceData(String vendor, BigDecimal amount, LocalDate dueDate, String invoiceNumber) {}

@Service
public class InvoiceExtractionService {
  private final ChatClient chatClient;

  public InvoiceData extract(String rawText) {
    return chatClient.prompt()
        .system("Extract invoice data. Return only structured JSON. If a field is missing use null.")
        .user("Extract from this invoice text: " + rawText)
        .call()
        .entity(InvoiceData.class);
  }
}
```

---

## SKILL: Agentic Tool with State
```java
@Component
public class DatabaseQueryTool {
  private final JdbcTemplate jdbcTemplate;

  @Bean
  @Description("Execute a read-only SQL query on the application database and return results as JSON")
  public Function<QueryRequest, QueryResult> dbQueryTool() {
    return req -> {
      // Validate: only SELECT allowed
      if (!req.sql().trim().toUpperCase().startsWith("SELECT")) {
        return new QueryResult(false, "Only SELECT queries are allowed", null);
      }
      try {
        var rows = jdbcTemplate.queryForList(req.sql());
        return new QueryResult(true, null, rows);
      } catch (Exception e) {
        return new QueryResult(false, e.getMessage(), null);
      }
    };
  }
  record QueryRequest(String sql) {}
  record QueryResult(boolean success, String error, List<Map<String, Object>> rows) {}
}
```