# Frontend Rules - React + TypeScript

## Arquitetura

- **Separação de responsabilidades**: lógica de negócio isolada da UI.
  - **Hooks customizados**: encapsulam lógica de estado, side effects e regras de negócio.
  - **Componentes**: responsáveis apenas por renderização e interação do usuário.
  - **Containers**: conectam hooks/estado aos componentes presentacionais quando necessário.
- Composição sobre herança em todos os níveis de componentes.

## Estrutura de Pastas

- Layout **feature-based** obrigatório:
  - `src/features/` - módulos organizados por funcionalidade/domínio.
  - `src/components/` - componentes compartilhados e reutilizáveis.
  - `src/hooks/` - hooks compartilhados.
  - `src/stores/` - stores Zustand.
  - `src/services/` - clients de API e comunicação externa.
  - `src/types/` - tipos e interfaces compartilhados por domínio.
  - `src/lib/` - configurações e wrappers de bibliotecas externas.
  - `src/styles/` - estilos globais e tokens de tema.
  - `src/i18n/` - arquivos de tradução e configuração de internacionalização.
  - `docs/adr/` - Architecture Decision Records de frontend.
- **Barrel exports** (`index.ts`) obrigatórios por módulo/feature para encapsular imports internos.
- **Proibido** criar pastas genéricas como `utils`, `helpers`, `common`. Colocar no contexto da feature ou em `lib/`.

## Framework & Componentes

- **React** como framework de UI.
- **Componentes funcionais only** - proibido usar class components.
- **Single Responsibility** - cada componente tem uma única responsabilidade. Se um componente faz demais, extrair em subcomponentes ou hooks.
- Composição de componentes via `children`, render props ou hooks - nunca herança.
- **Ant Design** como biblioteca de componentes UI. Usar os componentes do Ant Design como base, customizando via theme tokens quando necessário. Evitar recriar componentes que o Ant Design já oferece.

## Estado

- **Zustand** como gerenciador de estado global.
- **Separação clara** entre estado local (useState/useReducer) e estado global (Zustand stores).
  - Estado local: dados que pertencem apenas a um componente (form inputs, toggles, UI state temporário).
  - Estado global: dados compartilhados entre múltiplos componentes ou que precisam persistir entre navegações.
- Uma store por domínio/feature - nunca uma store monolítica.
- **Imutabilidade obrigatória** - nunca mutar estado diretamente. Sempre criar novos objetos/arrays.

## Estilização

- **Ant Design theme system** como abordagem principal de estilização.
- Customização via **design tokens** do Ant Design (cores, espaçamentos, tipografia).
- Para estilos customizados além do Ant Design, usar **CSS Modules**.
- **Desktop-first** - estilos base para desktop, media queries para adaptar a telas menores.
- **Proibido** inline styles exceto para valores dinâmicos calculados em runtime.

## TypeScript

- **Strict mode obrigatório** - `strict: true` no `tsconfig.json`.
- **Proibido `any`** - usar `unknown` quando o tipo não é conhecido, e fazer type narrowing explícito.
- **Tipos por domínio** - interfaces e types organizados por contexto de negócio, nunca tipos genéricos soltos.
- **Preferir `interface` para objetos** e `type` para unions, intersections e tipos utilitários.
- **Proibido type assertions (`as`)** exceto em casos justificados e documentados com comentário explicando o motivo.

## Testes

- **Obrigatórios** para todo hook customizado, função utilitária e componente com lógica.
- **Testes unitários**: cobrem hooks, stores e funções puras com mocks de dependências.
- **Testes de componente**: usam **React Testing Library** para validar comportamento do usuário (não implementação interna).
- **Testes E2E**: usam **Playwright** para fluxos críticos da aplicação.
- **Cobertura mínima**: 80% de cobertura em branches e statements para código de lógica (hooks, stores, services).
- Testar comportamento, não implementação. Nunca testar detalhes internos de componentes.

## Performance

