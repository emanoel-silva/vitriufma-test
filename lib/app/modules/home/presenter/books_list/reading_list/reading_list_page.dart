import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:vitrine_ufma/app/core/components/accessible_network_image_zoom.dart';
import 'package:vitrine_ufma/app/core/components/footer.dart';
import 'package:vitrine_ufma/app/core/components/text.dart';
import 'package:vitrine_ufma/app/core/constants/colors.dart';
import 'package:vitrine_ufma/app/core/constants/fonts_sizes.dart';
import 'package:vitrine_ufma/app/core/service/local_storage/i_local_storage.dart';
import 'package:vitrine_ufma/app/modules/home/presenter/books_list/reading_list/reading_list_store.dart';
import 'package:vitrine_ufma/app/modules/home/presenter/books_list/widgets/lists_modal.dart';
import 'package:vitrine_ufma/app/modules/home/presenter/books_list/widgets/shared_modal.dart';
import 'package:vitrine_ufma/app/modules/home/presenter/search/simple_search/search_modal.dart';

class ReadingListPage extends StatefulWidget {
  ReadingListPage({super.key});

  @override
  State<ReadingListPage> createState() => _ReadingListPageState();
}

class _ReadingListPageState extends State<ReadingListPage> {
  late ReadingListStore store;
  bool isLogged = false;
  late ILocalStorage storage;
  late Map boxData;

