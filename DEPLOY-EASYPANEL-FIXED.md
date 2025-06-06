# 🚀 Deploy no Easypanel (Versão Corrigida)

## 📋 **Problemas Resolvidos**

### ❌ **Problemas Anteriores:**
- `ERR_SSL_PROTOCOL_ERROR` - Frontend tentava acessar `apicrm.luckdistribuidora.com.br:3000` diretamente
- 403 errors em `/backend/public-settings/` - Rotas não autenticadas
- Script `easypanel-config.sh` não encontrado
- CORS incorreto entre domínios

### ✅ **Soluções Implementadas:**
- **Frontend usa MESMO domínio** do backend via proxy nginx: `crm.luckdistribuidora.com.br/backend`
- **Dockerfiles específicos** para produção (`Dockerfile.prod`)
- **Nginx configurado** para rotear corretamente os serviços
- **ENV_TOKEN** incluído automaticamente nas requisições
- **CORS configurado** para múltiplas origens

---

## 🏗️ **Estrutura Corrigida**

```
Frontend: crm.luckdistribuidora.com.br
  ├── / → Interface React (porta 80)
  ├── /backend → Proxy para Backend (porta 3000)
  └── /socket.io → WebSocket para Backend

Backend: luck_backcrmluck (interno)
  └── :3000 → API REST + Socket.io (HTTP interno)

Database: luck_postgresluck:5432
Redis: luck_redisluck:6379
```

---

## 📝 **Schema Corrigido**

Use o arquivo `easypanel-schema-fixed.json`:

### **Principais Mudanças:**

#### **Backend:**
- `Dockerfile.prod` específico para produção
- `BACKEND_URL=https://crm.luckdistribuidora.com.br/backend`
- Removeu domínio `apicrm.luckdistribuidora.com.br`

#### **Frontend:**
- `Dockerfile.prod` com script de configuração dinâmica
- Nginx roteando `/backend/*` para `luck_backcrmluck:3000`
- Configuração gerada dinamicamente via ENV vars

---

## 🔧 **Variáveis de Ambiente**

### **Backend (`backcrmluck`):**
```env
# URLs CORRIGIDAS
FRONTEND_URL=https://crm.luckdistribuidora.com.br
BACKEND_URL=https://crm.luckdistribuidora.com.br/backend
CORS_ORIGIN=https://crm.luckdistribuidora.com.br

# Usar as configurações do arquivo backend.env
```

### **Frontend (`frontcrmluck`):**
```env
# CONFIGURAÇÃO SIMPLIFICADA
BACKEND_PROTOCOL=https
BACKEND_HOST=crm.luckdistribuidora.com.br
BACKEND_PATH=/backend
ENV_TOKEN=luck
```

---

## 🚀 **Como Fazer o Deploy**

### **1. Fazer Push das Alterações:**
```bash
git add .
git commit -m "feat: Dockerfiles de produção para Easypanel"
git push origin main
```

### **2. No Easypanel:**
1. **Deletar serviços antigos** (se existirem)
2. **Importar** o schema `easypanel-schema-fixed.json`
3. **Verificar** que está usando `Dockerfile.prod` em ambos os serviços
4. **Fazer deploy** dos serviços na ordem:
   - PostgreSQL → Redis → Backend → Frontend

### **3. Verificar DNS:**
- `crm.luckdistribuidora.com.br` → Frontend
- ~~`apicrm.luckdistribuidora.com.br`~~ → **REMOVER ESTE DOMÍNIO**

---

## 🔍 **Monitoramento**

### **Logs para Verificar:**

#### **Frontend:**
```bash
=== Iniciando configuração do Frontend ===
BACKEND_HOST: crm.luckdistribuidora.com.br
BACKEND_PATH: /backend
```

#### **Backend:**
```bash
Server started on port: 3000
Database connected successfully
```

### **Testes após Deploy:**
1. **Acesso:** `https://crm.luckdistribuidora.com.br`
2. **API:** `https://crm.luckdistribuidora.com.br/backend/public-settings/appName`
3. **WebSocket:** Deve conectar automaticamente

---

## 🔧 **Troubleshooting**

### **Se ainda houver erros SSL:**
1. Verificar se `apicrm.luckdistribuidora.com.br` foi **removido** do DNS
2. Confirmar que frontend usa apenas `crm.luckdistribuidora.com.br/backend`

### **Se 403 em public-settings:**
1. Verificar se `ENV_TOKEN=luck` está configurado no frontend
2. Confirmar que o script está gerando `env-config.js` corretamente

### **Se nginx não rotear:**
1. Verificar se `frontend.prod.conf` está sendo copiado
2. Confirmar que usa `luck_backcrmluck:3000` (nome do serviço interno)

---

## 📊 **Diferenças Principais**

| Aspecto | Antes | Depois |
|---------|-------|--------|
| **Frontend URL** | `crm.luckdistribuidora.com.br` | `crm.luckdistribuidora.com.br` |
| **Backend URL** | `apicrm.luckdistribuidora.com.br:3000` | `crm.luckdistribuidora.com.br/backend` |
| **Acesso API** | Direto HTTPS→porta HTTP (❌) | Via nginx proxy (✅) |
| **CORS** | Domínios diferentes | Mesmo domínio |
| **SSL** | Erro de protocolo | Resolvido via proxy |

---

🎉 **Com essas correções, o projeto deve funcionar perfeitamente no Easypanel!** 