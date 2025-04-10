# Utiliser une image de base officielle Node.js
FROM node:14

# Définir le répertoire de travail dans le conteneur
WORKDIR /usr/src/weather-app

# Copier le fichier package.json et package-lock.json
COPY package*.json ./

# Installer les dépendances
RUN npm install

# Copier le reste de l'application
COPY . .

# Construire l'application
RUN npm run build

# Exposer le port sur lequel l'application va tourner
EXPOSE 3000

# Commande pour démarrer l'application
CMD ["npm", "start"]
