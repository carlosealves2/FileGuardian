# Flutter Rules - Mobile App

## Arquitetura

- **Clean Architecture** com separação em 3 camadas:
  - **Domain**: entidades, value objects, regras de negócio puras, use cases e interfaces de repositório. Sem dependências externas.
  - **Data**: implementações de repositórios, data sources (remote e local), models (DTOs) com serialização.
  - **Presentation**: widgets, pages, state management (Blocs/Cubits), view models.
- A comunicação entre camadas é sempre feita através de abstrações (interfaces/abstract classes), nunca por implementações concretas.
- **Use Cases** como unidade de lógica de negócio - cada use case representa uma ação do sistema e depende apenas de interfaces do domain.

## Estrutura de Pastas

- Layout **feature-based** obrigatório:
  - `lib/core/` - configurações globais, tema, constantes, extensões compartilhadas.
  - `lib/core/di/` - configuração de injeção de dependências.
  - `lib/core/theme/` - tokens de design, tema e estilos globais.
  - `lib/core/router/` - configuração de rotas e navegação.
  - `lib/core/grpc/` - client gRPC base, interceptors, configuração de channels.
  - `lib/core/error/` - tipos de erro e failure classes compartilhados.
  - `lib/core/i18n/` - arquivos de tradução e configuração de internacionalização.
  - `lib/features/<feature>/` - módulos organizados por funcionalidade/domínio.
  - `lib/features/<feature>/domain/` - entities, repositories (abstract), use cases.
  - `lib/features/<feature>/data/` - repositories (impl), data sources, models.
  - `lib/features/<feature>/presentation/` - pages, widgets, blocs/cubits.
  - `proto/` - arquivos `.proto` (contratos gRPC).
  - `docs/adr/` - Architecture Decision Records.
- **Barrel exports** (`index.dart` ou arquivo nomeado) obrigatórios por feature para encapsular imports internos.
- **Proibido** criar pastas genéricas como `utils`, `helpers`, `common`. Colocar no contexto da feature ou em `core/`.

## State Management

- **Bloc/Cubit** como gerenciador de estado.
- **Separação clara** entre estado local e estado gerenciado por Bloc:
  - Estado local (`StatefulWidget`): dados que pertencem apenas a um widget (animações, form controllers, UI toggles temporários).
  - Bloc/Cubit: lógica de negócio, estados de features, dados compartilhados entre widgets.
- **Um Bloc/Cubit por feature ou domínio** - nunca um Bloc monolítico.
- **Estados tipados e exaustivos** - usar sealed classes ou Freezed para modelar todos os estados possíveis (initial, loading, success, error).
- **Eventos tipados** (Bloc) - cada evento é uma classe distinta que representa uma intenção do usuário ou do sistema.
- **Imutabilidade obrigatória** - estados e eventos são sempre imutáveis.

## SOLID

- **NUNCA** implementar nada que viole os princípios SOLID.
- **S** - Single Responsibility: cada widget, bloc e use case tem uma única razão para mudar.
- **O** - Open/Closed: aberto para extensão, fechado para modificação. Usar abstrações e composição.
- **L** - Liskov Substitution: implementações de uma interface devem ser substituíveis sem quebrar o comportamento.
- **I** - Interface Segregation: interfaces (abstract classes) pequenas e específicas. Nunca forçar implementação de métodos desnecessários.
- **D** - Dependency Inversion: depender de abstrações, nunca de implementações concretas. Blocs dependem de use cases, use cases dependem de interfaces de repositório.

## Naming Conventions

