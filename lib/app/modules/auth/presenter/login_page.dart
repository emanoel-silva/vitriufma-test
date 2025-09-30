import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:vitrine_ufma/app/core/components/image_asset.dart';

import 'package:vitrine_ufma/app/core/constants/colors.dart';
import 'package:vitrine_ufma/app/core/utils/screen_helper.dart';
import 'package:vitrine_ufma/app/modules/auth/presenter/login_store.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late LoginStore controller;

  @override
  void initState() {
    super.initState();
    controller = Modular.get<LoginStore>();

    // WidgetsBinding.instance?.addPostFrameCallback((_) {
    //   controller.silentlyLogin();
    // });
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    return Scaffold(
      body: LayoutBuilder(builder: (_, constraints) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: ScreenHelper.isMobile
                      ? null
                      : Border.all(
                          color: AppColors.backgroundGrey,
                          width: 1,
                        ),
                ),
                width: 400,
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AppImageAsset(
                        image: "logo.png",
                        imageH: 100,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Bem-vindo, faça login para continuar",
                        style:
                            TextStyle(fontSize: 16, color: AppColors.cutGrey),
                      ),
                      const SizedBox(height: 30),
                      // RoundedInputField(
                      //   hintText: 'Email',
                      //   controller: controller.emailController,
                      //   icon: Icons.email_outlined,
                      //   onChanged: (value) {},
                      // ),
                      // RoundedInputField(
                      //   obscure: true,
                      //   hintText: 'Senha',
                      //   controller: controller.passwordController,
                      //   icon: Icons.lock_clock_outlined,
                      //   onChanged: (value) {},
                      // ),
                      // const SizedBox(height: 20),
                      // InkWell(
                      //   onTap: () => controller.login(),
                      //   child: Container(
                      //     height: 50,
                      //     decoration: BoxDecoration(
                      //       color: AppColors.blue,
                      //       borderRadius: BorderRadius.circular(5),
                      //     ),
                      //     child: Center(child: Observer(
                      //       builder: (_) {
                      //         if (controller.loading) {
                      //           return const CircularProgressIndicator(
                      //             color: AppColors.white,
                      //           );
                      //         }
                      //         return const Text(
                      //           "Entrar",
                      //           style: TextStyle(
                      //             color: AppColors.white,
                      //             fontSize: 16,
                      //           ),
                      //           textAlign: TextAlign.center,
                      //         );
                      //       },
                      //     )),
                      //   ),
                      // ),
                      // const SizedBox(height: 20),
                      // InkWell(
                      //   // onTap: () => controller.login(),
                      //   child: Container(
                      //     height: 50,
                      //     decoration: BoxDecoration(
                      //       color: AppColors.black,
                      //       borderRadius: BorderRadius.circular(5),
                      //     ),
                      //     child: Center(child: Observer(
                      //       builder: (_) {
                      //         if (controller.loading) {
                      //           return const CircularProgressIndicator(
                      //             color: AppColors.white,
                      //           );
                      //         }
                      //         return const Text(
                      //           "Entrar como administrador",
                      //           style: TextStyle(
                      //             color: AppColors.white,
                      //             fontSize: 16,
                      //           ),
                      //           textAlign: TextAlign.center,
                      //         );
                      //       },
                      //     )),
                      //   ),
                      // ),
                      // const SizedBox(height: 20),
                      InkWell(
                        onTap: () => controller.login(),
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: AppColors.black,
                              width: 1,
                            ),
                          ),
                          child: Center(child: Observer(
                            builder: (_) {
                              if (controller.loading) {
                                return const CircularProgressIndicator(
                                  color: AppColors.white,
                                );
                              }
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  AppImageAsset(
                                      image: 'google.jpeg', imageH: 25),
                                  const SizedBox(width: 10),
                                  const Text(
                                    "Login com Google",
                                    style: TextStyle(
                                      color: AppColors.black,
                                      fontSize: 16,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              );
                            },
                          )),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              // const ImageAsset(
              //   image: "logo.png",
              //   imageH: 50,
              // ),
              // const SizedBox(
              //   height: 60,
              // ),
            ],
          ),
        );
      }),
    );
  }
}
