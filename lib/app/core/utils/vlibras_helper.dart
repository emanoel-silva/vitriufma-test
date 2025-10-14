import 'dart:html' as html;
import 'dart:js' as js;

/// Helper class para integração do VLibras com Flutter Web
class VLibrasHelper {
  static bool _debug = true; // Modo debug para logs detalhados

  /// Verifica se o VLibras está disponível no window
  static bool get isAvailable {
    try {
      final hasVLibras = js.context.hasProperty('VLibras');
      final hasWidget = hasVLibras && 
                        js.context['VLibras'] != null &&
                        js.context['VLibras']['Widget'] != null;
      
      if (_debug) {
        print('VLibras disponível: $hasVLibras, Widget disponível: $hasWidget');
      }
      
      return hasWidget;
    } catch (e) {
      print('Erro ao verificar VLibras: $e');
      return false;
    }
  }

  /// Verifica se o VLibras foi inicializado via JavaScript
  static bool get isInitializedInJS {
    try {
      final result = js.context.callMethod('eval', ['typeof vlibrasInitialized !== "undefined" && vlibrasInitialized']);
      return result == true;
    } catch (e) {
      if (_debug) print('Erro ao verificar inicialização JS: $e');
      return false;
    }
  }

  /// Inicializa o VLibras
  static void initialize() {
    if (_debug) print('VLibras: Tentando inicializar...');
    
    try {
      // Verifica se o JavaScript já inicializou
      if (isInitializedInJS) {
        if (_debug) print('VLibras: Já inicializado via JavaScript');
        return;
      }
      
      if (isAvailable) {
        // Aguarda um pouco para garantir que o DOM está pronto
        Future.delayed(Duration(milliseconds: 200), () {
          final existingWidget = html.document.querySelector('[vw]');
          if (existingWidget != null) {
            if (_debug) print('VLibras: Widget já existe no DOM');
            _checkIfWorking();
          } else {
            if (_debug) print('VLibras: Criando novo widget...');
            _createWidget();
          }
        });
      } else {
        if (_debug) print('VLibras: Plugin não está disponível, tentando carregar...');
        _loadVLibrasScript();
      }
    } catch (e) {
      print('Erro ao inicializar VLibras: $e');
    }
  }

  /// Verifica se o VLibras está funcionando corretamente
  static void _checkIfWorking() {
    try {
      final button = html.document.querySelector('[vw-access-button]');
      final wrapper = html.document.querySelector('[vw-plugin-wrapper]');
      
      if (_debug) {
        print('VLibras: Botão encontrado: ${button != null}');
        print('VLibras: Wrapper encontrado: ${wrapper != null}');
        if (button != null) {
          print('VLibras: Botão visível: ${button.style.display != "none"}');
        }
      }
      
      // Se o botão existe mas não está visível, força exibição
      if (button != null && button.style.display == 'none') {
        button.style.display = 'block';
        if (_debug) print('VLibras: Botão reexibido');
      }
    } catch (e) {
      print('Erro ao verificar funcionamento do VLibras: $e');
    }
  }

  /// Reinicializa o VLibras (útil após mudanças de rota)
  static void reinitialize() {
    initialize();
  }

  /// Cria o widget VLibras
  static void _createWidget() {
    try {
      js.context.callMethod('eval', [
        'new window.VLibras.Widget("https://vlibras.gov.br/app");'
      ]);
      print('VLibras: Widget criado com sucesso');
    } catch (e) {
      print('Erro ao criar widget VLibras: $e');
    }
  }

  /// Carrega o script do VLibras dinamicamente
  static void _loadVLibrasScript() {
    final script = html.ScriptElement()
      ..src = 'https://vlibras.gov.br/app/vlibras-plugin.js'
      ..async = true;
    
    script.onLoad.listen((_) {
      print('VLibras: Script carregado, inicializando...');
      Future.delayed(Duration(milliseconds: 500), () {
        initialize();
      });
    });

    script.onError.listen((_) {
      print('VLibras: Erro ao carregar script');
    });

    html.document.head?.append(script);
  }

  /// Ativa/desativa o VLibras
  static void toggle() {
    try {
      if (isAvailable) {
        final button = html.document.querySelector('[vw-access-button]');
        if (button != null) {
          button.click();
        } else {
          print('VLibras: Botão de acesso não encontrado');
        }
      }
    } catch (e) {
      print('Erro ao alternar VLibras: $e');
    }
  }