- **PascalCase** para classes, enums, typedefs, extensions e widgets (ex: `UserProfile`, `FileUploadBloc`, `AuthState`).
- **camelCase** para variáveis, funções, parâmetros e métodos (ex: `userName`, `handleSubmit`).
- **snake_case** para nomes de arquivos e diretórios (ex: `user_profile.dart`, `file_upload_bloc.dart`).
- **SCREAMING_SNAKE_CASE** para constantes (ex: `MAX_FILE_SIZE`, `API_BASE_URL`).
- Blocs: sufixo `Bloc` ou `Cubit` (ex: `AuthBloc`, `FileCubit`).
- Estados: sufixo `State` (ex: `AuthState`, `FileUploadState`).
- Eventos: sufixo `Event` (ex: `AuthEvent`, `LoginRequested`).
- Use cases: nome descritivo da ação (ex: `UploadFile`, `GetUserProfile`).
- Repositories: prefixo da entidade + `Repository` (ex: `FileRepository`, `UserRepository`).
- Nomes descritivos e auto-explicativos - Clean Code. Evitar abreviações obscuras.

## Tipos & Null Safety

- **Sound null safety obrigatório** - nunca desabilitar null safety.
- **Proibido `dynamic`** - usar tipos explícitos sempre. Se o tipo não é conhecido, usar `Object` com type checking explícito.
- **Proibido type casting inseguro** (`as`) - usar pattern matching ou type checking (`is`) com smart casting.
- **Late variables com cautela** - usar `late` apenas quando a inicialização é garantida antes do acesso. Preferir nullable + null check.
- **Tipos por domínio** - entidades e value objects com tipos específicos, nunca `String` ou `int` genéricos para conceitos de negócio quando um value object fizer sentido.

## Error Handling

- **Either pattern** usando `fpdart` ou `dartz` - toda operação que pode falhar retorna `Either<Failure, T>`.
- **Failure classes por domínio** - hierarquia de failures tipadas (ex: `ServerFailure`, `CacheFailure`, `ValidationFailure`, `NetworkFailure`).
- **Proibido try/catch genérico** - capturar exceções específicas nos data sources e convertê-las em Failures tipadas.
- **Proibido lançar exceções na camada de domain** - domain trabalha apenas com `Either` e Failures.
- **Exceptions apenas na camada de data** - data sources podem lançar exceptions que são capturadas e convertidas em Failures pelo repository.
- **Proibido retornar null como indicador de erro** - usar `Either` ou `Option` para representar ausência de valor.

## Imutabilidade

- **Freezed obrigatório** para:
  - Entidades do domain.
  - Estados e eventos do Bloc.
  - Models/DTOs da camada de data.
- **Equatable** como alternativa ao Freezed apenas para classes simples onde a geração de código do Freezed seria excessiva.
- **Proibido mutar objetos diretamente** - sempre usar `copyWith` para criar novas instâncias com valores alterados.
- Listas e maps devem ser **unmodifiable** quando expostos publicamente.

## Widgets & Composição

- **Composição sobre herança** - nunca estender widgets existentes, compor novos a partir de widgets menores.
- **Widgets pequenos e focados** - se um método `build` tem mais de ~80 linhas, extrair subwidgets.
- **Separação presentation/logic** - widgets não devem conter lógica de negócio. Lógica fica nos Blocs/Cubits.
- **Const constructors obrigatórios** - todo widget que aceita parâmetros compile-time deve ter `const` constructor.
- **Keys** - usar keys explícitas em listas dinâmicas (`ListView.builder`, etc.) e quando o framework precisa preservar estado.
- **Proibido lógica condicional complexa dentro do `build`** - extrair para métodos privados ou widgets separados.

## Theming

- **Material 3** como base de design.
- **ThemeData centralizado** - tema definido em `lib/core/theme/` com design tokens (cores, tipografia, espaçamentos, border radius).
- **ColorScheme e TextTheme** do Material 3 como fonte de verdade para cores e tipografia.
- **Nunca hardcodar cores ou tamanhos de fonte** - sempre referenciar o tema via `Theme.of(context)`.
- **Dark mode obrigatório** - a aplicação deve suportar light e dark theme desde o início.
- **Tokens customizados** via `ThemeExtension` para valores de design que não existem no Material 3 padrão.

## Responsividade

