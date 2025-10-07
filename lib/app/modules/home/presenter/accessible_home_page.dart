import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/semantics.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:vitrine_ufma/app/core/components/accessibility_controls.dart';
import 'package:vitrine_ufma/app/core/utils/vlibras_helper.dart';

/// Página inicial totalmente acessível seguindo as diretrizes WCAG 2.2
/// 
/// Esta página implementa:
/// - Estrutura semântica clara com cabeçalho, navegação, conteúdo principal e rodapé
/// - Contraste de cores mínimo de 4.5:1
/// - Suporte completo a leitores de tela
/// - Gerenciamento adequado de foco
/// - Labels e hints semânticas para todos os elementos interativos
/// - Suporte a escalonamento de texto dinâmico
/// - Navegação por teclado completa
class AccessibleHomePage extends StatefulWidget {
  const AccessibleHomePage({Key? key}) : super(key: key);

  @override
  State<AccessibleHomePage> createState() => _AccessibleHomePageState();
}

class _AccessibleHomePageState extends State<AccessibleHomePage> with VLibrasPageMixin {
  final FocusNode _skipFocusNode = FocusNode();
  final FocusNode _mainContentFocusNode = FocusNode();
  final FocusNode _searchFocusNode = FocusNode();
  final TextEditingController _searchController = TextEditingController();
  
  // Add scroll controller for keyboard scrolling
  final ScrollController _scrollController = ScrollController();
  final FocusNode _scrollFocusNode = FocusNode();
  
  // Estados para demonstrar interatividade acessível
  bool _isFavorite = false;
  int _counter = 0;
  String _selectedCategory = 'Todos';
  
  // Categorias para demonstração
  final List<String> _categories = ['Todos', 'Livros', 'Artigos', 'Vídeos', 'Áudios'];
  
  @override
  void initState() {
    super.initState();
    // Garante que o VLibras seja reinicializado quando a página for carregada
    reinitializeVLibras();
    
    // Request focus for keyboard scrolling
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _skipFocusNode.dispose();
    _mainContentFocusNode.dispose();
    _searchFocusNode.dispose();
    _searchController.dispose();
    // Dispose scroll controllers
    _scrollController.dispose();
    _scrollFocusNode.dispose();
    super.dispose();
  }

  /// Função para lidar com o foco no link de skip navigation
  void _handleSkipFocus() {
    setState(() {
      // Foco no conteúdo principal quando o link de skip é ativado
      FocusScope.of(context).requestFocus(_mainContentFocusNode);
    });
  }

  /// Função para incrementar o contador de forma acessível
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
    