  /// Força refresh do VLibras após mudanças de conteúdo
  static void refresh() {
    if (!isAvailable) return;
    
    try {
      js.context.callMethod('eval', [
        '''
        if (window.VLibras && window.VLibras.Widget) {
          setTimeout(function() {
            try {
              // Força reprocessamento do conteúdo
              var event = new Event('DOMContentLoaded');
              document.dispatchEvent(event);
            } catch(e) {
              console.log("Erro ao refresh VLibras:", e);
            }
          }, 200);
        }
        '''
      ]);
    } catch (e) {
      print('Erro ao fazer refresh do VLibras: $e');
    }
  }

  /// Verifica se o widget está visível
  static bool get isVisible {
    try {
      final widget = html.document.querySelector('[vw]');
      return widget != null && widget.style.display != 'none';
    } catch (e) {
      return false;
    }
  }

  /// Configura acessibilidade para elementos específicos
  static void configureAccessibility() {
    try {
      // Adiciona atributos de acessibilidade aos elementos principais
      final body = html.document.body;
      if (body != null) {
        body.setAttribute('lang', 'pt-BR');
      }

      // Garante que o VLibras tenha o z-index adequado
      final style = html.StyleElement()
        ..text = '''
          [vw-access-button] {
            z-index: 9999 !important;
            position: fixed !important;
          }
          [vw-plugin-wrapper] {
            z-index: 9998 !important;
          }
        ''';
      
      html.document.head?.append(style);
    } catch (e) {
      print('Erro ao configurar acessibilidade: $e');
    }
  }

  /// Limpa instâncias do VLibras
  static void dispose() {
    try {
      // Remove listeners e instâncias se necessário
      js.context.callMethod('eval', [
        '''
        if (window.VLibras) {
          // Cleanup se houver métodos específicos
        }
        '''
      ]);
    } catch (e) {
      print('Erro ao fazer dispose do VLibras: $e');
    }
  }

  /// Debug para verificar estado do VLibras
  static void debug() {
    try {
      js.context.callMethod('eval', ['if (window.debugVLibras) window.debugVLibras();']);
      
      print('=== VLibras Debug ===');
      print('Disponível: ${isAvailable}');
      print('Inicializado (JS): ${isInitializedInJS}');
      print('Visível: ${isVisible}');
      
      final button = html.document.querySelector('[vw-access-button]');
      final wrapper = html.document.querySelector('[vw-plugin-wrapper]');
      final container = html.document.querySelector('[vw]');
      
      print('Container [vw]: ${container != null}');
      print('Botão [vw-access-button]: ${button != null}');
      print('Wrapper [vw-plugin-wrapper]: ${wrapper != null}');
      
      if (button != null) {
        print('Botão display: ${button.style.display}');
        print('Botão visibility: ${button.style.visibility}');
      }
      
      print('==================');
    } catch (e) {
      print('Erro ao fazer debug do VLibras: $e');
    }
  }

  /// Traduz texto específico no VLibras
  static void translateText(String text) {
    if (!isAvailable) {
      print('VLibras: Não disponível para tradução');
      return;
    }
    
    try {
      // Cria um elemento temporário com o texto
      final tempElement = html.DivElement()
        ..setAttribute('id', 'vlibras-temp-text')
        ..setAttribute('lang', 'pt-BR')
        ..style.position = 'absolute'
        ..style.top = '-9999px'
        ..style.left = '-9999px'
        ..style.opacity = '0'
        ..text = text;
      
      html.document.body?.append(tempElement);
      
      // Força o VLibras a processar o novo conteúdo
      js.context.callMethod('eval', [
        '''
        if (window.VLibras && window.VLibras.Widget) {
          try {
            // Simula evento de mudança de conteúdo
            var event = new CustomEvent('vlibras-text-change', {
              detail: { text: "${text.replaceAll('"', '\\"').replaceAll('\n', '\\n')}" }
            });
            document.dispatchEvent(event);
            
            // Força refresh do VLibras
            setTimeout(function() {
              var tempEl = document.getElementById('vlibras-temp-text');
              if (tempEl) {
                tempEl.focus();
                tempEl.click();
              }
            }, 100);
          } catch(e) {
            console.error("Erro ao traduzir texto:", e);
          }
        }
        '''
      ]);
      
      // Remove elemento temporário após delay
      Future.delayed(Duration(seconds: 2), () {
        tempElement.remove();
      });
      
      if (_debug) print('VLibras: Texto enviado para tradução: ${text.substring(0, text.length > 50 ? 50 : text.length)}...');
      
    } catch (e) {
      print('Erro ao traduzir texto no VLibras: $e');
    }
  }

