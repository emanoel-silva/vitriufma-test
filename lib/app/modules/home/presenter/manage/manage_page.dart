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
  
  bool showAllMostAccessed = false;
  bool showAllBestRated = false;
  String chartFilter = 'material'; // 'material' ou 'author'

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
        
        // Listas lado a lado

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
        // Lista de mais acessados
            Expanded(
              flex: 3,
              child: _buildMostAccessedList(),
            ),
            const SizedBox(width: 20),
            // Lista de melhores avaliados
            Expanded(

              child: _buildBestRatedList(),
            ),
          ],
        ),
        
        const SizedBox(height: 30),
        
       // Gráfico de barras dos melhores avaliados
        _buildBestRatedChart(),
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

  Widget _buildMostAccessedList() {
    const itemsPerPage = 5;
    final displayBooks = showAllMostAccessed 
        ? store.mostAccessedBooks 
        : store.mostAccessedBooks.take(itemsPerPage).toList();

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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const AppText(
                text: "Livros Mais Acessados",
                fontSize: 16,
                fontWeight: 'bold',
                color: Colors.black,
              ),
              if (store.mostAccessedBooks.length > itemsPerPage)
                TextButton(
                  onPressed: () {
                    setState(() {
                      showAllMostAccessed = !showAllMostAccessed;
                    });
                  },
                  child: AppText(
                    text: showAllMostAccessed ? "Mostrar Menos" : "Mostrar Mais",
                    fontSize: 14,
                    fontWeight: 'medium',
                    color: Colors.blue,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 15),
          store.mostAccessedBooks.isEmpty
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: AppText(
                      text: "Nenhum dado disponível",
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                   ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: displayBooks.length,
                  itemBuilder: (context, index) {
                    final book = displayBooks[index];
                    
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Row(
                        children: [
                          // Ranking badge
                          Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: _getRankColor(index),
                              shape: BoxShape.circle,
                            ),

                            child: Center(
                              child: AppText(
                                text: '${index + 1}',
                                fontSize: 14,
                                fontWeight: 'bold',
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          // Imagem de capa
                          if (book.coverImage.isNotEmpty)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Image.network(
                                book.coverImage,
                                width: 40,
                                height: 60,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 40,
                                    height: 60,
                                    color: Colors.grey[300],
                                    child: Icon(
                                      Icons.book,
                                      color: Colors.grey[600],
                                      size: 24,
                                    ),
                                  );
                                },
                              ),
                            ),
                          const SizedBox(width: 15),
                          // Informações do livro
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText(
                                  text: book.title,
                                  fontSize: 13,
                                  fontWeight: 'medium',
                                  color: Colors.black,
                                ),
                                if (book.author.isNotEmpty) ...[
                                  const SizedBox(height: 4),
                                  AppText(
                                    text: 'Por: ${book.author.join(", ")}',
                                    fontSize: 11,
                                    color: Colors.grey[500]!,
                                  ),
 
                                ],
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          // Badge de posição no ranking (já que a API não retorna contagem)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: AppText(
                              text: '#${index + 1}',
                              fontSize: 11,
                              fontWeight: 'bold',
                              color: Colors.blue[700]!,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }

  Widget _buildBestRatedList() {
    const itemsPerPage = 5;
    final displayBooks = showAllBestRated 
        ? store.bestRatedBooks 
        : store.bestRatedBooks.take(itemsPerPage).toList();

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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const AppText(
                text: "Melhores Avaliados",
                fontSize: 16,
                fontWeight: 'bold',
                color: Colors.black,
              ),
              if (store.bestRatedBooks.length > itemsPerPage)
                TextButton(
                  onPressed: () {
                    setState(() {
                      showAllBestRated = !showAllBestRated;
                    });
                  },
                  child: AppText(
                    text: showAllBestRated ? "Mostrar Menos" : "Mostrar Mais",
                    fontSize: 14,
                    fontWeight: 'medium',
                    color: Colors.blue,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 15),
          store.bestRatedBooks.isEmpty
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: AppText(
                      text: "Nenhum dado disponível",
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                   ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: displayBooks.length,
                  itemBuilder: (context, index) {
                    final book = displayBooks[index];
                    final rating = store.bookRatings[book.id] ?? 0.0;
                    
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Row(
                        children: [
                          // Ranking badge
                          Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: _getRankColor(index),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: AppText(
                                text: '${index + 1}',
                                fontSize: 14,
                                fontWeight: 'bold',
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          // Imagem de capa
                          if (book.coverImage.isNotEmpty)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Image.network(
                                book.coverImage,
                                width: 40,
                                height: 60,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 40,
                                    height: 60,
                                    color: Colors.grey[300],
                                    child: Icon(
                                      Icons.book,
                                      color: Colors.grey[600],
                                      size: 24,
                                    ),

                                  );
                                },
                              ),
                            ),

                          const SizedBox(width: 15),
                          // Informações do livro
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText(
                                  text: book.title,
                                  fontSize: 13,
                                  fontWeight: 'medium',
                                  color: Colors.black,
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    if (rating > 0) ...[
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
                                  ],
                                ),
                                if (book.author.isNotEmpty) ...[
                                  const SizedBox(height: 4),
                                  AppText(
                                    text: 'Por: ${book.author.join(", ")}',
                                    fontSize: 11,
                                    color: Colors.grey[500]!,
                                  ),
                                ],
                              ],
                            ),
                         ),
                        ],
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }

  Widget _buildBestRatedChart() {
    // Limitar a 10 itens para o gráfico
    final chartBooks = store.bestRatedBooks.take(10).toList();
    
    if (chartBooks.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(40),
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
        child: const Center(
          child: Column(
            children: [
              Icon(Icons.bar_chart, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              AppText(
                text: "Nenhum material avaliado encontrado",
                fontSize: 16,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      );
    }

    // Verificar se há algum rating válido
    final hasValidRatings = chartBooks.any((book) {
      final rating = store.bookRatings[book.id] ?? 0.0;
      return rating > 0.0;
    });

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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const AppText(
                text: "Gráfico de Melhores Avaliados",
                fontSize: 16,
                fontWeight: 'bold',
                color: Colors.black,
              ),
              // Filtros
              Row(
                children: [
                  _buildFilterButton('Material', 'material'),
                  const SizedBox(width: 10),
                  _buildFilterButton('Autor', 'author'),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (!hasValidRatings)
            Container(
              height: 350,
              alignment: Alignment.center,
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.star_border, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  AppText(
                    text: "Aguardando dados de avaliações...",
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 8),
                  AppText(
                    text: "Os ratings dos materiais estão sendo carregados",
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ],
              ),
            )
          else
            SizedBox(
              height: 350,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 5,
                  minY: 0,
                  barTouchData: BarTouchData(
                    enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (group) => Colors.blueGrey.withOpacity(0.9),
                    tooltipPadding: const EdgeInsets.all(8),
                    tooltipMargin: 8,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final book = chartBooks[group.x.toInt()];
                      final rating = store.bookRatings[book.id] ?? 0.0;
                      
                      return BarTooltipItem(
                        '',
                        const TextStyle(),
                        children: [
                          TextSpan(
                            text: chartFilter == 'material' 
                                ? '${book.title}\n' 
                                : '${book.author.isNotEmpty ? book.author.first : "Autor desconhecido"}\n',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          TextSpan(
                            text: 'Rating: ${rating.toStringAsFixed(1)} ⭐\n',
                            style: const TextStyle(
                              color: Colors.yellow,
                              fontSize: 11,
                            ),
                          ),
                          const TextSpan(
                            text: '\nClique para ver detalhes',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 10,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  touchCallback: (FlTouchEvent event, barTouchResponse) {
                    if (event is FlTapUpEvent && 
                        barTouchResponse != null && 
                        barTouchResponse.spot != null) {
                      final index = barTouchResponse.spot!.touchedBarGroupIndex;
                      if (index >= 0 && index < chartBooks.length) {
                        final book = chartBooks[index];
                        // Navegar para a página de detalhes
                        Modular.to.pushNamed('/detail/${book.id}');
                      }
                    }
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 80,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        if (value.toInt() < chartBooks.length) {
                          final book = chartBooks[value.toInt()];
                          String text = chartFilter == 'material' 
                              ? book.title 
                              : (book.author.isNotEmpty ? book.author.first : "Desconhecido");
                          
                          // Truncar texto longo
                          if (text.length > 15) {
                            text = '${text.substring(0, 15)}...';
                          }
                          
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: RotatedBox(
                              quarterTurns: -1,
                              child: Text(
                                text,
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.start,
                              ),
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
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toStringAsFixed(0),
                          style: const TextStyle(fontSize: 12),
                        );
                      },
                    ),
                  ),                 topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 1,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.grey[300]!,
                      strokeWidth: 1,
                    );
                  },
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border(
                    left: BorderSide(color: Colors.grey[400]!),
                    bottom: BorderSide(color: Colors.grey[400]!),
                  ),
                ),
                barGroups: chartBooks.asMap().entries.map((entry) {
                  final index = entry.key;
                  final book = entry.value;
                  final rating = store.bookRatings[book.id] ?? 0.0;
                  
                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: rating,
                        color: Colors.amber,
                        width: 25,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(4),
                        ),
                        gradient: LinearGradient(
                          colors: [
                            Colors.amber.shade700,
                            Colors.amber.shade300,
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

    Widget _buildFilterButton(String label, String value) {
    final isSelected = chartFilter == value;
    
    return InkWell(
      onTap: () {
        setState(() {
          chartFilter = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.amber : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.amber.shade700 : Colors.grey[400]!,
            width: 1,
          ),
        ),
        child: AppText(
          text: label,
          fontSize: 12,
          fontWeight: isSelected ? 'bold' : 'medium',
          color: isSelected ? Colors.white : Colors.grey[700]!,
        ),
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
