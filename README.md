# vitrine_ufma

A new Flutter project.

## Funcionalidades

Este projeto inclui uma variedade de funcionalidades, incluindo:

- Catálogo de livros digital
- Sistema de busca avançada
- Listas de leitura personalizadas
- Sistema de favoritos
- Integração com bibliotecas
- Recursos de acessibilidade avançados

## Recursos de Acessibilidade

O projeto implementa diversos recursos de acessibilidade para garantir que todos os usuários possam utilizar a aplicação:

### Zoom Acessível em Imagens

O componente `AccessibleImageZoom` permite que os usuários ampliem imagens clicando nelas. Ao ser ativado, a imagem é exibida em uma janela modal com as seguintes características:

- Fundo escurecido (70% de opacidade)
- Imagem centralizada na tela
- Ocupa no máximo 90% da largura e altura da tela
- Pode ser fechada clicando fora da imagem ou pressionando a tecla ESC
- Totalmente acessível por teclado (Enter/Space para abrir, ESC para fechar)
- Compatível com leitores de tela
- Suporta zoom interativo com gestos de pinça
- Cursor do mouse muda para indicar que a imagem pode ser ampliada

#### Como usar:

```dart
AccessibleImageZoom(
  image: 'nome_da_imagem.jpg', // Caminho da imagem em assets/images/
  altText: 'Descrição da imagem para leitores de tela',
  width: 300,
  height: 200,
  fit: BoxFit.cover,
)
```

### Navegação por Teclado

O projeto implementa navegação completa por teclado seguindo as diretrizes WCAG 2.1, permitindo que usuários naveguem por toda a aplicação usando apenas o teclado.

### Integração com VLibras

O projeto inclui integração com o VLibras para tornar o conteúdo acessível em Libras (Língua Brasileira de Sinais).

## Como Executar

Para executar o projeto localmente:

1. Certifique-se de ter o Flutter instalado
2. Execute `flutter pub get` para instalar as dependências
3. Execute `flutter run -d chrome` para executar no navegador

## Como Construir para Web

Para construir a versão web do projeto:

```bash
flutter build web --release
```

O resultado será colocado na pasta `build/web`.