FROM node:20-alpine as build-deps

WORKDIR /usr/src/app
COPY . .

ENV NODE_OPTIONS --openssl-legacy-provider

RUN --mount=type=cache,target=/root/.npm \
    npm ci && npm run build

FROM nginx:alpine

WORKDIR /usr/share/nginx/html

COPY --from=build-deps /usr/src/app/build /var/www/public
COPY --from=build-deps /usr/src/app/node_modules/@socket.io/admin-ui/ui/dist /var/www/public/socket-admin
COPY nginx /etc/nginx

# Criar config.json padrão
RUN echo '{\
  "BACKEND_PROTOCOL": "http",\
  "BACKEND_HOST": "localhost",\
  "BACKEND_PORT": "8080",\
  "BACKEND_PATH": "",\
  "LOG_LEVEL": "info",\
  "ENV_TOKEN": "ticketz",\
  "ENVIRONMENT": "local"\
}' > /var/www/public/config.json

# Criar env-config.js padrão
RUN echo 'window.__APP_ENV_TOKEN__ = "ticketz";\
console.log("ENV_TOKEN configurado (local):", window.__APP_ENV_TOKEN__);' > /var/www/public/env-config.js

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"] 