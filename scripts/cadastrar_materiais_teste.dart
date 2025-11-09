import 'dart:convert';
import 'package:http/http.dart' as http;

/// Script para cadastrar materiais de teste no sistema
/// 
/// Este script utiliza o endpoint de cadastro de materiais informacionais
/// para criar dados de teste no sistema.
/// 
/// Uso:
/// 1. Certifique-se de ter o token de autenticação válido
/// 2. Configure a URL da API e o token
/// 3. Execute: dart run scripts/cadastrar_materiais_teste.dart

class MaterialTestRegistration {
  final String apiUrl;
  final String authToken;

  MaterialTestRegistration({
    required this.apiUrl,
    required this.authToken,
  });

  /// Cadastra um material informacional no sistema
  Future<void> postInfoMaterial(Map<String, dynamic> data) async {
    try {
      final url = Uri.parse('$apiUrl/informational-material');
      
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        print('✅ Material cadastrado com sucesso!');
        print('   ID: ${result['id'] ?? 'N/A'}');
        print('   Título: ${data['title']}');
      } else {
        print('❌ Erro ao cadastrar material: ${data['title']}');
        print('   Status: ${response.statusCode}');
        print('   Resposta: ${response.body}');
      }
    } catch (e) {
      print('❌ Exceção ao cadastrar material: ${data['title']}');
      print('   Erro: $e');
    }
  }

  /// Retorna lista de materiais de teste
  List<Map<String, dynamic>> getMaterialsTesteData() {
    return [
      // Material 1 - Livro de Matemática
      {
        "title": "Cálculo Diferencial e Integral - Volume 1",
        "author": ["James Stewart"],
        "publication_year": "2013",
        "cover_image": "https://example.com/images/calculo1.jpg",
        "abstract": "Este livro apresenta os conceitos fundamentais do cálculo diferencial e integral de forma clara e rigorosa, com aplicações em diversas áreas da ciência e engenharia.",
        "matters": ["Ciências Exatas e da Terra", "Matemática"],
        "sub_matters": ["Cálculo", "Análise Matemática"],
        "address": "http://www.exemplo.com.br/calculo1",
        "summary": "http://www.exemplo.com.br/calculo1_sumario.pdf",
        "availability": "Disponível para empréstimo",
        "tags": ["cálculo", "matemática", "derivadas", "integrais"],
        "number_of_pages": 536,
        "isbn": "9788522112586",
        "issn": "",
        "typer": "Livro",
        "language": "Português",
        "publisher": "Cengage Learning",
        "volume": "1",
        "series": "Cálculo",
        "edition": "7ª edição",
        "reprint_update": "2013",
      },

      // Material 2 - Livro de Física
      {
        "title": "Física para Cientistas e Engenheiros - Volume 1",
        "author": ["Paul A. Tipler", "Gene Mosca"],
        "publication_year": "2009",
        "cover_image": "https://example.com/images/fisica1.jpg",
        "abstract": "Uma abordagem completa e moderna da física clássica, com ênfase em problemas e aplicações do mundo real.",
        "matters": ["Ciências Exatas e da Terra", "Física"],
        "sub_matters": ["Mecânica Clássica", "Termodinâmica"],
        "address": "http://www.exemplo.com.br/fisica1",
        "summary": "http://www.exemplo.com.br/fisica1_sumario.pdf",
        "availability": "Disponível online",
        "tags": ["física", "mecânica", "termodinâmica", "movimento"],
        "number_of_pages": 788,
        "isbn": "9788521617105",
        "issn": "",
        "typer": "Livro",
        "language": "Português",
        "publisher": "LTC",
        "volume": "1",
        "series": "Física para Cientistas",
        "edition": "6ª edição",
        "reprint_update": "2009",
      },

      // Material 3 - Livro de Programação
      {
        "title": "Algoritmos e Estruturas de Dados em Python",
        "author": ["Michael T. Goodrich", "Roberto Tamassia", "Michael H. Goldwasser"],
        "publication_year": "2015",
        "cover_image": "https://example.com/images/algoritmos_python.jpg",
        "abstract": "Uma introdução abrangente aos algoritmos e estruturas de dados usando a linguagem Python, com exemplos práticos e exercícios.",
        "matters": ["Ciências Exatas e da Terra", "Ciência da Computação"],
        "sub_matters": ["Algoritmos", "Programação", "Estruturas de Dados"],
        "address": "http://www.exemplo.com.br/algoritmos-python",
        "summary": "http://www.exemplo.com.br/algoritmos-python_sumario.pdf",
        "availability": "Disponível na biblioteca digital",
        "tags": ["python", "algoritmos", "estruturas de dados", "programação"],
        "number_of_pages": 748,
        "isbn": "9788582603260",
        "issn": "",
        "typer": "Livro",
        "language": "Português",
        "publisher": "Bookman",
        "volume": "0",
        "series": "",
        "edition": "1ª edição",
        "reprint_update": "2015",
      },

      // Material 4 - Artigo Científico
      {
        "title": "Inteligência Artificial aplicada à Educação: Uma Revisão Sistemática",
        "author": ["Maria Silva Santos", "João Pedro Oliveira"],
        "publication_year": "2023",
        "cover_image": "https://example.com/images/ia_educacao.jpg",
        "abstract": "Este artigo apresenta uma revisão sistemática sobre o uso de inteligência artificial em ambientes educacionais, destacando as principais aplicações e desafios.",
        "matters": ["Ciências Exatas e da Terra", "Ciência da Computação"],
        "sub_matters": ["Inteligência Artificial", "Educação"],
        "address": "http://www.exemplo.com.br/ia-educacao",
        "summary": "http://www.exemplo.com.br/ia-educacao_sumario.pdf",
        "availability": "Acesso livre",
        "tags": ["inteligência artificial", "educação", "machine learning", "revisão"],
        "number_of_pages": 24,
        "isbn": "",
        "issn": "2179-8435",
        "typer": "Artigo",
        "language": "Português",
        "publisher": "Revista Brasileira de Informática na Educação",
        "volume": "31",
        "series": "",
        "edition": "2",
        "reprint_update": "2023",
      },

      // Material 5 - Livro de Química
      {
        "title": "Química Orgânica - Fundamentos e Aplicações",
        "author": ["John McMurry"],
        "publication_year": "2016",
        "cover_image": "https://example.com/images/quimica_organica.jpg",
        "abstract": "Obra completa sobre química orgânica, cobrindo desde conceitos básicos até reações complexas e síntese orgânica.",
        "matters": ["Ciências Exatas e da Terra", "Química"],
        "sub_matters": ["Química Orgânica"],
        "address": "http://www.exemplo.com.br/quimica-organica",
        "summary": "http://www.exemplo.com.br/quimica-organica_sumario.pdf",
        "availability": "Disponível para consulta",
        "tags": ["química", "química orgânica", "reações", "síntese"],
        "number_of_pages": 1260,
        "isbn": "9788522123407",
        "issn": "",
        "typer": "Livro",
        "language": "Português",
        "publisher": "Cengage Learning",
        "volume": "0",
        "series": "",
        "edition": "9ª edição",
        "reprint_update": "2016",
      },

      // Material 6 - Livro de Literatura
      {
        "title": "Dom Casmurro",
        "author": ["Machado de Assis"],
        "publication_year": "2008",
        "cover_image": "https://example.com/images/dom_casmurro.jpg",
        "abstract": "Obra-prima da literatura brasileira que narra a história de Bentinho e Capitu, explorando temas como ciúme, memória e narrativa não confiável.",
        "matters": ["Linguística, Letras e Artes", "Literatura Brasileira"],
        "sub_matters": ["Romance", "Literatura Clássica"],
        "address": "http://www.exemplo.com.br/dom-casmurro",
        "summary": "http://www.exemplo.com.br/dom-casmurro_sumario.pdf",
        "availability": "Domínio público",
        "tags": ["literatura", "machado de assis", "romance", "clássico"],
        "number_of_pages": 256,
        "isbn": "9788535911664",
        "issn": "",
        "typer": "Livro",
        "language": "Português",
        "publisher": "Companhia das Letras",
        "volume": "0",
        "series": "",
        "edition": "Edição crítica",
        "reprint_update": "2008",
      },

      // Material 7 - Livro de Biologia
      {
        "title": "Biologia Molecular da Célula",
        "author": ["Bruce Alberts", "Alexander Johnson", "Julian Lewis"],
        "publication_year": "2017",
        "cover_image": "https://example.com/images/biologia_molecular.jpg",
        "abstract": "Texto fundamental sobre biologia celular e molecular, abordando estrutura celular, genética molecular e processos bioquímicos.",
        "matters": ["Ciências Biológicas", "Biologia Celular"],
        "sub_matters": ["Biologia Molecular", "Genética"],
        "address": "http://www.exemplo.com.br/biologia-molecular",
        "summary": "http://www.exemplo.com.br/biologia-molecular_sumario.pdf",
        "availability": "Disponível na biblioteca",
        "tags": ["biologia", "célula", "genética", "molecular"],
        "number_of_pages": 1464,
        "isbn": "9788582714065",
        "issn": "",
        "typer": "Livro",
        "language": "Português",
        "publisher": "Artmed",
        "volume": "0",
        "series": "",
        "edition": "6ª edição",
        "reprint_update": "2017",
      },

      // Material 8 - Livro de História
      {
        "title": "História do Brasil Contemporâneo",
        "author": ["Boris Fausto"],
        "publication_year": "2012",
        "cover_image": "https://example.com/images/historia_brasil.jpg",
        "abstract": "Análise abrangente da história do Brasil desde a República até os dias atuais, com foco em aspectos políticos, econômicos e sociais.",
        "matters": ["Ciências Humanas", "História"],
        "sub_matters": ["História do Brasil", "História Contemporânea"],
        "address": "http://www.exemplo.com.br/historia-brasil",
        "summary": "http://www.exemplo.com.br/historia-brasil_sumario.pdf",
        "availability": "Disponível",
        "tags": ["história", "brasil", "república", "política"],
        "number_of_pages": 688,
        "isbn": "9788520010914",
        "issn": "",
        "typer": "Livro",
        "language": "Português",
        "publisher": "Edusp",
        "volume": "0",
        "series": "",
        "edition": "2ª edição",
        "reprint_update": "2012",
      },
    ];
  }

  /// Executa o cadastro de todos os materiais de teste
  Future<void> cadastrarMateriais() async {
    final materials = getMaterialsTesteData();
    
    print('═══════════════════════════════════════════════════════');
    print('🚀 Iniciando cadastro de ${materials.length} materiais de teste');
    print('═══════════════════════════════════════════════════════\n');

    int successCount = 0;
    int errorCount = 0;

    for (int i = 0; i < materials.length; i++) {
      print('[${i + 1}/${materials.length}] Cadastrando: ${materials[i]['title']}');
      
      try {
        await postInfoMaterial(materials[i]);
        successCount++;
        print('');
      } catch (e) {
        errorCount++;
        print('Erro: $e\n');
      }

      // Pequeno delay entre requisições para não sobrecarregar a API
      if (i < materials.length - 1) {
        await Future.delayed(Duration(milliseconds: 500));
      }
    }

    print('\n═══════════════════════════════════════════════════════');
    print('📊 RESUMO DO CADASTRO');
    print('═══════════════════════════════════════════════════════');
    print('✅ Sucesso: $successCount materiais');
    print('❌ Erros: $errorCount materiais');
    print('📚 Total: ${materials.length} materiais');
    print('═══════════════════════════════════════════════════════');
  }
}

void main() async {
  // ⚠️ CONFIGURAÇÃO NECESSÁRIA
  // Altere os valores abaixo com suas credenciais
  
  const String API_URL = 'http://localhost:8000/api'; // URL da sua API
  const String AUTH_TOKEN = 'SEU_TOKEN_AQUI'; // Token de autenticação
  
  // Validação básica
  if (AUTH_TOKEN == 'SEU_TOKEN_AQUI') {
    print('❌ ERRO: Configure o token de autenticação antes de executar!');
    print('   Edite o arquivo e substitua "SEU_TOKEN_AQUI" pelo token válido.');
    return;
  }

  final registration = MaterialTestRegistration(
    apiUrl: API_URL,
    authToken: AUTH_TOKEN,
  );

  try {
    await registration.cadastrarMateriais();
  } catch (e) {
    print('❌ Erro fatal durante a execução: $e');
  }
}