  @override
  void initState() {
    super.initState();

    store = Modular.get<ReadingListStore>();
    storage = Modular.get<ILocalStorage>();
    boxData = storage.getKeyData(boxKey: 'data', dataKey: 'loggedUser');
    isLogged = ((boxData["id"] ?? '')).isNotEmpty;

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      try {
        await store.getMaterialList();
      } catch (e) {
        print('Error fetching material list: $e');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // HEADER
            SearchModal(
              expanded: false,
            ),

            _backButton(),
            // LISTA DE MATERIAIS
            Observer(builder: (_) {
              try {
                if (store.readingList.isEmpty) {
                  return Container(
                    height: height * 0.8,
                    child: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AppText(
                            text: 'Nenhuma lista de leitura encontrada',
                            fontSize: AppFontSize.fz06,
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 70,
                      // vertical: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            padding: const EdgeInsets.only(top: 20, bottom: 20),
                            width: MediaQuery.of(context).size.width,
                            child: const AppText(
                              fontWeight: 'bold',
                              fontSize: AppFontSize.fz07,
                              text: 'Suas listas de leitura',
                            ),
                          ),
                        ),
                        Center(
                          child: Column(
                            children: List.generate(store.readingList.length,
                                (index) {
                              // Pular a lista com o nome específico
                              if (store.readingList[index]['name'] ==
                                  'aee20c6a981fe6633c17340037ebb6472f1d8eb9') {
                                return SizedBox.shrink();
                              }

                              return Container(
                                padding: EdgeInsets.all(10),
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: AppColors.cutGrey,
                                    width: 0.5,
                                  ),
                                ),
                                margin: const EdgeInsets.only(bottom: 20),
                                child: Column(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                        vertical: 5,
                                      ),
                                      child: InkWell(
                                        onTap: () {
                                          try {
                                            showDialog(
                                              context: context,
                                              builder: (_) => ListModal(
                                                listId: index,
                                                store: store,
                                              ),
                                            );
                                          } catch (e) {
                                            print(
                                              'Error in reading list page: $e',
                                            );
                                          }
                                        },
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // IMAGEM
                                            if (store
                                                .readingList[index]
                                                    ['listInfoMats']
                                                .isNotEmpty) ...[
                                              Container(
                                                height: 100,
                                                width: 100,
                                                child: AccessibleNetworkImageZoom(
                                                  imageUrl: store.readingList[index]
                                                          ['listInfoMats'][0]
                                                      ['cover_image'],
                                                  altText: 'Capa do material',
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ] else ...[
                                              Container(
                                                height: 100,
                                                width: 100,
                                                color: Colors
                                                    .grey, // Placeholder for missing image
                                                child: const Center(
                                                  child: Text('No Image'),
                                                ),
                                              ),
                                            ],
                                            const SizedBox(width: 20),
                                            // TÍTULO
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  if (store.readingList
                                                          .isNotEmpty &&
                                                      index <
                                                          store.readingList
                                                              .length) ...[
                                                    // VISIBILIDADE
                                                    AppText(
                                                      text: store.readingList[
                                                                      index]
                                                                  ?['name'] ==
                                                              'aee20c6a981fe6633c17340037ebb6472f1d8eb9'
                                                          ? 'Favoritos'
                                                          : store.readingList[
                                                                      index]
                                                                  ?['name'] ??
                                                              'No Name',
                                                      fontWeight: 'bold',
                                                    ),
                                                    const SizedBox(height: 10),
                                                    // QUANTIDADE DE MATERIAIS
                                                    AppText(
                                                      text:
                                                          'Materiais: *${store.readingList[index]?['listInfoMats']?.length ?? 0}*',
                                                      fontSize:
                                                          AppFontSize.fz06,
                                                    ),
                                                  ] else ...[
                                                    const AppText(
                                                      text:
                                                          'No materials available',
                                                      fontSize:
                                                          AppFontSize.fz06,
                                                    ),
                                                  ],
                                                ],
                                              ),
                                            ),
                                            // BOTÃO DE COMPARTILHAR
                                            IconButton(
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (_) => SharedModal(
                                                    listId: index,
                                                    store: store,
                                                  ),
                                                );
                                              },
                                              icon: const Icon(
                                                Icons.share,
                                                color: AppColors.lightGrey,
                                              ),
                                            ),

                                            const SizedBox(width: 20),
                                            // BOTÃO DE EXCLUIR
                                            IconButton(
                                              icon: const Icon(
                                                Icons.delete,
                                                color: AppColors.lightGrey,
                                              ),
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title: Text(
                                                        store.readingList[index]
                                                                    ?['name'] ==
                                                                'aee20c6a981fe6633c17340037ebb6472f1d8eb9'
                                                            ? 'Favoritos'
                                                            : store.readingList[
                                                                        index]
                                                                    ?['name'] ??
                                                                'No Name',
                                                      ),
                                                      content: const Text(
                                                          'Você deseja excluir esta lista?'),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          style: TextButton
                                                              .styleFrom(
                                                            foregroundColor:
                                                                Colors.black,
                                                          ),
                                                          child: const Text(
                                                              'Cancelar'),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        ),
                                                        TextButton(
                                                          style: TextButton
                                                              .styleFrom(
                                                            foregroundColor:
                                                                Colors.red,
                                                          ),
                                                          child: const Text(
                                                              'Excluir'),
                                                          onPressed: () async {
                                                            try {
                                                              await store.deleteListInfoMat(
                                                                  idList: store
                                                                          .readingList[
                                                                      index]['id']);
                                                              if (mounted) {
                                                                setState(() {
                                                                  store
                                                                      .readingList
                                                                      .removeAt(
                                                                          index);
                                                                });
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              }
                                                            } catch (e) {
                                                              debugPrint(
                                                                  e.toString());
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
                                    // if (index < store.readingList.length - 1)
                                    //   Divider(
                                    //     color: AppColors.cutGrey,
                                    //     thickness: 1,
                                    //   ),
                                  ],
                                ),
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              } catch (e) {
                print('Error in material list observer: $e');
                return Container();
              }
            }),
            const SizedBox(height: 50),
            const FooterVitrine(),
          ],
        ),
      ),
    );
  }

  Widget _backButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 70, bottom: 0, top: 20),
      child: Row(
        children: [
          InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.wine),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.arrow_back,
                      color: AppColors.wine,
                      size: 16,
                    ),
                    const SizedBox(width: 5),
                    AppText(
                      text: "Voltar",
                      fontSize: 12,
                      fontWeight: 'medium',
                      color: AppColors.wine,
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
