# Scripts de Cadastro de Materiais de Teste

Este documento explica como utilizar os scripts criados para cadastrar materiais de teste no sistema Vitrine UFMA.

## 📋 Visão Geral

Foram criados dois scripts diferentes para cadastrar materiais de teste:

1. **Script Standalone** (`scripts/cadastrar_materiais_teste.dart`) - Script independente que pode ser executado via linha de comando
2. **Helper Interno** (`lib/app/core/utils/material_teste_helper.dart`) - Classe que pode ser usada dentro do app Flutter

Ambos utilizam o método `postInfoMaterial()` que é responsável pelo cadastro de materiais informacionais no sistema.

## 🎯 Opção 1: Script Standalone (Linha de Comando)

### Pré-requisitos

- Dart SDK instalado
- Token de autenticação válido
- API rodando e acessível

### Configuração

1. Abra o arquivo `scripts/cadastrar_materiais_teste.dart`

2. Configure as seguintes variáveis:

```dart
const String API_URL = 'http://localhost:8000/api'; // URL da sua API
const String AUTH_TOKEN = 'SEU_TOKEN_AQUI'; // Token de autenticação
```

3. Para obter o token de autenticação:
   - Faça login no sistema
   - Inspecione o localStorage ou cookies do navegador
   - Copie o token JWT válido

### Execução

No terminal, execute:

```bash
cd /Users/orcus/Documents/Caracol/vitrine_ufma
dart run scripts/cadastrar_materiais_teste.dart
```

### Saída Esperada

```
═══════════════════════════════════════════════════════
🚀 Iniciando cadastro de 8 materiais de teste
═══════════════════════════════════════════════════════

[1/8] Cadastrando: Cálculo Diferencial e Integral - Volume 1
✅ Material cadastrado com sucesso!
   ID: 123
   Título: Cálculo Diferencial e Integral - Volume 1

[2/8] Cadastrando: Física para Cientistas e Engenheiros - Volume 1
✅ Material cadastrado com sucesso!
   ID: 124
   Título: Física para Cientistas e Engenheiros - Volume 1

...

═══════════════════════════════════════════════════════
📊 RESUMO DO CADASTRO
═══════════════════════════════════════════════════════
✅ Sucesso: 8 materiais
❌ Erros: 0 materiais
📚 Total: 8 materiais
═══════════════════════════════════════════════════════
```

## 🎯 Opção 2: Helper Interno (Dentro do App)

### Como Usar

Este método é ideal para desenvolvedores que querem cadastrar materiais de teste diretamente do código Flutter.

#### Exemplo 1: Cadastrar todos os materiais

```dart
import 'package:vitrine_ufma/app/core/utils/material_teste_helper.dart';

// Cadastrar todos os materiais de teste (10 materiais)
Future<void> cadastrarTodosMateriais() async {
  final resultado = await MaterialTesteHelper.cadastrarMaterialTeste();
  
  print('Sucesso: ${resultado['success']}');
  print('Erros: ${resultado['error']}');
  print('Total: ${resultado['total']}');
}
```

#### Exemplo 2: Cadastrar apenas N materiais

```dart
import 'package:vitrine_ufma/app/core/utils/material_teste_helper.dart';

// Cadastrar apenas 3 materiais de teste
Future<void> cadastrarPoucosMateriais() async {
  final resultado = await MaterialTesteHelper.cadastrarNMateriais(3);
  
  print('Cadastrados: ${resultado['success']} de ${resultado['total']}');
}
```

#### Exemplo 3: Cadastrar um material específico

```dart
import 'package:vitrine_ufma/app/core/utils/material_teste_helper.dart';

Future<void> cadastrarMaterialEspecifico() async {
  final materials = MaterialTesteHelper.getMaterialsTeste();
  
  // Cadastrar apenas o primeiro material (Cálculo)
  final success = await MaterialTesteHelper.cadastrarMaterial(materials[0]);
  
  if (success) {
    print('Material cadastrado com sucesso!');
  } else {
    print('Erro ao cadastrar material');
  }
}
```

#### Exemplo 4: Criar um botão para cadastrar materiais

```dart
import 'package:flutter/material.dart';
import 'package:vitrine_ufma/app/core/utils/material_teste_helper.dart';

class CadastrarMaterialButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        // Mostrar indicador de carregamento
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => Center(child: CircularProgressIndicator()),
        );

        // Cadastrar materiais
        final resultado = await MaterialTesteHelper.cadastrarMaterialTeste();

        // Fechar indicador de carregamento
        Navigator.of(context).pop();

        // Mostrar resultado
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Cadastrados: ${resultado['success']} de ${resultado['total']} materiais',
            ),
          ),
        );
      },
      child: Text('Cadastrar Materiais de Teste'),
    );
  }
}
```

