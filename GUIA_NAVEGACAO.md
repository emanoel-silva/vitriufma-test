# 🧭 Guia de Navegação - Vitrine UFMA com VLibras

## 📱 Acesso a Todas as Páginas

O site Vitrine UFMA possui várias páginas que você pode acessar diretamente através do menu de navegação ou URLs diretas. **Todas as páginas têm integração completa com VLibras!**

## 🏠 Páginas Principais (Acesso Público)

### 1. Página Inicial - Livros
- **URL**: `http://localhost:8080/#/home/books`
- **Menu**: Clique em "Início" no menu superior
- **Conteúdo**: Lista de livros, materiais mais acessados, novas aquisições
- **VLibras**: ✅ Todos os títulos, descrições e botões são clicáveis

### 2. Sobre
- **URL**: `http://localhost:8080/#/home/about`
- **Menu**: Clique em "Sobre" no menu superior
- **Conteúdo**: Informações sobre a instituição
- **VLibras**: ✅ Todo o conteúdo informativo é clicável

### 3. Acessibilidade
- **URL**: `http://localhost:8080/#/home/acessibilities`
- **Menu**: Clique em "Acessibilidade" no menu superior
- **Conteúdo**: Recursos de acessibilidade disponíveis
- **VLibras**: ✅ Guias e instruções são clicáveis

### 4. Ajuda
- **URL**: `http://localhost:8080/#/home/help`
- **Menu**: Clique em "Ajuda" no menu superior
- **Conteúdo**: FAQ e documentação de help
- **VLibras**: ✅ Perguntas e respostas são clicáveis

### 5. Login
- **URL**: `http://localhost:8080/#/auth`
- **Menu**: Clique em "Login" no menu superior (quando não logado)
- **Conteúdo**: Formulário de autenticação
- **VLibras**: ✅ Labels e instruções são clicáveis

## 🔐 Páginas do Usuário Logado

### 6. Minhas Listas
- **URL**: `http://localhost:8080/#/home/list/reading`
- **Menu**: "Meu perfil" → "Minhas listas"
- **Conteúdo**: Listas de leitura personalizadas
- **VLibras**: ✅ Nomes das listas e itens são clicáveis

### 7. Meus Favoritos
- **URL**: `http://localhost:8080/#/home/list/favorites`
- **Menu**: "Meu perfil" → "Meus Favoritos"
- **Conteúdo**: Livros marcados como favoritos
- **VLibras**: ✅ Títulos e descrições são clicáveis

### 8. Cadastrar Material
- **URL**: `http://localhost:8080/#/home/register`
- **Menu**: "Meu perfil" → "Cadastrar"
- **Conteúdo**: Formulário para cadastro de novos materiais
- **VLibras**: ✅ Labels de formulário são clicáveis

### 9. Gerenciar
- **URL**: `http://localhost:8080/#/home/manage`
- **Menu**: "Meu perfil" → "Gerenciar"
- **Conteúdo**: Gerenciamento de materiais cadastrados
- **VLibras**: ✅ Opções de gerenciamento são clicáveis

## 🔍 Páginas Dinâmicas

### 10. Detalhes do Livro
- **URL**: `http://localhost:8080/#/home/books/:id`
- **Acesso**: Clique em qualquer livro na página inicial
- **Conteúdo**: Detalhes completos do material
- **VLibras**: ✅ Descrições, resumos e metadados são clicáveis

### 11. Resultados de Busca
- **URL**: `http://localhost:8080/#/home/result/:search`
- **Acesso**: Use a barra de pesquisa
- **Conteúdo**: Resultados filtrados de busca
- **VLibras**: ✅ Resultados e filtros são clicáveis

### 12. Busca Avançada
- **URL**: `http://localhost:8080/#/home/search`
- **Acesso**: Link "Busca Avançada" na pesquisa
- **Conteúdo**: Formulário de busca detalhada
- **VLibras**: ✅ Opções de filtro são clicáveis

### 13. Lista Compartilhada
- **URL**: `http://localhost:8080/#/home/share/:id`
- **Acesso**: Link de compartilhamento de listas
- **Conteúdo**: Visualização de listas compartilhadas
- **VLibras**: ✅ Conteúdo compartilhado é clicável

## 🎯 Como Navegar Entre Páginas

### Método 1: Menu Superior
1. Use os links no menu horizontal superior
2. Clique em: Início | Sobre | Acessibilidade | Ajuda | Login

### Método 2: Menu do Perfil (Usuário Logado)
1. Clique em "Meu perfil" no menu superior
2. Selecione: Minhas listas | Meus Favoritos | Cadastrar | Gerenciar

### Método 3: URLs Diretas
1. Digite ou cole a URL diretamente na barra do navegador
2. Todas as URLs seguem o padrão: `http://localhost:8080/#/home/[pagina]`

### Método 4: Navegação Contextual
1. Clique em livros para ver detalhes
2. Use a busca para acessar resultados
3. Clique em listas para acessar conteúdo específico

## ✨ Funcionalidade VLibras em Todas as Páginas

### 🔄 Funcionamento Automático
- **Inicialização**: VLibras se inicializa automaticamente em qualquer página
- **Reinicialização**: Ao navegar entre páginas, VLibras se atualiza automaticamente
- **Persistência**: O estado do VLibras persiste durante a navegação

### 🖱️ Interação com Textos
1. **Hover**: Passe o mouse sobre qualquer texto para ver o destaque
2. **Clique**: Clique em qualquer texto para enviar para tradução
3. **Feedback**: Receba confirmação visual via SnackBar
4. **Tradução**: VLibras traduz automaticamente o conteúdo

### 📱 Recursos Disponíveis em Todas as Páginas
- ✅ **Títulos e cabeçalhos** são clicáveis
- ✅ **Parágrafos e descrições** são clicáveis  
- ✅ **Botões e links** são clicáveis
- ✅ **Labels de formulário** são clicáveis
- ✅ **Mensagens de erro/sucesso** são clicáveis
- ✅ **Itens de lista** são clicáveis
- ✅ **Metadados** são clicáveis

## 🛠️ Para Desenvolvedores

### URLs de Desenvolvimento
```bash
# Servidor local de desenvolvimento
http://localhost:8080

# Exemplos de URLs diretas
http://localhost:8080/#/home/books
http://localhost:8080/#/home/about
http://localhost:8080/#/home/acessibilities
http://localhost:8080/#/home/help
http://localhost:8080/#/auth
```

### Testando VLibras
1. Abra qualquer página
2. Aguarde o carregamento completo
3. Clique no botão azul do VLibras (canto da tela)
4. Clique em qualquer texto para testar a tradução

## 🎉 Resumo

**Todas as 13+ páginas do site** agora têm:
- ✅ **Navegação funcional** entre páginas
- ✅ **VLibras integrado** e operacional
- ✅ **Textos clicáveis** para tradução
- ✅ **Funcionalidade preservada** sem quebras
- ✅ **Experiência consistente** em todo o site

**Acesse qualquer página e aproveite a acessibilidade completa!** 🚀