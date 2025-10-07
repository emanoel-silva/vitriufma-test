import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:vitrine_ufma/app/core/components/footer.dart';
import 'package:vitrine_ufma/app/core/components/text.dart';
import 'package:vitrine_ufma/app/core/components/enhanced_keyboard_navigation.dart';
import 'package:vitrine_ufma/app/core/constants/colors.dart';
import 'package:vitrine_ufma/app/core/constants/const.dart';
import 'package:vitrine_ufma/app/core/constants/fonts_sizes.dart';
import 'package:vitrine_ufma/app/core/service/local_storage/i_local_storage.dart';
import 'package:vitrine_ufma/app/core/store/auth/auth_store.dart';
import 'package:vitrine_ufma/app/core/utils/screen_helper.dart';
import 'package:universal_platform/universal_platform.dart';

class AcessibilitiesPage extends StatefulWidget {
  const AcessibilitiesPage({super.key});

  @override
  State<AcessibilitiesPage> createState() => _AcessibilitiesPageState();
}

class _AcessibilitiesPageState extends State<AcessibilitiesPage> {
  late AuthStore controller;
  late ILocalStorage storage;
  late Map boxData;
  late bool isLogged = false;
  @override
  void initState() {
    super.initState();

    storage = Modular.get<ILocalStorage>();
    boxData = storage.getKeyData(boxKey: 'data', dataKey: 'loggedUser');
    isLogged = ((boxData["id"] ?? '')).isNotEmpty;
  }

  void _testVLibras() {
    if (UniversalPlatform.isWeb) {
      // Usar o helper apenas no web
      // VLibrasHelper.toggle();
      
      // Removido a mensagem informativa para evitar notificações
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text('Procure pelo ícone azul do VLibras no canto da tela para ativar a tradução em Libras!'),
      //     duration: Duration(seconds: 4),
      //     action: SnackBarAction(
      //       label: 'OK',
      //       onPressed: () {
      //         ScaffoldMessenger.of(context).hideCurrentSnackBar();
      //       },
      //     ),
      //   ),
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isWeb = ScreenHelper.isDesktopOrWeb;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      body: EnhancedKeyboardNavigation(
        child: Column(
          children: [
             Padding(
              padding: EdgeInsets.symmetric(
                horizontal:
                    isWeb ? AppConst.sidePadding * 2 : AppConst.sidePadding,
                vertical: AppConst.sidePadding,
              ),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.backgroundGrey,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      height: 100,
                      width: width,
                      child: const Center(
                          child: AppText(
                        text: 'Acessibilidade',
                        fontSize: AppFontSize.fz10,
                        fontWeight: 'bold',
                        color: Colors.black,
                      )),
                    ),
                    const SizedBox(height: 30),
                    const AppText(
                      textAlign: TextAlign.justify,
                      text:
                          'A Estante Visual da Biblioteca de Pinheiro se preocupa em oferecer uma experiência acessível e inclusiva para todos os usuários, levando em consideração suas necessidades individuais. Por isso, foram implementados recursos que tornam a plataforma mais acessível, como a possibilidade dos textos presentes na página serem lidos por leitores de tela e dicas de como melhorar a acessibilidade para os usuários.',
                      maxLines: 10,
                      fontSize: AppFontSize.fz05,
                    ),
                    const SizedBox(height: 10),
                    const AppText(
                      textAlign: TextAlign.justify,
                      text:
                          'O VLibras é uma ferramenta incrível que traduz o conteúdo em texto para a Língua Brasileira de Sinais (Libras), permitindo que pessoas com deficiência auditiva tenham acesso ao conteúdo da Estante Visual.',
                      fontSize: AppFontSize.fz05,
                      maxLines: 10,
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                            text: '✓ VLibras Integrado',
                            fontSize: AppFontSize.fz06,
                            fontWeight: 'bold',
                            color: Colors.blue.shade700,
                          ),
                          SizedBox(height: 8),
                          AppText(
                            text: 'O VLibras já está ativo na Estante Visual! Procure pelo ícone azul no canto inferior direito da tela para ativar a tradução em Libras.',
                            fontSize: AppFontSize.fz05,
                            maxLines: 3,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    // Botão de teste do VLibras
                    if (UniversalPlatform.isWeb)
                      Container(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // Implementar teste do VLibras
                            _testVLibras();
                          },
                          icon: Icon(Icons.accessibility_new),
                          label: Text('Testar VLibras'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade600,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    if (UniversalPlatform.isWeb)
                      const SizedBox(height: 15),
                    const AppText(
                      textAlign: TextAlign.justify,
                      text:
                          'Para usar o VLibras na Estante Visual, basta clicar no ícone azul que aparece no canto da tela. O sistema irá traduzir automaticamente o conteúdo em texto para a Língua Brasileira de Sinais.',
                      fontSize: AppFontSize.fz05,
                      maxLines: 10,
                    ),
                    const SizedBox(height: 10),
                    const AppText(
                      textAlign: TextAlign.justify,
                      text:
                          'Caso não consiga visualizar o ícone do VLibras, recarregue a página ou limpe o cache do navegador. O sistema funciona melhor nos navegadores Chrome, Firefox e Edge atualizados.',
                      fontSize: AppFontSize.fz05,
                      maxLines: 10,
                    ),
                    const SizedBox(height: 10),
                    const AppText(
                      textAlign: TextAlign.justify,
                      text:
                          'Já o Leitor de Tela é uma tecnologia assistiva que transforma o conteúdo visual em áudio, permitindo que pessoas com deficiência visual possam ouvir as informações apresentadas na Estante Visual. É só garantir que o Leitor de Tela esteja ativado em seu dispositivo, e ele irá identificar automaticamente o conteúdo da página, permitindo que você navegue e ouça o que está sendo exibido.',
                      fontSize: AppFontSize.fz05,
                      maxLines: 10,
                    ),
                    const SizedBox(height: 10),
                    const AppText(
                      textAlign: TextAlign.justify,
                      text:
                          'Nosso objetivo é tornar a experiência na Estante Visual o mais inclusiva e agradável possível para todos os usuários. É de extrema importância garantir que você tenha todas as ferramentas necessárias para explorar o conteúdo e aproveitar ao máximo a plataforma.',
                      fontSize: AppFontSize.fz05,
                      maxLines: 10,
                    )
                  ]),
            ),
            const SizedBox(height: 100),
            const FooterVitrine()
          ],
        ),
      ),
    );
  }
}