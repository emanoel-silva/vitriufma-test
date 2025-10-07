import 'package:flutter_modular/flutter_modular.dart';
import 'package:vitrine_ufma/app/modules/home/presenter/accessible_test_page.dart';

class AccessibleTestModule extends Module {
  @override
  void binds(i) {
    // Bindings específicos do módulo de teste acessível, se necessário
  }

  @override
  void routes(r) {
    // Rota principal para a página de teste acessível
    r.child('/', child: (context) => const AccessibleTestPage());
  }
}