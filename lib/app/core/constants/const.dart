import 'package:hive/hive.dart';

class AppConst {
  AppConst._privateConstructor();

  static final AppConst _instance = AppConst._privateConstructor();

  factory AppConst() {
    return _instance;
  }
  static const String appName = "Vitrine UFMA";
  static const double imageH = 18;
  static const String API_URL = "https://infomatviewer-9e8d.onrender.com";
  static const String CLIENT_ID_GOOGLE ="428305704417-thbe459vht3ncepo5rj436545he5j704.apps.googleusercontent.com";
  static double sidePadding = 20;
  static double sideWindowWidth = 450;
  static double maxContainerWidth = 1080;
  static double maxContainerMobileWidth = 375;
  static double sideMargin = 30;
  //Input's height and padding bottom
  static double inputHeight = 40;
  static double inputPaddingBottom = 8;
  static double dropDownPaddingBottom = 9;

  static double borderRadius = 15;
  static double borderRadiusSmall = 10;
  static double borderRadiusModal = 20;
  static String getDefaultStorage() {
    var boxData = Hive.box("data");
    var appData = Map<String, dynamic>.from(boxData.get("appData") ?? {});
    return appData["storage"] ?? "https://storage.googleapis.com/core_apps/";
  }

  static String getFullName() {
    var boxData = Hive.box("data");
    var appData = Map<String, dynamic>.from(boxData.get("appData") ?? {});
    var userData = Map<String, dynamic>.from(appData["user"] ?? {});
    return userData["name"] ?? "Teste";
  }

  static Map getDefaultPermissions() {
    var boxData = Hive.box("data");
    var appData = Map<String, dynamic>.from(boxData.get("appData") ?? {});
    return appData["permission"] ?? {};
  }
}