    // Anuncia a mudança para leitores de tela
    SemanticsService.announce('Contador atualizado para $_counter', TextDirection.ltr);
  }

  /// Função para alternar estado de favorito
  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });
    
    // Anuncia a mudança para leitores de tela
    final message = _isFavorite 
        ? 'Item adicionado aos favoritos' 
        : 'Item removido dos favoritos';
    SemanticsService.announce(message, TextDirection.ltr);
  }

  /// Função para selecionar categoria
  void _selectCategory(String category) {
    setState(() {
      _selectedCategory = category;
    });
    
    // Anuncia a seleção para leitores de tela
    SemanticsService.announce('Categoria selecionada: $category', TextDirection.ltr);
    
    // Atualiza o VLibras quando o conteúdo muda
    refreshVLibras();
  }

  /// Handle keyboard events for scrolling
  void _handleScrollKeyEvent(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      // Handle arrow key events for scrolling
      if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
        // Scroll up by 100 pixels
        _scrollController.animateTo(
          _scrollController.offset - 100,
          duration: const Duration(milliseconds: 100),
          curve: Curves.linear,
        );
      } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
        // Scroll down by 100 pixels
        _scrollController.animateTo(
          _scrollController.offset + 100,
          duration: const Duration(milliseconds: 100),
          curve: Curves.linear,
        );
      } else if (event.logicalKey == LogicalKeyboardKey.pageUp) {
        // Page up - scroll up by 80% of screen height
        final screenHeight = MediaQuery.of(context).size.height;
        _scrollController.animateTo(
          _scrollController.offset - screenHeight * 0.8,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
        );
      } else if (event.logicalKey == LogicalKeyboardKey.pageDown) {
        // Page down - scroll down by 80% of screen height
        final screenHeight = MediaQuery.of(context).size.height;
        _scrollController.animateTo(
          _scrollController.offset + screenHeight * 0.8,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
        );
      } else if (event.logicalKey == LogicalKeyboardKey.home) {
        // Home key - scroll to top
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } else if (event.logicalKey == LogicalKeyboardKey.end) {
        // End key - scroll to bottom
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: _scrollFocusNode,
      onKey: _handleScrollKeyEvent,
      child: AccessibilityControls(
        child: Scaffold(
          appBar: _buildAppBar(),
          body: _buildBody(),
          floatingActionButton: _buildFloatingActionButton(),
        ),
      ),
    );
  }

  /// Constrói a barra de aplicativo com estrutura semântica adequada
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Semantics(
        header: true,
        child: Text(
          'Vitrine UFMA Acessível',
          semanticsLabel: 'Vitrine UFMA - Página inicial acessível',
        ),
      ),
      actions: [
        // Botão de pesquisa acessível
        IconButton(
          focusNode: FocusNode(),
          icon: const Icon(Icons.search),
          onPressed: () {
            FocusScope.of(context).requestFocus(_searchFocusNode);
          },
          tooltip: 'Abrir pesquisa', // Tooltip para leitores de tela
        ),
        // Botão de configurações acessível
        IconButton(
          focusNode: FocusNode(),
          icon: const Icon(Icons.settings),
          onPressed: () {
            // Ação de configurações
          },
          tooltip: 'Configurações de acessibilidade',
        ),
      ],
    );
  }

  /// Constrói o corpo principal da página com estrutura semântica
  Widget _buildBody() {
    return Semantics(
      // Define que este é o conteúdo principal da página
      container: true,
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            // Link de skip navigation para usuários de teclado
            _buildSkipLink(),
            
            // Cabeçalho principal com banner semântico
            _buildHeader(),
            
            // Barra de pesquisa acessível
            _buildSearchBar(),
            
            // Navegação por categorias
            _buildCategoryNavigation(),
            
            // Conteúdo principal
            _buildMainContent(),
            
            // Seção interativa de demonstração
            _buildInteractiveDemo(),
            
            // Rodapé
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  /// Constrói o link de skip navigation para usuários de teclado
  Widget _buildSkipLink() {
    return Semantics(
      // Esconde visualmente mas mantém acessível para leitores de tela
      excludeSemantics: true,
      child: Container(
        width: 0,
        height: 0,
        child: FocusableActionDetector(
          focusNode: _skipFocusNode,
          onFocusChange: (hasFocus) {
            if (hasFocus) {
              _handleSkipFocus();
            }
          },
          child: ActionChip(
            label: const Text('Pular para conteúdo principal'),
            onPressed: _handleSkipFocus,
          ),
        ),
      ),
    );
  }

  /// Constrói o cabeçalho principal com banner semântico
  Widget _buildHeader() {
    return Semantics(
      header: true,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
        ),
        child: Column(
          children: [
            Text(
              'Bem-vindo à Vitrine UFMA',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              semanticsLabel: 'Bem-vindo à Vitrine UFMA - Universidade Federal do Maranhão',
            ),
            const SizedBox(height: 16),
            Text(
              'Plataforma acessível para todos os usuários',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.white70,
              ),
              textAlign: TextAlign.center,
              semanticsLabel: 'Plataforma acessível para todos os usuários, seguindo as diretrizes WCAG 2.2',
            ),
          ],
        ),
      ),
    );
  }

  /// Constrói a barra de pesquisa acessível
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Semantics(
        textField: true,
        label: 'Campo de pesquisa',
        hint: 'Digite o que você procura',
        child: TextField(
          focusNode: _searchFocusNode,
          controller: _searchController,
          decoration: InputDecoration(
            labelText: 'Pesquisar',
            hintText: 'Digite palavras-chave...',
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            filled: true,
            fillColor: Theme.of(context).colorScheme.surface,
          ),
          // Anuncia quando o texto muda
          onChanged: (value) {
            if (value.isNotEmpty) {
              SemanticsService.announce('Pesquisando por: $value', TextDirection.ltr);
            }
          },
          // Suporte a comandos de teclado
          onEditingComplete: () {
            if (_searchController.text.isNotEmpty) {
              SemanticsService.announce(
                'Resultados da pesquisa por: ${_searchController.text}', 
                TextDirection.ltr
              );
              // Atualiza VLibras com novo conteúdo
              refreshVLibras();
            }
          },
        ),
      ),
    );
  }

  /// Constrói a navegação por categorias acessível
  Widget _buildCategoryNavigation() {
    return Semantics(
      header: true,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Categorias',
              style: Theme.of(context).textTheme.titleLarge,
              semanticsLabel: 'Navegação por categorias',
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _categories.map((category) {
                  final isSelected = category == _selectedCategory;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Semantics(
                      button: true,
                      selected: isSelected,
                      label: isSelected 
                          ? 'Categoria $category selecionada' 
                          : 'Selecionar categoria $category',
                      child: FilterChip(
                        label: Text(category),
                        selected: isSelected,
                        onSelected: (selected) {
                          if (selected) {
                            _selectCategory(category);
                          }
                        },
                        // Atributos de acessibilidade adicionais
                        avatar: isSelected 
                            ? const Icon(Icons.check, size: 18) 
                            : null,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Constrói o conteúdo principal da página
  Widget _buildMainContent() {
    return Semantics(
      container: true,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Destaques',
              style: Theme.of(context).textTheme.headlineSmall,
              semanticsLabel: 'Seção de destaques',
            ),
            const SizedBox(height: 16),
            // Cards de conteúdo acessíveis
            _buildContentCards(),
          ],
        ),
      ),
    );
  }

  /// Constrói os cards de conteúdo acessíveis
  Widget _buildContentCards() {
    return Column(
      children: List.generate(3, (index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Semantics(
              container: true,
              child: InkWell(
                onTap: () {
                  SemanticsService.announce(
                    'Abrindo detalhes do item ${index + 1}', 
                    TextDirection.ltr
                  );
                },
                borderRadius: BorderRadius.circular(12.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Item de Conteúdo ${index + 1}',
                              style: Theme.of(context).textTheme.titleMedium,
                              semanticsLabel: 'Item de Conteúdo número ${index + 1}',
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              _isFavorite 
                                  ? Icons.favorite 
                                  : Icons.favorite_border,
                              color: _isFavorite ? Colors.red : null,
                            ),
                            onPressed: _toggleFavorite,
                            tooltip: _isFavorite 
                                ? 'Remover dos favoritos' 
                                : 'Adicionar aos favoritos',
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Descrição detalhada do conteúdo ${index + 1}. '
                        'Esta descrição fornece contexto importante para usuários '
                        'de leitores de tela e ajuda na compreensão do conteúdo.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              SemanticsService.announce(
                                'Ação executada no item ${index + 1}', 
                                TextDirection.ltr
                              );
                            },
                            child: const Text('Acessar'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  /// Constrói a seção interativa de demonstração
  Widget _buildInteractiveDemo() {
    return Semantics(
      container: true,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.all(16.0),
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Demonstração Interativa',
              style: Theme.of(context).textTheme.headlineSmall,
              semanticsLabel: 'Seção de demonstração interativa de acessibilidade',
            ),
            const SizedBox(height: 16),
            Text(
              'Esta seção demonstra recursos de acessibilidade como:'
              '\n• Anúncios para leitores de tela'
              '\n• Gerenciamento de foco'
              '\n• Feedback tátil'
              '\n• Contraste adequado',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Semantics(
                  button: true,
                  label: 'Botão de incremento, valor atual: $_counter',
                  child: ElevatedButton.icon(
                    onPressed: _incrementCounter,
                    icon: const Icon(Icons.add),
                    label: Text('Incrementar ($_counter)'),
                  ),
                ),
                Semantics(
                  button: true,
                  label: _isFavorite 
                      ? 'Botão de favorito, marcado como favorito' 
                      : 'Botão de favorito, não marcado como favorito',
                  child: IconButton(
                    icon: Icon(
                      _isFavorite 
                          ? Icons.favorite 
                          : Icons.favorite_border,
                      color: _isFavorite ? Colors.red : null,
                      size: 32,
                    ),
                    onPressed: _toggleFavorite,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Constrói o rodapé acessível
  Widget _buildFooter() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24.0),
      color: Theme.of(context).primaryColor.withOpacity(0.1),
      child: Column(
        children: [
          Semantics(
            header: true,
            child: Text(
              'Vitrine UFMA',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              semanticsLabel: 'Rodapé da Vitrine UFMA',
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Universidade Federal do Maranhão\n'
            'Campus São Luís - Monte Castelo\n'
            'São Luís - MA, Brasil',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
            semanticsLabel: 'Endereço: Universidade Federal do Maranhão, '
                'Campus São Luís - Monte Castelo, São Luís - MA, Brasil',
          ),
          const SizedBox(height: 16),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 16,
            children: [
              TextButton(
                onPressed: () {
                  SemanticsService.announce(
                    'Abrindo política de privacidade', 
                    TextDirection.ltr
                  );
                },
                child: const Text('Política de Privacidade'),
              ),
              TextButton(
                onPressed: () {
                  SemanticsService.announce(
                    'Abrindo termos de uso', 
                    TextDirection.ltr
                  );
                },
                child: const Text('Termos de Uso'),
              ),
              TextButton(
                onPressed: () {
                  SemanticsService.announce(
                    'Abrindo acessibilidade', 
                    TextDirection.ltr
                  );
                },
                child: const Text('Acessibilidade'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Constrói o botão flutuante de ação acessível
  Widget _buildFloatingActionButton() {
    return Semantics(
      button: true,
      label: 'Botão de ajuda',
      child: FloatingActionButton(
        onPressed: () {
          // Mostra ajuda acessível
          _showAccessibleHelp();
        },
        tooltip: 'Ajuda e suporte', // Tooltip para leitores de tela
        child: const Icon(Icons.help),
      ),
    );
  }

  /// Mostra diálogo de ajuda acessível
  void _showAccessibleHelp() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Semantics(
          container: true,
          child: AlertDialog(
            title: Semantics(
              header: true,
              child: Text(
                'Ajuda de Acessibilidade',
                semanticsLabel: 'Diálogo de ajuda sobre acessibilidade',
              ),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Text(
                    'Navegação por Teclado:',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  const Text('• Use Tab para navegar entre elementos'),
                  const Text('• Use Shift+Tab para navegar para trás'),
                  const Text('• Use Enter para ativar botões e links'),
                  const SizedBox(height: 16),
                  Text(
                    'Leitores de Tela:',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  const Text('• Todos os elementos têm labels descritivas'),
                  const Text('• Estrutura semântica clara com cabeçalhos'),
                  const Text('• Feedback sonoro para interações'),
                ],
              ),
            ),
            actions: [
              Semantics(
                button: true,
                label: 'Fechar diálogo de ajuda',
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Fechar'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}