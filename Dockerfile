# Étape 1 : Build de l'application React
FROM node:16-alpine as build-vuejs
WORKDIR /app

COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# Étape 2 : Serveur Nginx pour les fichiers statiques
FROM nginx:stable-alpine as production-vuejs
WORKDIR /usr/share/nginx/html

# Supprimer les fichiers par défaut de Nginx
RUN rm -rf ./*

# Copier le build de l'étape précédente
COPY --from=build-vuejs /app/build /usr/share/nginx/html

# Copier le fichier de configuration modèle
COPY default.conf.template /etc/nginx/templates/default.conf.template

# Copier le script d'entrée
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

# Définir le script d'entrée
ENTRYPOINT ["/docker-entrypoint.sh"]
