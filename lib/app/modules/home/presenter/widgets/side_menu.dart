import 'package:vitrine_ufma/app/core/components/image_asset.dart';
import 'package:vitrine_ufma/app/core/components/text.dart';
import 'package:vitrine_ufma/app/core/constants/colors.dart';
import 'package:vitrine_ufma/app/core/constants/fonts_sizes.dart';
import 'package:vitrine_ufma/app/core/service/local_storage/i_local_storage.dart';
import 'package:vitrine_ufma/app/core/store/auth/auth_store.dart';
import 'package:vitrine_ufma/app/core/theme/them_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:vitrine_ufma/app/modules/auth/domain/usecases/logout_usecase.dart';
import 'package:vitrine_ufma/app/core/components/vlibras_clickable_text.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:vitrine_ufma/app/core/components/keyboard_accessible_components.dart';
import 'package:vitrine_ufma/app/core/services/focus_management_service.dart';
import 'package:flutter/services.dart';

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
  
  // Keyboard navigation support
  final FocusManagementService _focusService = FocusManagementService();
  final List<FocusNode> _menuFocusNodes = [];
  late FocusNode _fontSizeFocusNode;
  late FocusNode _homeFocusNode;
  late FocusNode _aboutFocusNode;
  late FocusNode _accessibilityFocusNode;
  late FocusNode _helpFocusNode;
  late FocusNode _loginFocusNode;
  late FocusNode _profileFocusNode;

  @override
  void initState() {
    super.initState();

    // Initialize focus nodes
    _initializeFocusNodes();
    
    checkLogin();

    currentPath = Modular.to.path;
    Modular.to.addListener(() {
      if (mounted) {
        setState(() {
          currentPath = Modular.to.path;
        });
      }
    });
    
    // Setup keyboard navigation
    if (UniversalPlatform.isWeb) {
      _setupKeyboardNavigation();
    }
  }

  void checkLogin() {
    storage = Modular.get<ILocalStorage>();
    boxData = storage.getKeyData(boxKey: 'data', dataKey: 'loggedUser');
    setState(() {
      isLogged = ((boxData["id"] ?? '')).isNotEmpty;
    });
  }
  
  void _initializeFocusNodes() {
    _fontSizeFocusNode = FocusNode();
    _homeFocusNode = FocusNode();
    _aboutFocusNode = FocusNode();
    _accessibilityFocusNode = FocusNode();
    _helpFocusNode = FocusNode();
    _loginFocusNode = FocusNode();
    _profileFocusNode = FocusNode();
    
    _menuFocusNodes.addAll([
      _fontSizeFocusNode,
      _homeFocusNode,
      _aboutFocusNode,
      _accessibilityFocusNode,
      _helpFocusNode,
      if (!isLogged) _loginFocusNode else _profileFocusNode,
    ]);
  }
  
  void _setupKeyboardNavigation() {
    _focusService.initializePage('side_menu');
    _focusService.registerPageFocusNodes('side_menu', _menuFocusNodes);
  }
  
  @override
  void dispose() {
    // Dispose focus nodes
    for (final node in _menuFocusNodes) {
      node.dispose();
    }
    _focusService.disposePage('side_menu');
    super.dispose();
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
              child: AppImageAsset(image: 'logo.png', imageH: 40),
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
            focusNode: _fontSizeFocusNode,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: _fontSizeFocusNode.hasFocus 
                  ? Border.all(color: Theme.of(context).primaryColor, width: 2)
                  : null,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const AppText(
                text: "A+|A-",
                fontSize: 16,
                fontWeight: 'bold',
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(width: 20),
          _buildKeyboardAccessibleMenuItem(
            context: context,
            icon: Icons.dashboard_outlined,
            title: 'Início',
            route: '/home/books',
            isSelected: isRouteSelected('/books'),
            focusNode: _homeFocusNode,
          ),
          const SizedBox(width: 20),
          _buildKeyboardAccessibleMenuItem(
            context: context,
            icon: Icons.dashboard_outlined,
            title: 'Sobre',
            route: '/home/about',
            isSelected: isRouteSelected('/about'),
            focusNode: _aboutFocusNode,
          ),
          const SizedBox(
            width: 20,
          ),
          _buildKeyboardAccessibleMenuItem(
            context: context,
            icon: Icons.task_outlined,
            title: 'Acessibilidade',
            route: '/home/acessibilities',
            isSelected: isRouteSelected('/acessibilities'),
            focusNode: _accessibilityFocusNode,
          ),
          const SizedBox(
            width: 20,
          ),
          _buildKeyboardAccessibleMenuItem(
            context: context,
            icon: Icons.inventory_2_outlined,
            title: 'Ajuda',
            route: '/home/help',
            isSelected: isRouteSelected('/help'),
            focusNode: _helpFocusNode,
          ),
          const SizedBox(
            width: 20,
          ),
          if (!isLogged)
            _buildKeyboardAccessibleMenuItem(
              context: context,
              icon: Icons.request_page_outlined,
              title: 'Login',
              route: '/auth',
              isSelected: isRouteSelected('/profile'),
              focusNode: _loginFocusNode,
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
  
  Widget _buildKeyboardAccessibleMenuItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String route,
    required bool isSelected,
    required FocusNode focusNode,
  }) {
    final theme = Theme.of(context).extension<ThemeCustom>()!;
    return Focus(
      focusNode: focusNode,
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent && 
            (event.logicalKey == LogicalKeyboardKey.enter ||
             event.logicalKey == LogicalKeyboardKey.space)) {
          Modular.to.navigate(route);
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: InkWell(
        hoverColor: Colors.transparent,
        focusColor: Colors.transparent,
        splashColor: Colors.transparent,
        onTap: () => Modular.to.navigate(route),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: focusNode.hasFocus 
              ? Border.all(color: Theme.of(context).primaryColor, width: 2)
              : null,
            borderRadius: BorderRadius.circular(4),
          ),
          child: KeyboardAccessibleText(
            text: title,
            style: TextStyle(
              fontSize: AppFontSize.fz06,
              fontWeight: FontWeight.bold,
              color: theme.textColor,
              decoration: isSelected ? TextDecoration.underline : TextDecoration.none,
            ),
            onPressed: () => Modular.to.navigate(route),
            semanticsLabel: 'Navegar para $title',
            tooltip: 'Clique para ir para $title',
            focusNode: focusNode,
          ),
        ),
      ),
    );
  }
}
