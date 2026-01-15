#!/bin/bash
# Arrêter le script si une commande échoue
set -e

echo "🛠️  Installation des dépendances..."
npm ci

echo "🗄️  Préparation de la base de données de test..."
npx prisma db push

echo "🔍  Vérification de la qualité du code (Linting)..."
npm run lint --if-present

echo "🧪  Lancement des tests unitaires..."
npm test --if-present
