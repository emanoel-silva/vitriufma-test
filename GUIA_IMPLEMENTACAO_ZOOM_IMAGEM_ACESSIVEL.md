# Guia de Implementação de Zoom de Imagem Acessível

Este documento fornece instruções de implementação para adicionar funcionalidade de zoom de imagem acessível ao projeto Vitrine UFMA.

## Requisitos

A funcionalidade de zoom de imagem deve:
1. Exibir imagens em um diálogo modal quando clicadas/tocadas
2. Ter um fundo escuro semitransparente
3. Centralizar a imagem ampliada e ocupar no máximo 90% da largura/altura da tela
4. Permitir fechamento ao clicar fora, tocar novamente ou pressionar ESC
5. Alterar o cursor do mouse para indicar capacidade de zoom
6. Funcionar tanto em dispositivos desktop quanto móveis
7. Ser acessível com navegação por teclado e leitores de tela
8. Incluir texto alternativo para imagens
9. Não interferir na funcionalidade de zoom do navegador
10. Ter transições visuais suaves

## Passos de Implementação

### 1. Criar o Componente AccessibleImageZoom

Crie um novo arquivo em `lib/app/core/components/accessible_image_zoom.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Um componente de zoom de imagem acessível que exibe imagens em um diálogo modal
/// quando clicado/tocado, com transições suaves e suporte completo a teclado.
class AccessibleImageZoom extends StatefulWidget {
  /// O caminho do asset da imagem
  final String image;

  /// Texto alternativo opcional para acessibilidade
  final String? altText;

  /// Largura opcional para a imagem
  final double? width;

  /// Altura opcional para a imagem
  final double? height;

  /// Ajuste opcional para a imagem
  final BoxFit? fit;

  const AccessibleImageZoom({
    Key? key,
    required this.image,
    this.altText,
    this.width,
    this.height,
    this.fit,
  }) : super(key: key);

  @override
  State<AccessibleImageZoom> createState() => _AccessibleImageZoomState();
}

class _AccessibleImageZoomState extends State<AccessibleImageZoom> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _openZoomDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black54,
      builder: (context) {
        return _ZoomDialog(
          image: widget.image,
          altText: widget.altText,
          width: widget.width,
          height: widget.height,
          fit: widget.fit,
          onClose: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: widget.altText ?? 'Imagem ampliável',
      button: true,
      focused: _focusNode.hasFocus,
      child: GestureDetector(
        onTap: _openZoomDialog,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: FocusableActionDetector(
            focusNode: _focusNode,
            actions: {
              ActivateIntent: CallbackAction<ActivateIntent>(
                onInvoke: (_) {
                  _openZoomDialog();
                  return null;
                },
              ),
            },
            shortcuts: {
              LogicalKeySet(LogicalKeyboardKey.enter): const ActivateIntent(),
              LogicalKeySet(LogicalKeyboardKey.space): const ActivateIntent(),
            },
            child: Image.asset(
              'assets/images/${widget.image}',
              width: widget.width,
              height: widget.height,
              fit: widget.fit,
              filterQuality: FilterQuality.high,
              semanticLabel: widget.altText,
            ),
          ),
        ),
      ),
    );
  }
}

class _ZoomDialog extends StatelessWidget {
  final String image;
  final String? altText;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final VoidCallback onClose;

  const _ZoomDialog({
    Key? key,
    required this.image,
    this.altText,
    this.width,
    this.height,
    this.fit,
    required this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GestureDetector(
        onTap: onClose,
        child: Container(
          color: Colors.black.withOpacity(0.7),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.9,
                maxHeight: MediaQuery.of(context).size.height * 0.9,
              ),
              child: InteractiveViewer(
                boundaryMargin: const EdgeInsets.all(20),
                minScale: 0.5,
                maxScale: 4,
                child: GestureDetector(
                  onTap: onClose,
                  child: Image.asset(
                    'assets/images/$image',
                    width: width,
                    height: height,
                    fit: fit ?? BoxFit.contain,
                    filterQuality: FilterQuality.high,
                    semanticLabel: altText,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
```

### 2. Exemplo de Uso

Para usar o componente em seu aplicativo:

```dart
// Importar o componente
import 'package:vitrine_ufma/app/core/components/accessible_image_zoom.dart';

// Usar na árvore de widgets
AccessibleImageZoom(
  image: 'example_image.jpg', // Arquivo de imagem em assets/images/
  altText: 'Descrição da imagem para leitores de tela',
  width: 200,
  height: 150,
  fit: BoxFit.cover,
)
```

### 3. Recursos de Acessibilidade

A implementação inclui:

1. **Navegação por Teclado**: 
   - Teclas Enter/Espaço para ativar
   - Tecla ESC para fechar
   - Gerenciamento adequado de foco

2. **Suporte a Leitores de Tela**:
   - Rótulos semânticos para imagens
   - Declaração de função de botão
   - Anúncios de estado de foco

3. **Indicadores Visuais**:
   - Cursor do mouse muda ao passar o mouse
   - Indicadores de foco
   - Transições suaves

4. **Design Responsivo**:
   - Funciona em dispositivos móveis e desktop
   - Adapta-se ao zoom do navegador
   - Mantém proporção de aspecto

### 4. Testando a Implementação

1. **Teste Visual**:
   - Clicar/tocar nas imagens para verificar funcionalidade de zoom
   - Verificar que o fundo é semitransparente
   - Verificar que a imagem está centralizada e com tamanho adequado

2. **Teste por Teclado**:
   - Tab para focar na imagem
   - Pressionar Enter/Espaço para zoom
   - Pressionar ESC para fechar

3. **Teste de Leitor de Tela**:
   - Verificar que o texto alternativo é anunciado
   - Verificar que a função de botão é identificada
   - Confirmar que mudanças de foco são anunciadas

4. **Teste em Dispositivo Móvel**:
   - Tocar para zoom
   - Tocar fora para fechar
   - Verificar que os alvos de toque são adequados

### 5. Integração com Componentes Existentes

Para integrar com componentes de imagem existentes:

1. Substituir usos existentes de [AppImageAsset](file:///c:/Users/EmanoelSL/OneDrive/Documentos/GitHub/vitrineufma/lib/app/core/components/image_asset.dart#L3-L34) com [AccessibleImageZoom](file:///c:/Users/EmanoelSL/OneDrive/Documentos/GitHub/vitrineufma/lib/app/core/components/accessible_image_zoom.dart#L35-L217) onde funcionalidade de zoom é necessária
2. Garantir que todas as imagens tenham texto alternativo apropriado
3. Testar em diferentes tamanhos de tela e níveis de zoom

### 6. Considerações de Desempenho

1. Usar `FilterQuality.high` para imagens nítidas
2. Limitar escala máxima no InteractiveViewer para evitar uso excessivo de memória
3. Usar dimensionamento adequado de assets para evitar carregar imagens desnecessariamente grandes

### 7. Solução de Problemas

Se você encontrar problemas:

1. **Imagens não carregando**: Verifique os caminhos dos assets em `pubspec.yaml`
2. **Acessibilidade não funcionando**: Verifique se rótulos semânticos são fornecidos
3. **Problemas de navegação por teclado**: Garanta que o FocusNode seja gerenciado adequadamente
4. **Problemas de layout**: Verifique as restrições e parâmetros de dimensionamento

Esta implementação segue as melhores práticas do Flutter e as diretrizes de acessibilidade documentadas no [ACCESSIBILITY_GUIDE.md](file:///c:/Users/EmanoelSL/OneDrive/Documentos/GitHub/vitrineufma/ACCESSIBILITY_GUIDE.md) do projeto.