#!/bin/bash
set -e

# Récupération du SHA du commit ou utilisation de 'local'
TAG=${1:-local}

echo "🐳  Construction de l'image Docker (Tag: $TAG)..."
docker build -f docker/Dockerfile -t ghcr.io/les-petits-foufou/tp-ci-cd:$TAG .
