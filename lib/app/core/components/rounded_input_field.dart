import 'package:flutter/material.dart';
import '../constants/colors.dart';

class RoundedInputField extends StatelessWidget {
  final String hintText;
  final IconData? icon;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback? onTap;
  final bool obscure;

  RoundedInputField(
      {super.key,
      required this.hintText,
      this.icon,
      required this.controller,
      this.obscure = false,
      this.onTap,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(vertical: 10),
      width: size.width,
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.backgroundGrey,
        borderRadius: BorderRadius.circular(5),
      ),
      child: TextField(
        onTap: onTap,
        onChanged: (value) {},
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
            icon: icon != null
                ? Icon(
                    icon,
                    color: AppColors.cutGrey,
                  )
                : null,
            hintText: hintText,
            hintStyle: TextStyle(color: AppColors.cutGrey),
            border: InputBorder.none),
      ),
    );
  }
}
