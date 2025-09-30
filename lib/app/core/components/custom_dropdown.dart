import 'package:flutter/material.dart';
import 'package:vitrine_ufma/app/core/components/svg_asset.dart';
import 'package:vitrine_ufma/app/core/theme/them_custom.dart';

class CustomDropDown extends StatelessWidget {
  final String title;
  final Widget? icon;
  final double? width;
  List<DropdownMenuItem<String>>? itemsList = [];
  final Function(String?)? onChanged;
  CustomDropDown({
    super.key,
    required this.title,
    this.icon,
    this.width,
    this.itemsList,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).extension<ThemeCustom>()!;
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: theme.backgroundColor,
      ),
      child: DropdownButton(
        isExpanded: true,
        icon: icon,
        value: title,
        underline: Container(),
        onChanged: onChanged,
        items: itemsList,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
