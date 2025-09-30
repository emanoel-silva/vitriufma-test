import 'package:flutter/material.dart';
import 'package:vitrine_ufma/app/core/components/svg_asset.dart';
import 'package:vitrine_ufma/app/core/components/text.dart';
import 'package:vitrine_ufma/app/core/constants/colors.dart';
import 'package:vitrine_ufma/app/core/constants/fonts_sizes.dart';

class ErrorCard extends StatelessWidget {
  final String errorMessage;
  const ErrorCard({super.key, required this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
        color: AppColors.white,
      ),
      child: ClipRRect(
        clipBehavior: Clip.hardEdge,
        borderRadius: BorderRadius.circular(5),
        child: Container(
          width: 330,
          alignment: Alignment.topCenter,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          decoration: const BoxDecoration(
            color: AppColors.white,
            border: Border(
              bottom: BorderSide(
                color: AppColors.normalRed,
                width: 3,
              ),
            ),
          ),
          child: Row(
            children: [
              const AppSvgAsset(
                image: "exclamation.svg",
                imageH: 22,
                color: AppColors.black,
              ),
              const SizedBox(
                width: 10,
              ),
              SizedBox(
                width: 250,
                child: AppText(
                  text:
                      errorMessage, //'Não encontramos nenhum CEP com esse \nnúmero. Por favor, verifique se o número \nestá correto.',
                  fontSize: AppFontSize.fz04,
                  maxLines: 3,
                  color: AppColors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