## 📚 Materiais Incluídos

Os scripts cadastram os seguintes materiais de teste:

1. **Cálculo Diferencial e Integral** - James Stewart (Matemática)
2. **Física para Cientistas e Engenheiros** - Tipler & Mosca (Física)
3. **Algoritmos e Estruturas de Dados em Python** - Goodrich (Computação)
4. **IA aplicada à Educação** - Artigo científico (Computação)
5. **Química Orgânica** - John McMurry (Química)
6. **Dom Casmurro** - Machado de Assis (Literatura)
7. **Biologia Molecular da Célula** - Alberts (Biologia)
8. **História do Brasil Contemporâneo** - Boris Fausto (História)
9. **O Mundo de Sofia** - Jostein Gaarder (Filosofia) *(apenas no helper interno)*
10. **Resistência dos Materiais** - Beer & Johnston (Engenharia) *(apenas no helper interno)*

## 🔧 Personalização

### Adicionar Novos Materiais

Para adicionar novos materiais de teste, edite o método `getMaterialsTesteData()` ou `getMaterialsTeste()` e adicione um novo mapa seguindo a estrutura:

```dart
{
  "title": "Título do Material",
  "author": ["Nome do Autor"],
  "publication_year": "2024",
  "cover_image": "URL da imagem",
  "abstract": "Resumo do material",
  "matters": ["Área de conhecimento"],
  "sub_matters": ["Subárea"],
  "address": "http://exemplo.com",
  "summary": "http://exemplo.com/sumario.pdf",
  "availability": "Disponível",
  "tags": ["tag1", "tag2"],
  "number_of_pages": 100,
  "isbn": "9781234567890",
  "issn": "",
  "typer": "Livro",
  "language": "Português",
  "publisher": "Editora",
  "volume": "0",
  "series": "",
  "edition": "1ª edição",
  "reprint_update": "2024",
}
```

### Campos Obrigatórios

De acordo com o código do sistema, os seguintes campos são **obrigatórios**:

- `title` - Título do material
- `author` - Lista de autores
- `publication_year` - Ano de publicação
- `abstract` - Resumo/descrição
- `matters` - Áreas de conhecimento
- `sub_matters` - Subáreas de conhecimento
- `typer` - Tipo de material
- `language` - Idioma
- `publisher` - Editora
- `number_of_pages` - Número de páginas
- `cover_image` - URL da imagem de capa
- `summary` - URL do sumário

### Campos Opcionais

- `isbn` - ISBN do livro
- `issn` - ISSN de periódicos
- `volume` - Volume
- `series` - Série
- `edition` - Edição
- `reprint_update` - Reimpressão/atualização
- `address` - Endereço eletrônico
- `availability` - Disponibilidade
- `tags` - Tags/palavras-chave

## ⚠️ Importante

1. **Autenticação**: Certifique-se de estar autenticado antes de executar os scripts
2. **Token válido**: O token de autenticação deve ser válido e não expirado
3. **API rodando**: A API deve estar rodando e acessível
4. **Imagens**: As URLs das imagens usam o serviço Picsum.photos para gerar imagens aleatórias (apenas no helper interno)
5. **Rate limiting**: Há um delay de 500ms entre cada requisição para não sobrecarregar a API

## 🐛 Solução de Problemas

### Erro: "Configure o token de autenticação"
- Configure o `AUTH_TOKEN` no script standalone antes de executar

### Erro: "Failed to connect"
- Verifique se a API está rodando
- Verifique a URL configurada em `API_URL`

### Erro: "Unauthorized" ou "401"
- O token está expirado ou inválido
- Faça login novamente e obtenha um novo token

### Erro: "DataSourceError"
- Verifique se todos os campos obrigatórios estão preenchidos
- Verifique o formato dos dados (ano, páginas, ISBN)

## 📝 Logs

Os logs são exibidos no console durante a execução:
- ✅ indica sucesso
- ❌ indica erro
- 📚 indica informação sobre materiais
- 🚀 indica início do processo
- 📊 indica resumo final

## 🔗 Referências

- Arquivo datasource: `/lib/app/modules/home/external/post_material_datasource.dart`
- Método usado: `postInfoMaterial(Map<String, dynamic> data)`
- Endpoint: `POST /informational-material`