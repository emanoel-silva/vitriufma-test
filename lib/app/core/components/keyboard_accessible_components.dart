import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:vitrine_ufma/app/core/components/vlibras_clickable_text.dart';
import 'package:vitrine_ufma/app/core/services/keyboard_navigation_service.dart';
import 'package:flutter_modular/flutter_modular.dart';

/// Botão aprimorado com suporte a navegação por teclado
class KeyboardAccessibleButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final String? semanticsLabel;
  final String? tooltip;
  final String? focusName;
  final bool autofocus;
  final FocusNode? focusNode;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final EdgeInsetsGeometry? padding;
  final ButtonStyle? style;

  const KeyboardAccessibleButton({
    Key? key,
    required this.child,
    this.onPressed,
    this.semanticsLabel,
    this.tooltip,
    this.focusName,
    this.autofocus = false,
    this.focusNode,
    this.backgroundColor,
    this.foregroundColor,
    this.padding,
    this.style,
  }) : super(key: key);

  @override
  State<KeyboardAccessibleButton> createState() => _KeyboardAccessibleButtonState();
}

class _KeyboardAccessibleButtonState extends State<KeyboardAccessibleButton> {
  late FocusNode _focusNode;
  final KeyboardNavigationService _keyboardService = KeyboardNavigationService();

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    
    if (widget.focusName != null) {
      _keyboardService.registerFocusNode(widget.focusName!, _focusNode);
    }
  }

  @override
  void dispose() {
    if (widget.focusName != null) {
      _keyboardService.unregisterFocusNode(widget.focusName!);
    }
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget button = ElevatedButton(
      onPressed: widget.onPressed,
      focusNode: _focusNode,
      autofocus: widget.autofocus,
      style: widget.style ?? ElevatedButton.styleFrom(
        backgroundColor: widget.backgroundColor,
        foregroundColor: widget.foregroundColor,
        padding: widget.padding,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ).copyWith(
        overlayColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.focused)) {
            return Theme.of(context).primaryColor.withOpacity(0.12);
          }
          return null;
        }),
      ),
      child: widget.child,
    );

    if (widget.tooltip != null) {
      button = Tooltip(
        message: widget.tooltip!,
        child: button,
      );
    }

    if (widget.semanticsLabel != null) {
      button = Semantics(
        label: widget.semanticsLabel,
        button: true,
        enabled: widget.onPressed != null,
        child: button,
      );
    }

    return button;
  }
}

/// Campo de texto aprimorado com suporte a navegação por teclado
class KeyboardAccessibleTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final String? semanticsLabel;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onEditingComplete;
  final TextInputType? keyboardType;
  final bool obscureText;
  final bool autofocus;
  final FocusNode? focusNode;
  final String? focusName;
  final int? maxLines;
  final InputDecoration? decoration;
  final TextStyle? style;

  const KeyboardAccessibleTextField({
    Key? key,
    this.controller,
    this.labelText,
    this.hintText,
    this.semanticsLabel,
    this.onChanged,
    this.onSubmitted,
    this.onEditingComplete,
    this.keyboardType,
    this.obscureText = false,
    this.autofocus = false,
    this.focusNode,
    this.focusName,
    this.maxLines = 1,
    this.decoration,
    this.style,
  }) : super(key: key);

  @override
  State<KeyboardAccessibleTextField> createState() => _KeyboardAccessibleTextFieldState();
}

class _KeyboardAccessibleTextFieldState extends State<KeyboardAccessibleTextField> {
  late FocusNode _focusNode;
  final KeyboardNavigationService _keyboardService = KeyboardNavigationService();

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    
    if (widget.focusName != null) {
      _keyboardService.registerFocusNode(widget.focusName!, _focusNode);
    }
  }

  @override
  void dispose() {
    if (widget.focusName != null) {
      _keyboardService.unregisterFocusNode(widget.focusName!);
    }
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: widget.semanticsLabel ?? widget.labelText,
      textField: true,
      child: TextFormField(
        controller: widget.controller,
        focusNode: _focusNode,
        autofocus: widget.autofocus,
        onChanged: widget.onChanged,
        onFieldSubmitted: widget.onSubmitted,
        onEditingComplete: widget.onEditingComplete,
        keyboardType: widget.keyboardType,
        obscureText: widget.obscureText,
        maxLines: widget.maxLines,
        style: widget.style,
        decoration: widget.decoration ?? InputDecoration(
          labelText: widget.labelText,
          hintText: widget.hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: Theme.of(context).primaryColor,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }
}

/// Texto clicável aprimorado com suporte a navegação por teclado
class KeyboardAccessibleText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final VoidCallback? onPressed;
  final String? semanticsLabel;
  final String? tooltip;
  final bool autofocus;
  final FocusNode? focusNode;
  final String? focusName;
  final bool enableVLibras;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const KeyboardAccessibleText({
    Key? key,
    required this.text,
    this.style,
    this.onPressed,
    this.semanticsLabel,
    this.tooltip,
    this.autofocus = false,
    this.focusNode,
    this.focusName,
    this.enableVLibras = true,
    this.textAlign,
    this.maxLines,
    this.overflow,
  }) : super(key: key);

  @override
  State<KeyboardAccessibleText> createState() => _KeyboardAccessibleTextState();
}

