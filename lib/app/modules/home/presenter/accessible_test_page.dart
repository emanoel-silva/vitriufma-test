import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:vitrine_ufma/app/core/components/accessibility_controls.dart';
import 'package:vitrine_ufma/app/core/components/accessible_button.dart';
import 'package:vitrine_ufma/app/core/components/accessible_textfield.dart';
import 'package:vitrine_ufma/app/core/components/accessible_card.dart';

/// Página de teste para componentes acessíveis
/// 
/// Esta página demonstra todos os componentes acessíveis implementados
/// e serve como teste para verificar conformidade com WCAG 2.2
class AccessibleTestPage extends StatefulWidget {
  const AccessibleTestPage({Key? key}) : super(key: key);

  @override
  State<AccessibleTestPage> createState() => _AccessibleTestPageState();
}

class _AccessibleTestPageState extends State<AccessibleTestPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  
  bool _isSubscribed = false;
  String _selectedOption = 'opcao1';
  
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AccessibilityControls(
      child: Scaffold(
        appBar: AppBar(
          title: Semantics(
            header: true,
            child: Text('Teste de Acessibilidade'),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Seção de introdução
                Semantics(
                  header: true,
                  child: Text(
                    'Componentes Acessíveis',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Esta página demonstra os componentes acessíveis implementados '
                  'seguindo as diretrizes WCAG 2.2. Use um leitor de tela e '
                  'navegue com Tab/Shift+Tab para testar a acessibilidade.',
                ),
                const SizedBox(height: 32),
                
                // Seção de campos de texto
                Semantics(
                  header: true,
                  child: Text(
                    'Campos de Texto',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 16),
                AccessibleTextField(
                  controller: _nameController,
                  focusNode: _nameFocusNode,
                  nextFocusNode: _emailFocusNode,
                  label: 'Nome completo',
                  hint: 'Digite seu nome completo',
                  semanticsLabel: 'Campo de entrada para nome completo',
                  onChanged: (value) {
                    // Tratar mudança de valor
                  },
                ),
                const SizedBox(height: 16),
                AccessibleTextField(
                  controller: _emailController,
                  focusNode: _emailFocusNode,
                  label: 'Email',
                  hint: 'Digite seu email',
                  keyboardType: TextInputType.emailAddress,
                  semanticsLabel: 'Campo de entrada para endereço de email',
                ),
                const SizedBox(height: 32),
                
                // Seção de botões
                Semantics(
                  header: true,
                  child: Text(
                    'Botões',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    CustomAccessibleButton(
                      semanticsLabel: 'Botão primário',
                      tooltip: 'Este é um botão primário',
                      onPressed: () {
                        SemanticsService.announce(
                          'Botão primário pressionado', 
                          TextDirection.ltr
                        );
                      },
                      child: Text('Primário'),
                    ),
                    CustomAccessibleButton(
                      semanticsLabel: 'Botão secundário',
                      tooltip: 'Este é um botão secundário',
                      backgroundColor: Colors.grey,
                      onPressed: () {
                        SemanticsService.announce(
                          'Botão secundário pressionado', 
                          TextDirection.ltr
                        );
                      },
                      child: Text('Secundário'),
                    ),
                    CustomAccessibleButton(
                      semanticsLabel: 'Botão de sucesso',
                      tooltip: 'Este é um botão de sucesso',
                      backgroundColor: Colors.green,
                      onPressed: () {
                        SemanticsService.announce(
                          'Botão de sucesso pressionado', 
                          TextDirection.ltr
                        );
                      },
                      child: Text('Sucesso'),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                
                // Seção de cards
                Semantics(
                  header: true,
                  child: Text(
                    'Cards',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 16),
                AccessibleCard(
                  title: Text('Card Padrão'),
                  content: Text(
                    'Este é um exemplo de card acessível com título e conteúdo. '
                    'Ele segue as diretrizes de acessibilidade e tem contraste '
                    'adequado para leitura.'
                  ),
                  actions: [
                    CustomAccessibleButton(
                      semanticsLabel: 'Ação do card',
                      onPressed: () {
                        SemanticsService.announce(
                          'Ação do card executada', 
                          TextDirection.ltr
                        );
                      },
                      child: Text('Ação'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                AccessibleCard(
                  title: Text('Card Clicável'),
                  content: Text(
                    'Este é um card clicável que pode ser ativado com Enter '
                    'ou clique do mouse. Ele anuncia sua função para leitores de tela.'
                  ),
                  clickable: true,
                  onTap: () {
                    SemanticsService.announce(
                      'Card clicável ativado', 
                      TextDirection.ltr
                    );
                  },
                  semanticsLabel: 'Card interativo com informações importantes',
                ),
                const SizedBox(height: 32),
                
                // Seção de controles
                Semantics(
                  header: true,
                  child: Text(
                    'Controles Interativos',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Semantics(
                      toggled: _isSubscribed,
                      child: Checkbox(
                        value: _isSubscribed,
                        onChanged: (value) {
                          setState(() {
                            _isSubscribed = value ?? false;
                          });
                          SemanticsService.announce(
                            _isSubscribed 
                                ? 'Inscrição ativada' 
                                : 'Inscrição desativada',
                            TextDirection.ltr
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text('Deseja se inscrever para receber notificações?'),
                  ],
                ),
                const SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Selecione uma opção:'),
                    RadioListTile<String>(
                      title: const Text('Opção 1'),
                      value: 'opcao1',
                      groupValue: _selectedOption,
                      onChanged: (value) {
                        setState(() {
                          _selectedOption = value!;
                        });
                        SemanticsService.announce(
                          'Opção 1 selecionada',
                          TextDirection.ltr
                        );
                      },
                    ),
                    RadioListTile<String>(
                      title: const Text('Opção 2'),
                      value: 'opcao2',
                      groupValue: _selectedOption,
                      onChanged: (value) {
                        setState(() {
                          _selectedOption = value!;
                        });
                        SemanticsService.announce(
                          'Opção 2 selecionada',
                          TextDirection.ltr
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                
                // Botão de envio
                Center(
                  child: CustomAccessibleButton(
                    semanticsLabel: 'Botão de envio do formulário',
                    tooltip: 'Enviar informações preenchidas',
                    minWidth: 200,
                    onPressed: () {
                      final message = 'Formulário enviado com sucesso. '
                          'Nome: ${_nameController.text}, '
                          'Email: ${_emailController.text}';
                      SemanticsService.announce(message, TextDirection.ltr);
                      
                      // Mostrar snackbar de confirmação
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Formulário enviado com sucesso!'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    child: Text('Enviar Formulário'),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}