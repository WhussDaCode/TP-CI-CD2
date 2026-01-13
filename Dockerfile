# =============================================================================
# DOCKERFILE - API Node.js (Nx + Prisma + Express)
# Multi-stage build optimisé pour CI/CD
# =============================================================================

# -----------------------------------------------------------------------------
# Stage 1: Dependencies (cache optimisé)
# -----------------------------------------------------------------------------
FROM node:20-alpine AS deps

WORKDIR /app

# Copier uniquement les fichiers de dépendances pour optimiser le cache
COPY package.json package-lock.json ./

# Installer toutes les dépendances (dev inclus pour le build)
RUN npm ci

# -----------------------------------------------------------------------------
# Stage 2: Builder
# -----------------------------------------------------------------------------
FROM node:20-alpine AS builder

WORKDIR /app

# Copier les dépendances du stage précédent
COPY --from=deps /app/node_modules ./node_modules
COPY . .

# Générer le client Prisma
RUN npx prisma generate --schema=src/prisma/schema.prisma

# Build de l'application avec Nx
RUN npx nx build api --configuration=production

# -----------------------------------------------------------------------------
# Stage 3: Production
# -----------------------------------------------------------------------------
FROM node:20-alpine AS production

# Labels pour identification de l'image
LABEL org.opencontainers.image.source="https://github.com/WhussDaCode/TP-CI-CD"
LABEL org.opencontainers.image.description="RealWorld API - Node.js/Express/Prisma"

WORKDIR /app

# Variables d'environnement par défaut
ENV NODE_ENV=production
ENV HOST=0.0.0.0
ENV PORT=3000

# Créer un utilisateur non-root pour la sécurité
RUN addgroup --system --gid 1001 nodejs && \
    adduser --system --uid 1001 api

# Copier les fichiers nécessaires depuis le builder
COPY --from=builder /app/dist/api ./dist/api
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./
COPY --from=builder /app/src/prisma ./prisma

# Changer les permissions
RUN chown -R api:nodejs /app

# Utiliser l'utilisateur non-root
USER api

# Exposer le port
EXPOSE 3000

# Healthcheck pour Docker/orchestrateurs
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD wget --no-verbose --tries=1 --spider http://localhost:3000/api/health || exit 1

# Commande de démarrage
CMD ["node", "dist/api/main.js"]
