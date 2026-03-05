# Stage 1: build
FROM node:18-alpine AS build

WORKDIR /app

COPY package.json package-lock.json yarn.lock ./
RUN npm ci --legacy-peer-deps

COPY . .
RUN npm run build

# Stage 2: production
FROM node:18-alpine

WORKDIR /app

RUN npm install -g serve@14.2.1

COPY --from=build /app/dist ./dist

EXPOSE 3000

CMD ["serve", "-s", "dist", "-l", "3000"]
