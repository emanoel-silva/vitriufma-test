import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:vitrine_ufma/app/core/services/keyboard_navigation_service.dart';
import 'package:vitrine_ufma/app/core/services/focus_management_service.dart';

/// Widget wrapper que lida com a navegação por teclado para páginas telas inteiras
class KeyboardNavigationWrapper extends StatefulWidget {
  final Widget child;
  final String pageKey;
  final bool enableGlobalShortcuts;
  final bool enableFocusManagement;
  final List<FocusNode>? focusNodes;
  final Map<LogicalKeyboardKey, VoidCallback>? customShortcuts;

  const KeyboardNavigationWrapper({
    Key? key,
    required this.child,
    required this.pageKey,
    this.enableGlobalShortcuts = true,
    this.enableFocusManagement = true,
    this.focusNodes,
    this.customShortcuts,
  }) : super(key: key);

  @override
  State<KeyboardNavigationWrapper> createState() => _KeyboardNavigationWrapperState();
}

class _KeyboardNavigationWrapperState extends State<KeyboardNavigationWrapper> {
  final KeyboardNavigationService _keyboardService = KeyboardNavigationService();
  final FocusManagementService _focusService = FocusManagementService();
  late FocusNode _wrapperFocusNode;

  @override
  void initState() {
    super.initState();
    _wrapperFocusNode = FocusNode();
    
    if (UniversalPlatform.isWeb) {
      _initializeKeyboardNavigation();
    }
  }

  void _initializeKeyboardNavigation() {
    // Inicializa a página no gerenciamento de foco
    if (widget.enableFocusManagement) {
      _focusService.initializePage(widget.pageKey);
      _focusService.setCurrentPage(widget.pageKey);
      
      if (widget.focusNodes != null) {
        _focusService.registerPageFocusNodes(widget.pageKey, widget.focusNodes!);
      }
    }

    // Inicializa o serviço de teclado se ainda não tiver sido feito
    _keyboardService.initialize();
  }

  @override
  void dispose() {
    if (widget.enableFocusManagement) {
      _focusService.disposePage(widget.pageKey);
    }
    _wrapperFocusNode.dispose();
    super.dispose();
  }

