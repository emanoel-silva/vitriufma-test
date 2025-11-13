import 'package:flutter/material.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:vitrine_ufma/app/core/components/text.dart';
import 'package:vitrine_ufma/app/core/components/footer.dart';
import 'package:vitrine_ufma/app/core/constants/colors.dart';
import 'package:vitrine_ufma/app/core/constants/const.dart';
import 'package:vitrine_ufma/app/core/constants/fonts_sizes.dart';
import 'package:vitrine_ufma/app/core/components/enhanced_keyboard_navigation.dart';

// Import condicional do NVDA helper
import 'package:vitrine_ufma/app/core/utils/nvda_helper_stub.dart' if (dart.library.html) 'package:vitrine_ufma/app/core/utils/nvda_helper.dart';

class NVDATestPage extends StatefulWidget {
  const NVDATestPage({super.key});

  @override
  State<NVDATestPage> createState() => _NVDATestPageState();
}

class _NVDATestPageState extends State<NVDATestPage> {
  void _toggleNVDA() {
    if (UniversalPlatform.isWeb) {
      final sampleText = 'Página de teste do Leitor de Tela NVDA. '
          'Esta página demonstra como o conteúdo é disponibilizado para leitores de tela. '
          'Todos os textos nesta página serão automaticamente lidos pelo NVDA quando a área estiver ativa.';
      
      NVDAHelper.toggleNVDAArea(sampleText);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isWeb = true; // Assuming web for this demo
    double width = MediaQuery.of(context).size.width;
    
    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      body: EnhancedKeyboardNavigation(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isWeb ? AppConst.sidePadding * 2 : AppConst.sidePadding,
                vertical: AppConst.sidePadding,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.backgroundGrey,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    height: 100,
                    width: width,
                    child: const Center(
                      child: AppText(
                        text: 'Teste do Leitor de Tela NVDA',
                        fontSize: AppFontSize.fz10,
                        fontWeight: 'bold',
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  
                  // Botão para ativar/desativar NVDA
                  if (UniversalPlatform.isWeb)
                    Container(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _toggleNVDA,
                        icon: Icon(Icons.hearing),
                        label: Text('Ativar/Desativar NVDA'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade600,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 25),
                  
                  // Conteúdo de teste
                  const AppText(
                    text: 'Bem-vindo à Página de Teste do NVDA',
                    fontSize: AppFontSize.fz07,
                    fontWeight: 'bold',
                    color: Colors.green,
                  ),
                  const SizedBox(height: 10),
                  
                  const AppText(
                    textAlign: TextAlign.justify,
                    text: 'Esta página foi criada especificamente para testar a funcionalidade do leitor de tela NVDA. '
                        'Todos os textos nesta página são automaticamente disponibilizados para o NVDA quando a área de leitura está ativa.',
                    fontSize: AppFontSize.fz05,
                    maxLines: 10,
                  ),
                  const SizedBox(height: 20),
                  
                  // Seção de instruções
                  Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.green.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const AppText(
                          text: '✓ Como usar o NVDA:',
                          fontSize: AppFontSize.fz06,
                          fontWeight: 'bold',
                          color: Colors.green,
                        ),
                        const SizedBox(height: 8),
                        const AppText(
                          text: '1. Clique no botão "Ativar/Desativar NVDA" acima',
                          fontSize: AppFontSize.fz05,
                        ),
                        const SizedBox(height: 4),
                        const AppText(
                          text: '2. Uma caixa verde aparecerá no canto inferior direito',
                          fontSize: AppFontSize.fz05,
                        ),
                        const SizedBox(height: 4),
                        const AppText(
                          text: '3. O conteúdo desta página será automaticamente lido',
                          fontSize: AppFontSize.fz05,
                        ),
                        const SizedBox(height: 4),
                        const AppText(
                          text: '4. Você pode arrastar a caixa para mover sua posição',
                          fontSize: AppFontSize.fz05,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  
                  // Conteúdo adicional para teste
                  const AppText(
                    text: 'Conteúdo Adicional para Teste',
                    fontSize: AppFontSize.fz07,
                    fontWeight: 'bold',
                    color: Colors.black87,
                  ),
                  const SizedBox(height: 10),
                  
                  const AppText(
                    textAlign: TextAlign.justify,
                    text: 'Este é um texto adicional para testar a capacidade do NVDA de ler múltiplos parágrafos. '
                        'Quando a área do NVDA está ativa, todos os textos da página são combinados e disponibilizados '
                        'para leitura pelo leitor de tela.',
                    fontSize: AppFontSize.fz05,
                    maxLines: 10,
                  ),
                  const SizedBox(height: 10),
                  
                  const AppText(
                    textAlign: TextAlign.justify,
                    text: 'O sistema foi projetado para funcionar perfeitamente com o NVDA e outros leitores de tela. '
                        'A integração é automática e não requer configurações complexas.',
                    fontSize: AppFontSize.fz05,
                    maxLines: 10,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 100),
            const FooterVitrine()
          ],
        ),
      ),
    );
  }
}