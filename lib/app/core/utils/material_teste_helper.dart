import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:vitrine_ufma/app/modules/home/domain/usecases/post_material_usecase.dart';

/// Classe para cadastrar materiais de teste usando o sistema interno
/// 
/// Esta classe utiliza o PostMaterialUsecase do próprio app para
/// cadastrar materiais de teste diretamente.
/// 
/// Uso:
/// 1. Certifique-se de estar autenticado no sistema
/// 2. Chame MaterialTesteHelper.cadastrarMaterialTeste()
/// 3. Os materiais serão cadastrados automaticamente

class MaterialTesteHelper {
  static final IPostMaterialUsecase _postMaterialUsecase =
      Modular.get<IPostMaterialUsecase>();

  /// Lista de materiais de teste pré-configurados
  static List<Map<String, dynamic>> getMaterialsTeste() {
    return [
      // Material 1 - Livro de Matemática
      {
        "title": "Cálculo Diferencial e Integral - Volume 1",
        "author": ["James Stewart"],
        "publication_year": "2013",
        "cover_image": "https://picsum.photos/seed/calc1/400/600",
        "abstract":
            "Este livro apresenta os conceitos fundamentais do cálculo diferencial e integral de forma clara e rigorosa, com aplicações em diversas áreas da ciência e engenharia.",
        "matters": ["Ciências Exatas e da Terra", "Matemática"],
        "sub_matters": ["Cálculo", "Análise Matemática"],
        "address": "http://www.exemplo.com.br/calculo1",
        "summary": "http://www.exemplo.com.br/calculo1_sumario.pdf",
        "availability": "Disponível para empréstimo",
        "tags": ["cálculo", "matemática", "derivadas", "integrais"],
        "number_of_pages": "536",
        "isbn": "9788522112586",
        "issn": "",
        "typer": "Livro",
        "language": "Português",
        "publisher": "Cengage Learning",
        "volume": 1,
        "series": "0",
        "edition": "7ª edição",
        "reprint_update": "2013",
      },

      // Material 2 - Livro de Física
      {
        "title": "Física para Cientistas e Engenheiros - Volume 1",
        "author": ["Paul A. Tipler", "Gene Mosca"],
        "publication_year": "2009",
        "cover_image": "https://picsum.photos/seed/fisica1/400/600",
        "abstract":
            "Uma abordagem completa e moderna da física clássica, com ênfase em problemas e aplicações do mundo real.",
        "matters": ["Ciências Exatas e da Terra", "Física"],
        "sub_matters": ["Mecânica Clássica", "Termodinâmica"],
        "address": "http://www.exemplo.com.br/fisica1",
        "summary": "http://www.exemplo.com.br/fisica1_sumario.pdf",
        "availability": "Disponível online",
        "tags": ["física", "mecânica", "termodinâmica", "movimento"],
        "number_of_pages": "788",
        "isbn": "9788521617105",
        "issn": "",
        "typer": "Livro",
        "language": "Português",
        "publisher": "LTC",
        "volume": 1,
        "series": "0",
        "edition": "6ª edição",
        "reprint_update": "2009",
      },

      // Material 3 - Livro de Programação
      {
        "title": "Algoritmos e Estruturas de Dados em Python",
        "author": [
          "Michael T. Goodrich",
          "Roberto Tamassia",
          "Michael H. Goldwasser"
        ],
        "publication_year": "2015",
        "cover_image": "https://picsum.photos/seed/python1/400/600",
        "abstract":
            "Uma introdução abrangente aos algoritmos e estruturas de dados usando a linguagem Python, com exemplos práticos e exercícios.",
        "matters": ["Ciências Exatas e da Terra", "Ciência da Computação"],
        "sub_matters": ["Algoritmos", "Programação", "Estruturas de Dados"],
        "address": "http://www.exemplo.com.br/algoritmos-python",
        "summary": "http://www.exemplo.com.br/algoritmos-python_sumario.pdf",
        "availability": "Disponível na biblioteca digital",
        "tags": ["python", "algoritmos", "estruturas de dados", "programação"],
        "number_of_pages": "748",
        "isbn": "9788582603260",
        "issn": "",
        "typer": "Livro",
        "language": "Português",
        "publisher": "Bookman",
        "volume": 0,
        "series": "0",
        "edition": "1ª edição",
        "reprint_update": "2015",
      },

      // Material 4 - Artigo Científico
      {
        "title":
            "Inteligência Artificial aplicada à Educação: Uma Revisão Sistemática",
        "author": ["Maria Silva Santos", "João Pedro Oliveira"],
        "publication_year": "2023",
        "cover_image": "https://picsum.photos/seed/ia1/400/600",
        "abstract":
            "Este artigo apresenta uma revisão sistemática sobre o uso de inteligência artificial em ambientes educacionais, destacando as principais aplicações e desafios.",
        "matters": ["Ciências Exatas e da Terra", "Ciência da Computação"],
        "sub_matters": ["Inteligência Artificial", "Educação"],
        "address": "http://www.exemplo.com.br/ia-educacao",
        "summary": "http://www.exemplo.com.br/ia-educacao_sumario.pdf",
        "availability": "Acesso livre",
        "tags": [
          "inteligência artificial",
          "educação",
          "machine learning",
          "revisão"
        ],
        "number_of_pages": "24",
        "isbn": "",
        "issn": "2179-8435",
        "typer": "Artigo",
        "language": "Português",
        "publisher": "Revista Brasileira de Informática na Educação",
        "volume": 31,
        "series": "0",
        "edition": "2",
        "reprint_update": "2023",
      },

      // Material 5 - Livro de Química
      {
        "title": "Química Orgânica - Fundamentos e Aplicações",
        "author": ["John McMurry"],
        "publication_year": "2016",
        "cover_image": "https://picsum.photos/seed/quimica1/400/600",
        "abstract":
            "Obra completa sobre química orgânica, cobrindo desde conceitos básicos até reações complexas e síntese orgânica.",
        "matters": ["Ciências Exatas e da Terra", "Química"],
        "sub_matters": ["Química Orgânica"],
        "address": "http://www.exemplo.com.br/quimica-organica",
        "summary": "http://www.exemplo.com.br/quimica-organica_sumario.pdf",
        "availability": "Disponível para consulta",
        "tags": ["química", "química orgânica", "reações", "síntese"],
        "number_of_pages": "1260",
        "isbn": "9788522123407",
        "issn": "",
        "typer": "Livro",
        "language": "Português",
        "publisher": "Cengage Learning",
        "volume": 0,
        "series": "0",
        "edition": "9ª edição",
        "reprint_update": "2016",
      },

      // Material 6 - Livro de Literatura
      {
        "title": "Dom Casmurro",
        "author": ["Machado de Assis"],
        "publication_year": "2008",
        "cover_image": "https://picsum.photos/seed/domcasmurro/400/600",
        "abstract":
            "Obra-prima da literatura brasileira que narra a história de Bentinho e Capitu, explorando temas como ciúme, memória e narrativa não confiável.",
        "matters": ["Linguística, Letras e Artes", "Literatura Brasileira"],
        "sub_matters": ["Romance", "Literatura Clássica"],
        "address": "http://www.exemplo.com.br/dom-casmurro",
        "summary": "http://www.exemplo.com.br/dom-casmurro_sumario.pdf",
        "availability": "Domínio público",
        "tags": ["literatura", "machado de assis", "romance", "clássico"],
        "number_of_pages": "256",
        "isbn": "9788535911664",
        "issn": "",
        "typer": "Livro",
        "language": "Português",
        "publisher": "Companhia das Letras",
        "volume": 0,
        "series": "0",
        "edition": "Edição crítica",
        "reprint_update": "2008",
      },

      // Material 7 - Livro de Biologia
      {
        "title": "Biologia Molecular da Célula",
        "author": ["Bruce Alberts", "Alexander Johnson", "Julian Lewis"],
        "publication_year": "2017",
        "cover_image": "https://picsum.photos/seed/biologia1/400/600",
        "abstract":
            "Texto fundamental sobre biologia celular e molecular, abordando estrutura celular, genética molecular e processos bioquímicos.",
        "matters": ["Ciências Biológicas", "Biologia Celular"],
        "sub_matters": ["Biologia Molecular", "Genética"],
        "address": "http://www.exemplo.com.br/biologia-molecular",
        "summary": "http://www.exemplo.com.br/biologia-molecular_sumario.pdf",
        "availability": "Disponível na biblioteca",
        "tags": ["biologia", "célula", "genética", "molecular"],
        "number_of_pages": "1464",
        "isbn": "9788582714065",
        "issn": "",
        "typer": "Livro",
        "language": "Português",
        "publisher": "Artmed",
        "volume": 0,
        "series": "0",
        "edition": "6ª edição",
        "reprint_update": "2017",
      },

      // Material 8 - Livro de História
      {
        "title": "História do Brasil Contemporâneo",
        "author": ["Boris Fausto"],
        "publication_year": "2012",
        "cover_image": "https://picsum.photos/seed/historia1/400/600",
        "abstract":
            "Análise abrangente da história do Brasil desde a República até os dias atuais, com foco em aspectos políticos, econômicos e sociais.",
        "matters": ["Ciências Humanas", "História"],
        "sub_matters": ["História do Brasil", "História Contemporânea"],
        "address": "http://www.exemplo.com.br/historia-brasil",
        "summary": "http://www.exemplo.com.br/historia-brasil_sumario.pdf",
        "availability": "Disponível",
        "tags": ["história", "brasil", "república", "política"],
        "number_of_pages": "688",
        "isbn": "9788520010914",
        "issn": "",
        "typer": "Livro",
        "language": "Português",
        "publisher": "Edusp",
        "volume": 0,
        "series": "0",
        "edition": "2ª edição",
        "reprint_update": "2012",
      },

      // Material 9 - Livro de Filosofia
      {
        "title": "O Mundo de Sofia",
        "author": ["Jostein Gaarder"],
        "publication_year": "1995",
        "cover_image": "https://picsum.photos/seed/filosofia1/400/600",
        "abstract":
            "Romance filosófico que apresenta a história da filosofia de forma acessível através da jornada de Sofia, uma jovem de 14 anos.",
        "matters": ["Ciências Humanas", "Filosofia"],
        "sub_matters": ["História da Filosofia", "Filosofia para Jovens"],
        "address": "http://www.exemplo.com.br/mundo-sofia",
        "summary": "http://www.exemplo.com.br/mundo-sofia_sumario.pdf",
        "availability": "Disponível",
        "tags": ["filosofia", "romance", "educação", "história"],
        "number_of_pages": "560",
        "isbn": "9788535902570",
        "issn": "",
        "typer": "Livro",
        "language": "Português",
        "publisher": "Companhia das Letras",
        "volume": 0,
        "series": "0",
        "edition": "1ª edição",
        "reprint_update": "1995",
      },

      // Material 10 - Livro de Engenharia
      {
        "title": "Resistência dos Materiais",
        "author": ["Ferdinand P. Beer", "E. Russell Johnston Jr."],
        "publication_year": "2011",
        "cover_image": "https://picsum.photos/seed/eng1/400/600",
        "abstract":
            "Texto clássico sobre resistência dos materiais, abordando conceitos fundamentais de tensão, deformação e comportamento mecânico de estruturas.",
        "matters": ["Engenharias", "Engenharia Civil"],
        "sub_matters": ["Mecânica dos Sólidos", "Estruturas"],
        "address": "http://www.exemplo.com.br/resistencia-materiais",
        "summary": "http://www.exemplo.com.br/resistencia-materiais_sumario.pdf",
        "availability": "Disponível na biblioteca",
        "tags": ["engenharia", "resistência", "materiais", "estruturas"],
        "number_of_pages": "800",
        "isbn": "9788563308337",
        "issn": "",
        "typer": "Livro",
        "language": "Português",
        "publisher": "McGraw-Hill",
        "volume": 0,
        "series": "0",
        "edition": "5ª edição",
        "reprint_update": "2011",
      },
    ];
  }

