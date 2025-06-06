#!/bin/bash

# Script de configuração para Easypanel
# Este script configura o ambiente para funcionar corretamente no Easypanel

# Função para gerar config.json otimizado
generate_config() {
    cat << EOF
{
  "BACKEND_PROTOCOL": "${BACKEND_PROTOCOL:-https}",
  "BACKEND_HOST": "${BACKEND_HOST:-localhost}",
  "BACKEND_PATH": "${BACKEND_PATH:-/backend}",
  "LOG_LEVEL": "${LOG_LEVEL:-info}",
  "ENV_TOKEN": "${ENV_TOKEN:-}",
  "ENVIRONMENT": "easypanel"
}
EOF
}

# Configurar DNS interno se BACKEND_SERVICE estiver definido
if [ -n "$BACKEND_SERVICE" ]; then
    echo "Configurando DNS interno para $BACKEND_SERVICE..."
    BACKEND_IP=$(getent hosts "$BACKEND_SERVICE" | awk '{ print $1 }' | head -n1)
    if [ -n "$BACKEND_IP" ]; then
        echo "$BACKEND_IP backend" >> /etc/hosts
        echo "DNS interno configurado: $BACKEND_IP -> backend"
    else
        echo "Aviso: Não foi possível resolver $BACKEND_SERVICE"
    fi
fi

# Gerar configuração JSON
echo "Gerando config.json..."
generate_config > /var/www/public/config.json

echo "Configuração gerada:"
cat /var/www/public/config.json

# Criar arquivo de configuração global para o ENV_TOKEN
echo "Configurando ENV_TOKEN global..."
cat << EOF > /var/www/public/env-config.js
window.__APP_ENV_TOKEN__ = "${ENV_TOKEN:-}";
console.log("ENV_TOKEN configurado:", window.__APP_ENV_TOKEN__ ? "OK" : "VAZIO");
EOF

echo "Iniciando nginx..."
exec nginx -g "daemon off;" 