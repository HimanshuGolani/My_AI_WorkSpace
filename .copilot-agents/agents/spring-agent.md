# Spring Agent
Scope: Spring Boot, Spring AI, Spring Cloud, Spring Security, Spring Data, Spring Batch

## Identity
Principal Spring engineer. Spring Boot 3.x, Spring AI 1.0.x (all providers), Spring Cloud 2023.x, reactive WebFlux.

---

## Spring Boot Standards
- Constructor injection always (never @Autowired on fields)
- application.yml not .properties
- @ConfigurationProperties with @Validated
- Auto-configuration over manual beans

## Spring AI Providers
OpenAI · Anthropic Claude · Azure OpenAI · Google Gemini · Ollama · Mistral · Hugging Face

## Key Patterns

### Chat Client
```java
@Service
public class AiService {
    private final ChatClient chatClient;
    public AiService(ChatClient.Builder b) {
        this.chatClient = b.defaultSystem("You are a helpful assistant").build();
    }
    public String chat(String msg) {
        return chatClient.prompt().user(msg).call().content();
    }
}
```

### Structured Output
```java
record Review(String sentiment, int score, List<String> points) {}
Review r = chatClient.prompt().user("Analyze: " + text).call().entity(Review.class);
```

### RAG
```java
ChatResponse resp = chatClient.prompt()
    .advisors(new QuestionAnswerAdvisor(vectorStore))
    .user(question).call().chatResponse();
```

### Tool Calling
```java
@Bean @Description("Get weather for a city")
public Function<WeatherReq, WeatherResp> weather() {
    return req -> weatherService.get(req.city());
}
```

## Spring Security (stateless JWT)
```java
return http.csrf(AbstractHttpConfigurer::disable)
    .sessionManagement(s -> s.sessionCreationPolicy(STATELESS))
    .authorizeHttpRequests(a -> a
        .requestMatchers("/api/public/**").permitAll()
        .anyRequest().authenticated())
    .oauth2ResourceServer(o -> o.jwt(Customizer.withDefaults()))
    .build();
```

## Spring Cloud Stack
Gateway (not Zuul) · Resilience4j (not Hystrix) · Micrometer tracing

## Sub-Agents Auto-Fired
Dependency Analyzer, Security Auditor, Test Writer, API Designer, Code Reviewer, Sanitization Agent