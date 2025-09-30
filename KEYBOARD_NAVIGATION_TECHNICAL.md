# Documentação Técnica - Navegação por Teclado

## 🏗️ Arquitetura

### Componentes Principais

1. **KeyboardNavigationService** (`keyboard_navigation_service.dart`)
   - Gerencia atalhos globais
   - Controla navegação entre páginas
   - Fornece feedback ao usuário

2. **FocusManagementService** (`focus_management_service.dart`)
   - Gerencia ordem de foco por página
   - Controla travessia de elementos
   - Implementa políticas de foco customizadas

3. **KeyboardNavigationWrapper** (`keyboard_navigation_wrapper.dart`)
   - Wrapper para páginas com suporte a teclado
   - Integra serviços de navegação
   - Fornece atalhos de ajuda

4. **Componentes Acessíveis** (`keyboard_accessible_components.dart`)
   - Botões, campos de texto e links com suporte a teclado
   - Integração com VLibras
   - Estados de foco e hover

5. **Tema de Foco** (`keyboard_focus_theme.dart`)
   - Estilos visuais para estados de foco
   - Cores e animações padronizadas
   - Mixins para componentes

## 🔧 Implementação

### 1. Configuração Básica

```dart
// No main.dart ou app_module.dart
void setupAccessibility() {
  // Registrar serviços
  final keyboardService = KeyboardNavigationService();
  final focusService = FocusManagementService();
  
  keyboardService.initialize();
}
```

### 2. Envolvendo Páginas

```dart
class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return KeyboardNavigationWrapper(
      pageKey: 'my_page',
      enableGlobalShortcuts: true,
      enableFocusManagement: true,
      child: Scaffold(
        // conteúdo da página
      ),
    );
  }
}
```

### 3. Criando Componentes Acessíveis

```dart
// Botão acessível
KeyboardAccessibleButton(
  onPressed: () => doSomething(),
  semanticsLabel: 'Executar ação',
  tooltip: 'Clique para executar',
  focusName: 'action_button',
  child: Text('Ação'),
)

// Campo de texto acessível
KeyboardAccessibleTextField(
  labelText: 'Nome',
  semanticsLabel: 'Campo de nome',
  focusName: 'name_field',
  onChanged: (value) => updateName(value),
)

// Texto clicável acessível
KeyboardAccessibleText(
  text: 'Link importante',
  onPressed: () => navigate(),
  semanticsLabel: 'Link para página importante',
  enableVLibras: true,
  focusName: 'important_link',
)
```

### 4. Gerenciamento de Foco

```dart
class MyPageWithFocus extends StatefulWidget {
  @override
  _MyPageWithFocusState createState() => _MyPageWithFocusState();
}

class _MyPageWithFocusState extends State<MyPageWithFocus> {
  final FocusManagementService _focusService = FocusManagementService();
  final List<FocusNode> _focusNodes = [];

  @override
  void initState() {
    super.initState();
    
    // Criar focus nodes
    for (int i = 0; i < 5; i++) {
      _focusNodes.add(FocusNode());
    }
    
    // Registrar com o serviço
    _focusService.initializePage('my_page');
    _focusService.registerPageFocusNodes('my_page', _focusNodes);
  }

  @override
  void dispose() {
    _focusService.disposePage('my_page');
    for (final node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }
}
```

## 🎨 Estilos e Temas

### 1. Aplicando Estilos de Foco

```dart
class FocusableWidget extends StatefulWidget {
  @override
  _FocusableWidgetState createState() => _FocusableWidgetState();
}

class _FocusableWidgetState extends State<FocusableWidget> 
    with FocusHoverMixin {
  
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: KeyboardFocusTheme.focusAnimationDuration,
      decoration: getStateDecoration(),
      child: Text('Conteúdo'),
    );
  }
}
```

### 2. Criando Indicadores Customizados

```dart
Widget buildCustomFocusIndicator({
  required Widget child,
  required bool isFocused,
}) {
  return KeyboardFocusTheme.buildFocusContainer(
    child: child,
    isFocused: isFocused,
    focusColor: Colors.blue,
    borderRadius: BorderRadius.circular(8),
    padding: EdgeInsets.all(8),
  );
}
```

## 🔍 Atalhos Personalizados

### 1. Atalhos Globais

```dart
final customShortcuts = {
  LogicalKeyboardKey.keyP: () => openProfile(),
  LogicalKeyboardKey.keyN: () => createNew(),
  LogicalKeyboardKey.keyD: () => deleteCurrent(),
};

KeyboardNavigationWrapper(
  pageKey: 'custom_page',
  customShortcuts: customShortcuts,
  child: myPageContent,
)
```

### 2. Atalhos de Página

```dart
class PageWithShortcuts extends StatelessWidget {
  bool _handleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent) {
      switch (event.logicalKey) {
        case LogicalKeyboardKey.keyR:
          if (HardwareKeyboard.instance.isControlPressed) {
            refresh();
            return true;
          }
          break;
        case LogicalKeyboardKey.keyF:
          if (HardwareKeyboard.instance.isControlPressed) {
            openSearch();
            return true;
          }
          break;
      }
    }
    return false;
  }
}
```