  bool _handleKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent) return false;

    // Manipula atalhos globais se habilitados
    if (widget.enableGlobalShortcuts) {
      if (_keyboardService.handleKeyEvent(event)) {
        return true;
      }
    }

    // Manipula atalhos personalizados
    if (widget.customShortcuts != null) {
      final callback = widget.customShortcuts![event.logicalKey];
      if (callback != null) {
        callback();
        return true;
      }
    }

    // Manipula atalhos de gerenciamento de foco
    if (widget.enableFocusManagement) {
      return _handleFocusShortcuts(event);
    }

    return false;
  }

  bool _handleFocusShortcuts(KeyEvent event) {
    final isCtrlPressed = HardwareKeyboard.instance.isControlPressed;
    final isShiftPressed = HardwareKeyboard.instance.isShiftPressed;
    final isAltPressed = HardwareKeyboard.instance.isAltPressed;

    switch (event.logicalKey) {
      case LogicalKeyboardKey.tab:
        if (isShiftPressed) {
          _focusService.focusPrevious(pageKey: widget.pageKey);
        } else {
          _focusService.focusNext(pageKey: widget.pageKey);
        }
        return true;

      case LogicalKeyboardKey.enter:
        // Enter normalmente é manipulado pelo widget com foco
        return false;

      case LogicalKeyboardKey.space:
        // Espaço normalmente é manipulado pelo widget com foco
        return false;

      case LogicalKeyboardKey.escape:
        // Escape é manipulado pelo serviço de teclado
        return false;

      case LogicalKeyboardKey.home:
        if (isCtrlPressed) {
          // Ctrl + Home: Navega para o topo da tela
          _focusService.focusFirst(pageKey: widget.pageKey);
          return true;
        } else {
          // Home: Navega para o primeiro item
          _focusService.focusFirst(pageKey: widget.pageKey);
          return true;
        }

      case LogicalKeyboardKey.end:
        if (isCtrlPressed) {
          // Ctrl + End: Navega para o final da tela
          _focusService.focusLast(pageKey: widget.pageKey);
          return true;
        } else {
          // End: Navega para o último item
          _focusService.focusLast(pageKey: widget.pageKey);
          return true;
        }

      case LogicalKeyboardKey.arrowUp:
      case LogicalKeyboardKey.arrowDown:
      case LogicalKeyboardKey.arrowLeft:
      case LogicalKeyboardKey.arrowRight:
        // Teclas de seta normalmente são manipuladas por componentes específicos como listas/menus
        // mas podemos implementar navegação de foco básica se necessário
        if (isCtrlPressed) {
          if (event.logicalKey == LogicalKeyboardKey.arrowUp || event.logicalKey == LogicalKeyboardKey.arrowLeft) {
            _focusService.focusPrevious(pageKey: widget.pageKey);
            return true;
          } else if (event.logicalKey == LogicalKeyboardKey.arrowDown || event.logicalKey == LogicalKeyboardKey.arrowRight) {
            _focusService.focusNext(pageKey: widget.pageKey);
            return true;
          }
        }
        return false;

      case LogicalKeyboardKey.f1:
        _showKeyboardShortcutsHelp();
        return true;
    }

    return false;
  }

  void _showKeyboardShortcutsHelp() {
    final shortcuts = _keyboardService.availableShortcuts;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Atalhos de Teclado'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Atalhos de Navegação:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...shortcuts.entries.map((entry) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        entry.key,
                        style: const TextStyle(fontFamily: 'monospace'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(child: Text(entry.value)),
                  ],
                ),
              )),
              const SizedBox(height: 16),
              const Text(
                'Atalhos de Foco:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...[
                ['Ctrl + Home', 'Ir para o primeiro elemento'],
                ['Ctrl + End', 'Ir para o último elemento'],
                ['Ctrl + ↑', 'Elemento anterior'],
                ['Ctrl + ↓', 'Próximo elemento'],
                ['F1', 'Mostrar esta ajuda'],
              ].map((shortcut) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        shortcut[0],
                        style: const TextStyle(fontFamily: 'monospace'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(child: Text(shortcut[1])),
                  ],
                ),
              )),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!UniversalPlatform.isWeb) {
      // Em plataformas não-web, apenas retorna o filho
      return widget.child;
    }

    return RawKeyboardListener(
      focusNode: _wrapperFocusNode,
      onKey: (RawKeyEvent event) {
        if (event is RawKeyDownEvent) {
          final logicalKey = event.logicalKey;
          final keyEvent = KeyDownEvent(
            physicalKey: event.physicalKey,
            logicalKey: logicalKey,
            character: event.character,
            timeStamp: Duration.zero,
            synthesized: false,
          );
          _handleKeyEvent(keyEvent);
        }
      },
      child: widget.child,
    );
  }
}

/// Widget de link de pulo para navegação por teclado
class SkipLinksWidget extends StatelessWidget {
  final List<SkipLink> skipLinks;

  const SkipLinksWidget({
    Key? key,
    required this.skipLinks,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!UniversalPlatform.isWeb) {
      return const SizedBox.shrink();
    }

    return Positioned(
      top: -100, // Inicialmente oculto
      left: 10,
      child: Focus(
        onFocusChange: (hasFocus) {
          // Mostra/oculta links de pulo com base no foco
        },
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(4),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: skipLinks.map((link) => 
              InkWell(
                onTap: link.onPressed,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: Text(
                    link.label,
                    style: const TextStyle(
                      color: Colors.white,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
            ).toList(),
          ),
        ),
      ),
    );
  }
}

/// Modelo de dados de link de pulo
class SkipLink {
  final String label;
  final VoidCallback onPressed;

  const SkipLink({
    required this.label,
    required this.onPressed,
  });
}

/// Widget de anúncio de navegação por teclado
class KeyboardAnnouncementWidget extends StatelessWidget {
  final String message;
  final Duration duration;

  const KeyboardAnnouncementWidget({
    Key? key,
    required this.message,
    this.duration = const Duration(seconds: 2),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      child: Container(
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.1),
          border: Border.all(color: Theme.of(context).primaryColor),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          message,
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}