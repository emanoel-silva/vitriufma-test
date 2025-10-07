import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:panorama_viewer/panorama_viewer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vitrine_ufma/app/core/components/footer.dart';
import 'package:vitrine_ufma/app/core/components/image_asset.dart';
import 'package:vitrine_ufma/app/core/components/text.dart';
import 'package:vitrine_ufma/app/core/components/enhanced_keyboard_navigation.dart';
import 'package:vitrine_ufma/app/core/components/accessible_keyboard_button.dart';
import 'package:vitrine_ufma/app/core/constants/colors.dart';
import 'package:vitrine_ufma/app/core/constants/const.dart';
import 'package:vitrine_ufma/app/core/constants/fonts_sizes.dart';
import 'package:vitrine_ufma/app/core/service/local_storage/i_local_storage.dart';
import 'package:vitrine_ufma/app/core/utils/screen_helper.dart';

class AboutUsPage extends StatelessWidget {
  AboutUsPage({super.key});

  late ILocalStorage storage;
  late Map boxData;
  late bool isLogged = false;
  @override
  Widget build(BuildContext context) {
    storage = Modular.get<ILocalStorage>();
    boxData = storage.getKeyData(boxKey: 'data', dataKey: 'loggedUser');
    isLogged = ((boxData["id"] ?? '')).isNotEmpty;
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
                        text: 'Biblioteca de Pinheiro',
                        fontSize: AppFontSize.fz10,
                        fontWeight: 'bold',
                        color: Colors.black,
                      )),
                    ),
                    const SizedBox(height: 30),
                    const AppText(
                      textAlign: TextAlign.justify,
                      text: 'Quem somos',
                      fontSize: AppFontSize.fz07,
                      fontWeight: 'bold',
                    ),
                    const SizedBox(height: 10),
                    const AppText(
                      textAlign: TextAlign.justify,
                      text:
                          'A Biblioteca de Pinheiro compõe uma das bibliotecas da Diretoria Integrada de Bibliotecas (DIB) e pertence ao Centro de Ciências de Pinheiro (CCPI), da Universidade Federal do Maranhão (UFMA).',
                      maxLines: 10,
                      fontSize: AppFontSize.fz05,
                    ),
                    const SizedBox(height: 10),
                    const AppText(
                      textAlign: TextAlign.justify,
                      text:
                          'Localizada no prédio das Licenciaturas, Câmpus Pinheiro, ela possui um acervo formado, principalmente, por livros, periódicos, folhetos, materiais audiovisuais, publicações maranhenses e da UFMA. O conteúdo informacional de sua coleção abrange as áreas de conhecimento dos cursos presentes no câmpus, assim como algumas obras muldisciplinares',
                      fontSize: AppFontSize.fz05,
                      maxLines: 10,
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: width,
                      child: Wrap(
                        children: [
                          const AppText(
                            textAlign: TextAlign.justify,
                            text:
                                'O acervo é aberto ao público e pode ser consultado na barra de pesquisa, localizada na página inicial, ou por meio do catálogo on-line da ',
                            fontSize: AppFontSize.fz05,
                            maxLines: 10,
                          ),
                          InkWell(
                            onTap: () async {
                              if (!await launchUrl(Uri.parse(
                                  'https://sigaa.ufma.br/sigaa/public/biblioteca/buscaPublicaAcervo.jsf'))) {
                                throw Exception('Could not launch');
                              }
                              // https://sigaa.ufma.br/sigaa/public/biblioteca/buscaPublicaAcervo.jsf
                            },
                            child: const AppText(
                              text: 'UFMA',
                              color: AppColors.blueLink,
                              fontSize: AppFontSize.fz05,
                              maxLines: 10,
                            ),
                          ),
                          const AppText(
                            textAlign: TextAlign.justify,
                            text:
                                'Além disso, a comunidade acadêmica tem acesso ao acervo digital presente nas bases de dados, na Biblioteca Digital, nos Periódicos eletônicos da UFMA, na Target GEDWeb (Normas da ABNT e outros documentos regulatórios), nos livros eletrônicos e no Portal de Periódicos Capes na página da ',
                            fontSize: AppFontSize.fz05,
                            maxLines: 10,
                          ),
                          InkWell(
                            onTap: () async {
                              if (!await launchUrl(Uri.parse(
                                  'https://portais.ufma.br/PortalUnidade/dib/'))) {
                                throw Exception('Could not launch');
                              }
                            },
                            child: const AppText(
                              text: 'DIB',
                              fontSize: AppFontSize.fz05,
                              color: AppColors.blueLink,
                              maxLines: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    const AppText(
                      textAlign: TextAlign.justify,
                      text:
                          'A Biblioteca oferece um conjunto de serviços, realiza exposições temáticas e campanhas transversais com o objetivo de informar e conscientizar a comunidade acadêmica acerca de temas relevantes à sociedade.',
                      fontSize: AppFontSize.fz05,
                      maxLines: 10,
                    ),
                    const SizedBox(height: 10),
                    const AppText(
                      textAlign: TextAlign.justify,
                      text:
                          'Venha nos visitar e descubra mais sobre o que a Biblioteca de Pinheiro tem a oferecer. Aqui a informação está ao alcance de todos. Aproveite e venha desfrutar deste universo da leitura e do conhecimento.',
                      fontSize: AppFontSize.fz05,
                      maxLines: 10,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const AppText(
                          textAlign: TextAlign.justify,
                          text: 'Conheça um pouco do nosso ',
                          fontSize: AppFontSize.fz05,
                          maxLines: 10,
                        ),
                        InkWell(
                          onTap: () async {
                            if (!await launchUrl(Uri.parse(
                                'https://teliportme.com/view/2244395'))) {
                              throw Exception('Could not launch');
                            }
                          },
                          child: const AppText(
                            textAlign: TextAlign.justify,
                            text: 'salão de leitura ',
                            color: AppColors.blueLink,
                            fontSize: AppFontSize.fz05,
                            maxLines: 10,
                          ),
                        ),
                        const AppText(
                          textAlign: TextAlign.justify,
                          text: 'e da ',
                          fontSize: AppFontSize.fz05,
                          maxLines: 10,
                        ),
                        InkWell(
                          onTap: () async {
                            if (!await launchUrl(Uri.parse(
                                'https://teliportme.com/view/2244396'))) {
                              throw Exception('Could not launch');
                            }
                          },
                          child: const AppText(
                            textAlign: TextAlign.justify,
                            text: 'área do acervo.',
                            color: AppColors.blueLink,
                            fontSize: AppFontSize.fz05,
                            maxLines: 10,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const AppText(
                      textAlign: TextAlign.justify,
                      text: 'Histórico',
                      fontSize: AppFontSize.fz07,
                      fontWeight: 'bold',
                    ),
                    const SizedBox(height: 10),
                    const AppText(
                      textAlign: TextAlign.justify,
                      text:
                          'A Biblioteca de PInheiro foi inaugurada no segundo semestre de 2010 para atender os cursos de graduação de licenciatura interdisciplinar – Curso de Ciências Humanas, habilitação em História e Filosofia, e o Curso de Ciências Naturais, habilitação em Biologia. Inicialmente ela funcionava no prédio da Prainha, mas em 2012 passou a funcionar no novo prédio, localizado no bairro da Enseada, ainda na cidade de Pinheiro-MA, onde se encontra até o momento.',
                      fontSize: AppFontSize.fz05,
                      maxLines: 10,
                    ),
                    const SizedBox(height: 10),
                    const AppText(
                      textAlign: TextAlign.justify,
                      text:
                          'Ao longo dos anos, com o crescimento do Câmpus Pinheiro, a biblioteca ampliou o seu acervo e passou por mudanças em sua infraestrutura para atender a comunidade acadêmica constituída pelos docentes, discentes e técnico-administrativos da UFMA, proporcionando um espaço acolhedor de leitura, pesquisa, estudo, troca de informações e cultura.',
                      fontSize: AppFontSize.fz05,
                      maxLines: 10,
                    ),
                    const SizedBox(height: 20),
                    const AppText(
                      textAlign: TextAlign.justify,
                      text: 'Missão',
                      fontSize: AppFontSize.fz07,
                      fontWeight: 'bold',
                    ),
                    const SizedBox(height: 10),
                    const AppText(
                      textAlign: TextAlign.justify,
                      text:
                          'Promover o acesso democrático à informação e ao conhecimento, contribuindo para a formação acadêmica, científica, cultural e profissional da comunidade atendida, por meio de serviços bibliotecários eficientes, de qualidade e inovadores.',
                      fontSize: AppFontSize.fz05,
                      maxLines: 10,
                    ),
                    const SizedBox(height: 10),
                    const AppText(
                      textAlign: TextAlign.justify,
                      text: 'Visão',
                      fontSize: AppFontSize.fz07,
                      fontWeight: 'bold',
                    ),
                    const SizedBox(height: 10),
                    const AppText(
                      textAlign: TextAlign.justify,
                      text:
                          'Ser referência em biblioteconomia e ciência da informação no estado do Maranhão, reconhecida pela qualidade dos seus serviços, pela excelência na gestão e pela valorização de seus colaboradores.',
                      fontSize: AppFontSize.fz05,
                      maxLines: 10,
                    ),
                    const SizedBox(height: 10),
                    const AppText(
                      textAlign: TextAlign.justify,
                      text: 'Valores',
                      fontSize: AppFontSize.fz07,
                      fontWeight: 'bold',
                    ),
                    const SizedBox(height: 10),
                    const AppText(
                      textAlign: TextAlign.justify,
                      text: '• Compromisso com a excelência;',
                      fontSize: AppFontSize.fz05,
                      maxLines: 10,
                    ),
                    const SizedBox(height: 5),
                    const AppText(
                      textAlign: TextAlign.justify,
                      text: '• Valorização da diversidade;',
                      fontSize: AppFontSize.fz05,
                      maxLines: 10,
                    ),
                    const SizedBox(height: 5),
                    const AppText(
                      textAlign: TextAlign.justify,
                      text: '• Inovação e atualização constante;',
                      fontSize: AppFontSize.fz05,
                      maxLines: 10,
                    ),
                    const SizedBox(height: 5),
                    const AppText(
                      textAlign: TextAlign.justify,
                      text: '• Ética e transparência;',
                      fontSize: AppFontSize.fz05,
                      maxLines: 10,
                    ),
                    const SizedBox(height: 5),
                    const AppText(
                      textAlign: TextAlign.justify,
                      text: '• Responsabilidade social e ambiental.',
                      fontSize: AppFontSize.fz05,
                      maxLines: 10,
                    ),
                    const SizedBox(height: 20),
                    AccessibleKeyboardButton(
                      onPressed: () {
                        Modular.to.navigate('/home/books');
                      },
                      semanticsLabel: 'Voltar para a página inicial',
                      child: const Text('Voltar'),
                    ),
                    const SizedBox(height: 20),
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