## 🧪 Testes de Acessibilidade

### 1. Testes Manuais

```dart
// Teste de navegação por Tab
void testTabNavigation() {
  // 1. Pressione Tab repetidamente
  // 2. Verifique se todos os elementos recebem foco
  // 3. Verifique se a ordem é lógica
  // 4. Teste Shift+Tab para navegação reversa
}

// Teste de atalhos
void testKeyboardShortcuts() {
  // 1. Teste cada atalho documentado
  // 2. Verifique feedback visual
  // 3. Confirme que ações são executadas
}
```

### 2. Testes Automatizados

```dart
testWidgets('Keyboard navigation works', (WidgetTester tester) async {
  await tester.pumpWidget(MyApp());
  
  // Simular Tab
  await tester.sendKeyEvent(LogicalKeyboardKey.tab);
  await tester.pump();
  
  // Verificar foco
  expect(find.byType(KeyboardAccessibleButton), findsOneWidget);
  
  // Simular Enter
  await tester.sendKeyEvent(LogicalKeyboardKey.enter);
  await tester.pump();
  
  // Verificar ação executada
  verify(mockAction.call()).called(1);
});
```

## 🔧 Configuração Avançada

### 1. Políticas de Foco Customizadas

```dart
class CustomFocusTraversalPolicy extends FocusTraversalPolicy {
  @override
  FocusNode? findFirstFocus(FocusNode currentNode) {
    // Implementação customizada
    return customLogic(currentNode);
  }
  
  @override
  FocusNode? findNextFocus(FocusNode currentNode, 
      {FocusTraversalPolicy? policy}) {
    // Lógica de próximo foco
    return findNextLogically(currentNode);
  }
}

// Aplicar política
FocusTraversalGroup(
  policy: CustomFocusTraversalPolicy(),
  child: myWidget,
)
```

### 2. Integração com Leitores de Tela

```dart
class ScreenReaderFriendlyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Descrição para leitores de tela',
      hint: 'Dica de uso',
      button: true,
      enabled: true,
      focusable: true,
      child: myInteractiveWidget,
    );
  }
}
```

## 📱 Suporte Multi-plataforma

### 1. Detecção de Plataforma

```dart
void setupKeyboardNavigation() {
  if (UniversalPlatform.isWeb) {
    // Configuração completa para web
    enableFullKeyboardNavigation();
  } else if (UniversalPlatform.isDesktop) {
    // Configuração para desktop
    enableDesktopKeyboardNavigation();
  } else {
    // Móvel - navegação básica
    enableBasicNavigation();
  }
}
```

### 2. Fallbacks Graceful

```dart
class PlatformAwareKeyboardWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (KeyboardNavigationService().isSupported) {
      return KeyboardNavigationWrapper(
        // Implementação completa
      );
    } else {
      return BasicNavigationWrapper(
        // Implementação básica
      );
    }
  }
}
```

## 🚀 Performance

### 1. Otimizações

```dart
// Lazy loading de focus nodes
class OptimizedFocusManager {
  final Map<String, FocusNode> _cachedNodes = {};
  
  FocusNode getFocusNode(String key) {
    return _cachedNodes.putIfAbsent(key, () => FocusNode());
  }
  
  void disposeCachedNodes() {
    for (final node in _cachedNodes.values) {
      node.dispose();
    }
    _cachedNodes.clear();
  }
}
```

### 2. Evitar Vazamentos de Memória

```dart
@override
void dispose() {
  // Sempre limpar focus nodes
  for (final node in _focusNodes) {
    node.dispose();
  }
  
  // Limpar registros de serviços
  _focusService.disposePage(widget.pageKey);
  _keyboardService.unregisterFocusNode(widget.focusName);
  
  super.dispose();
}
```

## 🐛 Depuração

### 1. Logs de Debug

```dart
void debugKeyboardNavigation() {
  final service = KeyboardNavigationService();
  
  print('Atalhos disponíveis: ${service.availableShortcuts}');
  print('Foco atual: ${service.currentFocus}');
  print('Plataforma suportada: ${service.isSupported}');
}
```

### 2. Visualização de Foco

```dart
class FocusDebugWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        myWidget,
        if (kDebugMode)
          FocusVisualizer(), // Mostra todos os focus nodes
      ],
    );
  }
}
```

## 📚 Boas Práticas

### 1. Ordem de Tab Lógica
- Sempre da esquerda para direita, cima para baixo
- Agrupar elementos relacionados
- Pular elementos não interativos

### 2. Feedback Visual
- Sempre fornecer indicação clara de foco
- Usar cores de alto contraste
- Animações suaves para transições

### 3. Semântica Adequada
- Labels descritivas para todos os elementos
- Estrutura HTML semântica
- Landmarks apropriados

### 4. Testes Regulares
- Testar com diferentes navegadores
- Usar leitores de tela reais
- Validar com usuários reais

---

**Esta documentação técnica garante que todos os aspectos da navegação por teclado sejam implementados corretamente e mantidos ao longo do tempo.**