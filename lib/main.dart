import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:hive/hive.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:path_provider/path_provider.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:vitrine_ufma/firebase_options.dart';
import 'app/app_module.dart';
import 'app/app_widget.dart';

// Import condicional do helper do VLibras
import 'app/core/utils/vlibras_helper_stub.dart' if (dart.library.html) 'app/core/utils/vlibras_helper.dart';

// Import condicional do helper do NVDA
import 'app/core/utils/nvda_helper_stub.dart' if (dart.library.html) 'app/core/utils/nvda_helper.dart';

// Import do serviço de navegação por teclado
import 'app/core/services/keyboard_navigation_service.dart';

void main() async {
  initializeDateFormatting();
  WidgetsFlutterBinding.ensureInitialized();
  SemanticsBinding.instance.ensureSemantics();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.web);
  
  // Inicializa o VLibras para web
  if (UniversalPlatform.isWeb) {
    VLibrasHelper.configureAccessibility();
    // Atraso para garantir que o DOM esteja pronto
    Future.delayed(Duration(milliseconds: 1000), () {
      VLibrasHelper.initialize();
      // Depuração após inicialização
      Future.delayed(Duration(milliseconds: 2000), () {
        VLibrasHelper.debug();
      });
    });
    
    // Inicializa o serviço de navegação por teclado
    KeyboardNavigationService().initialize();
  }
  
  if (!UniversalPlatform.isWeb) {
    var path = await getApplicationSupportDirectory();
    Hive.init(
      path.path,
    ); //TODO QUANDO FOR ALTERADO O BANCO DE DADOS TROCAR AQUI, OU REMOVER
  }
  // if (isDesktop()) {
  try {
    await Future.wait([
      Hive.openBox(
        "data",
        // encryptionCipher: HiveAesCipher(chaveDeCriptografia),
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