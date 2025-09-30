import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vitrine_ufma/app/core/components/footer.dart';
import 'package:vitrine_ufma/app/core/components/text.dart';
import 'package:vitrine_ufma/app/core/components/text_widget.dart';
import 'package:vitrine_ufma/app/core/constants/colors.dart';
import 'package:vitrine_ufma/app/core/constants/const.dart';
import 'package:vitrine_ufma/app/core/constants/fonts_sizes.dart';
import 'package:vitrine_ufma/app/core/service/local_storage/i_local_storage.dart';
import 'package:vitrine_ufma/app/core/utils/screen_helper.dart';

class HelpPage extends StatelessWidget {
  HelpPage({super.key});
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                        text: 'Ajuda',
                        fontSize: AppFontSize.fz10,
                        fontWeight: 'bold',
                        color: Colors.black,
                      )),
                    ),
                    const SizedBox(height: 30),
                    AppText(
                      textAlign: TextAlign.justify,
                      text: 'Perguntas Frequentes',
                      fontSize: AppFontSize.fz07,
                      fontWeight: 'bold',
                    ),
                    const SizedBox(height: 30),
                    AppText(
                      textAlign: TextAlign.justify,
                      text:
                          'Quem pode acessar a Estante Visual da Biblioteca de Pinheiro?',
                      fontSize: AppFontSize.fz06,
                    ),
                    const SizedBox(height: 20),
                    AppText(
                      textAlign: TextAlign.justify,
                      text:
                          'A Estante Visual tem como público alvo a comunidade acadêmica da UFMA, mas a comunidade externa pode fazer pesquisas para verificar os materiais informacionais que têm no acervo da biblioteca. Algumas funcionalidades como favoritar, selecionar e adicionar materiais informacionais em lista são restritas àqueles com vínculo ativo na UFMA, que podem utilizá-las realizando o login.',
                      fontSize: AppFontSize.fz05,
                      maxLines: 10,
                    ),
                    const SizedBox(height: 20),
                    AppText(
                      textAlign: TextAlign.justify,
                      text:
                          'Como faço para realizar o login na Estante visual?',
                      fontSize: AppFontSize.fz06,
                    ),
                    const SizedBox(height: 20),
                    AppText(
                      textAlign: TextAlign.justify,
                      text:
                          'Não é necessário fazer cadastro para realizar o login na Estante visual. O login é restrito somente à comunidade acadêmica da UFMA com vínculo ativo e pode ser feito ao clicar em “Login” na página inicial da Estante visual. Ao ser direcionado para a área de login, deve clicar em “Login com o Google” e colocar seu e-mail institucional e senha.',
                      fontSize: AppFontSize.fz05,
                      maxLines: 10,
                    ),
                    const SizedBox(height: 20),
                    AppText(
                      textAlign: TextAlign.justify,
                      text:
                          'Como faço para pesquisar um material informacional na Estante visual?',
                      fontSize: AppFontSize.fz06,
                    ),
                    const SizedBox(height: 20),
                    AppText(
                      textAlign: TextAlign.justify,
                      text:
                          'A pesquisa na Estante visual pode ser realizada sem a realização do login. A busca pode ser feita inserindo o termo referente a pesquisa na barra de pesquisa na página inicial ou então clicando em “Pesquisa avançada”. Na pesquisa avançada poderá realizar a busca preenchendo um ou mais campos e os combinando com os operadores booleanos.',
                      fontSize: AppFontSize.fz05,
                      maxLines: 10,
                    ),
                    const SizedBox(height: 20),
                    AppText(
                      textAlign: TextAlign.justify,
                      text:
                          'Como faço para favoritar e avaliar um material informacional?',
                      fontSize: AppFontSize.fz06,
                    ),
                    const SizedBox(height: 20),
                    AppText(
                      textAlign: TextAlign.justify,
                      text:
                          'Para favoritar e avaliar um material informacional é necessário que esteja logado na Estante visual. Clique no ícone em formato de coração para favoritar e no ícone em formato de estrela para avaliar o material. O material informacional favoritado irá para “Meus favoritos”, localizado na aba “Meu perfil”. E a avaliação vai ser processada as demais avaliações dadas por outros usuários e poderá ser verificada abaixo da capa do material informacional.',
                      fontSize: AppFontSize.fz05,
                      maxLines: 10,
                    ),
                    const SizedBox(height: 20),
                    AppText(
                      textAlign: TextAlign.justify,
                      text: 'Como faço para criar uma lista?',
                      fontSize: AppFontSize.fz06,
                    ),
                    const SizedBox(height: 20),
                    AppText(
                      textAlign: TextAlign.justify,
                      text:
                          'Para criar uma lista é necessário que esteja logado na Estante visual e clique no ícone em formato de + ou em “+ Adicionar a lista”. Você pode nomear a lista e configurá-la como pública (caso queira compartilhar com outras pessoas) ou privada (somente você poderá visualizar). As listas criadas poderão ser visualizadas em “Minhas listas”, na aba “Meu perfil”.',
                      fontSize: AppFontSize.fz05,
                      maxLines: 10,
                    ),

                    const SizedBox(height: 20),
                    AppText(
                      textAlign: TextAlign.justify,
                      text:
                          'Como faço para cadastrar um material informacional?',
                      fontSize: AppFontSize.fz06,
                    ),
                    const SizedBox(height: 20),
                    AppText(
                      textAlign: TextAlign.justify,
                      text:
                          'O cadastro de material informacional na Estante visual é restrito aos administradores. Para iniciar o cadastro é necessário realizar o login na Estante visual e clicar em “Cadastrar”, na aba “Meu perfil”. Cada campo possui um exemplo autoexplicativo de como devem ser colocadas as informações. Ao finalizar o preenchimento, deve-se clicar em “Salvar” e aguardar exibir a mensagem de confirmação de salvamento.',
                      fontSize: AppFontSize.fz05,
                      maxLines: 10,
                    ),
                    const SizedBox(height: 30),
                    InkWell(
                      onTap: () async {
                        if (!await launchUrl(Uri.parse(
                            'https://www.youtube.com/watch?v=ZyajzrO_rAU'))) {
                          throw Exception('Could not launch');
                        }
                      },
                      child: AppText(
                        textAlign: TextAlign.justify,
                        text: 'Material informativo de uso da vitrine',
                        fontSize: AppFontSize.fz07,
                        fontWeight: 'bold',
                      ),
                    ),
                    // const SizedBox(height: 30),
                    // AppText(
                    //   textAlign: TextAlign.justify,
                    //   text: 'Manual do administrador',
                    //   fontSize: AppFontSize.fz07,
                    //   fontWeight: 'bold',
                    // ),
                  ]),
            ),
            SizedBox(height: 200),
            FooterVitrine()
          ],
        ),
      ),
    );
  }
}
