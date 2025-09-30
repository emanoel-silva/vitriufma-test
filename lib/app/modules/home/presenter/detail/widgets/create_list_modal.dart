import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:vitrine_ufma/app/core/components/bottom_button.dart';
import 'package:vitrine_ufma/app/core/components/rounded_input_field.dart';
import 'package:vitrine_ufma/app/core/components/text.dart';
import 'package:vitrine_ufma/app/core/constants/colors.dart';
import 'package:vitrine_ufma/app/core/constants/const.dart';
import 'package:vitrine_ufma/app/core/constants/fonts_sizes.dart';
import 'package:vitrine_ufma/app/core/utils/functions.dart';
import 'package:vitrine_ufma/app/modules/home/presenter/detail/detail_store.dart';

class CreateListModal extends StatelessWidget {
  final int bookId;
  const CreateListModal({super.key, required this.bookId});

  @override
  Widget build(BuildContext context) {
    final DetailStore store = Modular.get<DetailStore>();

    return Scaffold(
      backgroundColor: AppColors.black.withOpacity(0.5),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(
            maxHeight: 350,
            maxWidth: 350,
          ),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.all(AppConst.sidePadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const AppText(
                    text: 'Criar Nova Lista',
                    fontSize: AppFontSize.fz14,
                    fontWeight: 'bold',
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
              const SizedBox(height: 20),
              RoundedInputField(
                hintText: 'Titulo',
                controller: store.listNameController,
                onChanged: (value) {},
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const AppText(
                    text: 'Visibilidade',
                    fontSize: AppFontSize.fz07,
                    fontWeight: 'bold',
                  ),
                  PopupMenuButton<void Function()>(
                      color: AppColors.white,
                      iconColor: AppColors.white,
                      padding: EdgeInsets.zero,
                      tooltip: "",
                      shadowColor: AppColors.black.withOpacity(0.3),
                      splashRadius: 5,
                      surfaceTintColor: AppColors.white,
                      icon: Container(
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppColors.black.withOpacity(0.3),
                          ),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: AppConst.sidePadding,
                          vertical: 10,
                        ),
                        child: Observer(builder: (context) {
                          return AppText(
                            text: store.public ? "Público" : "Privado",
                            fontSize: AppFontSize.fz07,
                            fontWeight: 'bold',
                            color: Colors.black,
                          );
                        }),
                      ),
                      onSelected: (value) => value(),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8.0),
                        ),
                      ),
                      itemBuilder: (_) => [
                            PopupMenuItem(
                              value: () {
                                store.setPublic(true);
                              },
                              child: const AppText(
                                text: "Público",
                                fontSize: 16,
                                fontWeight: 'bold',
                                color: Colors.black,
                              ),
                            ),
                            PopupMenuItem(
                              value: () {
                                store.setPublic(false);
                              },
                              child: const AppText(
                                text: "Privado",
                                fontSize: 16,
                                fontWeight: 'bold',
                                color: Colors.black,
                              ),
                            ),
                          ]),
                ],
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () {
                      if (store.listNameController.text.isEmpty) {
                        showSnackbarError('O campo nome é obrigatório');
                        return;
                      }
                      store.createListInfoMat(
                        name: store.listNameController.text,
                        public: store.public,
                        ids: [bookId],
                      );

                      Navigator.pop(context);
                    },
                    child: BottomButton(
                      backgroundColor: AppColors.wine,
                      label: 'Criar Lista',
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
