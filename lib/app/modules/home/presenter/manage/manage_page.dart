import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:vitrine_ufma/app/core/components/text.dart';
import 'package:vitrine_ufma/app/core/constants/colors.dart';
import 'package:vitrine_ufma/app/core/store/layout/layout_store.dart';
import 'package:vitrine_ufma/app/modules/home/presenter/manage/manage_store.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../../core/constants/const.dart';

class ManagePage extends StatefulWidget {
  @override
  _ManagePageState createState() => _ManagePageState();
}

class _ManagePageState extends State<ManagePage> {
  late ManageStore store;
  final LayoutStore layoutStore = Modular.get<LayoutStore>();

  @override
  void initState() {
    super.initState();
    store = Modular.get<ManageStore>();
    // Carregar dados dos relatórios
    WidgetsBinding.instance.addPostFrameCallback((_) {
      store.loadReportsData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Center(
        child: Container(
          width: AppConst.maxContainerWidth,
          constraints: BoxConstraints(
            maxHeight: AppConst.maxContainerWidth,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
          
                // Verificação de Permissão
                Observer(builder: (context) {
                  if (layoutStore.permissions.isEmpty) {
                    return const Center(
                      child: AppText(
                        text: 'Você não tem permissão para acessar esta página.',
                        fontSize: 16,
                        color: Colors.red,
                      ),
                    );
                  }
                  if (layoutStore.permissions[0]['permission_type'] == "FULL") {
                    return Column(
                      children: [
                        _backButton(),
          
                        // BODY
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 0, left: 50, right: 50, bottom: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // const AppText(
                              //   text: "Gerenciamento",
                              //   fontSize: 24,
                              //   fontWeight: 'bold',
                              //   color: Colors.black,
                              // ),
                              // Divider(
                              //   color: Colors.grey,
                              //   thickness: 1,
                              // ),
                              // const SizedBox(height: 20),
                                 // SEÇÃO DE RELATÓRIOS
                                  const AppText(
                                    text: "Relatórios",
                                    fontSize: 20,
                                    fontWeight: 'bold',
                                    color: Colors.black,
                                  ),
                                  const SizedBox(height: 20),
                                  Observer(builder: (context) {
                                    if (store.loadingReports) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                    return _buildReportsSection();
                                  }),
                                const SizedBox(height: 40),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const AppText(
                                    text: "Usuários",
                                    fontSize: 20,
                                    fontWeight: 'bold',
                                    color: Colors.black,
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      // BOTÃO DE HABILITAR USUÁRIO
                                      InkWell(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              TextEditingController
                                                  emailController =
                                                  TextEditingController();
                                              return AlertDialog(
                                                title: const Text(
                                                    'Digite o email do usuário'),
                                                content: TextField(
                                                  controller: emailController,
                                                  decoration: const InputDecoration(
                                                    hintText: 'Email',
                                                  ),
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () async {
                                                      await store
                                                          .enableOrDisableUser(
                                                              email: emailController
                                                                  .text,
                                                              enable: true);
                                                      if (mounted) {
                                                        Navigator.of(context).pop();
                                                      }
                                                    },
                                                    child: const Text('Habilitar'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                    },
                                                    child: const Text('Cancelar'),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        child: Container(
                                          width: 200,
                                          padding: const EdgeInsets.all(20),
                                          decoration: BoxDecoration(
                                            color: AppColors.backgroundGrey,
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: const AppText(
                                            text: "Habilitar Usuário",
                                            fontSize: 16,
                                            fontWeight: 'medium',
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 20),
          
                                      // BOTÃO DE DESABILITAR USUÁRIO
                                      InkWell(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              TextEditingController
                                                  emailController =
                                                  TextEditingController();
                                              return AlertDialog(
                                                title: const Text(
                                                    'Digite o email do usuário'),
                                                content: TextField(
                                                  controller: emailController,
                                                  decoration: const InputDecoration(
                                                    hintText: 'Email',
                                                  ),
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () async {
                                                      await store
                                                          .enableOrDisableUser(
                                                              email: emailController
                                                                  .text,
                                                              enable: false);
                                                      if (mounted) {
                                                        Navigator.of(context).pop();
                                                      }
                                                    },
                                                    child:
                                                        const Text('Desabilitar'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                    },
                                                    child: const Text('Cancelar'),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        child: Container(
                                          width: 200,
                                          padding: const EdgeInsets.all(20),
                                          decoration: BoxDecoration(
                                            color: AppColors.backgroundGrey,
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: const AppText(
                                            text: "Desabilitar Usuário",
                                            fontSize: 16,
                                            fontWeight: 'medium',
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  const AppText(
                                    text: "Administradores",
                                    fontSize: 20,
                                    fontWeight: 'bold',
                                    color: Colors.black,
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      // BOTÃO DE HABILITAR ADMIN
                                      InkWell(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              TextEditingController
                                                  emailController =
                                                  TextEditingController();
                                              TextEditingController daysController =
                                                  TextEditingController();
                                              return AlertDialog(
                                                title: const Text(
                                                    'Digite o email do administrador e a quantidade de dias'),
                                                content: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    TextField(
                                                      controller: emailController,
                                                      decoration:
                                                          const InputDecoration(
                                                        hintText: 'Email',
                                                      ),
                                                    ),
                                                    TextField(
                                                      controller: daysController,
                                                      decoration:
                                                          const InputDecoration(
                                                        hintText:
                                                            'Quantidade de dias (Ex: 30)',
                                                      ),
                                                      keyboardType:
                                                          TextInputType.number,
                                                    ),
                                                  ],
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () async {
                                                      int days = int.tryParse(
                                                              daysController
                                                                  .text) ??
                                                          0;
                                                      await store.setPermission(
                                                        email: emailController.text,
                                                        days: days,
                                                        permissionType: 'FULL',
                                                      );
                                                      if (mounted) {
                                                        Navigator.of(context).pop();
                                                      }
                                                    },
                                                    child: const Text(
                                                        'Habilitar Admin'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                    },
                                                    child: const Text('Cancelar'),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        child: Container(
                                          width: 200,
                                          padding: const EdgeInsets.all(20),
                                          decoration: BoxDecoration(
                                            color: AppColors.backgroundGrey,
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: const AppText(
                                            text: "Habilitar Admin",
                                            fontSize: 16,
                                            fontWeight: 'medium',
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 40),
                                  
                               ],
                              )
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                  return const Center(
                    child: AppText(
                      text: 'Você não tem permissão para acessar esta página.',
                      fontSize: 16,
                      color: Colors.red,
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReportsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Cards de estatísticas
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                "Total de Acessos",
                store.totalAccessCount.toString(),
                Icons.visibility,
                Colors.blue,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: _buildStatCard(
                "Livros Cadastrados",
                store.mostAccessedBooks.length.toString(),
                Icons.book,
                Colors.green,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: _buildStatCard(
                "Mais Acessados",
                store.mostAccessedBooks.length.toString(),
                Icons.trending_up,
                Colors.orange,
              ),
            ),
          ],
        ),
        const SizedBox(height: 30),
        
        // Gráficos
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gráfico de livros mais acessados
            Expanded(
              child: _buildMostAccessedChart(),
            ),
            const SizedBox(width: 20),
            // Gráfico de melhores avaliados
            Expanded(
              child: _buildBestRatedChart(),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(width: 10),
              AppText(
                text: title,
                fontSize: 14,
                fontWeight: 'medium',
                color: Colors.grey[600]!,
              ),
            ],
          ),
          const SizedBox(height: 10),
          AppText(
            text: value,
            fontSize: 24,
            fontWeight: 'bold',
            color: Colors.black,
          ),
        ],
      ),
    );
  }

  Widget _buildMostAccessedChart() {
    return Container(
      height: 300,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppText(
            text: "Livros Mais Acessados",
            fontSize: 16,
            fontWeight: 'bold',
            color: Colors.black,
          ),
          const SizedBox(height: 20),
          Expanded(
            child: store.mostAccessedBooks.isEmpty
                ? const Center(
                    child: AppText(
                      text: "Nenhum dado disponível",
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  )
                : BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: 100,
                      barTouchData: BarTouchData(enabled: false),
                      titlesData: FlTitlesData(
                        show: true,
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (double value, TitleMeta meta) {
                              if (value.toInt() < store.mostAccessedBooks.length) {
                                final book = store.mostAccessedBooks[value.toInt()];
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    book.title.length > 10 
                                        ? '${book.title.substring(0, 10)}...'
                                        : book.title,
                                    style: const TextStyle(fontSize: 10),
                                  ),
                                );
                              }
                              return const Text('');
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40,
                          ),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      barGroups: store.mostAccessedBooks
                          .take(5)
                          .toList()
                          .asMap()
                          .entries
                          .map((entry) {
                        return BarChartGroupData(
                          x: entry.key,
                          barRods: [
                            BarChartRodData(
                              toY: (entry.key + 1) * 15.0, // Valor simulado
                              color: Colors.blue,
                              width: 16,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildBestRatedChart() {
    return Container(
      height: 300,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppText(
            text: "Livros Melhores Avaliados",
            fontSize: 16,
            fontWeight: 'bold',
            color: Colors.black,
          ),
          const SizedBox(height: 20),
          Expanded(
            child: store.bestRatedBooks.isEmpty
                ? const Center(
                    child: AppText(
                      text: "Nenhum dado disponível",
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  )
                : PieChart(
                    PieChartData(
                      sections: store.bestRatedBooks
                          .take(5)
                          .toList()
                          .asMap()
                          .entries
                          .map((entry) {
                        final colors = [
                          Colors.orange,
                          Colors.green,
                          Colors.red,
                          Colors.purple,
                          Colors.teal,
                        ];
                        return PieChartSectionData(
                          color: colors[entry.key % colors.length],
                          value: (5 - entry.key).toDouble(),
                          title: '${5 - entry.key}⭐',
                          radius: 50,
                          titleStyle: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        );
                      }).toList(),
                      centerSpaceRadius: 40,
                      sectionsSpace: 2,
                    ),
                  ),
          ),
          if (store.bestRatedBooks.isNotEmpty)
            Column(
              children: store.bestRatedBooks
                  .take(3)
                  .toList()
                  .asMap()
                  .entries
                  .map((entry) {
                final book = entry.value;
                final colors = [Colors.orange, Colors.green, Colors.red];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: colors[entry.key],
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: AppText(
                          text: book.title.length > 25 
                              ? '${book.title.substring(0, 25)}...'
                              : book.title,
                          fontSize: 10,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  Widget _backButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 50, bottom: 20, top: 20),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.wine),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.arrow_back,
                    color: AppColors.wine,
                    size: 16,
                  ),
                  const SizedBox(width: 5),
                  AppText(
                    text: "Voltar",
                    fontSize: 12,
                    fontWeight: 'medium',
                    color: AppColors.wine,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
