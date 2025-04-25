# Étape 1: Utiliser une image de base officielle de Node.js pour construire l'application
FROM node:14 AS build

# Définir le répertoire de travail dans le conteneur
WORKDIR /usr/src/weather-app

# Copier le fichier package.json et package-lock.json
COPY package*.json ./

# Installer les dépendances
RUN npm install

# Copier le reste de l'application
COPY . .

# Construire l'application pour la production
RUN npm run build

# Étape 2: Utiliser une image Nginx pour servir l'application
FROM nginx:alpine

# Copier les fichiers construits par l'étape précédente vers le répertoire où Nginx les servira
COPY --from=build /usr/src/weather-app/build /usr/share/nginx/html

# Exposer le port sur lequel Nginx écoutera
EXPOSE 80

# Commande par défaut pour démarrer Nginx
CMD ["nginx", "-g", "daemon off;"]
