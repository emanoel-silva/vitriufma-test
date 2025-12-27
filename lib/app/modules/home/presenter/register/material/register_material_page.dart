import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:vitrine_ufma/app/core/components/custom_textfield.dart';
import 'package:vitrine_ufma/app/core/components/text.dart';
import 'package:vitrine_ufma/app/core/components/text_widget.dart';
import 'package:vitrine_ufma/app/core/constants/colors.dart';
import 'package:vitrine_ufma/app/core/constants/const.dart';
import 'package:vitrine_ufma/app/core/constants/fonts_sizes.dart';
import 'package:vitrine_ufma/app/core/utils/screen_helper.dart';
import 'package:vitrine_ufma/app/modules/home/domain/entities/book.dart';
import 'package:vitrine_ufma/app/modules/home/presenter/register/components/drag_and_drop.dart';
import 'package:vitrine_ufma/app/modules/home/presenter/register/material/register_material_store.dart';

import '../../../../../core/utils/material_teste_helper.dart';

class RegisterMaterialPage extends StatefulWidget {
  Book? book;
  RegisterMaterialPage({super.key, this.book}) {}

  @override
  State<RegisterMaterialPage> createState() => _RegisterMaterialPageState();
}

class _RegisterMaterialPageState extends State<RegisterMaterialPage> {
  late RegisterMaterialStore store;

