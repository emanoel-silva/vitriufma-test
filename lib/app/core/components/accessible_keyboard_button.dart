import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/semantics.dart';


/// Um botão acessível que lida corretamente com todas as interações de teclado

/// Supports:

/// - Ativação pela tecla Enter
/// - Ativação pela tecla Espaço

/// - Gerenciamento adequado de foco
/// - Anúncios para leitores de tela

class AccessibleKeyboardButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final Widget child;
  final String? semanticsLabel;
  final String? tooltip;
  final ButtonStyle? style;
  final FocusNode? focusNode;
  final bool autofocus;
  final bool enabled;
  final double? minWidth;
  final double? minHeight;
  final EdgeInsets? padding;
  final BorderSide? borderSide;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final OutlinedBorder? shape;
  final double? elevation;
  final bool enableFeedback;

  const AccessibleKeyboardButton({
    Key? key,
    required this.child,
    this.onPressed,
    this.onLongPress,
    this.semanticsLabel,
    this.tooltip,
    this.style,
    this.focusNode,
    this.autofocus = false,
    this.enabled = true,
    this.minWidth,
    this.minHeight,
    this.padding,
    this.borderSide,
    this.backgroundColor,
    this.foregroundColor,
    this.shape,
    this.elevation,
    this.enableFeedback = true,
  }) : super(key: key);

  @override
  State<AccessibleKeyboardButton> createState() => _AccessibleKeyboardButtonState();
}

class _AccessibleKeyboardButtonState extends State<AccessibleKeyboardButton> {
  late FocusNode _focusNode;
  bool _isFocused = false;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _handleFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  void _handlePress() {
    if (widget.onPressed != null && widget.enabled) {
      widget.onPressed!();
      

      // Fornece feedback tátil
      if (widget.enableFeedback) {
        Feedback.forTap(context);
      }
      

      // Anuncia para leitores de tela
      if (widget.semanticsLabel != null) {
        SemanticsService.announce('${widget.semanticsLabel} ativado', TextDirection.ltr);
      }
    }
  }

  void _handleLongPress() {
    if (widget.onLongPress != null && widget.enabled) {
      widget.onLongPress!();
      

      // Fornece feedback tátil
      if (widget.enableFeedback) {
        Feedback.forLongPress(context);
      }
      

      // Anuncia para leitores de tela
      if (widget.semanticsLabel != null) {
        SemanticsService.announce('${widget.semanticsLabel} pressionado longamente', TextDirection.ltr);
      }
    }
  }

  void _handleKeyDown(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {

      // Trata a ativação pelas teclas Enter e Espaço
      if (event.logicalKey == LogicalKeyboardKey.enter || 
          event.logicalKey == LogicalKeyboardKey.space) {
        _handlePress();
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    // Determina o estilo do botão com base nos parâmetros
    ButtonStyle buttonStyle = widget.style ?? 
        ButtonStyle(

          // Tamanho mínimo para um alvo de toque adequado (44x44 pixels recomendado)
          minimumSize: MaterialStateProperty.all<Size>(
            Size(
              widget.minWidth ?? 44.0,
              widget.minHeight ?? 44.0,
            ),
          ),
          // Preenchimento adequado
          padding: MaterialStateProperty.all<EdgeInsets>(
            widget.padding ?? const EdgeInsets.all(12.0),
          ),

          // Cor de fundo
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.disabled)) {
                return (widget.backgroundColor ?? Theme.of(context).primaryColor)
                    .withOpacity(0.5);
              }
              if (states.contains(MaterialState.pressed)) {
                return (widget.backgroundColor ?? Theme.of(context).primaryColor)
                    .withOpacity(0.8);
              }
              return widget.backgroundColor ?? Theme.of(context).primaryColor;
            },
          ),

          // Cor de primeiro plano
          foregroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.disabled)) {
                return (widget.foregroundColor ?? Colors.white)
                    .withOpacity(0.7);
              }
              return widget.foregroundColor ?? Colors.white;
            },
          ),

          // Borda
          side: MaterialStateProperty.all<BorderSide>(
            widget.borderSide ??
                BorderSide(
                  color: widget.backgroundColor ?? Theme.of(context).primaryColor,
                  width: 1.0,
                ),
          ),

          // forma
          shape: MaterialStateProperty.all<OutlinedBorder>(
            widget.shape ??
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
          ),

          // Elevação
          elevation: MaterialStateProperty.all<double>(
            widget.elevation ?? 2.0,
          ),
          // Overlay de foco
          overlayColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.focused)) {
                return (widget.backgroundColor ?? Theme.of(context).primaryColor)
                    .withOpacity(0.2);
              }
              if (states.contains(MaterialState.hovered)) {
                return (widget.backgroundColor ?? Theme.of(context).primaryColor)
                    .withOpacity(0.1);
              }
              return null;
            },
          ),
        );

    // Cria o widget do botão

    Widget button = ElevatedButton(
      onPressed: widget.enabled ? _handlePress : null,
      onLongPress: widget.enabled ? _handleLongPress : null,
      style: buttonStyle,
      focusNode: _focusNode,
      autofocus: widget.autofocus,
      child: widget.child,
    );


    // Adiciona tooltip se fornecido
    if (widget.tooltip != null) {
      button = Tooltip(
        message: widget.tooltip!,
        child: button,
      );
    }


    // Adiciona RawKeyboardListener para ativação por teclado
    button = RawKeyboardListener(
      focusNode: _focusNode,
      onKey: _handleKeyDown,
      child: button,
    );

    // Adiciona Semantics para informações de acessibilidade

    return Semantics(
      button: true,
      label: widget.semanticsLabel,
      enabled: widget.enabled,
      focused: _isFocused,
      child: button,
    );
  }
}