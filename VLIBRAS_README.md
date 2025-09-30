# Integração VLibras - Vitrine UFMA

Este documento explica como o VLibras está integrado na Estante Visual e como utilizá-lo.

## 🔧 Configuração Técnica

### Arquivos Modificados/Criados

1. **`web/index.html`** - Integração principal do VLibras
2. **`lib/app/core/utils/vlibras_helper.dart`** - Helper para controle do VLibras
3. **`lib/app/core/utils/vlibras_helper_stub.dart`** - Stub para plataformas não-web
4. **`lib/app/core/components/accessibility_controls.dart`** - Componentes de acessibilidade
5. **`lib/app/core/routes/vlibras_route_observer.dart`** - Observer para mudanças de rota
6. **`lib/main.dart`** - Inicialização do VLibras

### Funcionalidades Implementadas

- ✅ **Carregamento automático** do script VLibras
- ✅ **Reinicialização** após mudanças de rota
- ✅ **Configuração de z-index** para sobreposição correta
- ✅ **Tratamento de erros** e fallbacks
- ✅ **Integração condicional** (apenas web)
- ✅ **Página de acessibilidade** atualizada

## 🎯 Como Usar

### Para Usuários

1. **Localizar o VLibras**: Procure pelo ícone azul no canto inferior direito da tela
2. **Ativar**: Clique no ícone para ativar a tradução em Libras
3. **Usar**: O VLibras traduzirá automaticamente o conteúdo da página

### Para Desenvolvedores

#### Uso Básico

```dart
import 'package:vitrine_ufma/app/core/utils/vlibras_helper.dart';

// Verificar se está disponível
if (VLibrasHelper.isAvailable) {
  // Fazer algo
}

// Ativar/desativar
VLibrasHelper.toggle();

// Reinicializar após mudanças
VLibrasHelper.reinitialize();

// Atualizar após conteúdo dinâmico
VLibrasHelper.refresh();
```

#### Widget com Acessibilidade

```dart
import 'package:vitrine_ufma/app/core/components/accessibility_controls.dart';

class MyPage extends StatefulWidget with VLibrasPageMixin {
  @override
  Widget build(BuildContext context) {
    return AccessibilityControls(
      child: Scaffold(
        body: MyContent(),
      ),
    );
  }
}
```

#### Mixin para Páginas

```dart
class MyPageState extends State<MyPage> with VLibrasPageMixin {
  @override
  void initState() {
    super.initState();
    // VLibras será inicializado automaticamente
  }
  
  void onContentChange() {
    // Chame quando o conteúdo mudar dinamicamente
    refreshVLibras();
  }
}
```

## 🚀 Build e Deploy

### Build Local

```bash
# Usar o script personalizado
./build_web_vlibras.sh

# Ou build manual
flutter build web --web-renderer html --release
```

### Servidor Local de Teste

```bash
cd build/web
python3 -m http.server 8000
# Acesse: http://localhost:8000
```

### Deploy em Produção

1. **Upload dos arquivos** do diretório `build/web/`
2. **Configurar servidor** para servir arquivos .js
3. **Usar HTTPS** (recomendado para melhor funcionamento)
4. **Configurar CORS** se necessário

## 🐛 Solução de Problemas

### VLibras não aparece

1. **Verificar console do navegador** para erros
2. **Recarregar a página** (Ctrl+F5)
3. **Limpar cache** do navegador
4. **Verificar se o script** está carregando:
   ```javascript
   console.log(window.VLibras);
   ```

### VLibras não funciona após mudança de página

- Isso é normal, o sistema **reinicializa automaticamente**
- Se persistir, pode ser necessário **aguardar alguns segundos**

### Problemas de sobreposição

- O VLibras está configurado com **z-index: 9999**
- Verificar se outros elementos não têm z-index maior

## 📝 Configurações Avançadas

### Customização do VLibras

No arquivo `web/index.html`, você pode modificar:

```html
<!-- Configurações CSS -->
<style>
  [vw-access-button] {
    z-index: 9999 !important;
    position: fixed !important;
    /* Outras customizações */
  }
</style>

<!-- Configurações JavaScript -->
<script>
  new window.VLibras.Widget('https://vlibras.gov.br/app', {
    // Opções adicionais aqui
  });
</script>
```

### Configuração do Helper

No arquivo `vlibras_helper.dart`:

```dart
// Personalizar timeouts
static void _reinitialize() {
  setTimeout(() => {
    new window.VLibras.Widget("https://vlibras.gov.br/app");
  }, 1000); // Ajustar delay conforme necessário
}
```

## 🔄 Atualizações Futuras

### Melhorias Planejadas

- [ ] Cache local do script VLibras
- [ ] Configurações persistentes do usuário
- [ ] Integração com analytics
- [ ] Testes automatizados
- [ ] Suporte a temas personalizados

### Compatibilidade

- ✅ **Chrome** 80+
- ✅ **Firefox** 75+
- ✅ **Safari** 13+
- ✅ **Edge** 80+
- ❌ **Internet Explorer** (não suportado)

## 📞 Suporte

Para problemas técnicos:
1. Verificar **console do navegador**
2. Testar em **modo incógnito**
3. Verificar **conexão com internet**
4. Reportar com **logs detalhados**

## 📚 Recursos Adicionais

- [Documentação Oficial VLibras](https://vlibras.gov.br/)
- [Flutter Web Documentation](https://docs.flutter.dev/platform-integration/web)
- [Acessibilidade Web](https://www.w3.org/WAI/WCAG21/quickref/)
