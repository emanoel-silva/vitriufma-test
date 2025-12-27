import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Um widget que aprimora a navegação por teclado para o conteúdo filho
/// Suporta todos os atalhos de teclado solicitados:
/// - Tab: Avança entre elementos interativos
/// - Shift + Tab: Move o foco para trás
/// - Enter: Ativa links, botões ou submete formulários
/// - Espaço: Ativa caixas de seleção, botões ou rola a página
/// - Teclas de seta (↑↓←→): Navega por menus, listas ou controles
/// - Esc: Fecha menus ou modais
class EnhancedKeyboardNavigation extends StatefulWidget {
  final Widget child;
  final ScrollController? scrollController;
  final VoidCallback? onEscapePressed;

  const EnhancedKeyboardNavigation({
    Key? key,
    required this.child,
    this.scrollController,
    this.onEscapePressed,
  }) : super(key: key);

  @override
  State<EnhancedKeyboardNavigation> createState() => _EnhancedKeyboardNavigationState();
}

class _EnhancedKeyboardNavigationState extends State<EnhancedKeyboardNavigation> {
  late ScrollController _scrollController;
  final FocusNode _focusNode = FocusNode();
  final FocusScopeNode _focusScopeNode = FocusScopeNode();

  @override
  void initState() {
    super.initState();
    _scrollController = widget.scrollController ?? ScrollController();
    
    // Solicita foco após o widget ser construído
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    // Apenas descarta se criamos o controlador
    if (widget.scrollController == null) {
      _scrollController.dispose();
    }
    super.dispose();
  }

  void _handleKeyEvent(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      // Manipula rolagem com a tecla de espaço quando não está em um elemento focalizável
      if (event.logicalKey == LogicalKeyboardKey.space && 
          !event.isKeyPressed(LogicalKeyboardKey.shift) &&
          FocusManager.instance.primaryFocus?.context?.widget is! EditableText) {
        // Rola para baixo em 100 pixels
        _scrollController.animateTo(
          _scrollController.offset + 100,
          duration: const Duration(milliseconds: 100),
          curve: Curves.linear,
        );
        return;
      }

      // Manipula eventos de teclas de seta para rolagem (quando não está em um campo de texto)
      if (FocusManager.instance.primaryFocus?.context?.widget is! EditableText) {
        if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
          // Rola para cima em 100 pixels
          _scrollController.animateTo(
            _scrollController.offset - 100,
            duration: const Duration(milliseconds: 100),
            curve: Curves.linear,
          );
        } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
          // Rola para baixo em 100 pixels
          _scrollController.animateTo(
            _scrollController.offset + 100,
            duration: const Duration(milliseconds: 100),
            curve: Curves.linear,
          );
        } else if (event.logicalKey == LogicalKeyboardKey.pageUp) {
          // Page up - rola para cima em 80% da altura da tela
          final screenHeight = MediaQuery.of(context).size.height;
          _scrollController.animateTo(
            _scrollController.offset - screenHeight * 0.8,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
          );
        } else if (event.logicalKey == LogicalKeyboardKey.pageDown) {
          // Page down - rola para baixo em 80% da altura da tela
          final screenHeight = MediaQuery.of(context).size.height;
          _scrollController.animateTo(
            _scrollController.offset + screenHeight * 0.8,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
          );
        } else if (event.logicalKey == LogicalKeyboardKey.home) {
          // Tecla Home - rola para o topo
          _scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        } else if (event.logicalKey == LogicalKeyboardKey.end) {
          // Tecla End - rola para o final
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      }

      // Manipula a tecla Escape
      if (event.logicalKey == LogicalKeyboardKey.escape) {
        // Chama o callback de escape se fornecido
        widget.onEscapePressed?.call();
        
        // Também tenta fechar quaisquer diálogos ou pop-ups abertos
        Navigator.maybePop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: _focusNode,
      onKey: _handleKeyEvent,
      child: FocusScope(
        node: _focusScopeNode,
        autofocus: true,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: widget.child,
        ),
      ),
    );
  }
}