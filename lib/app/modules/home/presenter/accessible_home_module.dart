import 'package:flutter_modular/flutter_modular.dart';
import 'package:vitrine_ufma/app/modules/home/presenter/accessible_home_page.dart';

class AccessibleHomeModule extends Module {
  @override
  void binds(i) {
    // Bindings específicos do módulo acessível, se necessário
  }

  @override
  void routes(r) {
    // Rota principal para a página inicial acessível
    r.child('/', child: (context) => const AccessibleHomePage());
    
    // Rotas adicionais podem ser adicionadas aqui
  }
}