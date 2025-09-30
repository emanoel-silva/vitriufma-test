import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:vitrine_ufma/app/core/components/text.dart';
import 'package:vitrine_ufma/app/core/constants/colors.dart';
import 'package:vitrine_ufma/app/core/constants/const.dart';
import 'package:vitrine_ufma/app/core/constants/fonts_sizes.dart';
import 'package:vitrine_ufma/app/modules/home/domain/entities/book.dart';
import 'package:vitrine_ufma/app/modules/home/presenter/detail/widgets/filtered_book_card.dart';
import 'package:vitrine_ufma/app/modules/home/presenter/search/simple_search/search_modal.dart';
import 'package:vitrine_ufma/app/modules/home/presenter/search/search_store.dart';

class ResultSearchPage extends StatefulWidget {
  SearchStore store = Modular.get<SearchStore>();
  ResultSearchPage({super.key});

  @override
  State<ResultSearchPage> createState() => _ResultSearchPageState();
}

class _ResultSearchPageState extends State<ResultSearchPage> {
  late List<Book> originalBooks;
  List<Book> booksFiltered = [];
  List<String> filter = [];
  List<String> selectedAuthors = [];
  List<String> selectedTitles = [];
  List<String> selectedEditions = [];
  List<String> selectedYears = [];
  List<String> selectedVolumes = [];
  List<String> selectedAreas = [];
  List<String> selectedSubareas = [];
  List<String> selectedTypes = [];
  List<String> selectedLanguages = [];
  int? selectedRating;

  @override
  void initState() {
    super.initState();
    originalBooks = Modular.args.data;
    booksFiltered = List.from(originalBooks);
  }

  void toggleFilterType(String value) {
    setState(() {
      if (filter.contains(value)) {
        filter.remove(value);
      } else {
        filter.add(value);
      }
    });
  }

  void applyFilters() {
    setState(() {
      booksFiltered = originalBooks.where((book) {
        // Author
        final matchAuthor = selectedAuthors.isEmpty ||
            book.author.any((a) => selectedAuthors.contains(a));
        // Title
        final matchTitle =
            selectedTitles.isEmpty || selectedTitles.contains(book.title);
        // Edition
        final matchEdition =
            selectedEditions.isEmpty || selectedEditions.contains(book.edition);
        // Year
        final matchYear = selectedYears.isEmpty ||
            selectedYears.contains(book.publicationYear);
        // Volume
        final matchVolume = selectedVolumes.isEmpty ||
            selectedVolumes.contains(book.volume.toString());
        // Area
        final matchArea = selectedAreas.isEmpty ||
            book.matters.any((m) => selectedAreas.contains(m));
        // Subarea
        final matchSubarea = selectedSubareas.isEmpty ||
            book.subMatters.any((sm) => selectedSubareas.contains(sm));
        // Type
        final matchType =
            selectedTypes.isEmpty || selectedTypes.contains(book.typer);
        // Language
        final matchLanguage = selectedLanguages.isEmpty ||
            selectedLanguages.contains(book.language);
        // TODO: Add rating filter if Book has a rating field in the future

        return matchAuthor &&
            matchTitle &&
            matchEdition &&
            matchYear &&
            matchVolume &&
            matchArea &&
            matchSubarea &&
            matchType &&
            matchLanguage;
      }).toList();
    });
  }

