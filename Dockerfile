# Multi-stage Dockerfile for nextjs frontend

# Builder stage
FROM node:22-alpine AS builder
WORKDIR /app

# Copy manifest and lock files
COPY package*.json ./
COPY yarn.lock ./
RUN yarn install

# Copy all sources
COPY . .
RUN yarn build

FROM node:18-alpine AS production
WORKDIR /app

# Copy built code and production dependencies
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/yarn.lock ./
RUN yarn install
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public
#FOR nextjs only
EXPOSE 80    
#CMD ["yarn", "run", "start"]
CMD ["sh", "-c", "PORT=80 yarn run start"]
