import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Um widget que habilita rolagem por teclado (teclas de seta) para o conteúdo filho
class KeyboardScrollWrapper extends StatefulWidget {
  final Widget child;
  final ScrollController? scrollController;

  const KeyboardScrollWrapper({
    Key? key,
    required this.child,
    this.scrollController,
  }) : super(key: key);

  @override
  State<KeyboardScrollWrapper> createState() => _KeyboardScrollWrapperState();
}

class _KeyboardScrollWrapperState extends State<KeyboardScrollWrapper> {
  late ScrollController _scrollController;
  final FocusNode _focusNode = FocusNode();

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
      // Manipula eventos de teclas de seta para rolagem
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
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: _focusNode,
      onKey: _handleKeyEvent,
      child: SingleChildScrollView(
        controller: _scrollController,
        child: widget.child,
      ),
    );
  }
}