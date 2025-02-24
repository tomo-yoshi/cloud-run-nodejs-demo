FROM node:22-alpine

WORKDIR /app

# Install pnpm
RUN corepack enable && corepack prepare pnpm@latest --activate

COPY package*.json ./
RUN pnpm install

COPY . .
RUN pnpm run build

EXPOSE 3000
CMD ["pnpm", "start"] 