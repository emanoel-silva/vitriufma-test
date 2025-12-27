import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/semantics.dart';


/// Uma caixa de seleção acessível que lida adequadamente com todas as interações de teclado
/// Supports:
/// - Space key activation
/// - Enter key activation
/// - Proper focus management
/// - Screen reader announcements
class AccessibleKeyboardCheckbox extends StatefulWidget {
  final bool value;
  final ValueChanged<bool?>? onChanged;
  final String? semanticsLabel;
  final String? tooltip;
  final Color? activeColor;
  final Color? checkColor;
  final BorderSide? side;
  final OutlinedBorder? shape;
  final FocusNode? focusNode;
  final bool autofocus;
  final bool enabled;
  final double? size;
  final EdgeInsets? padding;
  final bool enableFeedback;

  const AccessibleKeyboardCheckbox({
    Key? key,
    required this.value,
    this.onChanged,
    this.semanticsLabel,
    this.tooltip,
    this.activeColor,
    this.checkColor,
    this.side,
    this.shape,
    this.focusNode,
    this.autofocus = false,
    this.enabled = true,
    this.size,
    this.padding,
    this.enableFeedback = true,
  }) : super(key: key);

  @override
  State<AccessibleKeyboardCheckbox> createState() => _AccessibleKeyboardCheckboxState();
}

class _AccessibleKeyboardCheckboxState extends State<AccessibleKeyboardCheckbox> {
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

  void _handleChange() {
    if (widget.onChanged != null && widget.enabled) {
      final newValue = !widget.value;
      widget.onChanged!(newValue);
      

      // Fornece feedback tátil
      if (widget.enableFeedback) {
        Feedback.forTap(context);
      }
      

      // Anuncia para leitores de tela
      if (widget.semanticsLabel != null) {
        final state = newValue ? 'marcado' : 'desmarcado';
        SemanticsService.announce('${widget.semanticsLabel} $state', TextDirection.ltr);
      }
    }
  }

  void _handleKeyDown(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      // Trata a ativação pelas teclas Espaço e Enter

      if (event.logicalKey == LogicalKeyboardKey.space || 
          event.logicalKey == LogicalKeyboardKey.enter) {
        _handleChange();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Cria o widget de checkbox
    Widget checkbox = Checkbox(
      value: widget.value,
      onChanged: widget.enabled ? (widget.onChanged != null ? (_) => _handleChange() : null) : null,
      activeColor: widget.activeColor,
      checkColor: widget.checkColor,
      side: widget.side,
      shape: widget.shape,
      focusNode: _focusNode,
      autofocus: widget.autofocus,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
    );

    // Adiciona padding se fornecido

    if (widget.padding != null) {
      checkbox = Padding(
        padding: widget.padding!,
        child: checkbox,
      );
    }

    // Adiciona o Tooltip se for lido
    if (widget.tooltip != null) {
      checkbox = Tooltip(
        message: widget.tooltip!,
        child: checkbox,
      );
    }

    // Envolve com RawKeyboardListener para ativação por teclado

    checkbox = RawKeyboardListener(
      focusNode: _focusNode,
      onKey: _handleKeyDown,
      child: checkbox,
    );

    // Envolve com Semantics para informações de acessibilidade

    return Semantics(
      label: widget.semanticsLabel,
      enabled: widget.enabled,
      focused: _isFocused,
      checked: widget.value,
      child: checkbox,
    );
  }
}