- **Lazy loading obrigatório** para rotas e módulos pesados via `React.lazy` + `Suspense`.
- **Memoização consciente** - usar `React.memo`, `useMemo` e `useCallback` apenas quando houver problema de performance comprovado ou em componentes que recebem callbacks em listas grandes. Nunca memoizar por padrão.
- **Bundle size budget** - monitorar tamanho do bundle. Proibido adicionar dependências pesadas sem justificativa e análise de impacto.
- **Otimização de assets** - imagens devem usar formatos modernos (WebP, AVIF). Ícones via SVG components ou Ant Design Icons. Lazy load para imagens fora do viewport.

## Qualidade de Código

- **ESLint + Prettier obrigatórios** - configurados no projeto com regras consistentes. Código que não passa no lint não pode ser commitado.
- **Proibido `console.log` em produção** - usar sistema de logging estruturado ou remover antes do commit. Permitido apenas `console.error` e `console.warn` em tratamento de erros.
- **Proibido magic numbers e magic strings** - extrair valores literais para constantes nomeadas com significado claro. Exceção: valores óbvios como `0`, `1`, `""`, `true/false`.
- **Error Boundaries obrigatórios** - toda aplicação deve ter Error Boundaries em pontos estratégicos (layout principal, features independentes) para evitar crash total da UI.
- **Fallback UI obrigatório** - todo Error Boundary deve renderizar uma UI de fallback informativa (mensagem de erro + ação de recuperação). Nunca exibir tela branca.

## Acessibilidade (a11y)

- **HTML semântico obrigatório** - usar elementos corretos (`button`, `nav`, `main`, `section`, `article`) em vez de `div` para tudo.
- **Atributos ARIA** quando HTML semântico não for suficiente.
- **Navegação por teclado** - todos os elementos interativos devem ser acessíveis via teclado (Tab, Enter, Escape).
- **Contraste mínimo WCAG AA** - textos devem ter contraste mínimo de 4.5:1 (normal) e 3:1 (large text).
- **Textos alternativos** - toda imagem deve ter `alt` descritivo. Imagens decorativas usam `alt=""`.

## Segurança

- **Sanitização de inputs** - todo conteúdo dinâmico renderizado deve ser sanitizado para prevenir XSS. Nunca usar `dangerouslySetInnerHTML` sem sanitização explícita.
- **Nunca expor secrets no client-side** - tokens, API keys e credentials nunca devem estar no código fonte ou em variáveis de ambiente acessíveis no browser. Usar variáveis de ambiente server-side only.
- **CSP headers** - Content Security Policy configurada para restringir origens de scripts, estilos e conexões externas.

## API & Comunicação

- **Client HTTP centralizado** - toda comunicação com APIs passa por um client configurado centralmente (axios instance ou fetch wrapper) com base URL, interceptors de auth, timeout e error handling.
- **Tratamento global de erros de API** - interceptors do client HTTP devem capturar erros e exibir notificações padronizadas (Ant Design notification/message). Erros genéricos (500, network error, timeout) tratados automaticamente. Erros de negócio (400, 404, 409) tratados pela feature específica.
- **Tratamento padronizado de estados** - todo request deve tratar explicitamente os estados: loading, success, error e empty. Componentes devem exibir feedback visual adequado para cada estado.
- **Cache de requests** - usar **React Query (TanStack Query)** para cache, revalidação e sincronização de dados do servidor. Nunca implementar cache manual de requests.

## UX & Feedback

- **Skeletons over spinners** - usar Ant Design Skeleton para loading states em vez de spinners genéricos. Skeletons refletem a estrutura do conteúdo que será carregado.
- **Feedback visual obrigatório** - toda ação do usuário deve ter feedback visual imediato (success, error, loading). Nunca deixar o usuário sem saber o que está acontecendo.
- **Debounce obrigatório** - inputs de busca e chamadas frequentes disparadas por interação do usuário devem ter debounce para evitar requests excessivos.

## Formulários & Validação

- **Validação com Zod** - schemas de validação definidos com Zod para todos os formulários e inputs do usuário.
- Schemas de validação colocados junto à feature que os utiliza.
- Mensagens de erro claras e traduzidas (i18n) para o usuário.
- Integrar Zod com Ant Design Form via validação customizada.

