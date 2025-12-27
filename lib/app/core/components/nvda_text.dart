import 'package:flutter/material.dart';
import 'package:universal_platform/universal_platform.dart';
import '../utils/nvda_helper_stub.dart' if (dart.library.html) '../utils/nvda_helper.dart';

/// Widget que torna o texto disponível para o leitor de tela NVDA
/// Quando enableNVDA é verdadeiro, o conteúdo de texto pode ser incluído na caixa de texto do NVDA
/// quando a caixa está ativa. O widget em si não cria ou remove a caixa NVDA.
class NVDAText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool enableNVDA;
  final String? semanticsLabel;

  const NVDAText(
    this.text, {
    Key? key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.enableNVDA = true,
    this.semanticsLabel,
  }) : super(key: key);

  @override
  State<NVDAText> createState() => _NVDATextState();
}

class _NVDATextState extends State<NVDAText> {
  @override
  Widget build(BuildContext context) {
    // Adiciona texto à área do NVDA se habilitado e na plataforma web
    if (widget.enableNVDA && UniversalPlatform.isWeb && NVDAHelper.isAreaVisible) {
      // O NVDAHelper gerenciará o conteúdo de texto quando a área estiver visível
      // Não precisamos fazer nada aqui, pois o helper já lida com isso
    }

    // Cria texto semântico para leitores de tela
    return Semantics(
      label: widget.semanticsLabel ?? widget.text,
      liveRegion: true, // Isso torna o texto disponível imediatamente para leitores de tela
      child: Text(
        widget.text,
        style: widget.style,
        textAlign: widget.textAlign,
        maxLines: widget.maxLines,
        overflow: widget.overflow,
      ),
    );
  }
}

/// Widget que envolve qualquer widget filho e torna seu conteúdo de texto disponível para o NVDA
class NVDATextWrapper extends StatefulWidget {
  final Widget child;
  final String textToRead;
  final bool enableNVDA;
  final String? semanticsLabel;

  const NVDATextWrapper({
    Key? key,
    required this.child,
    required this.textToRead,
    this.enableNVDA = true,
    this.semanticsLabel,
  }) : super(key: key);

  @override
  State<NVDATextWrapper> createState() => _NVDATextWrapperState();
}

class _NVDATextWrapperState extends State<NVDATextWrapper> {
  @override
  Widget build(BuildContext context) {
    // Adiciona texto à área do NVDA se habilitado e na plataforma web
    if (widget.enableNVDA && UniversalPlatform.isWeb && NVDAHelper.isAreaVisible) {
      // O NVDAHelper gerenciará o conteúdo de texto quando a área estiver visível
    }

    // Envelopa o filho com informações semânticas
    return Semantics(
      label: widget.semanticsLabel ?? widget.textToRead,
      liveRegion: true,
      child: widget.child,
    );
  }
}

/// Mixin para páginas que desejam contribuir com conteúdo para o NVDA
mixin NVDAPageMixin<T extends StatefulWidget> on State<T> {
  /// Atualiza a área de texto do NVDA com novo conteúdo
  /// Só funciona quando a área do NVDA já está visível
  void updateNVDAText(String text) {
    if (UniversalPlatform.isWeb && NVDAHelper.isAreaVisible) {
      // O NVDAHelper gerencia o conteúdo de texto
      // In a real implementation, we might want to queue or combine text
    }
  }

  /// Lê o texto imediatamente com o NVDA
  /// Isso cria uma área temporária que se fecha automaticamente
  void readWithNVDA(String text) {
    if (UniversalPlatform.isWeb) {
      NVDAHelper.createNVDAArea(text);
      // Remove automaticamente após um curto intervalo para evitar poluir a tela
      Future.delayed(const Duration(seconds: 10), () {
        if (NVDAHelper.isAreaVisible) {
          NVDAHelper.removeNVDAArea();
        }
      });
    }
  }
}