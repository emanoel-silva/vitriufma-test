import 'package:flutter/material.dart';
import 'package:vitrine_ufma/app/core/constants/colors.dart';

class CustomTextField extends StatelessWidget {
  TextEditingController? controller;
  Function()? onTap;
  bool icon;
  TextInputType? keyBoardType;
  String? hint;
  int maxLines;
  double? height;
  CustomTextField({
    super.key,
    this.controller,
    this.keyBoardType,
    this.onTap,
    this.maxLines = 1,
    this.height,
    this.icon = true,
    this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      constraints: BoxConstraints(maxWidth: 600, minWidth: 300),
      child: Container(
        height: height ?? 40,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        child: TextFormField(
          focusNode: FocusNode(),
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyBoardType,
          decoration: InputDecoration(
            hintText: hint ?? "Pesquisar",
            border: InputBorder.none,
            hintStyle: const TextStyle(color: AppColors.lightGrey),
            suffixIcon: icon
                ? InkWell(
                    onTap: () {
                      if (controller!.text.length > 4) {
                        onTap!();
                      }
                    },
                    child: const Icon(Icons.search))
                : null,
          ),
          onFieldSubmitted: (value) {
            if (value.length > 4) {
              onTap!();
            }
          },
          onEditingComplete: () {
            
              onTap!();

          },
        ),
      ),
    );
  }
}
