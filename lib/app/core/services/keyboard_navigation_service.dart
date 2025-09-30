import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:vitrine_ufma/app/app_widget.dart';

/// Service to handle global keyboard navigation and shortcuts
class KeyboardNavigationService {
  static final KeyboardNavigationService _instance = KeyboardNavigationService._internal();
  factory KeyboardNavigationService() => _instance;
  KeyboardNavigationService._internal();

  // Focus management
  final Map<String, FocusNode> _namedFocusNodes = {};
  FocusNode? _currentFocus;
  
  // Navigation shortcuts
  static const Map<String, LogicalKeyboardKey> _shortcuts = {
    'home': LogicalKeyboardKey.keyH,
    'about': LogicalKeyboardKey.keyA,
    'accessibility': LogicalKeyboardKey.keyC,
    'help': LogicalKeyboardKey.keyJ,
    'search': LogicalKeyboardKey.keyS,
    'login': LogicalKeyboardKey.keyL,
    'escape': LogicalKeyboardKey.escape,
  };

  /// Initialize keyboard navigation service
  void initialize() {
    if (!UniversalPlatform.isWeb) return;
    
    // Enable semantic mode for better screen reader support
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setupGlobalShortcuts();
    });
  }

  /// Setup global keyboard shortcuts
  void _setupGlobalShortcuts() {
    // This will be handled at the widget level using RawKeyboardListener
  }

  /// Handle keyboard events
  bool handleKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent) return false;

    // Handle Ctrl+Key shortcuts
    if (HardwareKeyboard.instance.isControlPressed) {
      return _handleControlShortcuts(event.logicalKey);
    }

    // Handle Alt+Key shortcuts for navigation
    if (HardwareKeyboard.instance.isAltPressed) {
      return _handleAltShortcuts(event.logicalKey);
    }

    // Handle Escape key
    if (event.logicalKey == LogicalKeyboardKey.escape) {
      return _handleEscape();
    }

    return false;
  }

  /// Handle Control+Key shortcuts
  bool _handleControlShortcuts(LogicalKeyboardKey key) {
    switch (key) {
      case LogicalKeyboardKey.keyS:
        _navigateToSearch();
        return true;
      case LogicalKeyboardKey.keyH:
        _navigateToHome();
        return true;
      default:
        return false;
    }
  }

  /// Handle Alt+Key shortcuts for main navigation
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

  /// Handle Escape key
  bool _handleEscape() {
    final currentContext = NavigationService.navigatorKey.currentContext;
    if (currentContext != null) {
      // Close any open dialogs or sheets
      if (Navigator.canPop(currentContext)) {
        Navigator.pop(currentContext);
        return true;
      }
    }
    return false;
  }

  // Navigation methods
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

  /// Announce navigation for screen readers
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

  /// Register a named focus node
  void registerFocusNode(String name, FocusNode focusNode) {
    _namedFocusNodes[name] = focusNode;
  }

  /// Unregister a named focus node
  void unregisterFocusNode(String name) {
    _namedFocusNodes.remove(name);
  }

  /// Focus on a named node
  void focusOn(String name) {
    final focusNode = _namedFocusNodes[name];
    if (focusNode != null) {
      focusNode.requestFocus();
      _currentFocus = focusNode;
    }
  }

  /// Get current focus node
  FocusNode? get currentFocus => _currentFocus;

  /// Check if keyboard navigation is supported
  bool get isSupported => UniversalPlatform.isWeb;

  /// Get available shortcuts as help text
  Map<String, String> get availableShortcuts => {
    'Alt + H': 'Ir para Início',
    'Alt + A': 'Ir para Sobre',
    'Alt + C': 'Ir para Acessibilidade',
    'Alt + J': 'Ir para Ajuda',
    'Alt + L': 'Ir para Login',
    'Ctrl + S': 'Ir para Busca',
    'Ctrl + H': 'Ir para Início',
    'Tab': 'Navegar pelos elementos',
    'Shift + Tab': 'Navegar pelos elementos (reverso)',
    'Enter': 'Ativar elemento selecionado',
    'Esc': 'Fechar diálogos/menus',
  };

  /// Dispose resources
  void dispose() {
    _namedFocusNodes.clear();
    _currentFocus = null;
  }
}