- **LayoutBuilder e MediaQuery** para adaptar UI a diferentes tamanhos de tela.
- **Breakpoints definidos** em constantes centralizadas para phone, tablet e desktop.
- **Widgets responsivos** - usar `Flexible`, `Expanded`, `FractionallySizedBox` em vez de tamanhos fixos quando possível.
- **Proibido tamanhos fixos em pixels** para containers que devem se adaptar - usar proporções, constraints ou MediaQuery.
- **Orientação** - suportar portrait e landscape quando fizer sentido para a feature.

## Acessibilidade (a11y)

- **Semantics obrigatório** - todo widget interativo deve ter `Semantics` ou propriedades de acessibilidade configuradas.
- **Labels descritivos** - botões e ícones interativos devem ter `tooltip` ou `semanticLabel`.
- **Contraste mínimo WCAG AA** - textos com contraste mínimo de 4.5:1 (normal) e 3:1 (large text).
- **Navegação por teclado/foco** - `FocusNode` e `FocusTraversalGroup` configurados para navegação lógica.
- **Tamanho mínimo de toque** - áreas interativas com no mínimo 48x48 dp.
- **Testar com TalkBack (Android) e VoiceOver (iOS)** - acessibilidade deve ser validada em ambas as plataformas.

## Feedback Visual

- **Shimmer/Skeleton obrigatório** para loading states - refletir a estrutura do conteúdo que será carregado. Nunca usar apenas spinner genérico.
- **Feedback imediato em toda ação** - toda interação do usuário deve ter resposta visual (loading, success, error).
- **SnackBar/Toast para ações** - feedback de sucesso e erros leves via SnackBar. Diálogos para erros críticos ou confirmações.
- **Pull-to-refresh** - telas com listas de dados devem suportar pull-to-refresh.
- **Empty states** - toda tela que exibe listas deve ter um empty state informativo com ação sugerida.
- **Animações sutis** - transições e animações devem ser suaves e funcionais, nunca decorativas em excesso.

## Navegação

- **GoRouter** como solução de navegação.
- **Rotas declarativas** - todas as rotas definidas centralmente em `lib/core/router/`.
- **Deep linking** configurado desde o início.
- **Route guards** para proteção de rotas autenticadas.
- **Tipagem nas rotas** - parâmetros de rota tipados, nunca strings soltas para passar dados entre telas.
- **Nested navigation** quando a UI exigir (ex: bottom navigation com stacks independentes).

## gRPC

- Comunicação com backend via **gRPC** (sem HTTP REST).
- **Protobuf files** (`.proto`) como contrato da API, compartilhados com o backend.
- **Geração de código** - usar `protoc` com plugin Dart para gerar stubs e messages.
- **Channel centralizado** - `ClientChannel` configurado em `lib/core/grpc/` com endereço, credenciais e opções.
- **Interceptors obrigatórios**:
  - Auth (injeta token de autenticação nos metadata).
  - Logging (log estruturado de cada request/response em modo debug).
  - Error mapping (converte `GrpcError` em Failures tipadas do domain).
- **Timeouts obrigatórios** - toda chamada gRPC deve ter deadline configurada. Nunca depender de timeout padrão.
- **Retry com exponential backoff** - chamadas ao servidor devem ter retry com backoff exponencial para erros transientes.
- **Streaming** - usar gRPC streams (server-side, client-side ou bidirectional) quando a feature exigir dados em tempo real.

## Cache & Storage

- **Armazenamento local tipado** - usar **Hive** ou **Drift** para persistência local estruturada. Nunca salvar JSON raw em SharedPreferences para dados complexos.
- **SharedPreferences** apenas para configurações simples (flags, preferências do usuário).
- **Secure Storage** (`flutter_secure_storage`) para dados sensíveis (tokens, credenciais).
- **Cache strategy definida** - cada feature que consome dados remotos deve ter estratégia de cache explícita (cache-first, network-first, stale-while-revalidate).
- **Expiração de cache** - todo dado cacheado deve ter TTL configurado. Nunca cache eterno sem invalidação.