  /// Ativa VLibras e traduz texto
  static void activateAndTranslate(String text) {
    try {
      // Primeiro garante que o VLibras está ativo
      final button = html.document.querySelector('[vw-access-button]');
      if (button != null) {
        // Verifica se o VLibras já está ativo
        final isActive = button.classes.contains('active') || 
                        button.getAttribute('aria-pressed') == 'true';
        
        if (!isActive) {
          button.click();
          // Aguarda ativação antes de traduzir
          Future.delayed(Duration(milliseconds: 500), () {
            translateText(text);
          });
        } else {
          // Já está ativo, traduz diretamente
          translateText(text);
        }
      } else {
        print('VLibras: Botão não encontrado');
      }
    } catch (e) {
      print('Erro ao ativar e traduzir VLibras: $e');
    }
  }

  /// Cria área de texto para tradução
  static void createTranslationArea(String text) {
    try {
      // Remove área anterior se existir
      final existing = html.document.querySelector('#vlibras-translation-area');
      existing?.remove();
      
      // Cria nova área
      final translationArea = html.DivElement()
        ..setAttribute('id', 'vlibras-translation-area')
        ..setAttribute('lang', 'pt-BR')
        ..style.position = 'fixed'
        ..style.bottom = '20px'
        ..style.right = '20px'
        ..style.width = '210px'
        ..style.height = '80px'  // Fixed height instead of auto/min-height
        ..style.backgroundColor = 'rgba(255, 255, 255, 0.95)'
        ..style.border = '2px solid #0066cc'
        ..style.borderRadius = '8px'
        ..style.padding = '16px'
        ..style.zIndex = '10000'
        ..style.fontSize = '14px'
        ..style.lineHeight = '1.3'
        ..style.boxShadow = '0 4px 12px rgba(0,0,0,0.15)'
        ..style.overflow = 'hidden'
        ..style.display = 'flex'
        ..style.flexDirection = 'column';
      
      // Cria conteúdo da área
      final header = html.DivElement()
        ..style.display = 'flex'
        ..style.justifyContent = 'space-between'
        ..style.alignItems = 'center'
        ..style.marginBottom = '4px'
        ..style.flexShrink = '0';
      
      final title = html.Element.tag('strong')
        ..style.color = '#0066cc'
        ..style.fontSize = '12px'
        ..text = 'Texto para VLibras:';
      
      final closeButton = html.ButtonElement()
        ..setAttribute('id', 'close-translation')
        ..style.background = 'none'
        ..style.border = 'none'
        ..style.fontSize = '16px'
        ..style.cursor = 'pointer'
        ..style.color = '#666'
        ..style.fontWeight = 'bold'
        ..text = '×';
      
      final textContent = html.DivElement()
        ..style.color = '#333'
        ..style.flex = '1'
        ..style.overflow = 'auto'  // Allow scrolling for overflow content
        ..style.fontSize = '13px'
        ..text = text;
      
      final instruction = html.DivElement()
        ..style.marginTop = '4px'
        ..style.fontSize = '9px'
        ..style.color = '#666'
        ..style.textAlign = 'center'
        ..style.flexShrink = '0'
        ..text = 'Clique no ícone azul do VLibras';
      
      header.children.addAll([title, closeButton]);
      translationArea.children.addAll([header, textContent, instruction]);
      
      html.document.body?.append(translationArea);
      
      // Adiciona evento para fechar
      closeButton.onClick.listen((_) {
        translationArea.remove();
      });
      
      // Auto-remove após 15 segundos
      Future.delayed(Duration(seconds: 15), () {
        if (translationArea.parent != null) {
          translationArea.remove();
        }
      });
      
      if (_debug) print('VLibras: Área de tradução criada');
      
    } catch (e) {
      print('Erro ao criar área de tradução: $e');
    }
  }
}
