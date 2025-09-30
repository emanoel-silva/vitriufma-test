#!/bin/bash

# Script para build do Flutter Web com VLibras

echo "🔧 Iniciando build do Flutter Web com VLibras..."

# Limpa builds anteriores
echo "🧹 Limpando builds anteriores..."
flutter clean

# Obtém dependências
echo "📦 Obtendo dependências..."
flutter pub get

# Build para web
echo "🌐 Fazendo build para web..."
flutter build web --web-renderer html --release

# Verifica se o build foi bem-sucedido
if [ $? -eq 0 ]; then
    echo "✅ Build concluído com sucesso!"
    echo ""
    echo "📝 Verificando integração do VLibras:"
    
    # Verifica se o VLibras está no index.html
    if grep -q "vlibras.gov.br" build/web/index.html; then
        echo "✅ VLibras encontrado no index.html"
    else
        echo "❌ VLibras NÃO encontrado no index.html"
    fi
    
    # Verifica se existem os atributos VLibras
    if grep -q 'vw class="enabled"' build/web/index.html; then
        echo "✅ Atributos VLibras encontrados"
    else
        echo "❌ Atributos VLibras NÃO encontrados"
    fi
    
    echo ""
    echo "🚀 Para testar localmente, execute:"
    echo "   cd build/web && python3 -m http.server 8000"
    echo "   Em seguida acesse: http://localhost:8000"
    echo ""
    echo "📋 Dicas de deploy:"
    echo "   - Certifique-se de que o servidor suporte arquivos .js"
    echo "   - Configure CORS se necessário"
    echo "   - Use HTTPS em produção para melhor funcionamento do VLibras"
    
else
    echo "❌ Erro no build!"
    exit 1
fi
