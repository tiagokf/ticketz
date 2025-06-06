#!/bin/bash

# Script de configuração para Easypanel
# Este script configura o ambiente para funcionar corretamente no Easypanel

# Função para gerar config.json otimizado
generate_config() {
    echo "{"
    
    # Configurações essenciais do backend
    if [ -n "$BACKEND_PROTOCOL" ]; then
        echo "  \"BACKEND_PROTOCOL\": \"$BACKEND_PROTOCOL\","
    else
        echo "  \"BACKEND_PROTOCOL\": \"https\","
    fi
    
    if [ -n "$BACKEND_HOST" ]; then
        echo "  \"BACKEND_HOST\": \"$BACKEND_HOST\","
    fi
    
    if [ -n "$BACKEND_PORT" ]; then
        echo "  \"BACKEND_PORT\": \"$BACKEND_PORT\","
    fi
    
    if [ -n "$BACKEND_PATH" ]; then
        echo "  \"BACKEND_PATH\": \"$BACKEND_PATH\","
    fi
    
    if [ -n "$LOG_LEVEL" ]; then
        echo "  \"LOG_LEVEL\": \"$LOG_LEVEL\","
    fi
    
    if [ -n "$ENV_TOKEN" ]; then
        echo "  \"ENV_TOKEN\": \"$ENV_TOKEN\","
    fi
    
    # Configurações do React (se existirem)
    while IFS='=' read -r name value; do
        if [[ "$name" == REACT_APP_* ]]; then
            echo "  \"$name\": \"$value\","
        fi
    done < <(env)
    
    # Remover a última vírgula e fechar JSON
    echo "  \"ENVIRONMENT\": \"easypanel\""
    echo "}"
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

echo "Iniciando nginx..."
exec nginx -g "daemon off;" 