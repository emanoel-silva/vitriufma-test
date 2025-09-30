# Guia de Uso do VLibras Clicável

Este guia explica como usar os novos componentes que tornam qualquer texto clicável para tradução no VLibras.

## 🎯 Componentes Disponíveis

### 1. VLibrasClickableText
Widget que substitui um `Text` normal, tornando-o clicável para tradução.

```dart
VLibrasClickableText(
  'Texto para traduzir',
  style: TextStyle(fontSize: 16),
  tooltip: 'Clique para traduzir em Libras',
  showIcon: true, // Mostra ícone de acessibilidade
)
```

### 2. VLibrasClickableWrapper
Widget que envolve qualquer outro widget tornando-o clicável.

```dart
VLibrasClickableWrapper(
  textToTranslate: 'Texto longo que será traduzido',
  tooltip: 'Clique para traduzir em Libras',
  child: Container(
    child: Text('Qualquer conteúdo aqui'),
  ),
)
```

### 3. VLibrasPageMixin
Mixin para páginas que usam VLibras.

```dart
class MyPageState extends State<MyPage> with VLibrasPageMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: // seu conteúdo
    );
  }
  
  void onSomeAction() {
    // Traduzir texto específico
    translateText('Texto para traduzir');
    
    // Refresh do VLibras após mudanças
    refreshVLibras();
  }
}
```

## 🚀 Exemplos Práticos

### Exemplo 1: Título Clicável
```dart
VLibrasClickableText(
  'Título do Livro',
  style: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  ),
  tooltip: 'Clique para traduzir o título em Libras',
)
```

### Exemplo 2: Resumo Longo Clicável
```dart
VLibrasClickableWrapper(
  textToTranslate: book.abstract,
  tooltip: 'Clique para traduzir o resumo em Libras',
  child: Text(
    book.abstract,
    textAlign: TextAlign.justify,
    maxLines: 10,
  ),
)
```

### Exemplo 3: Lista de Items Clicáveis
```dart
Column(
  children: book.tags.map((tag) => 
    VLibrasClickableText(
      tag,
      style: TextStyle(color: Colors.blue),
      showIcon: false, // Sem ícone para economizar espaço
    )
  ).toList(),
)
```

## 🎨 Personalização

### Parâmetros do VLibrasClickableText
- `text`: O texto a ser exibido e traduzido
- `style`: Estilo do texto (TextStyle)
- `textAlign`: Alinhamento do texto
- `maxLines`: Máximo de linhas
- `showIcon`: Se deve mostrar o ícone de acessibilidade
- `iconColor`: Cor do ícone
- `iconSize`: Tamanho do ícone
- `tooltip`: Texto do tooltip
- `highlightColor`: Cor de destaque ao clicar

### Parâmetros do VLibrasClickableWrapper
- `child`: Widget filho a ser envolvido
- `textToTranslate`: Texto que será enviado para tradução
- `tooltip`: Texto do tooltip
- `highlightColor`: Cor de destaque ao clicar
- `showFeedback`: Se deve mostrar SnackBar de feedback

## 🔧 Funcionalidades Automáticas

### 1. Detecção de Plataforma
Os componentes só funcionam na web. Em outras plataformas, mostram o conteúdo normal sem funcionalidade de clique.

### 2. Feedback Visual
- Destaque visual ao passar o mouse
- Tooltip explicativo
- SnackBar de confirmação quando o texto é enviado

### 3. Gerenciamento de Estado
- Verifica se o VLibras está disponível
- Ativa o VLibras automaticamente se necessário
- Cria área de feedback caso o VLibras não esteja funcionando

## 🐛 Solução de Problemas

### Problema: Componente não responde ao clique
**Solução**: Verifique se está rodando na web e se o VLibras está carregado.

```dart
// Debug
VLibrasHelper.debug();
```

### Problema: Texto não aparece na área de tradução
**Solução**: Verifique se o texto não está vazio e se contém caracteres válidos.

### Problema: VLibras não traduz o texto
**Solução**: 
1. Verifique o console do navegador
2. Teste com texto simples primeiro
3. Certifique-se de que o VLibras está funcionando clicando no botão azul

## 📋 Boas Práticas

### 1. Use tooltips descritivos
```dart
tooltip: 'Clique para traduzir o título em Libras',
```

### 2. Agrupe textos relacionados
Em vez de tornar cada palavra clicável, agrupe frases ou parágrafos inteiros.

### 3. Evite textos muito longos
Para textos muito longos, divida em seções menores.

### 4. Teste a funcionalidade
Sempre teste com o VLibras real para garantir que a tradução funciona.

## 🔄 Integração em Páginas Existentes

### 1. Importe o componente
```dart
import 'package:vitrine_ufma/app/core/components/vlibras_clickable_text.dart';
```

### 2. Substitua Text por VLibrasClickableText
```dart
// Antes
Text('Meu texto')

// Depois
VLibrasClickableText('Meu texto')
```

### 3. Para widgets complexos, use o Wrapper
```dart
// Antes
Container(
  child: Column(
    children: [
      Text('Título'),
      Text('Descrição longa...'),
    ],
  ),
)

// Depois
VLibrasClickableWrapper(
  textToTranslate: 'Título. Descrição longa...',
  child: Container(
    child: Column(
      children: [
        Text('Título'),
        Text('Descrição longa...'),
      ],
    ),
  ),
)
```

## 🚀 Funcionalidades Avançadas

### Tradução Programática
```dart
// Em qualquer lugar do código
VLibrasHelper.activateAndTranslate('Texto para traduzir');
```

### Verificação de Disponibilidade
```dart
if (VLibrasHelper.isAvailable) {
  // VLibras está funcionando
}
```

### Debug Completo
```dart
VLibrasHelper.debug(); // Imprime informações de debug
```

Com esses componentes, agora qualquer texto na aplicação pode ser facilmente tornado acessível para tradução em Libras!
