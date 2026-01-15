#!/bin/bash
set -e

echo "🚀  Déploiement du conteneur..."

# Arrêt de l'ancien conteneur
docker stop api-container || true
docker rm api-container || true

# Lancement du nouveau
docker run -d \
  --name api-container \
  --restart always \
  -p 3000:3000 \
  -e DATABASE_URL="$DATABASE_URL" \
  -e JWT_SECRET="$JWT_SECRET" \
  ghcr.io/les-petits-foufou/tp-ci-cd:latest
