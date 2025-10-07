import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:vitrine_ufma/app/core/components/book_card.dart';
import 'package:vitrine_ufma/app/core/components/custom_textfield.dart';
import 'package:vitrine_ufma/app/core/components/image_asset.dart';
import 'package:vitrine_ufma/app/core/components/text.dart';
import 'package:vitrine_ufma/app/core/constants/colors.dart';
import 'package:vitrine_ufma/app/core/constants/const.dart';
import 'package:vitrine_ufma/app/modules/home/presenter/home/home_store.dart';
import 'package:vitrine_ufma/app/modules/home/presenter/search/simple_search/search_modal.dart';

class HomeBooksPage extends StatefulWidget {
  final HomeStore store;
  const HomeBooksPage({super.key, required this.store});

  @override
  State<HomeBooksPage> createState() => _HomeBooksPageState();
}

class _HomeBooksPageState extends State<HomeBooksPage> {
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // You can directly get the store instance inside the callback
      await widget.store.loadbooks(); // Carrega as coleções
      await widget.store.getMostAccessedMaterials(10);
      await widget.store.getTopRatedMaterials(10);
      widget.store.fetchRelatedBooks('Literatura');
      widget.store.fetchRelatedBooks('Ficção');
      widget.store.fetchRelatedBooks('Romance');
      widget.store.fetchRelatedBooks('Ciências');
    });
    
    // Request focus for keyboard navigation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleKeyEvent(RawKeyEvent event) {
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
        // Page up - scroll up by half the screen height
        final screenHeight = MediaQuery.of(context).size.height;
        _scrollController.animateTo(
          _scrollController.offset - screenHeight * 0.8,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
        );
      } else if (event.logicalKey == LogicalKeyboardKey.pageDown) {
        // Page down - scroll down by half the screen height
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
      focusNode: _focusNode,
      onKey: _handleKeyEvent,
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SearchModal(
            ),
            _mainContent(),
            _mostAccessedMaterials(),
            _topRatedMaterials(),
            //LISTAS DE LIVROS RELACIONADOS
            _relatedBooksSection('Literatura'),
            _relatedBooksSection('Ficção'),
            _relatedBooksSection('Romance'),
            _relatedBooksSection('Ciências'),
          ],
        ),
      ),
    );
  }

  Widget _mainContent() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Observer(
      builder: (_) {
        //mostra o loading
        if (widget.store.loading) {
          return SizedBox(
            height: 500,
            width: width,
            child: const Center(
              child: CircularProgressIndicator(
                color: AppColors.black,
              ),
            ),
          );
        }

        return Center(
          child: Container(
            width: AppConst.maxContainerWidth,
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 40,
                        ),
                        AppText(
                          text: 'Novas aquisições',
                          fontSize: 18,
                          fontWeight: 'bold',
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        SizedBox(
                          height: 300,
                          child: Observer(builder: (context) {
                            if (widget.store.books.isEmpty) {
                              return const SizedBox();
                            }
                            return ListView.builder(
                              scrollDirection: Axis.horizontal,
                              controller: widget.store.scrollController[0],
                              itemCount: widget.store.filteredBooks.length,
                              itemBuilder: (context, index) {
                                var book = widget.store.filteredBooks[index];
                                return InkWell(
                                    hoverColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () {
                                      widget.store.setSelectedBook(book);
                                      // Get.toNamed("/book-view");
                                    },
                                    child: BookCard(book: book));
                              },
                            );
                          }),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                    
                        //BOTÃO VER MAIS
                        Row(
                          children: [
                            const Spacer(),
                            Container(
                              alignment: Alignment.center,
                              height: 40,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                                color: AppColors.lightRed.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: AppText(
                                text: "Veja Mais!",
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 60,
                        ),
                      ],
                    ),

                    //SETA PARA A ESQUERDA E DIREITA
                    Row(
                      children: [
                        Container(
                          height: 270,
                          width: 40,
                          color: Colors.transparent,
                          child: IconButton(
                            onPressed: () => widget.store.scrollToLeft(0),
                            icon: const Icon(
                              Icons.arrow_back_ios,
                              color: AppColors.mediumGrey,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Container(
                          height: 270,
                          width: 40,
                          color: Colors.transparent,
                          child: IconButton(
                            onPressed: () => widget.store.scrollToRight(0),
                            icon: const Icon(
                              Icons.arrow_forward_ios,
                              color: AppColors.mediumGrey,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        );

        // return const SizedBox();
      },
    );
  }

  Widget _mostAccessedMaterials() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Observer(
      builder: (_) {
        //mostra o loading
        if (widget.store.loading) {
          return SizedBox(
            height: 500,
            width: width,
            child: const Center(
              child: CircularProgressIndicator(
                color: AppColors.black,
              ),
            ),
          );
        }

        return Center(
          child: Container(
            width: AppConst.maxContainerWidth,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.store.mostAccessedMaterials.isNotEmpty)
                  AppText(
                    text: 'Materiais mais acessados',
                    fontSize: 18,
                    fontWeight: 'bold',
                  ),
                if (widget.store.mostAccessedMaterials.isNotEmpty)
                  const SizedBox(
                    height: 40,
                  ),
                SizedBox(
                  height: 300,
                  child: Observer(builder: (context) {
                    if (widget.store.mostAccessedMaterials.isEmpty) {
                      return const SizedBox();
                    }
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      controller: widget.store.scrollController[0],
                      itemCount: widget.store.mostAccessedMaterials.length,
                      itemBuilder: (context, index) {
                        var book = widget.store.mostAccessedMaterials[index];
                        return InkWell(
                            hoverColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () {
                              widget.store.setSelectedBook(book);
                              print("Book: ${book.title}");

                              Modular.to.pushNamed('/home/book/${book.id}',
                                  arguments: book);
                            },
                            child: BookCard(book: book));
                      },
                    );
                  }),
                ),
                const SizedBox(
                  height: 20,
                ),
                const SizedBox(
                  height: 60,
                ),
              ],
            ),
          ),
        );

        // return const SizedBox();
      },
    );
  }

  Widget _topRatedMaterials() {
    double width = MediaQuery.of(context).size.width;
    return Observer(
      builder: (_) {
        //mostra o loading
        if (widget.store.loading) {
          return SizedBox(
            height: 500,
            width: width,
            child: const Center(
              child: CircularProgressIndicator(
                color: AppColors.black,
              ),
            ),
          );
        }

        return Center(
          child: Container(
            width: AppConst.maxContainerWidth,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.store.topRatedMaterials.isNotEmpty)
                  AppText(
                    text: 'Materiais mais bem avaliados',
                    fontSize: 18,
                    fontWeight: 'bold',
                  ),
                if (widget.store.topRatedMaterials.isNotEmpty)
                  const SizedBox(
                    height: 40,
                  ),
                SizedBox(
                  height: 300,
                  child: Observer(builder: (context) {
                    if (widget.store.topRatedMaterials.isEmpty) {
                      return const SizedBox();
                    }
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      controller: widget.store.scrollController[0],
                      itemCount: widget.store.topRatedMaterials.length,
                      itemBuilder: (context, index) {
                        var book = widget.store.topRatedMaterials[index];
                        return InkWell(
                            hoverColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () {
                              widget.store.setSelectedBook(book);
                              print("Book: ${book.title}");

                              Modular.to.pushNamed('/home/book/${book.id}',
                                  arguments: book);
                            },
                            child: BookCard(book: book));
                      },
                    );
                  }),
                ),
                const SizedBox(
                  height: 20,
                ),
                const SizedBox(
                  height: 60,
                ),
              ],
            ),
          ),
        );

        // return const SizedBox();
      },
    );
  }

  Widget _relatedBooksSection(String keyword) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Observer(
      builder: (_) {
        // Mostra o loading
        if (widget.store.loading) {
          return SizedBox(
            height: 500,
            width: width,
            child: const Center(
              child: CircularProgressIndicator(
                color: AppColors.black,
              ),
            ),
          );
        }

        var books = widget.store.relatedBooksMap[keyword];
        if (books == null || books.isEmpty) {
          return const SizedBox();
        }

        return Center(
          child: Container(
            width: AppConst.maxContainerWidth,
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 70),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                            text: 'Materiais sobre $keyword',
                            fontSize: 18,
                            fontWeight: 'bold',
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          SizedBox(
                            height: 300,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              controller: widget.store.scrollController[0],
                              itemCount: books.length,
                              itemBuilder: (context, index) {
                                var book = books[index];
                                return InkWell(
                                  hoverColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () {
                                    widget.store.setSelectedBook(book);
                                    // Get.toNamed("/book-view");
                                  },
                                  child: BookCard(book: book),
                                );
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const SizedBox(
                            height: 60,
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _footer() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
        width: width,
        color: AppColors.backgroundGrey,
        padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 20),
        child: Wrap(
          spacing: 40,
          runSpacing: 40,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(text: "Quem Somos"),
                const SizedBox(
                  height: 10,
                ),
                AppText(text: "Serviços e Produtos"),
                const SizedBox(
                  height: 10,
                ),
                AppText(text: "Canais de Comunicação"),
                const SizedBox(
                  height: 10,
                ),
                AppText(text: "Redes Sociais"),
                const SizedBox(
                  height: 10,
                ),
                AppText(text: "Localização"),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(text: "Copyright © 2023"),
                const SizedBox(
                  height: 10,
                ),
                AppText(
                    text: "NOME DAS INSTITUIÇÕES ENVOLVIDAS \nUFMA/DIB/CCPI"),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ],
        ));
  }
}
