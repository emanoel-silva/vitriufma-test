import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:vitrine_ufma/app/core/components/custom_textfield.dart';
import 'package:vitrine_ufma/app/core/components/text.dart';
import 'package:vitrine_ufma/app/core/components/text_widget.dart';
import 'package:vitrine_ufma/app/core/constants/colors.dart';
import 'package:vitrine_ufma/app/core/service/local_storage/i_local_storage.dart';
import 'package:vitrine_ufma/app/modules/home/presenter/search/search_store.dart';

class AdvancedSearchPage extends StatefulWidget {
  const AdvancedSearchPage({super.key});

  @override
  State<AdvancedSearchPage> createState() => _AdvancedSearchPageState();
}

class _AdvancedSearchPageState extends State<AdvancedSearchPage> {
  late SearchStore store;
  late ILocalStorage storage;
  late Map boxData;
  late bool isLogged = false;

  // Controladores dos campos de texto e valores de dropdown
  final _yearStartController = TextEditingController();
  final _yearEndController = TextEditingController();

  String _selectedMaterialType = 'Todos os Campos';
  String _selectedLanguage = 'Todos';
  List<String> _selectedFields = ['Tudo'];
  List<String> _selectedOperators = ['E'];
  List<TextEditingController> _customTextControllers = [
    TextEditingController()
  ];

