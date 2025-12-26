import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:vitrine_ufma/app/app_widget.dart';

// Importa helper condicional do NVDA
import 'package:vitrine_ufma/app/core/utils/nvda_helper_stub.dart' if (dart.library.html) 'package:vitrine_ufma/app/core/utils/nvda_helper.dart';

/// Serviço para lidar com navegação por teclado global e atalhos
class KeyboardNavigationService {
  static final KeyboardNavigationService _instance = KeyboardNavigationService._internal();
  factory KeyboardNavigationService() => _instance;
  KeyboardNavigationService._internal();

  // Gerenciamento de foco
  final Map<String, FocusNode> _namedFocusNodes = {};
  FocusNode? _currentFocus;
  
  // Atalhos de navegação
  static const Map<String, LogicalKeyboardKey> _shortcuts = {
    'home': LogicalKeyboardKey.keyH,
    'about': LogicalKeyboardKey.keyA,
    'accessibility': LogicalKeyboardKey.keyC,
    'help': LogicalKeyboardKey.keyJ,
    'search': LogicalKeyboardKey.keyS,
    'login': LogicalKeyboardKey.keyL,
    'escape': LogicalKeyboardKey.escape,
  };

  /// Inicializa o serviço de navegação por teclado
  void initialize() {
    if (!UniversalPlatform.isWeb) return;
    
    // Habilita modo semântico para melhor suporte ao leitor de tela
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setupGlobalShortcuts();
    });
  }

  /// Configura atalhos de teclado globais
  void _setupGlobalShortcuts() {
    // Isso será tratado no nível do widget usando RawKeyboardListener
  }

  /// Trata eventos de teclado
  bool handleKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent) return false;

    // Trata atalhos Ctrl+Alt+Tecla
    if (HardwareKeyboard.instance.isControlPressed && HardwareKeyboard.instance.isAltPressed) {
      return _handleCtrlAltShortcuts(event.logicalKey);
    }
    
    // Trata atalhos Ctrl+Tecla
    if (HardwareKeyboard.instance.isControlPressed) {
      return _handleControlShortcuts(event.logicalKey);
    }

    // Trata atalhos Alt+Tecla para navegação
    if (HardwareKeyboard.instance.isAltPressed) {
      return _handleAltShortcuts(event.logicalKey);
    }

    // Trata tecla Escape
    if (event.logicalKey == LogicalKeyboardKey.escape) {
      return _handleEscape();
    }
    
    // Trata tecla F1 para ajuda
    if (event.logicalKey == LogicalKeyboardKey.f1) {
      _showKeyboardShortcutsHelp();
      return true;
    }
    
    // Trata tecla Home
    if (event.logicalKey == LogicalKeyboardKey.home) {
      if (HardwareKeyboard.instance.isControlPressed) {
        _navigateToTop();
        return true;
      } else {
        _navigateToFirstItem();
        return true;
      }
    }
    
    // Trata tecla End
    if (event.logicalKey == LogicalKeyboardKey.end) {
      if (HardwareKeyboard.instance.isControlPressed) {
        _navigateToBottom();
        return true;
      } else {
        _navigateToLastItem();
        return true;
      }
    }
    
    // Trata teclas de seta para navegação em menu/lista
    if (event.logicalKey == LogicalKeyboardKey.arrowUp ||
        event.logicalKey == LogicalKeyboardKey.arrowDown ||
        event.logicalKey == LogicalKeyboardKey.arrowLeft ||
        event.logicalKey == LogicalKeyboardKey.arrowRight) {
      return _handleArrowKeys(event.logicalKey);
    }

    return false;
  }

  /// Trata atalhos Control+Tecla
  bool _handleControlShortcuts(LogicalKeyboardKey key) {
    switch (key) {
      case LogicalKeyboardKey.keyS:
        _navigateToSearch();
        return true;
      case LogicalKeyboardKey.keyH:
        _navigateToHome();
        return true;
      case LogicalKeyboardKey.home:
        _navigateToTop();
        return true;
      case LogicalKeyboardKey.end:
        _navigateToBottom();
        return true;
      default:
        return false;
    }
  }

  /// Trata atalhos Alt+Tecla para navegação principal
  bool _handleAltShortcuts(LogicalKeyboardKey key) {
    switch (key) {
      case LogicalKeyboardKey.keyH:
        _navigateToHome();
        return true;
      case LogicalKeyboardKey.keyA:
        _navigateToAbout();
        return true;
      case LogicalKeyboardKey.keyC:
        _navigateToAccessibility();
        return true;
      case LogicalKeyboardKey.keyJ:
        _navigateToHelp();
        return true;
      case LogicalKeyboardKey.keyL:
        _navigateToLogin();
        return true;
      default:
        return false;
    }
  }

  /// Trata atalhos Ctrl+Alt+Tecla
  bool _handleCtrlAltShortcuts(LogicalKeyboardKey key) {
    switch (key) {
      case LogicalKeyboardKey.keyN:
        _toggleNVDA();
        return true;
      default:
        return false;
    }
  }

  /// Alternar leitor de tela NVDA
  void _toggleNVDA() {
    if (UniversalPlatform.isWeb) {
      NVDAHelper.toggleNVDAArea();
      _announceNavigation('NVDA ativado/desativado');
    }
  }

  /// Trata tecla Escape
  bool _handleEscape() {
    final currentContext = NavigationService.navigatorKey.currentContext;
    if (currentContext != null) {
      // Fecha quaisquer diálogos ou folhas abertos
      if (Navigator.canPop(currentContext)) {
        Navigator.pop(currentContext);
        return true;
      }
    }
    return false;
  }

  /// Trata teclas de seta para navegação
  bool _handleArrowKeys(LogicalKeyboardKey key) {
    // Isso normalmente é tratado pelo sistema de gerenciamento de foco
    // Para navegação em menu/lista, isso seria tratado nos componentes específicos
    return false;
  }

  /// Navega para o topo da página
  void _navigateToTop() {
    final currentContext = NavigationService.navigatorKey.currentContext;
    if (currentContext != null) {
      // Rola para o topo da página
      // Isso normalmente seria tratado rolando para um widget específico
      _announceNavigation('Navegando para o topo da página');
    }
  }

  /// Navega para o final da página
  void _navigateToBottom() {
    final currentContext = NavigationService.navigatorKey.currentContext;
    if (currentContext != null) {
      // Rola para o final da página
      // Isso normalmente seria tratado rolando para um widget específico
      _announceNavigation('Navegando para o final da página');
    }
  }

  /// Navega para o primeiro item na lista/página
  void _navigateToFirstItem() {
    _announceNavigation('Navegando para o primeiro item');
    // Isso seria tratado pelo serviço de gerenciamento de foco
  }

  /// Navega para o último item na lista/página
  void _navigateToLastItem() {
    _announceNavigation('Navegando para o último item');
    // Isso seria tratado pelo serviço de gerenciamento de foco
  }

  // Métodos de navegação
  void _navigateToHome() {
    Modular.to.navigate('/home/books');
    _announceNavigation('Navegando para Início');
  }

  void _navigateToAbout() {
    Modular.to.navigate('/home/about');
    _announceNavigation('Navegando para Sobre');
  }

  void _navigateToAccessibility() {
    Modular.to.navigate('/home/acessibilities');
    _announceNavigation('Navegando para Acessibilidade');
  }

  void _navigateToHelp() {
    Modular.to.navigate('/home/help');
    _announceNavigation('Navegando para Ajuda');
  }

  void _navigateToLogin() {
    Modular.to.navigate('/auth');
    _announceNavigation('Navegando para Login');
  }

  void _navigateToSearch() {
    Modular.to.navigate('/home/search');
    _announceNavigation('Navegando para Busca');
  }

  /// Anuncia navegação para leitores de tela
  void _announceNavigation(String message) {
    final currentContext = NavigationService.navigatorKey.currentContext;
    if (currentContext != null) {
      ScaffoldMessenger.of(currentContext).clearSnackBars();
      ScaffoldMessenger.of(currentContext).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(milliseconds: 1500),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.blue.shade600,
        ),
      );
    }
  }

  /// Mostra ajuda de atalhos de teclado
  void _showKeyboardShortcutsHelp() {
    // Isso será tratado pelo KeyboardNavigationWrapper
    _announceNavigation('Pressione F1 para ajuda com atalhos de teclado');
  }

  /// Registra um nó de foco nomeado
  void registerFocusNode(String name, FocusNode focusNode) {
    _namedFocusNodes[name] = focusNode;
  }

  /// Remove o registro de um nó de foco nomeado
  void unregisterFocusNode(String name) {
    _namedFocusNodes.remove(name);
  }

  /// Foca em um nó nomeado
  void focusOn(String name) {
    final focusNode = _namedFocusNodes[name];
    if (focusNode != null) {
      focusNode.requestFocus();
      _currentFocus = focusNode;
    }
  }

  /// Obtém o nó de foco atual
  FocusNode? get currentFocus => _currentFocus;

  /// Verifica se a navegação por teclado é suportada
  bool get isSupported => UniversalPlatform.isWeb;

  /// Obtém atalhos disponíveis como texto de ajuda
  Map<String, String> get availableShortcuts => {
    'Alt + H': 'Ir para Início',
    'Alt + A': 'Ir para Sobre',
    'Alt + C': 'Ir para Acessibilidade',
    'Alt + J': 'Ir para Ajuda',
    'Alt + L': 'Ir para Login',
    'Ctrl + S': 'Ir para Busca',
    'Ctrl + H': 'Ir para Início',
    'Ctrl + Home': 'Ir para o topo da página',
    'Ctrl + End': 'Ir para o final da página',
    'Ctrl + Alt + N': 'Ativar/desativar NVDA',
    'Tab': 'Navegar pelos elementos',
    'Shift + Tab': 'Navegar pelos elementos (reverso)',
    'Enter': 'Ativar elemento selecionado',
    'Space': 'Ativar checkbox/radio',
    'Esc': 'Fechar diálogos/menus',
    'Home': 'Ir para o primeiro item',
    'End': 'Ir para o último item',
    'F1': 'Mostrar ajuda de atalhos',
  };

  /// Descarta recursos
  void dispose() {
    _namedFocusNodes.clear();
    _currentFocus = null;
  }
}