## Serialização

- **json_serializable** ou **Freezed** para serialização/desserialização type-safe de models/DTOs.
- **Proibido parsing manual de JSON** - nunca acessar `Map<String, dynamic>` diretamente fora dos models gerados.
- **Factory constructors** `fromJson` e método `toJson` gerados automaticamente.
- **Protobuf messages** como DTOs para comunicação gRPC - converter para entidades do domain no repository.

## Testes

- **Obrigatórios** para todo use case, bloc/cubit, repository e widget com lógica.
- **Testes unitários**: cobrem domain (use cases, entidades) e data (repositories, data sources) com mocks.
- **Testes de widget**: validam comportamento dos widgets usando `WidgetTester`, com mocks dos Blocs.
- **Testes de integração**: validam fluxos completos usando `integration_test`.
- **Cobertura mínima**: 80% em branches e statements para lógica (use cases, blocs, repositories).
- **Golden tests** para componentes visuais críticos - comparação pixel-a-pixel de widgets.
- Testar comportamento, não implementação. Nunca testar detalhes internos de widgets.

## Mocks

- **Mocktail** como biblioteca de mocks (preferência sobre Mockito por não exigir geração de código).
- **Mock de todas as dependências** - use cases, repositories, data sources, blocs devem ser mockáveis via interfaces.
- **Fakes e Stubs** quando necessário para simular comportamento mais complexo.
- **Proibido mocks em testes de integração** - testes de integração devem usar dependências reais ou fakes controlados.

## Dependency Injection

- **get_it + injectable** como solução de DI.
- **Registro centralizado** em `lib/core/di/` com módulos separados por feature ou camada.
- **Todas as dependências registradas via DI** - nunca instanciar dependências diretamente nos widgets ou blocs.
- **Scoped instances** - usar `injectable` com escopos quando a dependência tem lifecycle específico.
- **Lazy singletons** por padrão - instanciar dependências apenas quando necessário.

## Performance

- **Const constructors** em todo widget que aceita parâmetros compile-time.
- **Const wherever possible** - variáveis, listas, maps e widgets `const` quando os valores são conhecidos em compile-time.
- **RepaintBoundary** - isolar widgets que fazem repaint frequente para evitar repaint de árvores inteiras.
- **ListView.builder** para listas longas - nunca usar `Column` com `SingleChildScrollView` para listas dinâmicas.
- **Lazy loading de imagens** - usar `cached_network_image` ou similar para cache e carregamento progressivo.
- **Evitar rebuilds desnecessários** - usar `BlocSelector`, `BlocBuilder` com `buildWhen`, e `context.select` para limitar rebuilds ao mínimo necessário.
- **Proibido computação pesada na main thread** - usar `compute()` ou `Isolate` para operações intensivas.

## Assets

- **flutter_gen** para geração de referências tipadas a assets (imagens, fontes, etc.).
- **Proibido referenciar assets por string** - sempre usar as constantes geradas pelo flutter_gen.
- **Imagens otimizadas** - usar formatos modernos (WebP) e múltiplas resoluções (1x, 2x, 3x).
- **SVG** para ícones e ilustrações escaláveis via `flutter_svg`.
- **Assets declarados no pubspec.yaml** - todo asset deve estar listado explicitamente.

## Segurança

- **Nunca armazenar secrets no client** - tokens, API keys e credenciais nunca hardcoded ou em assets. Usar secure storage para tokens recebidos em runtime.
- **Certificate pinning** para conexões gRPC em produção.
- **Ofuscação obrigatória** no build de release (`--obfuscate --split-debug-info`).
- **Proibido logging de dados sensíveis** - senhas, tokens, PII nunca aparecem em logs.
- **Input sanitization** - sanitizar inputs do usuário antes de enviar ao backend.
- **Biometric/PIN** - telas sensíveis devem exigir autenticação local quando disponível.

