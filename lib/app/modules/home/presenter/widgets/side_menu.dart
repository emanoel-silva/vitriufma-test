import 'package:vitrine_ufma/app/core/components/image_asset.dart';
import 'package:vitrine_ufma/app/core/components/text.dart';
import 'package:vitrine_ufma/app/core/constants/colors.dart';
import 'package:vitrine_ufma/app/core/constants/fonts_sizes.dart';
import 'package:vitrine_ufma/app/core/service/local_storage/i_local_storage.dart';
import 'package:vitrine_ufma/app/core/store/auth/auth_store.dart';
import 'package:vitrine_ufma/app/core/theme/them_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:vitrine_ufma/app/core/utils/screen_helper.dart';
import 'package:vitrine_ufma/app/modules/auth/domain/usecases/logout_usecase.dart';
import 'package:vitrine_ufma/app/core/components/vlibras_clickable_text.dart';
import 'package:universal_platform/universal_platform.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({
    super.key,
  });

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> with RouteAware {
  late AuthStore controller;
  late ILocalStorage storage;
  late Map boxData;
  late bool isLogged = false;
  String currentPath = '';

  @override
  void initState() {
    super.initState();

    checkLogin();

    currentPath = Modular.to.path;
    Modular.to.addListener(() {
      if (mounted) {
        setState(() {
          currentPath = Modular.to.path;
        });
      }
    });
  }

  void checkLogin() {
    storage = Modular.get<ILocalStorage>();
    boxData = storage.getKeyData(boxKey: 'data', dataKey: 'loggedUser');
    setState(() {
      isLogged = ((boxData["id"] ?? '')).isNotEmpty;
    });
  }

  bool isRouteSelected(String route) {
    return currentPath.contains(route);
  }

  // final double sidePadding = 40;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<ThemeCustom>()!;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            // height: ScreenHelper.doubleWidth(60),
            // width: ScreenHelper.doubleWidth(60),
            clipBehavior: Clip.antiAlias,
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: const Align(
              alignment: Alignment.centerLeft,
              child: AppImageAsset(image: 'logo.png', imageH: 40, altText: 'Logotipo da Vitrine Virtual'),
            ),
          ),
          const Spacer(),
          InkWell(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: UniversalPlatform.isWeb ? 
                           VLibrasClickableText('Tamanho do texto', showIcon: false, tooltip: 'Passe o mouse para traduzir em Libras') :
                           const Text('Tamanho do texto'),
                    content: UniversalPlatform.isWeb ? 
                             VLibrasClickableText(
                               'Para aumentar ou diminuir a fonte no nosso site, utilize os atalhos Ctrl+ (para aumentar) e Ctrl- (para diminuir) no seu teclado. Caso queira restaurar o zoom para o tamanho original, basta pressionar as teclas "Ctrl" e "0" (zero) simultaneamente.',
                               showIcon: false,
                               tooltip: 'Passe o mouse para traduzir em Libras',
                             ) :
                             const Text(
                               'Para aumentar ou diminuir a fonte no nosso site, utilize os atalhos Ctrl+ (para aumentar) e Ctrl- (para diminuir) no seu teclado. Caso queira restaurar o zoom para o tamanho original, basta pressionar as teclas "Ctrl" e "0" (zero) simultaneamente.'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'OK'),
                        child: UniversalPlatform.isWeb ? 
                               VLibrasClickableText('OK', showIcon: false, tooltip: 'Passe o mouse para traduzir em Libras') :
                               const Text('OK'),
                      ),
                    ],
                  );
                },
              );
            },
            child: const AppText(
              text: "A+|A-",
              fontSize: 16,
              fontWeight: 'bold',
              color: Colors.black,
            ),
          ),
          const SizedBox(width: 20),
          _buildMenuItem(
            context: context,
            icon: Icons.dashboard_outlined,
            title: 'Início',
            route: '/home/books',
            isSelected: isRouteSelected('/books'),
          ),
          const SizedBox(width: 20),
          _buildMenuItem(
            context: context,
            icon: Icons.dashboard_outlined,
            title: 'Sobre',
            route: '/home/about',
            isSelected: isRouteSelected('/about'),
          ),
          const SizedBox(
            width: 20,
          ),
          _buildMenuItem(
            context: context,
            icon: Icons.task_outlined,
            title: 'Acessibilidade',
            route: '/home/acessibilities',
            isSelected: isRouteSelected('/acessibilities'),
          ),
          const SizedBox(
            width: 20,
          ),
          _buildMenuItem(
            context: context,
            icon: Icons.inventory_2_outlined,
            title: 'Ajuda',
            route: '/home/help',
            isSelected: isRouteSelected('/help'),
          ),
          const SizedBox(
            width: 20,
          ),
          if (!isLogged)
            _buildMenuItem(
              context: context,
              icon: Icons.request_page_outlined,
              title: 'Login',
              route: '/auth',
              isSelected: isRouteSelected('/profile'),
            ),
          if (isLogged)
            SizedBox(
              child: PopupMenuButton<void Function()>(
                  color: AppColors.white,
                  iconColor: AppColors.white,
                  padding: EdgeInsets.zero,
                  tooltip: "",
                  shadowColor: AppColors.black.withOpacity(0.3),
                  splashRadius: 5,
                  surfaceTintColor: AppColors.white,
                  icon: const AppText(
                    text: "Meu perfil",
                    fontSize: 16,
                    fontWeight: 'bold',
                    color: Colors.black,
                  ),
                  onSelected: (value) => value(),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8.0),
                    ),
                  ),
                  itemBuilder: (_) => [
                        PopupMenuItem(
                            enabled: false,
                            padding: EdgeInsets.zero,
                            child: InkWell(
                                onTap: () {
                                  Modular.to.pushNamed('/home/list/reading');
                                },
                                child: Container(
                                  color: AppColors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  child: const Row(
                                    children: [
                                      AppText(
                                        text: "Minhas listas",
                                        fontSize: 16,
                                        fontWeight: 'bold',
                                        color: Colors.black,
                                      ),
                                    ],
                                  ),
                                ))),
                        PopupMenuItem(
                            enabled: false,
                            padding: EdgeInsets.zero,
                            child: InkWell(
                                onTap: () {
                                  Modular.to.pushNamed('/home/list/favorites');
                                },
                                child: Container(
                                  color: AppColors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  child: const Row(
                                    children: [
                                      AppText(
                                        text: "Meus Favoritos",
                                        fontSize: 16,
                                        fontWeight: 'bold',
                                        color: Colors.black,
                                      ),
                                    ],
                                  ),
                                ))),
                        PopupMenuItem(
                            enabled: false,
                            padding: EdgeInsets.zero,
                            child: InkWell(
                                onTap: () {
                                  Modular.to.pushNamed('/home/register');
                                },
                                child: Container(
                                  color: AppColors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  child: const Row(
                                    children: [
                                      AppText(
                                        text: "Cadastrar",
                                        fontSize: 16,
                                        fontWeight: 'bold',
                                        color: Colors.black,
                                      ),
                                    ],
                                  ),
                                ))),
                        PopupMenuItem(
                            enabled: false,
                            padding: EdgeInsets.zero,
                            child: InkWell(
                                onTap: () {
                                  Modular.to.pushNamed('/home/manage');
                                },
                                child: Container(
                                  color: AppColors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  child: const Row(
                                    children: [
                                      AppText(
                                        text: "Gerenciar",
                                        fontSize: 16,
                                        fontWeight: 'bold',
                                        color: Colors.black,
                                      ),
                                    ],
                                  ),
                                ))),
                        // PopupMenuItem(
                        //     enabled: false,
                        //     padding: EdgeInsets.zero,
                        //     child: InkWell(
                        //         onTap: () {
                        //           Modular.to.pushNamed('/reports');
                        //           // controller.setCurrentPage(7);
                        //           // controller.pageController.jumpToPage(7);
                        //         },
                        //         child: Container(
                        //           color: AppColors.white,
                        //           padding: const EdgeInsets.symmetric(
                        //             horizontal: 10,
                        //           ),
                        //           child: const Row(
                        //             children: [
                        //               AppText(
                        //                 text: "Relatórios",
                        //                 fontSize: 16,
                        //                 fontWeight: 'bold',
                        //                 color: Colors.black,
                        //               ),
                        //             ],
                        //           ),
                        //         ))),

                        PopupMenuItem(
                            enabled: false,
                            padding: EdgeInsets.zero,
                            child: InkWell(
                                onTap: () async {
                                  final ILogoutUsecase logoutUsecase =
                                      Modular.get<ILogoutUsecase>();
                                  await Future.wait([
                                    logoutUsecase.call(),
                                    storage.clearBox(boxKey: 'data')
                                  ]);

                                  Modular.to.popAndPushNamed('/home/books');

                                  await Future.delayed(
                                    const Duration(seconds: 1),
                                  );
                                  checkLogin();

                                },
                                child: Container(
                                  color: AppColors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  child: const Row(
                                    children: [
                                      AppText(
                                        text: "Sair",
                                        fontSize: 16,
                                        fontWeight: 'bold',
                                        color: Colors.black,
                                      ),
                                    ],
                                  ),
                                )))
                      ]),
            )
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String route,
    required bool isSelected,
  }) {
    final theme = Theme.of(context).extension<ThemeCustom>()!;
    return InkWell(
      hoverColor: Colors.transparent,
      focusColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: () => Modular.to.navigate(route),
      child: Container(
        padding: EdgeInsets.symmetric(
            // horizontal: widget.isExpanded ? sidePadding : 0,
            ),
        child: AppText(
          text: title,
          fontSize: AppFontSize.fz06,
          fontWeight: 'bold',
          color: theme.textColor,
          decoration:
              isSelected ? TextDecoration.underline : TextDecoration.none,
        ),
      ),
    );
  }
}
