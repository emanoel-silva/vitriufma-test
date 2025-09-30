import 'package:flutter/material.dart';
import 'package:vitrine_ufma/app/core/components/text.dart';
import 'package:vitrine_ufma/app/core/constants/colors.dart';

class FooterVitrine extends StatelessWidget {
  const FooterVitrine({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
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
