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
  final ManageStore store = Modular.get<ManageStore>();
  final LayoutStore layoutStore = Modular.get<LayoutStore>();

  @override
  void initState() {
    super.initState();
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
            const SizedBox(width: 15),
            Expanded(
              child: _buildStatCard(
                "Livros Cadastrados",
                store.totalBooksCount.toString(),
                Icons.book,
                Colors.green,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: _buildStatCard(
                "Mais Acessados",
                store.mostAccessedBooks.length.toString(),
                Icons.trending_up,
                Colors.orange,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: _buildStatCard(
                "Melhores Avaliados",
                store.bestRatedBooks.length.toString(),
                Icons.star,
                Colors.amber,
              ),
            ),
          ],
        ),
        const SizedBox(height: 30),
        
        // Gráficos e listas
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gráfico de livros mais acessados
            Expanded(
              flex: 3,
              child: _buildMostAccessedChart(),
            ),
            const SizedBox(width: 20),
            // Lista de melhores avaliados
            Expanded(
              flex: 2,
              child: _buildBestRatedList(),
            ),
          ],
        ),
        
        const SizedBox(height: 30),
        
        // Seção de acessos por período
        _buildAccessTrendsChart(),
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
                      maxY: store.bookAccessCounts.values.isNotEmpty 
                          ? store.bookAccessCounts.values.reduce((a, b) => a > b ? a : b).toDouble() + 20
                          : 100,
                      barTouchData: BarTouchData(
                        enabled: true,
                        touchTooltipData: BarTouchTooltipData(
                          getTooltipColor: (group) => Colors.blueGrey,
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            final book = store.mostAccessedBooks[group.x.toInt()];
                            return BarTooltipItem(
                              '${book.title}\n',
                              const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              children: [
                                TextSpan(
                                  text: '${rod.toY.round()} acessos',
                                  style: const TextStyle(
                                    color: Colors.yellow,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
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
                          .take(6)
                          .toList()
                          .asMap()
                          .entries
                          .map((entry) {
                        final book = entry.value;
                        final accessCount = store.bookAccessCounts[book.id] ?? 0;
                        return BarChartGroupData(
                          x: entry.key,
                          barRods: [
                            BarChartRodData(
                              toY: accessCount.toDouble(),
                              color: Colors.blue.withOpacity(0.8),
                              width: 20,
                              borderRadius: BorderRadius.circular(4),
                              gradient: LinearGradient(
                                colors: [
                                  Colors.blue.withOpacity(0.8),
                                  Colors.blue.withOpacity(0.4),
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
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

  Widget _buildBestRatedList() {
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
            text: "Melhores Avaliados",
            fontSize: 16,
            fontWeight: 'bold',
            color: Colors.black,
          ),
          const SizedBox(height: 15),
          Expanded(
            child: store.bestRatedBooks.isEmpty
                ? const Center(
                    child: AppText(
                      text: "Nenhum dado disponível",
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  )
                : ListView.builder(
                    itemCount: store.bestRatedBooks.length,
                    itemBuilder: (context, index) {
                      final book = store.bestRatedBooks[index];
                      final rating = store.bookRatings[book.id] ?? 0.0;
                      
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: _getRankColor(index),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: AppText(
                                      text: '${index + 1}',
                                      fontSize: 12,
                                      fontWeight: 'bold',
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: AppText(
                                    text: book.title.length > 30 
                                        ? '${book.title.substring(0, 30)}...'
                                        : book.title,
                                    fontSize: 13,
                                    fontWeight: 'medium',
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                ...List.generate(5, (starIndex) {
                                  return Icon(
                                    Icons.star,
                                    size: 14,
                                    color: starIndex < rating.floor()
                                        ? Colors.amber
                                        : Colors.grey[300],
                                  );
                                }),
                                const SizedBox(width: 8),
                                AppText(
                                  text: rating.toStringAsFixed(1),
                                  fontSize: 12,
                                  fontWeight: 'medium',
                                  color: Colors.grey[600]!,
                                ),
                              ],
                            ),
                            if (book.author.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              AppText(
                                text: 'Por: ${book.author.first}',
                                fontSize: 11,
                                color: Colors.grey[500]!,
                              ),
                            ],
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccessTrendsChart() {
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
            text: "Tendência de Acessos nos Últimos 7 Dias",
            fontSize: 16,
            fontWeight: 'bold',
            color: Colors.black,
          ),
          const SizedBox(height: 20),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawHorizontalLine: true,
                  drawVerticalLine: false,
                  horizontalInterval: 20,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.grey[300]!,
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 1,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        const days = ['Dom', 'Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sab'];
                        if (value.toInt() >= 0 && value.toInt() < days.length) {
                          return Text(
                            days[value.toInt()],
                            style: const TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
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
                      interval: 20,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        return Text(
                          value.toInt().toString(),
                          style: const TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        );
                      },
                      reservedSize: 32,
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: Colors.grey[300]!, width: 1),
                ),
                minX: 0,
                maxX: 6,
                minY: 0,
                maxY: 120,
                lineBarsData: [
                  LineChartBarData(
                    spots: store.weeklyAccessData.isNotEmpty
                        ? store.weeklyAccessData.asMap().entries
                            .map((entry) => FlSpot(
                                  entry.key.toDouble(),
                                  entry.value.toDouble(),
                                ))
                            .toList()
                        : [
                            const FlSpot(0, 45),
                            const FlSpot(1, 52),
                            const FlSpot(2, 38),
                            const FlSpot(3, 67),
                            const FlSpot(4, 82),
                            const FlSpot(5, 95),
                            const FlSpot(6, 78),
                          ],
                    isCurved: true,
                    gradient: LinearGradient(
                      colors: [
                        Colors.green.withOpacity(0.8),
                        Colors.green.withOpacity(0.3),
                      ],
                    ),
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) =>
                        FlDotCirclePainter(
                          radius: 4,
                          color: Colors.green,
                          strokeWidth: 2,
                          strokeColor: Colors.white,
                        ),
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.green.withOpacity(0.3),
                          Colors.green.withOpacity(0.05),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getRankColor(int index) {
    const colors = [
      Colors.amber,     // 1º lugar - dourado
      Colors.grey,      // 2º lugar - prata  
      Colors.orange,    // 3º lugar - bronze
      Colors.blue,      // demais posições
      Colors.green,
    ];
    return colors[index < colors.length ? index : colors.length - 1];
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
