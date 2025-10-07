import 'package:flutter/material.dart';
import 'package:universal_platform/universal_platform.dart';

// Import condicional do VLibras helper
import '../utils/vlibras_helper_stub.dart' if (dart.library.html) '../utils/vlibras_helper.dart';

/// Widget personalizado para controles de acessibilidade
class AccessibilityControls extends StatefulWidget {
  final Widget child;
  final bool showVLibrasButton;
  final Color? buttonColor;
  final double? buttonSize;

  const AccessibilityControls({
    Key? key,
    required this.child,
    this.showVLibrasButton = true,
    this.buttonColor,
    this.buttonSize = 56.0,
  }) : super(key: key);

  @override
  State<AccessibilityControls> createState() => _AccessibilityControlsState();
}

class _AccessibilityControlsState extends State<AccessibilityControls> {
  @override
  void initState() {
    super.initState();
    
    // Inicializa VLibras após o widget ser montado
    if (UniversalPlatform.isWeb) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        VLibrasHelper.reinitialize();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        
        // Botão customizado do VLibras (opcional)
        if (widget.showVLibrasButton && UniversalPlatform.isWeb)
          Positioned(
            bottom: 16,
            right: 16,
            child: _buildCustomVLibrasButton(),
          ),
      ],
    );
  }

  Widget _buildCustomVLibrasButton() {
    return FloatingActionButton(
      onPressed: () {
        VLibrasHelper.toggle();
      },
      backgroundColor: widget.buttonColor ?? Theme.of(context).primaryColor,
      child: Icon(
        Icons.accessibility_new,
        color: Colors.white,
      ),
      heroTag: "vlibras_button", // Evita conflitos se houver múltiplos FABs
      tooltip: 'Ativar/Desativar VLibras (Tradução em Libras)',
    );
  }

  @override
  void dispose() {
    // Cleanup se necessário
    super.dispose();
  }
}

/// Mixin para páginas que precisam de integração com VLibras
mixin VLibrasPageMixin<T extends StatefulWidget> on State<T> {
  
  @override
  void initState() {
    super.initState();
    _initializeVLibras();
  }

  void _initializeVLibras() {
    if (UniversalPlatform.isWeb) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        VLibrasHelper.refresh();
      });
    }
  }

  /// Chama este método quando o conteúdo da página muda dinamicamente
  void refreshVLibras() {
    if (UniversalPlatform.isWeb) {
      VLibrasHelper.refresh();
    }
  }

  /// Garante que o VLibras funcione após mudanças de rota
  void reinitializeVLibras() {
    if (UniversalPlatform.isWeb) {
      VLibrasHelper.reinitialize();
    }
  }
}

/// Widget para melhorar a acessibilidade de textos
class AccessibleText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final String? semanticsLabel;

  const AccessibleText(
    this.text, {
    Key? key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.semanticsLabel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticsLabel ?? text,
      child: Text(
        text,
        style: style,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
      ),
    );
  }
}

/// Widget para botões acessíveis
class AccessibleButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final String? semanticsLabel;
  final String? tooltip;

  const AccessibleButton({
    Key? key,
    required this.child,
    this.onPressed,
    this.semanticsLabel,
    this.tooltip,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget button = ElevatedButton(
      onPressed: onPressed,
      child: child,
    );

    if (tooltip != null) {
      button = Tooltip(
        message: tooltip!,
        child: button,
      );
    }

    if (semanticsLabel != null) {
      button = Semantics(
        label: semanticsLabel,
        button: true,
        child: button,
      );
    }

    return button;
  }
}