  /// Cadastra um único material de teste
  static Future<bool> cadastrarMaterial(Map<String, dynamic> material) async {
    try {
      debugPrint('📚 Cadastrando: ${material['title']}');

      // Garantir que listas vazias sejam arrays e não null
      material['tags'] = material['tags'] ?? [];
      material['matters'] = material['matters'] ?? [];
      material['sub_matters'] = material['sub_matters'] ?? [];
      material['author'] = material['author'] ?? [];
      
      // Garantir que campos string vazios sejam strings
      material['isbn'] = material['isbn'] ?? "";
      material['issn'] = material['issn'] ?? "";
      material['address'] = material['address'] ?? "";
      material['availability'] = material['availability'] ?? "";
      material['reprint_update'] = material['reprint_update'] ?? "";

      final result = await _postMaterialUsecase.call(material);

      return result.fold(
        (error) {
          debugPrint('❌ Erro ao cadastrar ${material['title']}: $error');
          return false;
        },
        (response) {
          debugPrint('✅ Material cadastrado: ${material['title']}');
          return true;
        },
      );
    } catch (e) {
      debugPrint('❌ Exceção ao cadastrar ${material['title']}: $e');
      return false;
    }
  }

  /// Cadastra todos os materiais de teste
  static Future<Map<String, int>> cadastrarMaterialTeste() async {
    debugPrint('═══════════════════════════════════════════════════════');
    debugPrint('🚀 Iniciando cadastro de materiais de teste');
    debugPrint('═══════════════════════════════════════════════════════\n');

    final materials = getMaterialsTeste();
    int successCount = 0;
    int errorCount = 0;

    for (int i = 0; i < materials.length; i++) {
      debugPrint('[${i + 1}/${materials.length}] Processando...');

      final success = await cadastrarMaterial(materials[i]);

      if (success) {
        successCount++;
      } else {
        errorCount++;
      }

      // Delay entre requisições
      if (i < materials.length - 1) {
        await Future.delayed(Duration(milliseconds: 500));
      }
    }

    debugPrint('\n═══════════════════════════════════════════════════════');
    debugPrint('📊 RESUMO DO CADASTRO');
    debugPrint('═══════════════════════════════════════════════════════');
    debugPrint('✅ Sucesso: $successCount materiais');
    debugPrint('❌ Erros: $errorCount materiais');
    debugPrint('📚 Total: ${materials.length} materiais');
    debugPrint('═══════════════════════════════════════════════════════');

    return {
      'success': successCount,
      'error': errorCount,
      'total': materials.length,
    };
  }

