# Backend Rules - Go Services

## Arquitetura

- **Hexagonal Architecture (Ports & Adapters)**: o domínio fica no centro, isolado de detalhes externos.
  - **Domain**: entidades, value objects, regras de negócio puras (sem dependências externas).
  - **Ports**: interfaces que definem contratos de entrada (driving) e saída (driven).
  - **Adapters**: implementações concretas dos ports (gRPC handlers, repositórios, clients externos).
- A comunicação entre camadas é sempre feita através de interfaces (ports), nunca por implementações concretas.

## Estrutura de Pastas

- Layout padronizado obrigatório:
  - `cmd/` - entry points da aplicação.
  - `internal/domain/` - entidades, value objects, regras de negócio.
  - `internal/ports/` - interfaces (driving e driven ports).
  - `internal/adapters/` - implementações concretas (gRPC handlers, repositórios, clients).
  - `proto/` - arquivos `.proto` (contratos gRPC).
  - `docs/adr/` - Architecture Decision Records.
- **Um package por bounded context** - proibido criar packages genéricos como `utils`, `helpers`, `common`.

## SOLID (regra inviolável)

- **NUNCA** implementar nada que viole os princípios SOLID.
- **S** - Single Responsibility: cada struct/package tem uma única razão para mudar.
- **O** - Open/Closed: aberto para extensão, fechado para modificação. Usar interfaces e composição.
- **L** - Liskov Substitution: implementações de uma interface devem ser substituíveis sem quebrar o comportamento.
- **I** - Interface Segregation: interfaces pequenas e específicas. Nunca forçar implementação de métodos desnecessários.
- **D** - Dependency Inversion: depender de abstrações (interfaces), nunca de implementações concretas.

## Concorrência

- **Goroutines com controle de lifecycle** - toda goroutine deve ter mecanismo de cancelamento via `context.Context` ou `chan`. Nunca disparar goroutines "fire and forget" sem controle.
- **Timeouts obrigatórios** - toda chamada externa (banco, gRPC client, HTTP) deve ter timeout configurado via context. Nunca depender de timeout padrão.

## Services

- Todo service **deve** implementar uma interface (port).
- Dependências são **sempre** injetadas via função construtora `New()`, nunca como variáveis globais.
- Error handling explícito: erros customizados por domínio, sem `panic`, sempre retornar `error`.
- Toda função de service deve receber `context.Context` como primeiro parâmetro.

## gRPC

- Comunicação via **gRPC** (sem framework HTTP REST).
- Protobuf files (.proto) como contrato da API.
- gRPC handlers são adapters da camada de entrada (driving adapters).
- **Interceptors obrigatórios** em todo server gRPC:
  - Logging (log estruturado de cada request/response).
  - Recovery (converte panic em error, nunca deixar o server crashar).
  - Tracing (propagação de trace context).
- **Health check obrigatório** - todo serviço gRPC deve implementar o gRPC Health Checking Protocol.
- **Graceful shutdown obrigatório** - todo servidor gRPC deve tratar sinais de shutdown (SIGTERM/SIGINT) e finalizar conexões abertas antes de encerrar.
- **Correlation ID** - propagar um ID único por request em toda a cadeia de chamadas (via metadata gRPC).
- **Idempotência** - operações de escrita expostas via gRPC devem ser idempotentes. Clients podem retentar sem efeitos colaterais.
- **Pagination obrigatória** - todo endpoint que retorna listas deve implementar pagination (cursor-based de preferência). Nunca retornar coleções inteiras.

## Erros

- Definir **error types por domínio** (ex: `ErrNotFound`, `ErrAlreadyExists`, `ErrInvalidInput`) em vez de strings soltas.
- **Proibido retornar nil sem error** - se uma função retorna `(T, error)`, o retorno válido nunca deve ser ambíguo. Se `error == nil`, `T` deve ser um valor válido.

## Testes

- **Obrigatórios** para todo service, handler e repository.
- Implementar **mocks** para todas as dependências (interfaces).
- **Testes unitários**: cobrem domain e services isoladamente com mocks.
- **Testes de integração**: validam adapters com dependências reais (banco, gRPC).

## Resiliência

- **Retry com exponential backoff** - chamadas a serviços externos devem ter retry com backoff exponencial. Nunca retry infinito.
- **Circuit breaker** - comunicação entre serviços deve implementar circuit breaker para evitar cascading failures.

## Logging

- **Logging estruturado** obrigatório (slog ou zap).
- **Nunca** usar `fmt.Println` ou `log.Println` em código de produção.

## Segurança

- **Nunca logar dados sensíveis** - senhas, tokens, PII nunca aparecem em logs.
- **Secrets via secret manager ou variáveis de ambiente** - nunca em arquivos commitados no repositório.

## Validação

- Validar input **apenas** nos adapters de entrada (gRPC handlers).
- Services recebem dados já validados.

## Nomenclatura e Convenções Go

- Seguir convenções idiomáticas do Go: camelCase, pacotes lowercase, nomes curtos e descritivos.
- Clean Code: nomes de variáveis, funções e pacotes devem expressar claramente sua intenção.

## Database

- **Migrations versionadas** - schema changes sempre via migration files versionados, nunca alteração manual no banco.
- **Repository pattern estrito** - toda interação com banco passa por um repository que implementa um port. Queries nunca no service.

## Configuração

- Configurações carregadas de **variáveis de ambiente**, nunca hardcoded.

## Dependências

- Sempre usar `go get <package>` para obter a versão mais atual do pacote.

## Documentação

- **Proto files como documentação viva** - comments nos arquivos `.proto` descrevem o contrato da API, dispensando documentação separada.
- **Versionamento de API** - protos organizados por versão (`proto/v1/`, `proto/v2/`). Nunca quebrar contrato existente.
- **ADRs (Architecture Decision Records)** - toda decisão arquitetural relevante deve ser documentada em `docs/adr/` para rastreabilidade.

## Docker

- **Multi-stage build obrigatório** - Dockerfile sempre com multi-stage para imagem final mínima (build em uma stage, binário copiado para scratch/distroless).

## Proto Lint

- **Buf obrigatório** - usar `buf` para validar e fazer lint dos arquivos `.proto`. Garantir consistência e qualidade dos contratos.

## Versionamento e Git

- **Conventional Commits** - mensagens de commit seguindo o padrão: `feat:`, `fix:`, `refactor:`, `test:`, `docs:`, `chore:`.
- **Branch naming** - branches seguem o padrão: `feat/`, `fix/`, `refactor/` + descrição curta em kebab-case.

## Makefile

- **Makefile como entry point** do projeto com comandos padronizados:
  - `make build` - compila o projeto.
  - `make test` - roda todos os testes.
  - `make proto` - gera código a partir dos `.proto`.
  - `make lint` - roda o linter.

## Princípios Gerais

- Seguir boas práticas de Clean Code e Clean Architecture.
- Simplicidade acima de tudo: não criar abstrações desnecessárias.
- Qualquer decisão de design deve ser justificável pelos princípios SOLID.
