import 'dart:html' as html;
import 'dart:async';

/// Helper class para integração do NVDA com Flutter Web
class NVDAHelper {
  static bool _debug = true; // Modo debug para logs detalhados
  static bool _isAreaVisible = false;
  static html.DivElement? _translationArea;
  static StreamSubscription? _dragSubscription;
  static StreamSubscription? _dragEndSubscription;
  static StreamSubscription? _moveSubscription;
  static Timer? _autoCloseTimer; // Timer for auto-close functionality
  
  // Store text content for NVDA
  static String _currentText = '';
  static final List<String> _textQueue = [];

  /// Cria área de texto para leitura do NVDA
  static void createNVDAArea(String text) {
    try {
      // Update current text
      _currentText = text;
      
      // Remove área anterior se existir
      final existing = html.document.querySelector('#nvda-translation-area');
      existing?.remove();
      
      // Cancela o timer anterior se existir
      _autoCloseTimer?.cancel();
      
      // Cria nova área
      _translationArea = html.DivElement()
        ..setAttribute('id', 'nvda-translation-area')
        ..setAttribute('lang', 'pt-BR')
        ..style.position = 'fixed'
        ..style.bottom = '20px'
        ..style.right = '20px'
        ..style.width = '210px'
        ..style.height = '80px'
        ..style.backgroundColor = 'rgba(255, 255, 255, 0.95)'
        ..style.border = '2px solid #00cc66'
        ..style.borderRadius = '8px'
        ..style.padding = '16px'
        ..style.zIndex = '10000'
        ..style.fontSize = '14px'
        ..style.lineHeight = '1.3'
        ..style.boxShadow = '0 4px 12px rgba(0,0,0,0.15)'
        ..style.overflow = 'hidden'
        ..style.display = 'flex'
        ..style.flexDirection = 'column'
        ..style.cursor = 'move'; // Indica que pode ser arrastada
      
      // Cria conteúdo da área
      final header = html.DivElement()
        ..style.display = 'flex'
        ..style.justifyContent = 'space-between'
        ..style.alignItems = 'center'
        ..style.marginBottom = '4px'
        ..style.flexShrink = '0';
      
      final title = html.Element.tag('strong')
        ..style.color = '#00cc66'
        ..style.fontSize = '12px'
        ..text = 'Texto para NVDA:';
      
      final closeButton = html.ButtonElement()
        ..setAttribute('id', 'close-nvda-translation')
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
        ..style.overflow = 'auto'
        ..style.fontSize = '13px'
        ..text = text;
      
      final instruction = html.DivElement()
        ..style.marginTop = '4px'
        ..style.fontSize = '9px'
        ..style.color = '#666'
        ..style.textAlign = 'center'
        ..style.flexShrink = '0'
        ..text = 'Clique e arraste para mover';
      
      header.children.addAll([title, closeButton]);
      _translationArea!.children.addAll([header, textContent, instruction]);
      
      html.document.body?.append(_translationArea!);
      
      // Adiciona evento para fechar
      closeButton.onClick.listen((_) {
        removeNVDAArea();
      });
      
      // Adiciona eventos para arrastar
      _addDragFunctionality();
      
      _isAreaVisible = true;
      
      if (_debug) print('NVDA: Área de leitura criada com texto: $text');
      
    } catch (e) {
      print('Erro ao criar área de leitura do NVDA: $e');
    }
  }
  
  /// Atualiza o conteúdo da área de texto do NVDA
  static void updateNVDAText(String text) {
    if (!_isAreaVisible) return;
    
    try {
      final textContent = html.document.querySelector('#nvda-translation-area div:nth-child(2)') as html.DivElement?;
      if (textContent != null) {
        textContent.text = text;
        _currentText = text;
        
        if (_debug) print('NVDA: Texto atualizado para: $text');
      }
    } catch (e) {
      print('Erro ao atualizar texto do NVDA: $e');
    }
  }
  
  /// Adiciona texto à fila do NVDA
  static void addTextToQueue(String text) {
    _textQueue.add(text);
    
    // Se a área está visível, atualiza imediatamente
    if (_isAreaVisible) {
      final combinedText = _textQueue.join('\n\n');
      updateNVDAText(combinedText);
    }
  }
  
  /// Limpa a fila de textos
  static void clearTextQueue() {
    _textQueue.clear();
  }
  
  /// Remove a área de texto do NVDA
  static void removeNVDAArea() {
    try {
      final existing = html.document.querySelector('#nvda-translation-area');
      existing?.remove();
      
      // Cancela subscrições de drag
      _dragSubscription?.cancel();
      _dragEndSubscription?.cancel();
      _moveSubscription?.cancel();
      
      // Cancela o timer
      _autoCloseTimer?.cancel();
      
      _isAreaVisible = false;
      _translationArea = null;
      _currentText = '';
      
      if (_debug) print('NVDA: Área de leitura removida');
      
    } catch (e) {
      print('Erro ao remover área de leitura do NVDA: $e');
    }
  }
  
  /// Alterna a visibilidade da área de texto do NVDA
  static void toggleNVDAArea([String? text]) {
    if (_isAreaVisible) {
      removeNVDAArea();
    } else {
      final displayText = text ?? _currentText;
      if (displayText.isNotEmpty) {
        createNVDAArea(displayText);
      } else if (_textQueue.isNotEmpty) {
        createNVDAArea(_textQueue.join('\n\n'));
      } else {
        createNVDAArea('Conteúdo da página pronto para leitura com NVDA.');
      }
    }
  }
  
  /// Verifica se a área está visível
  static bool get isAreaVisible => _isAreaVisible;
  
  /// Obtém o texto atual
  static String get currentText => _currentText;
  
  /// Adiciona funcionalidade de arrastar
  static void _addDragFunctionality() {
    if (_translationArea == null) return;
    
    num? posX, posY;
    num? divTop, divLeft;
    
    // Cancela subscrições anteriores
    _dragSubscription?.cancel();
    _dragEndSubscription?.cancel();
    _moveSubscription?.cancel();
    
    _dragSubscription = _translationArea!.onMouseDown.listen((e) {
      final mouseEvent = e as html.MouseEvent;
      
      // Não inicia drag se clicar no botão de fechar
      if (mouseEvent.target is html.ButtonElement) {
        return;
      }
      
      posX = mouseEvent.client.x;
      posY = mouseEvent.client.y;
      divTop = _translationArea!.offsetTop;
      divLeft = _translationArea!.offsetLeft;
      
      final moveHandler = (html.MouseEvent moveEvent) {
        final dx = moveEvent.client.x - posX!;
        final dy = moveEvent.client.y - posY!;
        
        _translationArea!.style.top = '${divTop! + dy}px';
        _translationArea!.style.left = '${divLeft! + dx}px';
        _translationArea!.style.bottom = 'auto';
        _translationArea!.style.right = 'auto';
      };
      
      _moveSubscription = html.document.onMouseMove.listen(moveHandler);
      
      _dragEndSubscription = html.document.onMouseUp.listen((_) {
        _moveSubscription?.cancel();
      });
    });
  }
}