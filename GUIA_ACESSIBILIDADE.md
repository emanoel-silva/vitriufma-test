# Guia de Acessibilidade para Vitrine UFMA

Este guia documenta as práticas de acessibilidade implementadas no projeto Vitrine UFMA, seguindo as diretrizes WCAG 2.2 e as melhores práticas de 2025 para aplicações Flutter Web.

## Diretrizes de Acessibilidade Implementadas

### 1. Estrutura Semântica

#### Hierarquia de Cabeçalhos
- Uso correto de níveis de cabeçalhos (H1, H2, H3, etc.)
- Cada página tem um único H1 que descreve o propósito principal
- Hierarquia lógica e consistente

#### Landmarks Regionais
- Uso de `Semantics` para definir landmarks como:
  - `header` para cabeçalhos
  - `footer` para rodapés
  - `main` para conteúdo principal
  - `navigation` para menus de navegação

### 2. Contraste de Cores

#### Requisitos de Contraste
- Contraste mínimo de 4.5:1 para texto normal
- Contraste mínimo de 3:1 para texto grande (18pt+ ou 14pt+ bold)
- Verificação automática de contraste em componentes

#### Paleta de Cores Acessível
```dart
// Exemplo de cores com contraste adequado
class AccessibleColors {
  static const Color primary = Color(0xFF0066CC); // 4.5:1+ contra branco
  static const Color onPrimary = Color(0xFFFFFFFF); // Texto em cima do primário
  static const Color background = Color(0xFFFFFFFF); // Fundo
  static const Color onBackground = Color(0xFF212121); // Texto normal
  static const Color surface = Color(0xFFF5F5F5); // Superfícies
  static const Color onSurface = Color(0xFF212121); // Texto em superfícies
}
```

### 3. Navegação por Teclado

#### Foco Visível
- Indicadores de foco claros em todos os elementos interativos
- Animações de foco suaves e perceptíveis
- Ordem lógica de tabulação

#### Skip Links
- Links para pular diretamente ao conteúdo principal
- Visíveis ao receber foco do teclado

#### Atalhos de Teclado
- Suporte a comandos padrão (Tab, Enter, Space, etc.)
- Atalhos personalizados documentados

### 4. Suporte a Leitores de Tela

#### Labels Semânticas
- Uso de `Semantics` para fornecer labels descritivas
- Textos alternativos para ícones e imagens
- Estados dinâmicos anunciados (selecionado, focado, etc.)

#### Anúncios de Conteúdo
- Uso de `SemanticsService.announce()` para notificações importantes
- Feedback imediato para ações do usuário

### 5. Escalonamento de Texto

#### Tamanhos de Fonte Flexíveis
- Unidades relativas (em, rem) onde apropriado
- Suporte a configurações de zoom do navegador
- Tamanhos mínimos garantidos (16px para corpo de texto)

#### Zoom de Conteúdo
- Layout responsivo que se adapta ao zoom
- Nenhum conteúdo cortado ou sobreposto em 200% de zoom

### 6. Componentes Acessíveis Personalizados

#### AccessibleTextField
Campo de texto com:
- Labels e hints semânticas
- Contraste adequado
- Feedback de foco
- Anúncios para leitores de tela

#### AccessibleButton
Botão com:
- Tamanho mínimo de toque (44x44px)
- Estados visuais claros
- Labels semânticas
- Feedback tátil e sonoro

#### AccessibleCard
Card com:
- Estrutura semântica adequada
- Hierarquia de cabeçalhos
- Contraste de cores
- Suporte a interação por teclado

## Testando Acessibilidade

### 1. Ativando um Leitor de Tela

