# Image de base : Node.js (version LTS légère Alpine)
FROM node:20-alpine

# Dossier de travail dans le conteneur
WORKDIR /app

# 1re couche : dépendances (mise en cache tant que package.json ne change pas)
COPY package.json package-lock.json ./
RUN npm ci --omit=dev

# 2e couche : code source
COPY src ./src

# Port exposé par l'API Express
EXPOSE 3001

# Commande de démarrage
CMD ["npm", "start"]
