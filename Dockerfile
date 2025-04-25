# Étape 1 : Build de l'application React
FROM node:16-alpine as build-vuejs
WORKDIR /app

# Copier les fichiers nécessaires pour installer les dépendances
COPY package*.json ./

# Installer les dépendances
RUN npm install

# Copier le reste du projet
COPY . .

# Construire l'application (génère le dossier "build")
RUN npm run build

# Étape 2 : Serveur Nginx pour les fichiers statiques
FROM nginx:stable-alpine as production-vuejs
WORKDIR /usr/share/nginx/html

# Supprimer les fichiers par défaut de Nginx
RUN rm -rf ./*

# Copier le build de l'étape précédente depuis l'étape `build-vuejs`
COPY --from=build-vuejs /app/build /usr/share/nginx/html

# Copier un fichier de configuration Nginx personnalisé si besoin (facultatif)
COPY nginx.conf /etc/nginx/conf.d/default.conf
RUN cat /etc/nginx/conf.d/default.conf

# Changer les permissions des fichiers pour Nginx
RUN chown -R nginx:nginx /usr/share/nginx/html

# Exposer le port 80 (classique pour Nginx)
EXPOSE 8080

# Démarrer Nginx
CMD ["nginx", "-g", "daemon off;"]