  List<String> getAllAuthors() =>
      originalBooks.expand((b) => b.author).toSet().toList();
  List<String> getAllTitles() =>
      originalBooks.map((b) => b.title).toSet().toList();
  List<String> getAllEditions() => originalBooks
      .map((b) => b.edition)
      .where((e) => e.isNotEmpty)
      .toSet()
      .toList();
  List<String> getAllYears() => originalBooks
      .map((b) => b.publicationYear)
      .where((y) => y.isNotEmpty)
      .toSet()
      .toList();
  List<String> getAllVolumes() => originalBooks
      .map((b) => b.volume.toString())
      .where((v) => v != "0")
      .toSet()
      .toList();
  List<String> getAllAreas() =>
      originalBooks.expand((b) => b.matters).toSet().toList();
  List<String> getAllSubareas() =>
      originalBooks.expand((b) => b.subMatters).toSet().toList();
  List<String> getAllTypes() => originalBooks
      .map((b) => b.typer)
      .where((t) => t.isNotEmpty)
      .toSet()
      .toList();
  List<String> getAllLanguages() => originalBooks
      .map((b) => b.language)
      .where((l) => l.isNotEmpty)
      .toSet()
      .toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.white,
        body: Center(
          child: SingleChildScrollView(
              child: Column(
            children: [
              SearchModal(
                expanded: false,
              ),
              const SizedBox(height: 20),
              Container(
                width: AppConst.maxContainerWidth,
                child: Observer(builder: (context) {
                  if (widget.store.loading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (widget.store.booksFiltered.isEmpty) {
                    return Center(
                      child: SizedBox(
                        width: AppConst.maxContainerWidth,
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            Container(
                              child: InkWell(
                                  onTap: () {
                                    Modular.to.navigate('/home/books');
                                    // store.back();
                                  },
                                  child: Container(
                                    width: 80,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
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
                                  )),
                            ),
                            const SizedBox(height: 80),
                            Center(child: Text("Nenhum resultado encontrado")),
                          ],
                        ),
                      ),
                    );
                  }
                  return Container(
                    width: AppConst.maxContainerWidth,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: InkWell(
                              onTap: () {
                                Modular.to.navigate('/home/books');
                                // store.back();
                              },
                              child: Container(
                                width: 80,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: AppColors.wine),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.arrow_back,
                                      color: AppColors.wine,
                                      size: 16,
                                    ),
                                    SizedBox(width: 5),
                                    AppText(
                                      text: "Voltar",
                                      fontSize: 12,
                                      fontWeight: 'medium',
                                      color: AppColors.wine,
                                    ),
                                  ],
                                ),
                              )),
                        ),
                        Center(
                          child: Container(
                            width: AppConst.maxContainerWidth,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 250,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 20),
                                        AppText(
                                            text: "Filtros",
                                            fontSize: AppFontSize.fz07,
                                            fontWeight: 'bold'),
                                        const SizedBox(height: 20),

                                        // Autor
                                        // AppText(
                                        //     text: "Autor",
                                        //     fontSize: AppFontSize.fz07,
                                        //     fontWeight: 'bold'),
                                        // ...getAllAuthors()
                                        //     .map((author) => CheckboxListTile(
                                        //           value: selectedAuthors
                                        //               .contains(author),
                                        //           title: Text(author),
                                        //           onChanged: (val) {
                                        //             setState(() {
                                        //               if (val == true) {
                                        //                 selectedAuthors
                                        //                     .add(author);
                                        //               } else {
                                        //                 selectedAuthors
                                        //                     .remove(author);
                                        //               }
                                        //             });
                                        //           },
                                        //         )),
                                        // const SizedBox(height: 10),

                                        // // Título
                                        // AppText(
                                        //     text: "Título",
                                        //     fontSize: AppFontSize.fz07,
                                        //     fontWeight: 'bold'),
                                        // ...getAllTitles()
                                        //     .map((title) => CheckboxListTile(
                                        //           value: selectedTitles
                                        //               .contains(title),
                                        //           title: Text(title),
                                        //           onChanged: (val) {
                                        //             setState(() {
                                        //               if (val == true) {
                                        //                 selectedTitles
                                        //                     .add(title);
                                        //               } else {
                                        //                 selectedTitles
                                        //                     .remove(title);
                                        //               }
                                        //             });
                                        //           },
                                        //         )),
                                        // const SizedBox(height: 10),

                                        // Edição
                                        AppText(
                                            text: "Edição",
                                            fontSize: AppFontSize.fz06,
                                            fontWeight: 'bold'),
                                        ...getAllEditions()
                                            .map((edition) => CheckboxListTile(
                                                  value: selectedEditions
                                                      .contains(edition),
                                                  title: Text(edition),
                                                  onChanged: (val) {
                                                    setState(() {
                                                      if (val == true) {
                                                        selectedEditions
                                                            .add(edition);
                                                      } else {
                                                        selectedEditions
                                                            .remove(edition);
                                                      }
                                                    });
                                                  },
                                                )),
                                        const SizedBox(height: 10),

                                        // Ano de publicação
                                        AppText(
                                            text: "Ano de publicação",
                                            fontSize: AppFontSize.fz06,
                                            fontWeight: 'bold'),
                                        ...getAllYears()
                                            .map((year) => CheckboxListTile(
                                                  value: selectedYears
                                                      .contains(year),
                                                  title: Text(year),
                                                  onChanged: (val) {
                                                    setState(() {
                                                      if (val == true) {
                                                        selectedYears.add(year);
                                                      } else {
                                                        selectedYears
                                                            .remove(year);
                                                      }
                                                    });
                                                  },
                                                )),
                                        const SizedBox(height: 10),

                                        // Volume
                                        AppText(
                                            text: "Volume",
                                            fontSize: AppFontSize.fz06,
                                            fontWeight: 'bold'),
                                        ...getAllVolumes()
                                            .map((volume) => CheckboxListTile(
                                                  value: selectedVolumes
                                                      .contains(volume),
                                                  title: Text(volume),
                                                  onChanged: (val) {
                                                    setState(() {
                                                      if (val == true) {
                                                        selectedVolumes
                                                            .add(volume);
                                                      } else {
                                                        selectedVolumes
                                                            .remove(volume);
                                                      }
                                                    });
                                                  },
                                                )),
                                        const SizedBox(height: 10),

                                        // Área do conhecimento
                                        AppText(
                                            text: "Área do conhecimento",
                                            fontSize: AppFontSize.fz06,
                                            fontWeight: 'bold'),
                                        ...getAllAreas()
                                            .map((area) => CheckboxListTile(
                                                  value: selectedAreas
                                                      .contains(area),
                                                  title: Text(area),
                                                  onChanged: (val) {
                                                    setState(() {
                                                      if (val == true) {
                                                        selectedAreas.add(area);
                                                      } else {
                                                        selectedAreas
                                                            .remove(area);
                                                      }
                                                    });
                                                  },
                                                )),
                                        const SizedBox(height: 10),

                                        // Subárea do conhecimento
                                        AppText(
                                            text: "Subárea do conhecimento",
                                            fontSize: AppFontSize.fz06,
                                            fontWeight: 'bold'),
                                        ...getAllSubareas()
                                            .map((subarea) => CheckboxListTile(
                                                  value: selectedSubareas
                                                      .contains(subarea),
                                                  title: Text(subarea),
                                                  onChanged: (val) {
                                                    setState(() {
                                                      if (val == true) {
                                                        selectedSubareas
                                                            .add(subarea);
                                                      } else {
                                                        selectedSubareas
                                                            .remove(subarea);
                                                      }
                                                    });
                                                  },
                                                )),
                                        const SizedBox(height: 10),

                                        // Tipo de material
                                        AppText(
                                            text: "Tipo de material",
                                            fontSize: AppFontSize.fz06,
                                            fontWeight: 'bold'),
                                        ...getAllTypes()
                                            .map((type) => CheckboxListTile(
                                                  value: selectedTypes
                                                      .contains(type),
                                                  title: Text(type),
                                                  onChanged: (val) {
                                                    setState(() {
                                                      if (val == true) {
                                                        selectedTypes.add(type);
                                                      } else {
                                                        selectedTypes
                                                            .remove(type);
                                                      }
                                                    });
                                                  },
                                                )),
                                        const SizedBox(height: 10),

                                        // Idioma
                                        AppText(
                                            text: "Idioma",
                                            fontSize: AppFontSize.fz06,
                                            fontWeight: 'bold'),
                                        ...getAllLanguages()
                                            .map((lang) => CheckboxListTile(
                                                  value: selectedLanguages
                                                      .contains(lang),
                                                  title: Text(lang),
                                                  onChanged: (val) {
                                                    setState(() {
                                                      if (val == true) {
                                                        selectedLanguages
                                                            .add(lang);
                                                      } else {
                                                        selectedLanguages
                                                            .remove(lang);
                                                      }
                                                    });
                                                  },
                                                )),
                                        const SizedBox(height: 10),

                                        // Avaliação
                                        AppText(
                                            text: "Avaliação",
                                            fontSize: AppFontSize.fz06,
                                            fontWeight: 'bold'),
                                        Row(
                                          children: List.generate(
                                              5,
                                              (i) => IconButton(
                                                    icon: Icon(
                                                      Icons.star,
                                                      color: selectedRating !=
                                                                  null &&
                                                              selectedRating! >
                                                                  i
                                                          ? Colors.amber
                                                          : Colors.grey,
                                                    ),
                                                    onPressed: () {
                                                      setState(() {
                                                        selectedRating = i + 1;
                                                      });
                                                    },
                                                  )),
                                        ),
                                        const SizedBox(height: 20),

                                        // Botões
                                        Row(
                                          children: [
                                            ElevatedButton(
                                              onPressed: () {
                                                setState(() {
                                                  // selectedAuthors.clear();
                                                  // selectedTitles.clear();
                                                  selectedEditions.clear();
                                                  selectedYears.clear();
                                                  selectedVolumes.clear();
                                                  selectedAreas.clear();
                                                  selectedSubareas.clear();
                                                  selectedTypes.clear();
                                                  selectedLanguages.clear();
                                                  selectedRating = null;
                                                });
                                                applyFilters();
                                              },
                                              child: Text("Limpar"),
                                            ),
                                            const SizedBox(width: 10),
                                            ElevatedButton(
                                              onPressed: applyFilters,
                                              child: Text("Filtrar"),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 20),
                                        child: AppText(
                                          text:
                                              "${booksFiltered.length} resultados encontrados",
                                          fontSize: 16,
                                          color: AppColors.mediumGrey,
                                        ),
                                      ),
                                      GridView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: booksFiltered.length,
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisSpacing: 12,
                                          mainAxisExtent: 300,
                                          mainAxisSpacing: 20,
                                          crossAxisCount: 4,
                                        ),
                                        itemBuilder: (context, index) {
                                          return InkWell(
                                            onTap: () {
                                              // store.setSelectedBook(widget.store.booksFiltered[index]);
                                            },
                                            child: FilteredBookCard(
                                                book: booksFiltered[index]),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  );
                }),
              ),
            ],
          )),
        ));
  }
}
