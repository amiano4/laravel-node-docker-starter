FROM node:20-alpine

# Enable and install pnpm
RUN corepack enable && corepack prepare pnpm@latest --activate

WORKDIR /app

COPY docker/node/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]