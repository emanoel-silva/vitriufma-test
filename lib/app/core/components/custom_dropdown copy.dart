import 'package:flutter/material.dart';

class CustomDropDown extends StatelessWidget {
  final String title;
  final double? width;
  List<DropdownMenuItem<String>>? itemsList = [];
  final Function(String?)? onChanged;
  CustomDropDown({
    super.key,
    required this.title,
    this.width,
    this.itemsList,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: width?? 200,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: DropdownButton(
        isExpanded: true,
        value: title,
        underline: Container(),
        onChanged: onChanged,
        items: itemsList,
      ),
    );
  }
}
