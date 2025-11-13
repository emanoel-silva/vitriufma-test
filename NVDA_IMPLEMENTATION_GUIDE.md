# Guia de Implementação do Leitor de Tela NVDA

## Visão Geral

Este documento detalha a implementação do suporte ao leitor de tela NVDA no sistema Vitrine UFMA. A implementação permite que usuários com deficiência visual possam ouvir o conteúdo da página através do leitor de tela NVDA.

## Arquitetura

### Componentes Principais

1. **NVDAHelper** (`lib/app/core/utils/nvda_helper.dart`)
   - Classe principal que gerencia a área de texto para o NVDA
   - Fornece métodos para criar, atualizar e remover a área de texto
   - Gerencia a fila de textos para leitura

2. **NVDAText** (`lib/app/core/components/nvda_text.dart`)
   - Componente que torna textos disponíveis para o NVDA
   - Integra-se com o NVDAHelper para adicionar textos à fila

3. **AppText** (`lib/app/core/components/text.dart`)
   - Componente de texto principal com suporte integrado ao NVDA
   - Adiciona automaticamente textos à fila do NVDA quando visível

## Implementação Detalhada

### 1. NVDAHelper

O helper principal que gerencia a integração com o NVDA:

```dart
class NVDAHelper {
  static bool _isAreaVisible = false;
  static String _currentText = '';
  static final List<String> _textQueue = [];

  /// Cria área de texto para leitura do NVDA
  static void createNVDAArea(String text) {
    // Cria uma área flutuante com o texto para o NVDA ler
    final translationArea = html.DivElement()
      ..setAttribute('id', 'nvda-translation-area')
      ..style.position = 'fixed'
      ..style.bottom = '20px'
      ..style.right = '20px'
      ..style.width = '210px'
      ..style.height = '80px'
      ..style.backgroundColor = 'rgba(255, 255, 255, 0.95)'
      ..style.border = '2px solid #00cc66'
      ..style.borderRadius = '8px';
      
    // Adiciona conteúdo e instruções
    final title = html.Element.tag('strong')
      ..text = 'Texto para NVDA:';
      
    final textContent = html.DivElement()
      ..text = text;
      
    final instruction = html.DivElement()
      ..style.fontSize = '9px'
      ..text = 'Clique e arraste para mover';
  }

  /// Adiciona texto à fila do NVDA
  static void addTextToQueue(String text) {
    _textQueue.add(text);
    
    // Se a área está visível, atualiza imediatamente
    if (_isAreaVisible) {
      final combinedText = _textQueue.join('\n\n');
      updateNVDAText(combinedText);
    }
  }

  /// Alterna a visibilidade da área de texto do NVDA
  static void toggleNVDAArea([String? text]) {
    if (_isAreaVisible) {
      removeNVDAArea();
    } else {
      final displayText = text ?? _currentText;
      if (displayText.isNotEmpty) {
        createNVDAArea(displayText);
      } else if (_textQueue.isNotEmpty) {
        createNVDAArea(_textQueue.join('\n\n'));
      } else {
        createNVDAArea('Conteúdo da página pronto para leitura com NVDA.');
      }
    }
  }
}
```

### 2. Componente AppText com Suporte NVDA

O componente de texto principal agora inclui suporte automático ao NVDA:

```dart
class AppText extends StatelessWidget {
  final String text;
  final bool enableNVDA;
  
  const AppText({
    required this.text,
    this.enableNVDA = true,
    // outros parâmetros...
  });

  @override
  Widget build(BuildContext context) {
    // Adiciona texto à fila do NVDA se habilitado
    if (enableNVDA && UniversalPlatform.isWeb) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (NVDAHelper.isAreaVisible) {
          NVDAHelper.addTextToQueue(text);
        }
      });
    }
    
    // Renderiza o texto normalmente
    return TextWidget();
  }
}
```

## Como Funciona

### 1. Ativação do NVDA

Os usuários podem ativar o suporte ao NVDA de duas formas:

1. **Botão na Página de Acessibilidade**: Clicar no botão "Ativar/Desativar Leitor de Tela NVDA"
2. **Programaticamente**: Através do código usando `NVDAHelper.toggleNVDAArea()`

### 2. Coleta de Textos

Quando a área do NVDA está visível, todos os componentes `AppText` com `enableNVDA=true` automaticamente adicionam seu conteúdo à fila do NVDA:

- Textos são coletados quando o widget é renderizado
- Textos são combinados quando múltiplos elementos estão presentes
- A área é atualizada em tempo real com novo conteúdo

### 3. Interface do Usuário

A área do NVDA apresenta as seguintes características:

- **Posicionamento**: Fixa no canto inferior direito da tela
- **Design**: Fundo branco semi-transparente com borda verde
- **Funcionalidade**: Pode ser arrastada para outra posição
- **Conteúdo**: Exibe todos os textos da página em uma única área
- **Instruções**: Inclui instruções para o usuário

## Recursos de Acessibilidade

### 1. Suporte a Leitores de Tela

- **Semântica**: Todos os textos incluem labels semânticas apropriadas
- **Regiões ao Vivo**: Textos são marcados como regiões ao vivo para atualização imediata
- **Navegação**: Estrutura clara para navegação por leitores de tela

### 2. Personalização

- **Habilitação Seletiva**: Componentes podem desabilitar o NVDA individualmente
- **Fila de Textos**: Textos são combinados de forma organizada
- **Limpeza Automática**: Área é removida automaticamente quando não necessária

## Testes

### 1. Funcionalidade

- Verificar criação da área do NVDA
- Confirmar adição de textos à fila
- Testar atualização em tempo real do conteúdo
- Validar funcionalidade de arrastar

### 2. Acessibilidade

- Testar com NVDA real
- Verificar leitura correta de todos os textos
- Confirmar navegação adequada
- Validar compatibilidade com outros leitores de tela

### 3. Performance

- Verificar impacto mínimo no carregamento da página
- Confirmar gerenciamento adequado de memória
- Testar em diferentes navegadores

## Integração com Outros Recursos

### 1. VLibras

O suporte ao NVDA trabalha em conjunto com o VLibras:

- Ambos podem estar ativos simultaneamente
- Não há conflitos entre os sistemas
- Usuários podem escolher qual tecnologia usar

### 2. Navegação por Teclado

- A área do NVDA não interfere na navegação por teclado
- Teclas de atalho continuam funcionando normalmente
- Foco é mantido nos elementos interativos

## Boas Práticas

### 1. Uso de Textos

- Manter textos claros e descritivos
- Evitar jargões técnicos quando possível
- Organizar conteúdo de forma lógica

### 2. Implementação

- Habilitar NVDA por padrão em todos os textos
- Usar `AppText` em vez de `Text` para componentes visíveis
- Testar regularmente com leitores de tela reais

### 3. Manutenção

- Atualizar textos quando o conteúdo da página muda
- Limpar fila de textos quando a página é fechada
- Monitorar compatibilidade com novas versões do NVDA

## Conclusão

A implementação do suporte ao NVDA no Vitrine UFMA fornece uma experiência acessível completa para usuários com deficiência visual. Com a integração automática de textos, interface amigável e compatibilidade com outras tecnologias assistivas, o sistema garante que todos os usuários possam acessar o conteúdo da plataforma de forma eficaz.