#### NVDA (Windows)
1. Baixe e instale o NVDA em [nvaccess.org](https://www.nvaccess.org/download/)
2. Execute o NVDA
3. Abra a aplicação Vitrine UFMA no navegador
4. Use comandos do NVDA para navegar:
   - `Ctrl` - Parar leitura
   - `NVDA + Seta para cima/baixo` - Navegar por linhas
   - `Tab/Shift + Tab` - Navegar entre elementos interativos

#### VoiceOver (macOS)
1. Ative VoiceOver: `Cmd + F5`
2. Abra a aplicação no Safari
3. Use comandos do VoiceOver:
   - `Ctrl + Alt + Shift + Seta para baixo` - Iniciar/parar VoiceOver
   - `Ctrl + Alt + Seta para a direita/esquerda` - Navegar entre elementos

### 2. Navegação com Teclado

#### Comandos Básicos
1. Use `Tab` para avançar para o próximo elemento interativo
2. Use `Shift + Tab` para voltar ao elemento anterior
3. Use `Enter` ou `Space` para ativar botões e links
4. Use `Setas` para navegar em menus e listas

#### Verificando Funcionalidades
- Todos os elementos interativos devem ser alcançáveis via Tab
- Indicadores de foco devem ser claramente visíveis
- Labels e instruções devem ser anunciadas corretamente
- Estados dinâmicos devem ser comunicados

### 3. Verificação de Contraste

#### Ferramentas Recomendadas
- [WebAIM Contrast Checker](https://webaim.org/resources/contrastchecker/)
- [Colour Contrast Analyser](https://developer.paciellogroup.com/resources/contrastanalyser/)
- Extensões de navegador como axe ou WAVE

#### Critérios de Aprovação
- Texto normal: mínimo 4.5:1
- Texto grande: mínimo 3:1
- Componentes gráficos: mínimo 3:1

## Melhores Práticas de Implementação

### 1. Uso de Semantics

```dart
// Boa prática - Semantics com labels descritivas
Semantics(
  header: true,
  label: 'Seção de destaques',
  child: Text(
    'Destaques',
    style: Theme.of(context).textTheme.headlineSmall,
  ),
)

// Boa prática - Botão com label semântica
Semantics(
  button: true,
  label: 'Adicionar aos favoritos',
  child: IconButton(
    icon: Icon(Icons.favorite),
    onPressed: _toggleFavorite,
  ),
)
```

### 2. Gerenciamento de Foco

```dart
// Boa prática - FocusNode com tratamento adequado
class _AccessibleComponentState extends State<AccessibleComponent> {
  late FocusNode _focusNode;
  
  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_handleFocusChange);
  }
  
  void _handleFocusChange() {
    if (_focusNode.hasFocus) {
      // Ação quando recebe foco
      SemanticsService.announce('Campo focado', TextDirection.ltr);
    }
  }
  
  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
    super.dispose();
  }
}
```

### 3. Anúncios para Leitores de Tela

```dart
// Boa prática - Anúncios contextuais
void _handleAction() {
  // Executar ação
  performAction();
  
  // Anunciar resultado
  SemanticsService.announce(
    'Item adicionado com sucesso', 
    TextDirection.ltr
  );
}
```

## Componentes Acessíveis Disponíveis

### AccessibleTextField
```dart
AccessibleTextField(
  label: 'Nome completo',
  hint: 'Digite seu nome completo',
  semanticsLabel: 'Campo de entrada para nome completo',
  onChanged: (value) {
    // Tratar mudança de valor
  },
)
```

### AccessibleButton
```dart
AccessibleButton(
  semanticsLabel: 'Botão de envio',
  tooltip: 'Enviar formulário',
  onPressed: _handleSubmit,
  child: Text('Enviar'),
)
```

### AccessibleCard
```dart
AccessibleCard(
  title: Text('Título do Card'),
  content: Text('Conteúdo do card'),
  clickable: true,
  onTap: () {
    // Ação ao clicar
  },
  semanticsLabel: 'Card interativo com informações importantes',
)
```

## Recursos Adicionais

### Documentação Oficial
- [Flutter Accessibility Documentation](https://flutter.dev/docs/development/accessibility-and-localization/accessibility)
- [WCAG 2.2 Guidelines](https://www.w3.org/TR/WCAG22/)
- [WAI-ARIA Authoring Practices](https://w3c.github.io/aria-practices/)

### Ferramentas de Teste
- [axe DevTools](https://www.deque.com/axe/devtools/)
- [WAVE Evaluation Tool](https://wave.webaim.org/)
- [Lighthouse Accessibility Audit](https://developers.google.com/web/tools/lighthouse)

### Comunidades e Suporte
- [Flutter Community](https://flutter.dev/community)
- [Accessibility Slack Channels](https://fluttercommunity.dev/)
- [A11Y Project](https://a11yproject.com/)

## Contribuindo com Acessibilidade

### Diretrizes para Novos Componentes
1. Sempre use `Semantics` para fornecer contexto
2. Garanta contraste de cores adequado
3. Teste com leitor de tela
4. Verifique navegação por teclado
5. Documente funcionalidades acessíveis

### Revisão de Código
- Verifique implementação de acessibilidade em todos os PRs
- Use checklists de acessibilidade
- Teste com ferramentas automatizadas
- Valide com usuários reais quando possível

## Contato

Para dúvidas ou sugestões sobre acessibilidade, entre em contato com a equipe de desenvolvimento através do [canal de issues do projeto](https://github.com/seu-usuario/vitrineufma/issues).