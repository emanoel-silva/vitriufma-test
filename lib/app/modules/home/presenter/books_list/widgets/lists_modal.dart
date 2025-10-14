import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:vitrine_ufma/app/core/components/accessible_network_image_zoom.dart';
import 'package:vitrine_ufma/app/core/components/text.dart';
import 'package:vitrine_ufma/app/core/constants/colors.dart';
import 'package:vitrine_ufma/app/core/constants/const.dart';
import 'package:vitrine_ufma/app/core/constants/fonts_sizes.dart';
import 'package:vitrine_ufma/app/modules/home/presenter/books_list/reading_list/reading_list_store.dart';

class ListModal extends StatefulWidget {
  final bool? isDialog;
  final int listId;
  final ReadingListStore store;
  const ListModal({
    super.key,
    required this.listId,
    required this.store,
    this.isDialog,
  });

  @override
  State<ListModal> createState() => _ListModalState();
}

class _ListModalState extends State<ListModal> {
  late ReadingListStore store = widget.store;
  final bool _isDialog = true;
  bool get isDialog => widget.isDialog ?? true;
  
  @override
  void initState() {
    super.initState();

    // store.selectedBook = null;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      store.getMaterialFromList(widget.listId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black.withOpacity(0.5),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(
            maxHeight: 800,
            maxWidth: 800,
          ),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.all(AppConst.sidePadding),
          child: Column(
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                AppText(
                  text: store.readingList[widget.listId]?['name'] ==
                          'aee20c6a981fe6633c17340037ebb6472f1d8eb9'
                      ? 'Favoritos'
                      : store.readingList[widget.listId]?['name'] ?? 'No name',
                  fontSize: AppFontSize.fz14,
                  fontWeight: 'bold',
                ),
                isDialog
                    ? IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      )
                    : const SizedBox(),
              ]),
              const SizedBox(height: 20),
              Expanded(
                child: Observer(builder: (_) {
                  // if (store.selectedBook != null) {
                  //   store.loading = false;
                  //   // return BookViewPage(
                  //   //   book: store.selectedBook!,
                  //   //   // controller: store,
                  //   // );
                  // }
                  if (store.loading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (store.listBooks.isEmpty) {
                    return const Center(
                      child: AppText(
                        text: 'Nenhum material encontrado',
                        fontSize: AppFontSize.fz08,
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: store.listBooks.length,
                    itemBuilder: (context, index) {
                      var book = store.listBooks[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: InkWell(
                          onTap: () {
                            // store.setSelectedBook(book);
                            Navigator.of(context).pop();
                            Modular.to.pushNamed(
                              '/home/books/${book.id}',
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.lightGrey),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // IMAGEM
                                Container(
                                  height: 150,
                                  width: 100,
                                  child: AccessibleNetworkImageZoom(
                                    imageUrl: book.coverImage,
                                    altText: 'Capa do livro ${book.title}',
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Center(
                                        child: Icon(Icons.error),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(width: 20),
                                // TITULO
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 400,
                                        child: AppText(
                                          text: book.title,
                                          fontWeight: 'bold',
                                          fontSize: AppFontSize.fz07,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      // AUTOR
                                      SizedBox(
                                        width: 200,
                                        child: AppText(
                                          text: book.author.isNotEmpty
                                              ? book.author.length > 1
                                                  ? 'de ${book.author[0]} e outros'
                                                  : 'de ${book.author[0]}'
                                              : 'Autor desconhecido',
                                          fontSize: AppFontSize.fz06,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      // EDITORA
                                      // SizedBox(
                                      //   width: 200,
                                      //   child: AppText(
                                      //     text: book.publisher,
                                      //     fontSize: AppFontSize.fz06,
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ),
                                // BOTÃO DE EXCLUIR
                                IconButton(
                                  icon: Icon(Icons.delete,
                                      color: AppColors.lightGrey),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('${book.title}'),
                                          content: Text(
                                              'Você deseja remover este item da lista?'),
                                          actions: <Widget>[
                                            TextButton(
                                              style: TextButton.styleFrom(
                                                foregroundColor: Colors.black,
                                              ),
                                              child: Text('Cancelar'),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            TextButton(
                                              style: TextButton.styleFrom(
                                                foregroundColor: Colors.red,
                                              ),
                                              child: const Text('Remover'),
                                              onPressed: () async {
                                                try {
                                                  print(
                                                      'id: ${book.id}, listId: ${store.readingList[widget.listId]['id']}');
                                                  await store
                                                      .removeItemFromList(
                                                    id: book.id,
                                                    idList: store.readingList[
                                                        widget.listId]['id'],
                                                  );
                                                  if (mounted) {
                                                    setState(() {
                                                      store.listBooks
                                                          .removeAt(index);
                                                    });
                                                    Navigator.of(context).pop();
                                                  }
                                                } catch (e) {
                                                  debugPrint(
                                                      'Erro ao remover item: $e');
                                                }
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
