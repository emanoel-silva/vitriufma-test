import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:vitrine_ufma/app/core/components/custom_textfield.dart';
import 'package:vitrine_ufma/app/core/components/image_asset.dart';
import 'package:vitrine_ufma/app/core/components/text.dart';
import 'package:vitrine_ufma/app/core/constants/colors.dart';
import 'package:vitrine_ufma/app/core/constants/const.dart';
import 'package:vitrine_ufma/app/modules/home/presenter/search/search_store.dart';

class SearchModal extends StatelessWidget {
  SearchStore store = Modular.get<SearchStore>();
  final bool expanded;
  SearchModal({super.key, this.expanded = true});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: expanded ? 250 : 150,
          width: MediaQuery.of(context).size.width,
          child: const AppImageAsset(
            image: "home.jpeg",
            fit: BoxFit.cover,
            altText: 'Imagem de fundo da página inicial',
          ),
        ),
        Container(
            height: expanded ? 250 : 150,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 20),
            child: Wrap(
              spacing: 20,
              runSpacing: 20,
              alignment: WrapAlignment.center,
              runAlignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.end,
              children: [
                //Input de pesquisa
                SizedBox(
                  width: 400,
                  child: CustomTextField(
                    controller: store.searchController,
                    onTap: () async {
                      await store.searchWithFilters();
                    },
                  ),
                ),

                //filtro de busca dropdown
                Observer(builder: (context) {
                  return PopupMenuButton<void Function()>(
                      color: AppColors.white,
                      iconColor: AppColors.white,
                      padding: EdgeInsets.zero,
                      tooltip: "",
                      shadowColor: AppColors.black.withOpacity(0.3),
                      splashRadius: 5,
                      surfaceTintColor: AppColors.white,
                      icon: Container(
                        width: 160,
                        padding: EdgeInsets.symmetric(
                            horizontal: AppConst.sidePadding, vertical: 10),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Center(
                          child: AppText(
                            text: "${store.filter['name']}",
                            fontSize: 14,
                          ),
                        ),
                      ),
                      onSelected: (value) => value(),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8.0),
                        ),
                      ),
                      itemBuilder: (_) => [
                            for (var filter in store.filters)
                              PopupMenuItem(
                                value: () {
                                  store.applyFilter(filter);
                                },
                                child: AppText(
                                  text: filter['name'],
                                  fontSize: 14,
                                ),
                              ),
                          ]);
                }),

                //Busca avançada
                InkWell(
                  onTap: () {
                    Modular.to.pushNamed('search');
                  },
                  child: Container(
                    height: 40,
                    width: 160,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Center(
                      child: AppText(
                        text: "Busca Avançada",
                        fontSize: 14,
                        fontWeight: 'bold',
                      ),
                    ),
                  ),
                ),
              ],
            )),
      ],
    );
  }
}
