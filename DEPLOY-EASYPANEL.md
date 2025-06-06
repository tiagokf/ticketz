# Deploy do Ticketz no Easypanel

Este guia mostra como fazer o deploy correto do projeto Ticketz no Easypanel.

## Problemas Resolvidos

As seguintes correções foram implementadas para garantir funcionamento no Easypanel:

1. **Configuração CORS flexível** - Backend aceita múltiplas origens
2. **Proxy nginx otimizado** - Headers corretos para SSL/TLS
3. **Script de configuração específico** - Geração otimizada do config.json
4. **DNS interno** - Resolução automática entre containers
5. **ENV_TOKEN automático** - Token injetado globalmente para public-settings
6. **Index.html otimizado** - Splash screen com autenticação correta

## Schema Corrigido

Use o arquivo `easypanel-schema.json` que contém as configurações corrigidas.

### Principais Correções no Schema:

#### Frontend:
```env
# CONFIGURAÇÃO CORRIGIDA PARA EASYPANEL

# Protocolo do backend (sempre HTTPS em produção)
BACKEND_PROTOCOL=https

# Host do backend (SEM porta para HTTPS) 
BACKEND_HOST=apicrm.luckdistribuidora.com.br

# Caminho para proxy (sempre usar /backend)
BACKEND_PATH=/backend

# Para resolução DNS interna entre containers
BACKEND_SERVICE=luck_backcrmluck

# Configurações de log
LOG_LEVEL=debug

# Token de ambiente (OBRIGATÓRIO - mesmo do backend)
ENV_TOKEN=luck
```

#### Backend:
```env
# URLs e CORS - CONFIGURAÇÃO CORRIGIDA
FRONTEND_URL=https://crm.luckdistribuidora.com.br
BACKEND_URL=https://apicrm.luckdistribuidora.com.br
CORS_ORIGIN=https://crm.luckdistribuidora.com.br
```

## Passo a Passo do Deploy

### 1. Preparar o Repositório
```bash
# Clone e faça push das correções
git add .
git commit -m "Correções para deploy no Easypanel"
git push origin main
```

### 2. Configurar no Easypanel

1. **Importe o schema corrigido** (`easypanel-schema.json`)
2. **Aguarde o build** dos containers
3. **Verifique os logs** de cada serviço

### 3. Verificar Funcionamento

Após o deploy, verifique:

1. **Backend**: Acesse `https://apicrm.luckdistribuidora.com.br/`
2. **Frontend**: Acesse `https://crm.luckdistribuidora.com.br/`
3. **Console do navegador**: Não deve mais mostrar erros SSL

## Logs de Debug

Para verificar problemas:

### Logs do Frontend:
```bash
# No Easypanel, vá em Services > frontcrmluck > Logs
```

### Logs do Backend:
```bash
# No Easypanel, vá em Services > backcrmluck > Logs
```

## Variáveis de Ambiente Críticas

### Não Funciona ❌:
```env
# BACKEND_PORT=3000  # Causa erro SSL
# BACKEND_PROTOCOL=http  # Não funciona com HTTPS
```

### Funciona ✅:
```env
BACKEND_PROTOCOL=https
BACKEND_HOST=apicrm.luckdistribuidora.com.br
BACKEND_SERVICE=luck_backcrmluck
```

## Arquivos Modificados

Os seguintes arquivos foram corrigidos:

1. `frontend/nginx/sites.d/frontend.conf` - Headers de proxy
2. `frontend/Dockerfile` - Uso do script otimizado  
3. `frontend/easypanel-config.sh` - Script de configuração
4. `frontend/public/index.html` - Splash screen com ENV_TOKEN
5. `frontend/src/services/api.js` - Interceptor para ENV_TOKEN
6. `backend/src/app.ts` - CORS flexível
7. `backend/src/libs/socket.ts` - Socket.io CORS

## Troubleshooting

### Erro SSL Protocol Error
- **Causa**: `BACKEND_PORT=3000` com HTTPS
- **Solução**: Remover ou usar `BACKEND_PORT=443`

### Erro 403 nos recursos
- **Causa**: CORS mal configurado
- **Solução**: Verificar `CORS_ORIGIN` no backend

### Container não inicia
- **Causa**: Variável de ambiente malformada
- **Solução**: Verificar sintaxe no schema

## Comandos Úteis

### Verificar config.json gerado:
```bash
# No container do frontend
cat /var/www/public/config.json
```

### Verificar DNS interno:
```bash
# No container do frontend  
cat /etc/hosts
```

### Testar conectividade:
```bash
# Do frontend para o backend
wget -O- http://luck_backcrmluck:3000/
```

## Suporte

Se encontrar problemas:

1. Verifique os logs de ambos os serviços
2. Compare com o schema corrigido
3. Confirme que os domínios estão configurados no DNS
4. Verifique se os certificados SSL estão válidos 