# ♿ Guia Mestre de Acessibilidade e Navegação por Teclado - Vitrine UFMA

Bem-vindo ao guia compreensivo de acessibilidade da Vitrine UFMA. Este documento consolida todas as funcionalidades, atalhos e diretrizes técnicas para garantir uma experiência inclusiva a todos os usuários, seguindo as normas **WCAG 2.1 e 2.2**.

---

## 📖 1. Visão Geral
A Vitrine UFMA foi desenvolvida com o compromisso de ser 100% acessível. Implementamos recursos avançados de navegação por teclado, integração com VLibras, suporte a leitores de tela e ampliação visual de conteúdos.

## ⌨️ 2. Guia Rápido de Atalhos

### Navegação de Foco (Padrão)
| Tecla | Função |
| :--- | :--- |
| **Tab** | Avança para o próximo elemento interativo |
| **Shift + Tab** | Retrocede para o elemento anterior |
| **Enter** | Ativa links, botões ou envia formulários |
| **Espaço** | Ativa botões/checkboxes ou rola a página |
| **Esc** | Fecha menus, diálogos ou cancela ações |

### Atalhos Globais de Navegação (`Alt` + Tecla)
| Atalho | Destino |
| :--- | :--- |
| **Alt + H** | Ir para **Início** |
| **Alt + A** | Ir para **Sobre** |
| **Alt + C** | Ir para **Acessibilidade** |
| **Alt + J** | Ir para **Ajuda** |
| **Alt + L** | Ir para **Login** |

### Atalhos de Controle e Busca
- **Ctrl + S**: Ir diretamente para a Barra de Busca.
- **Ctrl + H**: Atalho alternativo para o Início.
- **F1**: Exibir ajuda contextual de atalhos.

---

## 🖱️ 3. Navegação Detalhada por Teclado

### Controle de Rolagem
Utilize estas teclas para navegar pelo conteúdo quando não estiver em campos de texto:
- **Setas (↑ / ↓)**: Rolagem fina de 100 pixels.
- **Page Up / Page Down**: Rolagem rápida (80% da altura da tela).
- **Home**: Salta instantaneamente para o topo da página.
- **End**: Salta instantaneamente para o final da página.

### Navegação em Extremidades
- **Ctrl + Home**: Foca no primeiro elemento interativo da página.
- **Ctrl + End**: Foca no último elemento interativo da página.

---

## ✨ 4. Recursos Específicos de Acessibilidade

### 🤟 Integração VLibras (Tradução em Libras)
O site possui integração completa com o VLibras para tradução automática do conteúdo brasileiro de sinais.
- **Ativação**: Clique no botão azul flutuante no canto inferior direito.
- **Tradução por Hover (Mouse)**: Ao passar o mouse sobre qualquer texto, ele será automaticamente enviado para tradução.
- **Atalho de Teclado**: Use `Tab` para alcançar o botão do VLibras e `Enter` para ativar.

### 🔍 Zoom de Imagem Acessível
O componente `AccessibleImageZoom` permite detalhar capas de livros e imagens.
- **Como usar**: Foque na imagem com `Tab` e pressione `Enter` ou `Space`.
- **Modo Ampliado**: A imagem ocupa até 90% da tela sobre um fundo escuro.
- **Saída**: Pressione `Esc` ou clique fora para fechar o zoom.

### 🗣️ Suporte ao Leitor de Tela (NVDA/VoiceOver)
- **Estrutura Semântica**: Uso correto de H1-H6 e landmarks (header, footer, main).
- **Labels Descritivos**: Todos os ícones e botões possuem `semanticsLabel`.
- **NVDA Helper**: Área dedicada para leitura de textos longos e feedback em tempo real.

---

## 🎨 5. Indicadores Visuais e Contraste
Para facilitar a percepção visual:
- **Foco Ativo**: Elementos focados exibem um anel azul brilhante (`#2196F3`).
- **Estados de Hover**: Destaque visual suave em itens interativos.
- **Contraste**: Seguimos o padrão mínimo de **4.5:1** para textos normais.
- **Ajuste de Fonte**: Botões (A+ / A-) no cabeçalho para instruções de zoom do navegador.

---

## 🔧 6. Guia Técnico para Desenvolvedores

### Arquitetura de Acessibilidade
O sistema é baseado em dois serviços principais:
1. **`KeyboardNavigationService`**: Gerencia o registro e disparo de atalhos globais.
2. **`FocusManagementService`**: Controla a ordem lógica (`FocusTraversalPolicy`) entre páginas.

### Componentes Core
Ao desenvolver novas funcionalidades, utilize sempre as variantes acessíveis:
- `KeyboardNavigationWrapper`: Envolva a página inteira para habilitar atalhos.
- `AccessibleKeyboardButton`: Substitui botões padrão com suporte a `Enter/Space`.
- `AccessibleImageZoom`: Para visualização detalhada de assets.
- `VLibrasClickableWrapper`: Torna qualquer widget interativo para o VLibras.

### Exemplo de Implementação de Página
```dart
return KeyboardNavigationWrapper(
  pageKey: 'nome_da_pagina',
  child: Scaffold(
    body: SingleChildScrollView(
      child: Column(
        children: [
          AccessibleKeyboardButton(
            onPressed: () => print('Ação'),
            semanticsLabel: 'Botão de Exemplo',
            child: Text('Enviar'),
          ),
        ],
      ),
    ),
  ),
);
```

---

## ⚠️ 7. Solução de Problemas (FAQ)

**O Tab não está movendo o foco?**
> Clique em qualquer área vazia do site para restaurar o foco inicial do navegador.

**O VLibras não está traduzindo?**
> Certifique-se de que o botão azul no canto inferior está ativado (ícone de mãos).

**Atalhos Alt + Letra não funcionam?**
> Em alguns navegadores, pode ser necessário usar `Alt + Shift + Letra` ou verificar se o navegador não está capturando o atalho para si.

---

## 🎓 8. Créditos e Contato
Este sistema foi desenvolvido visando a **Inclusão Digital Efetiva** na UFMA. 
Para sugestões ou reporte de barreiras de acessibilidade, utilize a página de **Ajuda** (`Alt + J`).

**Vitrine UFMA - Tecnologia a serviço da inclusão.**
