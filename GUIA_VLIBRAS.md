# 🤟 Guia Mestre de Integração VLibras - Vitrine UFMA

Este guia consolida todas as informações sobre a integração do **VLibras** (Língua Brasileira de Sinais) na plataforma Vitrine UFMA, cobrindo desde o uso básico até detalhes técnicos de implementação.

---

## 📖 1. O que é o VLibras na Vitrine UFMA?
O VLibras é uma ferramenta que traduz conteúdos digitais (texto, áudio e vídeo) para Libras, tornando computadores, dispositivos móveis e sites acessíveis para pessoas surdas. Na Vitrine UFMA, qualquer texto pode ser traduzido instantaneamente.

## 🎯 2. Como Usar (Para Usuários)

### Ativação
1. Localize o **ícone azul com mãos** no canto inferior direito da tela.
2. Clique no ícone para expandir o tradutor virtual.

### Métodos de Tradução
A Vitrine UFMA oferece duas formas intuitivas de traduzir textos:

1. **Tradução por Passagem de Mouse (Hover)**: 
   - Basta passar o cursor sobre qualquer título, botão ou descrição.
   - O texto será destacado e enviado automaticamente para o tradutor.
   - Um balão (tooltip) indicará: *"Passe o mouse para traduzir em Libras"*.

2. **Tradução por Teclado**:
   - Utilize a tecla `Tab` até focar no elemento desejado.
   - Pressione `Enter` para enviar o conteúdo para tradução.

---

## 🛠️ 3. Guia de Componentes (Para Desenvolvedores)

Para garantir que novos conteúdos sejam acessíveis, utilize os seguintes componentes padrões:

### `AppText` e `TextWidget`
Estes são os componentes de texto principais do projeto. Eles já possuem suporte **automático** ao VLibras no ambiente Web.
```dart
AppText(
  'Meu texto acessível',
  enableVLibras: true, // Padrão é true
  showVLibrasIcon: false,
)
```

### `VLibrasClickableText` e `VLibrasClickableWrapper`
Para widgets complexos ou quando você precisa de controle manual sobre o que é traduzido:
- **`VLibrasClickableText`**: Substitui o widget `Text` padrão.
- **`VLibrasClickableWrapper`**: Envolve qualquer widget (ex: um `Container` com vários textos) para traduzir um bloco de informações.

---

## 🔧 4. Arquitetura Técnica

### Configuração Core
- **`web/index.html`**: Contém o script oficial do VLibras e configurações de `z-index` (definido como 9999) para garantir visibilidade sobre outros elementos.
- **`VLibrasHelper`**: Classe utilitária que gerencia a comunicação com a API do VLibras, tratando ativação, reinicialização de rotas e fallbacks para plataformas não-web (stubs).

### Gerenciamento de Rotas
Utilizamos o `VLibrasRouteObserver` para garantir que o tradutor virtual não "quebre" ao navegar entre diferentes páginas do aplicativo. Ele força a reinicialização dos scripts necessários a cada mudança de tela.

---

## 🌐 5. Cobertura do Site
O VLibras está presente em **100% das páginas públicas e privadas**, incluindo:
- Vitrine de Livros e Resultados de Busca.
- Páginas Informativas (Sobre, Ajuda, Acessibilidade).
- Formulários de Cadastro (Labels e Instruções).
- Modais e Diálogos de Alerta.

---

## ⚠️ 6. Solução de Problemas

**O botão do VLibras não aparece?**
> Verifique se você está acessando a versão Web do site. O VLibras é uma tecnologia específica para navegadores.

**O hover não está ativando a tradução?**
> Certifique-se de que o tradutor virtual está selecionado (clique no ícone de mãos uma vez para "acordar" o avatar).

**O texto está sendo cortado na tradução?**
> O VLibras tem limites de caracteres. Para textos muito longos, tente passar o mouse por parágrafos individuais.

---

**Vitrine UFMA - Tecnologia promovendo autonomia e acessibilidade.**
