# Stage 1: Dependencies
FROM node:20-slim AS deps
WORKDIR /app
COPY app/package.json app/package-lock.json ./
RUN npm ci

# Stage 2: Builder
FROM node:20-slim AS builder
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY app/ .

# Génération du client Prisma
RUN npx prisma generate --schema=src/prisma/schema.prisma

# Build de l'application avec Nx
RUN npx nx build api --configuration=production

# Stage 3: Production
FROM node:20-slim AS production
WORKDIR /app
ENV NODE_ENV=production
ENV PORT=3000

# Sécurité : utilisateur non-root
RUN addgroup --system --gid 1001 nodejs && \
    adduser --system --uid 1001 api

# Copie des artefacts depuis le builder
COPY --from=builder /app/dist/api ./dist/api
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./
COPY --from=builder /app/src/prisma ./prisma

RUN chown -R api:nodejs /app
USER api

EXPOSE 3000
CMD ["node", "dist/api/main.js"]
