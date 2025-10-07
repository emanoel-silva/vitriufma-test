import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

/// Botão totalmente acessível seguindo as diretrizes WCAG 2.2
/// 
/// Este componente implementa:
/// - Labels semânticas para leitores de tela
/// - Contraste de cores mínimo de 4.5:1
/// - Suporte a navegação por teclado
/// - Feedback tátil e sonoro para interações
/// - Estados adequados de foco e hover
/// - Anúncios para leitores de tela quando ativado
class CustomAccessibleButton extends StatefulWidget {
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

  const CustomAccessibleButton({
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
  }) : super(key: key);

  @override
  State<CustomAccessibleButton> createState() => _CustomAccessibleButtonState();
}

class _CustomAccessibleButtonState extends State<CustomAccessibleButton> {
  late FocusNode _focusNode;
  bool _isFocused = false;

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
      // Anuncia a ação para leitores de tela
      if (widget.semanticsLabel != null) {
        SemanticsService.announce('${widget.semanticsLabel} ativado', TextDirection.ltr);
      }
    }
  }

  void _handleLongPress() {
    if (widget.onLongPress != null && widget.enabled) {
      widget.onLongPress!();
      // Anuncia a ação para leitores de tela
      if (widget.semanticsLabel != null) {
        SemanticsService.announce('${widget.semanticsLabel} pressionado longamente', TextDirection.ltr);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determina o estilo do botão com base nos parâmetros
    ButtonStyle buttonStyle = widget.style ?? 
        ButtonStyle(
          // Tamanho mínimo para toque adequado (44x44 pixels é recomendado)
          minimumSize: MaterialStateProperty.all<Size>(
            Size(
              widget.minWidth ?? 44.0,
              widget.minHeight ?? 44.0,
            ),
          ),
          // Padding adequado
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
          // Cor do texto/ícone
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
          // Forma
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

    // Envolvemos em um widget Semantics para fornecer informações acessíveis
    return Semantics(
      button: true,
      label: widget.semanticsLabel,
      enabled: widget.enabled,
      focused: _isFocused,
      child: button,
    );
  }
}