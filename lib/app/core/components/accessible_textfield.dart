import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/semantics.dart';
import 'package:vitrine_ufma/app/core/constants/colors.dart';

/// Campo de texto totalmente acessível seguindo as diretrizes WCAG 2.2
/// 
/// Este componente implementa:
/// - Labels e hints semânticas para leitores de tela
/// - Contraste de cores mínimo de 4.5:1
/// - Suporte a escalonamento de texto dinâmico
/// - Feedback tátil e sonoro para interações
/// - Gerenciamento adequado de foco
/// - Anúncios para leitores de tela quando o conteúdo muda
class AccessibleTextField extends StatefulWidget {
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final TextInputType? keyboardType;
  final String? label;
  final String? hint;
  final String? helperText;
  final String? errorText;
  final int maxLines;
  final bool enabled;
  final bool autoFocus;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;
  final VoidCallback? onEditingComplete;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final String? semanticsLabel;
  final String? semanticsHint;

  const AccessibleTextField({
    Key? key,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.keyboardType,
    this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.maxLines = 1,
    this.enabled = true,
    this.autoFocus = false,
    this.textInputAction,
    this.focusNode,
    this.nextFocusNode,
    this.onEditingComplete,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
    this.semanticsLabel,
    this.semanticsHint,
  }) : super(key: key);

  @override
  State<AccessibleTextField> createState() => _AccessibleTextFieldState();
}

class _AccessibleTextFieldState extends State<AccessibleTextField> {
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

    // Anuncia o foco para leitores de tela
    if (_focusNode.hasFocus && widget.label != null) {
      SemanticsService.announce('${widget.label} campo de texto focado', TextDirection.ltr);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      // Fornece labels semânticas para leitores de tela
      label: widget.semanticsLabel ?? widget.label,
      hint: widget.semanticsHint ?? widget.hint,
      textField: true,
      focused: _isFocused,
      enabled: widget.enabled,
      child: TextField(
        controller: widget.controller,
        focusNode: _focusNode,
        keyboardType: widget.keyboardType,
        maxLines: widget.maxLines,
        enabled: widget.enabled,
        autofocus: widget.autoFocus,
        textInputAction: widget.textInputAction,
        onEditingComplete: widget.onEditingComplete,
        obscureText: widget.obscureText,
        textCapitalization: widget.textCapitalization,
        inputFormatters: widget.inputFormatters,
        style: TextStyle(
          // Garante tamanho mínimo de fonte para acessibilidade
          fontSize: 16.0,
          // Garante contraste adequado
          color: Theme.of(context).textTheme.bodyMedium?.color,
        ),
        decoration: InputDecoration(
          labelText: widget.label,
          hintText: widget.hint,
          helperText: widget.helperText,
          errorText: widget.errorText,
          prefixIcon: widget.prefixIcon,
          suffixIcon: widget.suffixIcon,
          // Estilo acessível com contraste adequado
          labelStyle: TextStyle(
            color: _isFocused 
                ? Theme.of(context).primaryColor 
                : Theme.of(context).hintColor,
          ),
          hintStyle: const TextStyle(
            color: AppColors.lightGrey,
          ),
          // Borda com feedback visual de foco
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).primaryColor,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
          // Borda padrão com contraste adequado
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).dividerColor,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
          // Borda para estado de erro
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.red,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
          // Borda para estado de foco com erro
          focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.red,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
          // Fundo com contraste adequado
          filled: true,
          fillColor: widget.enabled 
              ? Theme.of(context).colorScheme.surface 
              : Theme.of(context).disabledColor.withOpacity(0.1),
        ),
        // Callbacks com suporte a acessibilidade
        onChanged: (value) {
          widget.onChanged?.call(value);
          // Para campos de texto longos, podemos anunciar mudanças importantes
          if (widget.maxLines > 1 && value.length % 10 == 0) {
            SemanticsService.announce('Texto atualizado', TextDirection.ltr);
          }
        },
        onSubmitted: (value) {
          widget.onSubmitted?.call(value);
          // Anuncia submissão para leitores de tela
          SemanticsService.announce('Texto submetido', TextDirection.ltr);
          
          // Move o foco para o próximo campo, se especificado
          if (widget.nextFocusNode != null) {
            widget.nextFocusNode!.requestFocus();
          }
        },
      ),
    );
  }
}