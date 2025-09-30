import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:vitrine_ufma/app/core/components/bottom_button.dart';
import 'package:vitrine_ufma/app/core/components/error_card.dart';
import 'package:vitrine_ufma/app/core/components/text.dart';
import 'package:vitrine_ufma/app/core/constants/colors.dart';
import 'package:vitrine_ufma/app/core/constants/const.dart';
import 'package:vitrine_ufma/app/core/constants/fonts_sizes.dart';
import 'package:vitrine_ufma/app/core/utils/functions.dart';
import 'package:vitrine_ufma/app/modules/home/presenter/detail/detail_store.dart';

class AddToListModal extends StatefulWidget {
  final int bookId;
  const AddToListModal({super.key, required this.bookId});

  @override
  State<AddToListModal> createState() => _AddToListModalState();
}

class _AddToListModalState extends State<AddToListModal> {
  late DetailStore store;
  @override
  void initState() {
    super.initState();
    store = Modular.get<DetailStore>();

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      store.getMaterialList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black.withOpacity(0.5),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(
            maxHeight: 600,
            maxWidth: 600,
          ),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.all(AppConst.sidePadding),
          child: SingleChildScrollView(
            // Adicionado para permitir rolagem
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const AppText(
                      text: 'Selecione uma lista',
                      fontSize: AppFontSize.fz14,
                      fontWeight: 'bold',
                    ),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                //TODO: Mostar as listas do usuário
                Observer(builder: (_) {
                  if (store.loading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (store.readingList.isEmpty) {
                    return const Center(
                      child: AppText(
                        text: 'Nenhuma lista encontrada',
                        fontSize: AppFontSize.fz08,
                      ),
                    );
                  }

                  return Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.cutGrey, width: 0.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.all(10),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics:
                          NeverScrollableScrollPhysics(), // Desativa a rolagem interna do ListView
                      itemCount: store.readingList.length,
                      itemBuilder: (context, index) {
                        // Pular a lista com o nome específico
                        if (store.readingList[index]['name'] ==
                            'aee20c6a981fe6633c17340037ebb6472f1d8eb9') {
                          return SizedBox.shrink();
                        }

                        return Column(
                          children: [
                            InkWell(
                              onTap: () async {
                                await store.getMaterialList();

                                // Verificar se o material já está na lista antes de adicionar
                                var booksIdsInList = store.readingList[index]
                                        ['listInfoMats']
                                    .map((e) => e['id'])
                                    .toList();
                                if (booksIdsInList.contains(widget.bookId)) {
                                  showSnackbarError(
                                      "Este material já está na lista ${store.readingList[index]['name']}");
                                  return;
                                } else {
                                  store.addItemsToList(
                                      id: widget.bookId,
                                      idList: store.readingList[index]['id']);
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: EdgeInsets.all(10),
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    //IMAGEM
                                    if (store.readingList[index]['listInfoMats']
                                        .isNotEmpty) ...[
                                      Container(
                                        height: 100,
                                        width: 100,
                                        child: Image.network(
                                          store.readingList[index]
                                                  ['listInfoMats'][0]
                                              ['cover_image'],
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
                                    //TITULO
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          AppText(
                                            text: store.readingList[index]
                                                    ?['name'] ??
                                                'No Name',
                                            fontWeight: 'bold',
                                            fontSize: AppFontSize.fz07,
                                          ),
                                          const SizedBox(height: 10),
                                          //QUANTIDADE DE MATERIAIS
                                          AppText(
                                            text:
                                                'Materiais: ${store.readingList[index]?['listInfoMats']?.length ?? 0}',
                                            fontSize: AppFontSize.fz06,
                                          ),
                                          const SizedBox(height: 10),
                                          //VISIBILIDADE
                                          AppText(
                                            text: store.readingList[index]
                                                        ?['observable'] ==
                                                    true
                                                ? 'Pública'
                                                : 'Privada',
                                            fontSize: AppFontSize.fz06,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            if (index < store.readingList.length - 1)
                              Divider(
                                color: AppColors.cutGrey,
                                thickness: 1,
                              ),
                          ],
                        );
                      },
                    ),
                  );
                }),

                const SizedBox(height: 20),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.end,
                //   children: [
                //     InkWell(
                //       onTap: () {
                //         //TODO: Adicionar a lista na API pelo ID

                //         Navigator.pop(context);
                //       },
                //       child: BottomButton(
                //         backgroundColor: AppColors.yellow,
                //         label: 'Adicionar',
                //       ),
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