## Internacionalização (i18n)

- **i18n desde o início** - toda string visível ao usuário deve ser traduzível. Nunca hardcodar textos na UI.
- Usar biblioteca de i18n (i18next + react-i18next).
- Arquivos de tradução organizados por feature/módulo em `src/i18n/`.
- **Chaves de tradução descritivas** - usar namespace e chaves hierárquicas (ex: `files.upload.button`, `errors.notFound`).

## Documentação

- **Storybook** para documentação visual de componentes compartilhados (`src/components/`).
- Cada componente reutilizável deve ter ao menos uma story demonstrando seus estados e variações.
- **ADRs** - decisões arquiteturais de frontend documentadas em `docs/adr/`.

## Versionamento e Git

- **Conventional Commits** - mensagens de commit seguindo o padrão: `feat:`, `fix:`, `refactor:`, `test:`, `docs:`, `chore:`.
- **Branch naming** - branches seguem o padrão: `feat/`, `fix/`, `refactor/` + descrição curta em kebab-case.

## Naming Conventions

- **PascalCase** para componentes, types e interfaces (ex: `UserProfile`, `FileUploadProps`).
- **camelCase** para variáveis, funções e hooks (ex: `userName`, `handleSubmit`).
- Hooks customizados **sempre** com prefixo `use` (ex: `useFileUpload`, `useAuth`).
- **UPPER_SNAKE_CASE** para constantes (ex: `MAX_FILE_SIZE`, `API_BASE_URL`).
- Nomes descritivos e auto-explicativos - Clean Code. Evitar abreviações obscuras.

## Ordem de Imports

- Ordem padronizada obrigatória em todo arquivo:
  1. Imports externos (React, bibliotecas de terceiros).
  2. Imports internos (components, hooks, stores, services).
  3. Imports de tipos/interfaces.
  4. Imports de estilos (CSS Modules, etc.).
- Separar cada grupo com uma linha em branco. Configurar ESLint para enforçar esta ordem automaticamente.

## Hooks

- Custom hooks devem seguir o padrão `useNomeDescritivo` e ter **responsabilidade única**.
- **Proibido hooks com mais de 3 dependências externas** (outros hooks, stores, services) - sinal de que o hook precisa ser dividido em hooks menores e mais focados.
- Lógica de negócio reside nos hooks, nunca diretamente nos componentes.

## Configuração & Ambiente

- **Variáveis de ambiente tipadas e validadas** - usar Zod para validar todas as variáveis de ambiente no startup da aplicação. Se uma variável obrigatória estiver ausente, a aplicação deve falhar imediatamente com mensagem clara.
- **Dois ambientes definidos**: `dev` e `production`, com configurações separadas.
- Nunca hardcodar valores que variam entre ambientes.

## Dependências

- Sempre instalar dependências via **gerenciador de pacotes** (`npm`, `pnpm`, `bun`, etc.) - nunca adicionar pacotes manualmente no `package.json`.
- Usar o comando adequado do gerenciador escolhido (ex: `npm install`, `pnpm add`, `bun add`) para garantir que o lockfile seja atualizado corretamente.
- **Sempre instalar a versão mais recente** (`latest`) dos pacotes. Quando for necessário fixar uma versão específica, buscar a última versão LTS disponível e informar explicitamente a versão no comando de instalação (ex: `npm install react@18.3.1`).

## Princípios Gerais

- Seguir boas práticas de Clean Code.
- Simplicidade acima de tudo: não criar abstrações desnecessárias.
- **SOLID aplicado ao frontend**:
  - **S** - componentes e hooks com responsabilidade única.
  - **O** - componentes extensíveis via props e composição, sem modificar internos.
  - **L** - componentes que implementam a mesma interface devem ser substituíveis.
  - **I** - props interfaces pequenas e específicas. Nunca forçar props desnecessárias.
  - **D** - depender de abstrações (hooks, contexts), não de implementações concretas.
