# Build stage
FROM node:20-alpine AS builder
WORKDIR /app

COPY package*.json ./
RUN npm ci --only=production && npm cache clean --force

# Production stage
FROM node:20-alpine
WORKDIR /app

RUN addgroup -g 1001 -S nodejs && \
    adduser -S -u 1001 -G nodejs nodejs

COPY --from=builder /app/node_modules ./node_modules
COPY app.js ./

USER nodejs
EXPOSE 3000
CMD ["node", "app.js"]