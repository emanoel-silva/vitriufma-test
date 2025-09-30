import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:vitrine_ufma/app/core/components/book_card.dart';
import 'package:vitrine_ufma/app/core/components/footer.dart';
import 'package:vitrine_ufma/app/core/components/text.dart';
import 'package:vitrine_ufma/app/core/constants/colors.dart';
import 'package:vitrine_ufma/app/core/constants/fonts_sizes.dart';
import 'package:vitrine_ufma/app/core/service/local_storage/i_local_storage.dart';
import 'package:vitrine_ufma/app/modules/home/presenter/books_list/reading_list/reading_list_store.dart';
import 'package:vitrine_ufma/app/modules/home/presenter/search/simple_search/search_modal.dart';

class FavoritesListPage extends StatefulWidget {
  FavoritesListPage({super.key});

  @override
  State<FavoritesListPage> createState() => _FavoritesListPageState();
}

class _FavoritesListPageState extends State<FavoritesListPage> {
  late ReadingListStore store;
  int? favoriteListIndex;
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

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) async {
      await store.getMaterialList();

      try {
        favoriteListIndex = store.readingList.indexWhere(
          (list) => list['name'] == 'aee20c6a981fe6633c17340037ebb6472f1d8eb9',
        );

        if (favoriteListIndex != -1) {
          await store
              .getMaterialFromList(store.readingList[favoriteListIndex!]['id']);
        } else {
          favoriteListIndex = null;
        }
      } catch (e) {
        print('Erro ao buscar lista de favoritos: $e');
      }

      store.getMaterialFromList(favoriteListIndex ?? 0);
      if (mounted) {
        setState(() {});
      }
    });
  }

 @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.white,
    body: CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child:  SearchModal(expanded: false)),
        SliverToBoxAdapter(child: _backButton()),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(left: 70, right: 70, bottom: 20),
            child: const AppText(
              fontWeight: 'bold',
              fontSize: AppFontSize.fz07,
              text: 'Sua lista de favoritos',
              textAlign: TextAlign.left,
            ),
          ),
        ),
        Observer(builder: (_) {
          if (store.loading) {
            return const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            );
          }

          if (favoriteListIndex == null || store.readingList.isEmpty) {
            return const SliverFillRemaining(
              child: Center(
                child: AppText(
                  text: 'Nenhuma lista de favoritos encontrada',
                  fontSize: AppFontSize.fz06,
                ),
              ),
            );
          }

          return SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 70),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return BookCard(book: store.listBooks[index]);
                },
                childCount: store.listBooks.length,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 20,
                mainAxisExtent: 265,
                mainAxisSpacing: 20,
                childAspectRatio: 0.65,
              ),
            ),
          );
        }),
        const SliverToBoxAdapter(child: SizedBox(height: 50)),
        const SliverToBoxAdapter(child: FooterVitrine()),
      ],
    ),
  );
}


  Widget _backButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 70, bottom: 20, top: 20),
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