  @override
  void initState() {
    store = Modular.get<SearchStore>();

    storage = Modular.get<ILocalStorage>();
    boxData = storage.getKeyData(boxKey: 'data', dataKey: 'loggedUser');
    isLogged = ((boxData["id"] ?? '')).isNotEmpty;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
        body: SingleChildScrollView(
            child: Column(children: [
      _backButton(),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 40),
        child: Container(
          // constraints: const BoxConstraints(maxWidth: 1200, maxHeight: 800),
          decoration: BoxDecoration(
            color: AppColors.backgroundGrey,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextWidget(
                text: 'Busca Avançada',
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(height: 30),
              // Dropdowns e campos de texto
              ..._selectedFields.asMap().entries.map((entry) {
                int index = entry.key;
                String value = entry.value;
                return _buildDropdownField(
                  'Campo ${index + 1}', 
                  value,
                  (newValue) {
                    setState(() {
                      _selectedFields[index] = newValue!;
                    });
                  }, 
                  controller: _customTextControllers[index],
                  fieldIndex: index,
                );
              }).toList(),
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    _selectedFields.add('Tudo');
                    _customTextControllers.add(TextEditingController());
                    _selectedOperators.add('OU');
                  });
                },
                icon: const Icon(Icons.add),
                label: const Text('Adicionar mais campos'),
              ),
              // Campos de Ano de Publicação
              const SizedBox(
                height: 20,
              ),
              TextWidget(text: 'Ano de Publicação', fontSize: 16),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 400,
                child: Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                  height: 50,
                        hint: '',
                        controller: _yearStartController,
                        icon: false,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text('a'),
                    const SizedBox(width: 10),
                    Expanded(
                      child: CustomTextField(
                  height: 50,
                        controller: _yearEndController,
                        icon: false,
                        hint: '',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              // Tipo de Material

              TextWidget(text: 'Tipo do Material', fontSize: 16),
              const SizedBox(
                height: 10,
              ),
              _buildDropdownField('Tipo do Material', _selectedMaterialType,
                  (value) {
                setState(() {
                  _selectedMaterialType = value!;
                });
              }, options: [
                'Todos os Campos',
                'Atlas',
                'CD-Rom',
                'DVD, Disquete',
                'Dissertação externa',
                'Dissertação UFMA',
                'E-books',
                'Fita cassete',
                'Fita de vídeo',
                'Folheto',
                'Folheto Maranhão',
                'Fotografia',
                'Globo',
                'Gravura',
                'Livro',
                'Mapa',
                'Monografia externa',
                'Monografia UFMA',
                'Não especificado',
                'Partitura',
                'Periódico',
                'Periódico Maranhão',
                'Planta',
                'Publicação externa',
                'Publicação UFMA',
                'Referência',
                'Referência Maranhão, Slide',
                'Tese externa e Tese UFMA'
              ]),
              // Idioma
              const SizedBox(
                height: 10,
              ),
              TextWidget(text: 'Idioma', fontSize: 16),
              const SizedBox(
                height: 10,
              ),
              _buildDropdownField('Idioma', _selectedLanguage, (value) {
                setState(() {
                  _selectedLanguage = value!;
                });
              }, options: ['Todos', 'Português', 'Inglês', 'Espanhol']),
              const SizedBox(height: 30),
              Row(
                children: [
                  Spacer(),
                  _searchButtons(),
                ],
              ),
            ],
          ),
        ),
      )
    ])));
  }

  // Widget para construir os dropdowns do formulário
  Widget _buildDropdownField(
      String label, String selectedValue, ValueChanged<String?> onChanged,
      {List<String> options = const [
        'Tudo',
        'Título',
        'Autor',
        'Assunto',
        'Tag'
      ],
      TextEditingController? controller,
      int? fieldIndex}) {
    // Para campos personalizados (com controller), usar o fieldIndex
    // Para outros campos (sem controller), não mostrar operador
    bool isCustomField = controller != null && options.length == 5;
    bool isLastField = fieldIndex != null && fieldIndex == _selectedFields.length - 1;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(5),
              ),
              child: DropdownButtonFormField<String>(
                value: selectedValue,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  border: InputBorder.none,
                ),
                items: options.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: TextWidget(text: value),
                  );
                }).toList(),
                onChanged: onChanged,
              ),
            ),
          ),
          const SizedBox(width: 10),
          if (controller != null)
            Expanded(
              flex: 2,
              child: CustomTextField(
                icon: false,
                height: 50,
                hint: '',
                controller: controller,
              ),
            ),
          const SizedBox(width: 10),
          // Mostrar operador apenas se for campo personalizado, 
          // houver mais de um campo e NÃO for o último campo
          if (isCustomField && _selectedFields.length > 1 && !isLastField)
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    border: InputBorder.none,
                  ),
                  value: fieldIndex != null ? _selectedOperators[fieldIndex] : null,
                  items: ['E', 'OU', 'NÃO'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: TextWidget(text: value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (fieldIndex != null) {
                      setState(() {
                        _selectedOperators[fieldIndex] = value!;
                      });
                    }
                  },
                ),
              ),
            ),
          // Botão de deletar apenas para campos personalizados com mais de um campo
          if (isCustomField && _selectedFields.length > 1)
            IconButton(
              onPressed: () {
                if (fieldIndex != null) {
                  setState(() {
                    _selectedFields.removeAt(fieldIndex);
                    _customTextControllers.removeAt(fieldIndex);
                    _selectedOperators.removeAt(fieldIndex);
                  });
                }
              },
              icon: const Icon(Icons.delete, color: AppColors.normalRed),
            ),
        ],
      ),
    );
  }

  Widget _searchButtons() {
    String formatField(field) {
      switch (field) {
        case 'Tudo':
          return 'all';
        case 'Título':
          return 'title';
        case 'Autor':
          return 'author';
        case 'Assunto':
          return 'matters';
        case 'Tag':
          return 'tags'; // Corrigido para plural para ser consistente
        default:
          return 'all';
      }
    }

    Map<String, dynamic> buildQueryJson() {
      // Helper function to build nested conditions

      // Lists to store conditions for each operator
      List<Map<String, dynamic>> mainConditions = [];
      List<Map<String, dynamic>> currentOrConditions = [];
      List<Map<String, dynamic>> currentNotConditions = [];

      // Process custom field conditions
      for (int i = 0; i < _selectedFields.length; i++) {
        String field = formatField(_selectedFields[i]);
        String value = _customTextControllers[i].text.trim();
        if (value.isEmpty) continue;

        // Para campos "all", usar a estrutura OR similar ao datasource
        if (field == 'all') {
          Map<String, dynamic> condition = {
            "or": [
              {"title": value},
              {"author": value},
              {"matters": value},
              {"sub_matters": value},
              {"language": value},
              {"tags": value},
              {"isbn": value},
              {"issn": value},
            ]
          };
          
          String operator = _selectedOperators[i];
          switch (operator) {
            case 'E':
              mainConditions.add(condition);
              break;
            case 'OU':
              currentOrConditions.add(condition);
              break;
            case 'NÃO':
              currentNotConditions.add({'not': condition});
              break;
          }
        } else {
          String operator = _selectedOperators[i];
          Map<String, dynamic> condition = {field: value};

          switch (operator) {
            case 'E':
              mainConditions.add(condition);
              break;
            case 'OU':
              currentOrConditions.add(condition);
              break;
            case 'NÃO':
              currentNotConditions.add({'not': condition});
              break;
          }
        }
      }

      // Process year range condition
      String startYear = _yearStartController.text.trim();
      String endYear = _yearEndController.text.trim();
      if (startYear.isNotEmpty || endYear.isNotEmpty) {
        Map<String, dynamic> yearCondition = {};
        if (startYear.isNotEmpty && endYear.isNotEmpty) {
          yearCondition = {
            'and': [
              {
                'publication_year': {'gte': startYear}
              },
              {
                'publication_year': {'lte': endYear}
              }
            ]
          };
        } else if (startYear.isNotEmpty) {
          yearCondition = {
            'publication_year': {'gte': startYear}
          };
        } else if (endYear.isNotEmpty) {
          yearCondition = {
            'publication_year': {'lte': endYear}
          };
        }
        mainConditions.add(yearCondition);
      }

      // Process material type condition
      if (_selectedMaterialType != 'Todos os Campos') {
        mainConditions.add({'type': _selectedMaterialType.toLowerCase()});
      }

      // Process language condition
      if (_selectedLanguage != 'Todos') {
        mainConditions.add({'language': _selectedLanguage.toLowerCase()});
      }

      // Build the final query structure
      Map<String, dynamic> finalQuery = {};

      // Add OR conditions if present
      if (currentOrConditions.isNotEmpty) {
        mainConditions.add({'or': currentOrConditions});
      }

      // Add NOT conditions if present
      mainConditions.addAll(currentNotConditions);

      // Build the final query based on conditions
      if (mainConditions.isEmpty) {
        finalQuery = {
          'query': {'match_all': {}}
        };
      } else if (mainConditions.length == 1) {
        finalQuery = {'query': mainConditions.first};
      } else {
        finalQuery = {
          'query': {'and': mainConditions}
        };
      }

      print("Query construída: $finalQuery");
      return finalQuery;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        InkWell(
          onTap: () {
            // Validação antes de executar a busca
            bool hasValidInput = false;
            
            // Verificar se há campos preenchidos
            for (int i = 0; i < _customTextControllers.length; i++) {
              if (_customTextControllers[i].text.isNotEmpty) {
                hasValidInput = true;
                break;
              }
            }
            
            // Verificar se há filtros de ano
            if (_yearStartController.text.isNotEmpty || _yearEndController.text.isNotEmpty) {
              hasValidInput = true;
            }
            
            // Verificar se há filtros selecionados
            if (_selectedMaterialType != 'Todos os Campos' || _selectedLanguage != 'Todos') {
              hasValidInput = true;
            }
            
            if (!hasValidInput) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Preencha pelo menos um campo de busca'),
                  backgroundColor: Colors.orange,
                ),
              );
              return;
            }
            
            // Verificar se deve usar busca simples (apenas campo "Tudo" preenchido sem outros filtros)
            bool shouldUseSimpleSearch = false;
            if (_selectedFields.length == 1 && _selectedFields[0] == 'Tudo') {
              // Verificar se não há outros filtros aplicados
              bool hasOtherFilters = _yearStartController.text.isNotEmpty || 
                                    _yearEndController.text.isNotEmpty ||
                                    _selectedMaterialType != 'Todos os Campos' ||
                                    _selectedLanguage != 'Todos';
              
              if (!hasOtherFilters) {
                shouldUseSimpleSearch = true;
              }
            }
            
            if (shouldUseSimpleSearch) {
              String searchText = _customTextControllers[0].text.trim();
              if (searchText.isNotEmpty) {
                // Use o store para busca simples para manter consistência
                store.searchController.text = searchText;
                store.search(searchText);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Digite um termo para buscar'),
                    backgroundColor: Colors.orange,
                  ),
                );
              }
              return;
            }
            
            store.advancedSearchMethod(buildQueryJson());
          },
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.blue,
              borderRadius: BorderRadius.circular(50),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                TextWidget(
                  text: 'Buscar',
                  fontSize: 14,
                  color: AppColors.white,
                ),
                const SizedBox(width: 10),
                const Icon(
                  Icons.search,
                  color: AppColors.white,
                  size: 20,
                )
              ],
            ),
          ),
        ),
        const SizedBox(width: 20),
        InkWell(
          onTap: () {
            setState(() {
              // Limpar todos os controladores de texto
              for (var controller in _customTextControllers) {
                controller.clear();
              }
              _yearStartController.clear();
              _yearEndController.clear();
              
              // Resetar valores dos dropdowns
              _selectedMaterialType = 'Todos os Campos';
              _selectedLanguage = 'Todos';
              
              // Resetar campos e operadores para o estado inicial
              _selectedFields = ['Tudo'];
              _selectedOperators = ['E'];
              _customTextControllers = [TextEditingController()];
              
              // Limpar o searchController do store também
              store.searchController.clear();
            });
            
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Campos limpos com sucesso'),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 2),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.yellow,
              borderRadius: BorderRadius.circular(50),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                TextWidget(
                  text: 'Limpar',
                  fontSize: 14,
                  color: AppColors.white,
                ),
                const SizedBox(width: 10),
                const Icon(
                  Icons.clear,
                  color: AppColors.white,
                  size: 20,
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _backButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 70, bottom: 20, top: 20),
      child: Row(
        children: [
          InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
        ],
      ),
    );
  }

  Map<String, dynamic> buildQuery(Map<String, dynamic> condition) {
    if (condition.containsKey('and')) {
      return {
        'and': (condition['and'] as List).map((c) => buildQuery(c)).toList(),
      };
    } else if (condition.containsKey('or')) {
      return {
        'or': (condition['or'] as List).map((c) => buildQuery(c)).toList(),
      };
    } else if (condition.containsKey('not')) {
      return {
        'not': buildQuery(condition['not']),
      };
    } else {
      return condition;
    }
  }
}
