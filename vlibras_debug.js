// Debug script para VLibras - Ferramenta de diagnostico
console.log('=== VLibras Debug Script Carregado ===');

// Função para debug completo do VLibras
window.debugVLibrasComplete = function() {
  console.log('\n=== DEBUG COMPLETO DO VLIBRAS ===');
  
  // 1. Verificar disponibilidade
  console.log('1. DISPONIBILIDADE:');
  console.log('- window.VLibras existe:', !!window.VLibras);
  console.log('- window.VLibras.Widget existe:', !!(window.VLibras && window.VLibras.Widget));
  console.log('- vlibrasInitialized:', typeof vlibrasInitialized !== 'undefined' ? vlibrasInitialized : 'undefined');
  
  // 2. Verificar elementos DOM
  console.log('\n2. ELEMENTOS DOM:');
  const container = document.querySelector('[vw]');
  const button = document.querySelector('[vw-access-button]');
  const wrapper = document.querySelector('[vw-plugin-wrapper]');
  
  console.log('- Container [vw]:', !!container);
  console.log('- Botão [vw-access-button]:', !!button);
  console.log('- Wrapper [vw-plugin-wrapper]:', !!wrapper);
  
  // 3. Verificar estilos e visibilidade
  if (button) {
    console.log('\n3. ESTILOS DO BOTÃO:');
    const styles = window.getComputedStyle(button);
    console.log('- display:', styles.display);
    console.log('- visibility:', styles.visibility);
    console.log('- opacity:', styles.opacity);
    console.log('- z-index:', styles.zIndex);
    console.log('- position:', styles.position);
    console.log('- width:', styles.width);
    console.log('- height:', styles.height);
  }
  
  // 4. Verificar eventos
  console.log('\n4. EVENTOS:');
  if (button) {
    console.log('- Botão clicável:', button.onclick || 'sem evento onclick direto');
    
    // Tentar clicar programaticamente
    try {
      console.log('- Tentando click programático...');
      button.click();
      console.log('- Click executado com sucesso');
    } catch (e) {
      console.log('- Erro no click:', e.message);
    }
  }
  
  // 5. Verificar console errors
  console.log('\n5. MONITORAMENTO:');
  console.log('- Para testar manualmente, clique no botão azul do VLibras');
  console.log('- Verifique se aparecem erros no console após o clique');
  
  console.log('\n=== FIM DEBUG VLIBRAS ===\n');
};

// Função para verificar periodicamente o estado
window.monitorVLibras = function(interval = 5000) {
  console.log('Iniciando monitoramento do VLibras a cada', interval, 'ms');
  
  setInterval(() => {
    const button = document.querySelector('[vw-access-button]');
    const isVisible = button && window.getComputedStyle(button).display !== 'none';
    
    console.log('VLibras Status:', {
      available: !!(window.VLibras && window.VLibras.Widget),
      buttonExists: !!button,
      buttonVisible: isVisible,
      timestamp: new Date().toLocaleTimeString()
    });
  }, interval);
};

// Função para forçar reinicialização
window.forceVLibrasRestart = function() {
  console.log('Forçando restart do VLibras...');
  
  try {
    // Remove elementos existentes
    const existing = document.querySelectorAll('[vw]');
    existing.forEach(el => el.remove());
    
    // Aguarda um pouco e recria
    setTimeout(() => {
      if (window.VLibras && window.VLibras.Widget) {
        new window.VLibras.Widget('https://vlibras.gov.br/app');
        console.log('VLibras reinicializado');
      } else {
        console.log('VLibras não disponível para reinicialização');
      }
    }, 500);
    
  } catch (e) {
    console.error('Erro ao reinicializar VLibras:', e);
  }
};

// Auto-run do debug após carregamento
document.addEventListener('DOMContentLoaded', () => {
  setTimeout(() => {
    console.log('Executando debug automático...');
    if (window.debugVLibrasComplete) {
      debugVLibrasComplete();
    }
  }, 3000);
});

// Adicionar ao window para acesso global
window.vlibrasDebugLoaded = true;
console.log('VLibras Debug: Use debugVLibrasComplete(), monitorVLibras() ou forceVLibrasRestart()');