  @override
  void initState() {
    super.initState();

    store = Modular.get<RegisterMaterialStore>();

    if (widget.book != null) {
      store.setForm(widget.book!);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isWeb = ScreenHelper.isDesktopOrWeb;
    double screenWidth = MediaQuery.of(context).size.width;
    double formWidth = screenWidth > 1200 ? 1200 : screenWidth * 0.9;
    double columnWidth =
        (formWidth - 100) / 2; // Subtract padding and space between columns

    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: AppColors.backgroundGrey,
            constraints: BoxConstraints(maxWidth: formWidth),
            padding: EdgeInsets.symmetric(
              horizontal:
                  isWeb ? AppConst.sidePadding * 2 : AppConst.sidePadding,
              vertical: AppConst.sidePadding,
            ),
            child: Observer(builder: (_) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _backButton(),
                  const SizedBox(height: 20),
                  TextWidget(
                    text: widget.book != null
                        ? 'Editar Material'
                        : 'Cadastrar novo material',
                    fontSize: AppFontSize.fz10,
                    fontWeight: FontWeight.bold,
                  ),
                  const SizedBox(height: 30),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Left Column
                      SizedBox(
                        width: columnWidth,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildField(
                              label: 'Título',
                              optional: false,
                              isValid: store.isTitleValid,
                              hint: 'Exemplo',
                              controller: store.titleController,
                              validationField: 'title',
                              width: columnWidth,
                            ),
                            _buildField(
                              label: 'Autor',
                              optional: false,
                              isValid: store.isAuthorValid,
                              hint: 'Gonçaves Dias, etc',
                              controller: store.author1Controller,
                              validationField: 'author',
                              width: columnWidth,
                            ),
                            _buildField(
                              label: 'Edição',
                              keyBoardType: TextInputType.number,
                              hint: '1 ed.',
                              controller: store.editionController,
                              validationField: 'edition',
                              width: columnWidth,
                            ),
                            _buildField(
                              label: 'Local de publicação',
                              hint: 'Porto Alegre',
                              controller: store.publicationLocationController,
                              validationField: 'publication_location',
                              width: columnWidth,
                            ),
                            _buildField(
                              label: 'Ano de publicação',
                              keyBoardType: TextInputType.number,
                              optional: false,
                              isValid: store.isPublicationYearValid,
                              hint: '2011',
                              controller: store.publicationYearController,
                              validationField: 'publication_year',
                              width: columnWidth,
                            ),
                            _buildField(
                              label: 'Editora',
                              optional: false,
                              isValid: store.isEditingValid,
                              hint: 'Exemplo',
                              controller: store.editingController,
                              validationField: 'editing',
                              width: columnWidth,
                            ),
                            _buildField(
                              label: 'Número de páginas',
                              keyBoardType: TextInputType.number,
                              optional: false,
                              isValid: store.isPageNumbersValid,
                              hint: '140',
                              controller: store.pageNumbersController,
                              validationField: 'page_numbers',
                              width: columnWidth,
                            ),
                            _buildField(
                              label: 'ISBN',
                              optional: false,
                              isValid: store.isIsbnValid,
                              hint: '0000000000000',
                              controller: store.isbnController,
                              validationField: 'isbn',
                              width: columnWidth,
                            ),
                            _buildField(
                              label: 'Volume',
                              keyBoardType: TextInputType.number,
                              hint: '1',
                              controller: store.volumeController,
                              validationField: 'volume',
                              width: columnWidth,
                            ),
                            _buildField(
                              label: 'Assunto',
                              optional: false,
                              isValid: store.isSubjectValid,
                              hint: 'Enfermagem, Medicina, etc',
                              controller: store.subject1Controller,
                              validationField: 'subject',
                              width: formWidth - 40,
                            ),
                            Container(
                              padding: const EdgeInsets.only(bottom: 20),
                              width: columnWidth,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextWidget(
                                    text: 'Adicionar na exposição temática',
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Observer(builder: (_) {
                                        return Switch(
                                          value: store.isThematic,
                                          onChanged: (bool value) {
                                            store.setIsThematic(value);
                                          },
                                          activeColor: AppColors.blue,
                                        );
                                      }),
                                      Observer(builder: (_) {
                                        return TextWidget(
                                          text:
                                              store.isThematic ? 'Sim' : 'Não',
                                          fontSize: 14,
                                        );
                                      }),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Right Column
                      SizedBox(
                        width: columnWidth,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildField(
                              label: 'Tipo de material',
                              optional: false,
                              isValid: store.isMaterialTypeValid,
                              hint: 'Livro',
                              controller: store.materialTypeController,
                              validationField: 'material_type',
                              width: columnWidth,
                            ),
                            _buildField(
                              label: 'Idioma',
                              optional: false,
                              isValid: store.isLanguageValid,
                              hint: 'Português',
                              controller: store.languageController,
                              validationField: 'language',
                              width: columnWidth,
                            ),
                            _buildField(
                              label: 'Área de conhecimento',
                              optional: false,
                              isValid: store.isKnolwedgeAreaValid,
                              hint:
                                  'Ciências Exatas e da Terra, Ciências Biológicas, etc',
                              controller: store.knolwedgeArea1Controller,
                              validationField: 'knowledge_area',
                              width: columnWidth,
                            ),
                            _buildField(
                              label: 'Subárea de conhecimento',
                              isValid: store.isSubKnolwedgeAreaValid,
                              optional: false,
                              hint: 'Matemática, Física, etc',
                              controller: store.subKnolwedgeArea1Controller,
                              validationField: 'sub_knowledge_area',
                              width: columnWidth,
                            ),
                            _buildField(
                              label: 'Endereço eletrônico',
                              hint: 'http://www.exemplo.com.br',
                              controller: store.emailController,
                              validationField: 'email',
                              width: columnWidth,
                            ),
                            _buildField(
                              label: 'Disponibilidade',
                              hint: 'http://www.exemplo.com.br',
                              controller: store.avaliabilityController,
                              validationField: 'avaliability',
                              width: columnWidth,
                            ),
                            _buildFieldAnex(
                                label: 'Capa do livro',
                                isValid: store.isCoverImageValid,
                                cover: true),
                            _buildFieldAnex(
                                label: 'Sumário',
                                isValid: store.isSumaryValid,
                                cover: false),
                            _buildField(
                              label: 'Descrição da Imagem (Alt Text)',
                              hint: 'Descrição para acessibilidade',
                              controller: store.altTextController,
                              width: columnWidth,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // Bottom fields that span full width
                  _buildLargeField(
                    label: 'Resumo',
                    isValid: store.isResumeValid,
                    optional: false,
                    controller: store.resumeController,
                    validationField: 'resume',
                    width: formWidth - 40,
                  ),
                  const SizedBox(height: 20),
                  // Save button and Test button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Botão de Teste (Debug)
                      InkWell(
                        onTap: () async {
                          // Mostrar diálogo de confirmação
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Row(
                                children: const [
                                  Icon(Icons.science, color: AppColors.blue),
                                  SizedBox(width: 8),
                                  Text('Cadastrar Materiais de Teste'),
                                ],
                              ),
                              content: const Text(
                                'Deseja cadastrar materiais de teste no sistema?\n\n'
                                'Isso irá adicionar 10 materiais de exemplo de diferentes áreas.',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(false),
                                  child: const Text('Cancelar'),
                                ),
                                ElevatedButton(
                                  onPressed: () => Navigator.of(context).pop(true),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.blue,
                                  ),
                                  child: const Text('Cadastrar'),
                                ),
                              ],
                            ),
                          );

                          if (confirm == true) {
                            // Mostrar loading
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) => const Center(
                                child: CircularProgressIndicator(),
                              ),
                            );

                            // Cadastrar materiais
                            final resultado = await MaterialTesteHelper.cadastrarMaterialTeste();

                            // Fechar loading
                            Navigator.of(context).pop();

                            // Mostrar resultado
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  '${resultado['success']} materiais cadastrados com sucesso!\n'
                                  'Erros: ${resultado['error']}',
                                ),
                                backgroundColor: resultado['error'] == 0
                                    ? Colors.green
                                    : Colors.orange,
                                duration: const Duration(seconds: 4),
                              ),
                            );
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.science,
                                color: AppColors.white,
                                size: 16,
                              ),
                              const SizedBox(width: 8),
                              TextWidget(
                                text: 'Cadastrar Teste',
                                fontSize: 14,
                                color: AppColors.white,
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Botão Salvar
                      
                      InkWell(
                        onTap: () async {
                          if (store.validateFields()) {
                            if (widget.book != null) {
                              //TODO: await store.updateBook();
                            } else {
                              await store.saveBook();
                            }
                          }
                        },
                        child: Container(
                          width: 100,
                          decoration: BoxDecoration(
                            color: AppColors.blue,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          child: Observer(builder: (context) {
                            if (store.loading) {
                              return const SizedBox(
                                width: 16,
                                height: 16,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: AppColors.white,
                                    strokeWidth: 2,
                                  ),
                                ),
                              );
                            }
                            return TextWidget(
                              text: 'Salvar',
                              fontSize: 14,
                              color: AppColors.white,
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required String label,
    String? hint,
    bool optional = true,
    bool isValid = false,
    TextEditingController? controller,
    TextInputType? keyBoardType,
    double? width,
    String? validationField,
  }) {
    return Container(
      padding: const EdgeInsets.only(bottom: 20),
      width: width ?? 350, // Set a default width
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              TextWidget(
                text: label,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              if (!optional)
                TextWidget(
                  text: ' *',
                  fontSize: 16,
                  color: AppColors.normalRed,
                ),
            ],
          ),
          const SizedBox(height: 6),
          Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(5),
              border: !isValid && !optional
                  ? Border.all(color: AppColors.normalRed)
                  : Border.all(color: Colors.transparent),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextField(
                  controller: controller,
                  keyBoardType: keyBoardType,
                  icon: false,
                  hint: hint ?? '',
                  onTap: () {
                    if (validationField != null && controller != null) {
                      store.validateField(validationField, controller.text);
                    }
                  },
                ),
                if (!isValid && !optional)
                  Padding(
                    padding: const EdgeInsets.only(left: 12, top: 4, bottom: 4),
                    child: TextWidget(
                      text: _getErrorMessage(validationField ?? label),
                      fontSize: 12,
                      color: AppColors.normalRed,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getErrorMessage(String field) {
    switch (field) {
      case 'title':
        return 'O título é obrigatório';
      case 'author':
        return 'O autor é obrigatório';
      case 'publication_year':
        return 'Ano de publicação inválido';
      case 'isbn':
        return 'ISBN inválido (deve ter 10 ou 13 dígitos)';
      case 'page_numbers':
        return 'Número de páginas inválido';
      case 'material_type':
        return 'Tipo de material é obrigatório';
      case 'language':
        return 'Idioma é obrigatório';
      case 'knowledge_area':
        return 'Área de conhecimento é obrigatória';
      case 'sub_knowledge_area':
        return 'Subárea de conhecimento é obrigatória';
      case 'subject':
        return 'Assunto é obrigatório';
      default:
        return 'Campo obrigatório';
    }
  }

  Widget _buildLargeField({
    required String label,
    TextEditingController? controller,
    bool isValid = false,
    bool optional = true,
    String? validationField,
    double? width,
  }) {
    return Container(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              TextWidget(
                text: label,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              if (!optional)
                TextWidget(
                  text: ' *',
                  fontSize: 16,
                  color: AppColors.normalRed,
                ),
            ],
          ),
          const SizedBox(height: 5),
          Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(5),
              border: !isValid && !optional
                  ? Border.all(color: AppColors.normalRed)
                  : Border.all(color: Colors.transparent),
            ),
            width: width ?? 650,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextField(
                  controller: controller,
                  height: 100,
                  icon: false,
                  hint: '',
                  onTap: () {
                    if (validationField != null && controller != null) {
                      store.validateField(validationField, controller.text);
                    }
                  },
                  maxLines: 10,
                ),
                if (!isValid && !optional)
                  Padding(
                    padding: const EdgeInsets.only(left: 12, top: 4, bottom: 4),
                    child: TextWidget(
                      text: _getErrorMessage(validationField ?? label),
                      fontSize: 12,
                      color: AppColors.normalRed,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFieldAnex(
      {required String label, bool cover = true, bool isValid = false}) {
    return Container(
      padding: EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextWidget(
            text: label,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 5),
          DragAndDrop(store: store, cover: cover, isValid: !isValid)
        ],
      ),
    );
  }

  Widget _backButton() {
    return InkWell(
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
    );
  }
}
