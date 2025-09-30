import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:hive/hive.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:path_provider/path_provider.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:vitrine_ufma/firebase_options.dart';
import 'app/app_module.dart';
import 'app/app_widget.dart';

// Import condicional do VLibras helper
import 'app/core/utils/vlibras_helper_stub.dart' if (dart.library.html) 'app/core/utils/vlibras_helper.dart';

void main() async {
  initializeDateFormatting();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.web);
  
  // Inicializa VLibras para web
  if (UniversalPlatform.isWeb) {
    VLibrasHelper.configureAccessibility();
    // Delay para garantir que o DOM esteja pronto
    Future.delayed(Duration(milliseconds: 1000), () {
      VLibrasHelper.initialize();
      // Debug após inicialização
      Future.delayed(Duration(milliseconds: 2000), () {
        VLibrasHelper.debug();
      });
    });
  }
  
  if (!UniversalPlatform.isWeb) {
    var path = await getApplicationSupportDirectory();
    Hive.init(
      path.path,
    ); //TODO QUANDO FOR AUTERADO O BANCO DE D ADOS TROCAR AQUI, OU REMOVER
  }
  // if (isDesktop()) {
  try {
    await Future.wait([
      Hive.openBox(
        "data",
        // encryptionCipher: HiveAesCipher(encryptionKey),
      ),
    ]);
  } catch (e) {
    exit(1);
  }
  // }

  runApp(
    ModularApp(
      module: AppModule(),
      child: const AppWidget(),
    ),
  );
}