class _KeyboardAccessibleTextState extends State<KeyboardAccessibleText> {
  late FocusNode _focusNode;
  final KeyboardNavigationService _keyboardService = KeyboardNavigationService();
  bool _isHovered = false;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);
    
    if (widget.focusName != null) {
      _keyboardService.registerFocusNode(widget.focusName!, _focusNode);
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    if (widget.focusName != null) {
      _keyboardService.unregisterFocusNode(widget.focusName!);
    }
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget textWidget;

    if (widget.enableVLibras && UniversalPlatform.isWeb) {
      textWidget = VLibrasClickableText(
        widget.text,
        style: widget.style?.copyWith(
          decoration: (_isHovered || _isFocused) 
            ? TextDecoration.underline 
            : widget.style?.decoration,
        ),
        textAlign: widget.textAlign,
        maxLines: widget.maxLines,
        overflow: widget.overflow,
        tooltip: widget.tooltip,
      );
    } else {
      textWidget = Text(
        widget.text,
        style: widget.style?.copyWith(
          decoration: (_isHovered || _isFocused) 
            ? TextDecoration.underline 
            : widget.style?.decoration,
        ),
        textAlign: widget.textAlign,
        maxLines: widget.maxLines,
        overflow: widget.overflow,
      );
    }

    if (widget.onPressed != null) {
      textWidget = Focus(
        focusNode: _focusNode,
        autofocus: widget.autofocus,
        onKeyEvent: (node, event) {
          if (event is KeyDownEvent && 
              (event.logicalKey == LogicalKeyboardKey.enter ||
               event.logicalKey == LogicalKeyboardKey.space)) {
            widget.onPressed!();
            return KeyEventResult.handled;
          }
          return KeyEventResult.ignored;
        },
        child: MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: widget.onPressed,
            child: Container(
              decoration: BoxDecoration(
                border: _isFocused 
                  ? Border.all(
                      color: Theme.of(context).primaryColor,
                      width: 2,
                    )
                  : null,
                borderRadius: BorderRadius.circular(4),
              ),
              padding: const EdgeInsets.all(2),
              child: textWidget,
            ),
          ),
        ),
      );
    }

    if (widget.semanticsLabel != null || widget.onPressed != null) {
      textWidget = Semantics(
        label: widget.semanticsLabel ?? widget.text,
        button: widget.onPressed != null,
        enabled: widget.onPressed != null,
        child: textWidget,
      );
    }

    if (widget.tooltip != null) {
      textWidget = Tooltip(
        message: widget.tooltip!,
        child: textWidget,
      );
    }

    return textWidget;
  }
}

/// Widget de link aprimorado com suporte a navegação por teclado
class KeyboardAccessibleLink extends StatelessWidget {
  final String text;
  final String route;
  final TextStyle? style;
  final String? semanticsLabel;
  final String? tooltip;
  final bool autofocus;
  final FocusNode? focusNode;
  final String? focusName;

  const KeyboardAccessibleLink({
    Key? key,
    required this.text,
    required this.route,
    this.style,
    this.semanticsLabel,
    this.tooltip,
    this.autofocus = false,
    this.focusNode,
    this.focusName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return KeyboardAccessibleText(
      text: text,
      style: style ?? TextStyle(
        color: Theme.of(context).primaryColor,
        decoration: TextDecoration.underline,
      ),
      onPressed: () => _navigateToRoute(),
      semanticsLabel: semanticsLabel ?? 'Link para $text',
      tooltip: tooltip ?? 'Navegar para $text',
      autofocus: autofocus,
      focusNode: focusNode,
      focusName: focusName,
    );
  }

  void _navigateToRoute() {
    // Manipula tanto rotas internas quanto URLs externas
    if (route.startsWith('http')) {
      // URL externa - precisaria do pacote url_launcher
      // Por enquanto, apenas mostra uma mensagem
      return;
    } else {
      // Rota interna
      if (route.startsWith('/')) {
        // Rota absoluta
        Modular.to.navigate(route);
      } else {
        // Rota relativa
        Modular.to.pushNamed(route);
      }
    }
  }
}