## Internacionalização (i18n)

- **i18n desde o início** - toda string visível ao usuário deve ser traduzível. Nunca hardcodar textos na UI.
- Usar **intl** com ARB files ou **easy_localization**.
- Arquivos de tradução organizados por feature em `lib/core/i18n/`.
- **Chaves de tradução descritivas** - usar namespace e chaves hierárquicas (ex: `files.upload.button`, `errors.notFound`).
- **Pluralização e gênero** - usar os mecanismos do intl para plurais e formas de gênero.
- **Locale fallback** - sempre definir um locale padrão como fallback.

## Flavors & Environments

- **Dois ambientes definidos**: `dev` e `production`.
- **Flutter flavors** configurados para cada ambiente com:
  - Bundle ID / Application ID distintos.
  - Ícones e nomes de app distintos por flavor.
  - Endpoints e configurações específicas por ambiente.
- **Variáveis de ambiente** via `--dart-define` ou arquivo de configuração por flavor.
- **Nunca hardcodar valores** que variam entre ambientes.
- **Configuração validada no startup** - se uma configuração obrigatória estiver ausente, a aplicação deve falhar imediatamente com mensagem clara.

## ADRs (Architecture Decision Records)

- Toda decisão arquitetural relevante deve ser documentada em `docs/adr/`.
- Formato padronizado: contexto, decisão, consequências.
- ADRs são imutáveis após aprovação - novas decisões geram novos ADRs que referenciam os anteriores.

## Versionamento e Git

- **Conventional Commits** - mensagens de commit seguindo o padrão: `feat:`, `fix:`, `refactor:`, `test:`, `docs:`, `chore:`.
- **Branch naming** - branches seguem o padrão: `feat/`, `fix/`, `refactor/` + descrição curta em kebab-case.

## Platform Channels

- **Method Channels tipados** - toda comunicação com código nativo via Method Channel com contratos bem definidos.
- **Codec explícito** - usar `StandardMessageCodec` ou codec customizado. Nunca assumir o codec padrão sem declarar.
- **Error handling** - exceptions no lado nativo devem ser convertidas em `PlatformException` e tratadas no Dart como Failures tipadas.
- **Proibido lógica de negócio no lado nativo** - platform channels servem para acessar capacidades da plataforma, nunca para lógica de negócio.
- **Testes** - platform channels devem ter mocks para testes unitários e widget tests.

## Pacotes & Dependências

- Sempre adicionar pacotes via **`flutter pub add <package>`** ou equivalente, nunca editar `pubspec.yaml` manualmente.
- **Sempre instalar a versão mais recente** - buscar a última versão disponível no pub.dev antes de adicionar. Usar o comando com versão explícita (ex: `flutter pub add freezed:^2.5.2`) para garantir a versão correta.
- **Critérios para escolha de pacotes**:
  - Manutenção ativa (última atualização < 6 meses).
  - Dart 3 e null safety compatível.
  - Pub points >= 120.
  - Preferir pacotes do ecosystem Flutter Favorites quando disponíveis.
- **Proibido pacotes abandonados** - se um pacote não tem atualização há mais de 1 ano, buscar alternativa.
- **Análise de impacto** - antes de adicionar uma nova dependência, avaliar o impacto no tamanho do app e conflitos com dependências existentes.

## Linting

- **analysis_options.yaml rigoroso** obrigatório com `flutter_lints` ou `very_good_analysis` como base.
- **Zero warnings policy** - código que gera warnings não pode ser commitado.
- **Custom rules** adicionais conforme necessidade do projeto.

## Princípios Gerais

- Seguir boas práticas de Clean Code e Clean Architecture.
- Simplicidade acima de tudo: não criar abstrações desnecessárias.
- Qualquer decisão de design deve ser justificável pelos princípios SOLID.
- **DRY com cautela** - três repetições similares de código é melhor que uma abstração prematura.
