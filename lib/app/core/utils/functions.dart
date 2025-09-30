import 'package:vitrine_ufma/app/app_widget_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

String? formatMoney(String value) {
  return double.parse(value).toStringAsFixed(2);
}

double getMoneyInValue(String money) {
  return double.tryParse(money.replaceAll(".", "").replaceAll(",", ".")) ?? 0.0;
}

showSnackbarError(String text) async {
  AppWidgetStore app = Modular.get<AppWidgetStore>();
  ScaffoldMessenger.of(app.appContext!).removeCurrentSnackBar();
  // NotificationService.showNotification(app.appContext!, text, null, null);

  ScaffoldMessenger.of(app.appContext!).showSnackBar(
    SnackBar(
      content: Text(text),
      backgroundColor: Colors.red,
    ),
  );
}

showSnackbarSuccess(String text) async {
  AppWidgetStore app = Modular.get<AppWidgetStore>();
  ScaffoldMessenger.of(app.appContext!).removeCurrentSnackBar();
  // NotificationService.showNotification(
  //   app.appContext!,
  //   text,
  //   'check.svg',
  //   Colors.green,
  // );

  ScaffoldMessenger.of(app.appContext!).showSnackBar(
    SnackBar(
      content: Text(text),
      backgroundColor: Colors.green,
    ),
  );
}

List<Map<String, dynamic>> convertDynamicList(List<dynamic> dynamicList) {
  List<Map<String, dynamic>> convertedList = [];

  for (var item in dynamicList) {
    if (item is Map<String, dynamic>) {
      convertedList.add(item);
    } else {
      // Handle the case if the item is not a Map<String, dynamic>
      // For example, you can convert it to a map with a single key-value pair
      // or skip it depending on your requirement.
    }
  }

  return convertedList;
}
