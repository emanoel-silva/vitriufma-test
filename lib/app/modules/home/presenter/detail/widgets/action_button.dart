import 'package:flutter/material.dart';
import 'package:vitrine_ufma/app/core/components/text_widget.dart';
import 'package:vitrine_ufma/app/core/constants/colors.dart';

class ActionButton extends StatelessWidget {
  final String text;
  final Function()? onTap;
  const ActionButton({
    super.key,
    required this.text,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.yellow,
          borderRadius: BorderRadius.circular(5),
        ),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: TextWidget(
          text: text,
          fontSize: 16,
          color: AppColors.black,
        ),
      ),
    );
  }
}
