import 'package:flutter/material.dart';
import 'package:vitrine_ufma/app/core/components/accessible_image_zoom.dart';
import 'package:vitrine_ufma/app/core/components/text.dart';

class ImageZoomExample extends StatelessWidget {
  const ImageZoomExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exemplo de Zoom em Imagens'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppText(
              text: 'Exemplo de Imagem com Zoom Acessível',
              fontSize: 24,
              fontWeight: 'bold',
            ),
            const SizedBox(height: 20),
            const AppText(
              text: 'Clique na imagem abaixo para ampliá-la. O recurso é acessível e funciona com teclado (Enter/Space para abrir, ESC para fechar).',
              fontSize: 16,
            ),
            const SizedBox(height: 30),
            Center(
              child: AccessibleImageZoom(
                image: 'example_image.jpg', // Substitua por uma imagem real do seu projeto
                altText: 'Descrição da imagem para leitores de tela',
                width: 300,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 30),
            const AppText(
              text: 'Características do recurso:',
              fontSize: 18,
              fontWeight: 'bold',
            ),
            const SizedBox(height: 10),
            const AppText(text: '• Fundo escurecido ao ampliar'),
            const AppText(text: '• Imagem centralizada na tela'),
            const AppText(text: '• Fechamento ao clicar fora da imagem ou pressionar ESC'),
            const AppText(text: '• Suporte completo a acessibilidade'),
            const AppText(text: '• Zoom interativo com gestos de pinça'),
            const AppText(text: '• Navegação por teclado'),
            const AppText(text: '• Compatível com leitores de tela'),
          ],
        ),
      ),
    );
  }
}