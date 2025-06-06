# 🔒 Guia de Segurança - Ticketz

## ⚠️ IMPORTANTE: Dados Sensíveis

**NUNCA commite dados sensíveis no repositório!** Isso inclui:

- ❌ Senhas de banco de dados
- ❌ Tokens JWT e secrets
- ❌ Chaves de API 
- ❌ Emails pessoais
- ❌ Domínios específicos de produção

## 🛠️ Configuração Segura

### 1. Use o Template

Utilize o arquivo `easypanel-schema-template.json` como base e substitua os placeholders:

```bash
cp easypanel-schema-template.json easypanel-schema.json
```

### 2. Gere Secrets Seguros

#### JWT Secrets (64+ caracteres):
```bash
# JWT_SECRET
node -e "console.log(require('crypto').randomBytes(64).toString('hex'))"

# JWT_REFRESH_SECRET  
node -e "console.log(require('crypto').randomBytes(64).toString('hex'))"
```

#### Senhas Seguras:
```bash
# DB_PASS e Redis Password
openssl rand -base64 32
```

#### ENV_TOKEN:
```bash
# Simples mas único
openssl rand -hex 16
```

### 3. Substitua os Placeholders

No arquivo `easypanel-schema.json`:

| Placeholder | Exemplo | Descrição |
|------------|---------|-----------|
| `YOUR_PROJECT_NAME` | `meucrm` | Nome do projeto no Easypanel |
| `YOUR_GITHUB_USERNAME` | `seunome` | Seu usuário do GitHub |
| `YOUR_FRONTEND_DOMAIN.com` | `crm.seusite.com` | Domínio do frontend |
| `YOUR_BACKEND_DOMAIN.com` | `api.seusite.com` | Domínio do backend |
| `YOUR_SECURE_DB_PASSWORD` | `abc123XYZ...` | Senha segura do banco |
| `YOUR_SECURE_REDIS_PASSWORD` | `def456UVW...` | Senha segura do Redis |
| `YOUR_SECURE_ENV_TOKEN` | `ghi789RST...` | Token de ambiente |
| `YOUR_SECURE_JWT_SECRET_64_CHARS_MINIMUM` | Resultado do comando acima | Secret JWT |
| `YOUR_EMAIL@YOUR_DOMAIN.com` | `admin@seusite.com` | Email administrativo |

### 4. Adicione ao .gitignore

Certifique-se de que o arquivo com dados reais não seja commitado:

```bash
# Adicione ao .gitignore
echo "easypanel-schema.json" >> .gitignore
echo "*.env" >> .gitignore
echo "*.env.local" >> .gitignore
```

## 🔄 Rotação de Secrets

### Se secrets foram expostos:

1. **Imediatamente:**
   - Gere novos secrets
   - Atualize no Easypanel
   - Redeploy os serviços

2. **Longo prazo:**
   - Monitore logs de acesso
   - Considere rotacionar periodicamente

## ✅ Boas Práticas

### Para Desenvolvimento:
- Use valores de desenvolvimento diferentes dos de produção
- Mantenha um arquivo `.env.example` sem valores reais

### Para Produção:
- Use gerenciadores de secrets (HashiCorp Vault, etc.)
- Implemente rotação automática
- Monitore acessos não autorizados

### Para Git:
- Use ferramentas como `git-secrets` para prevenir commits de secrets
- Configure pre-commit hooks
- Use `.gitignore` adequadamente

## 🚨 Resposta a Incidentes

Se detectar exposição de secrets:

1. **Pare imediatamente** qualquer processo que use os secrets expostos
2. **Gere novos secrets** seguindo este guia
3. **Atualize todas** as configurações
4. **Monitore logs** por atividade suspeita
5. **Documente** o incidente para aprendizado

## 📞 Suporte

Para questões de segurança:
- Abra uma issue privada no repositório
- Use práticas de responsible disclosure
- Documente problemas encontrados

---

**Lembre-se:** Segurança é responsabilidade de todos. Sempre revise seus commits antes de fazer push! 