  /// Cadastra apenas N materiais (útil para testes)
  static Future<Map<String, int>> cadastrarNMateriais(int quantidade) async {
    debugPrint('═══════════════════════════════════════════════════════');
    debugPrint('🚀 Cadastrando $quantidade material(is) de teste');
    debugPrint('═══════════════════════════════════════════════════════\n');

    final materials = getMaterialsTeste().take(quantidade).toList();
    int successCount = 0;
    int errorCount = 0;

    for (int i = 0; i < materials.length; i++) {
      debugPrint('[${i + 1}/${materials.length}] Processando...');

      final success = await cadastrarMaterial(materials[i]);

      if (success) {
        successCount++;
      } else {
        errorCount++;
      }

      if (i < materials.length - 1) {
        await Future.delayed(Duration(milliseconds: 500));
      }
    }

    debugPrint('\n═══════════════════════════════════════════════════════');
    debugPrint('📊 RESUMO DO CADASTRO');
    debugPrint('═══════════════════════════════════════════════════════');
    debugPrint('✅ Sucesso: $successCount materiais');
    debugPrint('❌ Erros: $errorCount materiais');
    debugPrint('📚 Total: ${materials.length} materiais');
    debugPrint('═══════════════════════════════════════════════════════');

    return {
      'success': successCount,
      'error': errorCount,
      'total': materials.length,
    };
  }
}