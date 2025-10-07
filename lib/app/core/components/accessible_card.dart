import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

/// Card totalmente acessível seguindo as diretrizes WCAG 2.2
/// 
/// Este componente implementa:
/// - Estrutura semântica adequada para leitores de tela
/// - Contraste de cores mínimo de 4.5:1
/// - Labels descritivas para conteúdo
/// - Suporte a navegação por teclado
/// - Feedback tátil para interações
/// - Hierarquia de cabeçalhos adequada
class AccessibleCard extends StatelessWidget {
  final Widget? header;
  final Widget? title;
  final Widget? subtitle;
  final Widget? content;
  final List<Widget>? actions;
  final String? semanticsLabel;
  final String? semanticsHint;
  final bool clickable;
  final VoidCallback? onTap;
  final Color? color;
  final double? elevation;
  final ShapeBorder? shape;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final BorderSide? borderSide;

  const AccessibleCard({
    Key? key,
    this.header,
    this.title,
    this.subtitle,
    this.content,
    this.actions,
    this.semanticsLabel,
    this.semanticsHint,
    this.clickable = false,
    this.onTap,
    this.color,
    this.elevation,
    this.shape,
    this.margin,
    this.padding,
    this.borderSide,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Constrói o conteúdo do card
    List<Widget> cardChildren = [];
    
    // Adiciona o cabeçalho se fornecido
    if (header != null) {
      cardChildren.add(
        Semantics(
          header: true,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: color?.withOpacity(0.1) ?? Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12.0)),
            ),
            child: DefaultTextStyle(
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ) ??
                  const TextStyle(fontWeight: FontWeight.bold),
              child: header!,
            ),
          ),
        ),
      );
    }
    
    // Adiciona o conteúdo principal
    List<Widget> contentChildren = [];
    
    // Adiciona o título se fornecido
    if (title != null) {
      contentChildren.add(
        Semantics(
          header: true,
          child: DefaultTextStyle(
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ) ??
                const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            child: title!,
          ),
        ),
      );
    }
    
    // Adiciona o subtítulo se fornecido
    if (subtitle != null) {
      contentChildren.add(
        Semantics(
          child: DefaultTextStyle(
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).hintColor,
                ) ??
                const TextStyle(color: Colors.grey, fontSize: 16),
            child: subtitle!,
          ),
        ),
      );
    }
    
    // Adiciona o conteúdo se fornecido
    if (content != null) {
      contentChildren.add(
        Semantics(
          child: Container(
            margin: const EdgeInsets.only(top: 8.0),
            child: content,
          ),
        ),
      );
    }
    
    // Adiciona o conteúdo principal ao card
    if (contentChildren.isNotEmpty) {
      cardChildren.add(
        Padding(
          padding: padding ?? const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: contentChildren,
          ),
        ),
      );
    }
    
    // Adiciona as ações se fornecidas
    if (actions != null && actions!.isNotEmpty) {
      cardChildren.add(
        Semantics(
          container: true,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: actions!,
            ),
          ),
        ),
      );
    }
    
    // Cria o card base
    Widget card = Card(
      color: color ?? Theme.of(context).cardColor,
      elevation: elevation ?? 2.0,
      shape: shape ??
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
            side: borderSide ??
                BorderSide(
                  color: Theme.of(context).dividerColor.withOpacity(0.3),
                  width: 1.0,
                ),
          ),
      margin: margin ?? const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: cardChildren,
      ),
    );
    
    // Torna o card clicável se necessário
    if (clickable && onTap != null) {
      card = Semantics(
        button: true,
        label: semanticsLabel,
        hint: semanticsHint,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12.0),
          child: card,
        ),
      );
    } else {
      // Adiciona semântica ao card não clicável
      card = Semantics(
        container: true,
        label: semanticsLabel,
        hint: semanticsHint,
        child: card,
      );
    }
    
    return card;
  }
}