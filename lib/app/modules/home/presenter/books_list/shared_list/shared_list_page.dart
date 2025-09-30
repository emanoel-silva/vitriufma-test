import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:vitrine_ufma/app/core/components/text.dart';
import 'package:vitrine_ufma/app/core/constants/colors.dart';
import 'package:vitrine_ufma/app/core/constants/const.dart';
import 'package:vitrine_ufma/app/core/constants/fonts_sizes.dart';
import 'package:vitrine_ufma/app/modules/home/presenter/books_list/reading_list/reading_list_store.dart';

class SharedListPage extends StatefulWidget {
  const SharedListPage({
    super.key,
  });

  @override
  State<SharedListPage> createState() => _SharedListPageState();
}

class _SharedListPageState extends State<SharedListPage> {
  late ReadingListStore store;
  late int listId;
  
  @override
  void initState() {
    super.initState();
    store = Modular.get<ReadingListStore>();
    listId = int.parse(Modular.args.params['id']);
    print('listId: $listId');
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await store.getMaterialList();
      await store.getMaterialFromList(listId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Center(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: AppConst.maxContainerWidth
          ),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.all(AppConst.sidePadding),
          child: Observer(
            builder: (context) {
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
              return Column(
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    AppText(
                      text: store.readingList[listId]?['name'] ==
                              'aee20c6a981fe6633c17340037ebb6472f1d8eb9'
                          ? 'Favoritos'
                          : store.readingList[listId]?['name'] ?? 'No name',
                      fontSize: AppFontSize.fz14,
                      fontWeight: 'bold',
                    ),
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
                                      child: Image.network(
                                        book.coverImage,
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
                                    ),],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }),
                  ),
                ],
              );
            }
          ),
        ),
      ),
    );
  }
}
