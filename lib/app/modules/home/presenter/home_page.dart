import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:vitrine_ufma/app/core/constants/const.dart';
import 'package:vitrine_ufma/app/core/store/layout/layout_store.dart';
import 'package:vitrine_ufma/app/modules/home/presenter/widgets/side_menu.dart';
import 'package:vitrine_ufma/app/core/theme/them_custom.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final layoutStore = Modular.get<LayoutStore>();

  @override
  void initState() {
    super.initState();
    // Navigate to dashboard when mounted
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if(Modular.to.path == '/') {
          Modular.to.navigate('/home/books');
        }
        if(Modular.to.path == '/home') {
          Modular.to.navigate('/home/books');
        }
        Modular.to.navigate('/home/books');
      });

      layoutStore.getPemission();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<ThemeCustom>()!;

    return Scaffold(
      backgroundColor: theme.backgroundColor,
      body: Observer(
        builder: (_) => Stack(
          children: [
            Column(
              children: [
                // Side Menu
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: AppConst.maxContainerWidth,
                  child: SideMenu(
                  ),
                ),
                // Main Content
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(0),
                    child: const RouterOutlet(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}