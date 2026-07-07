FROM node:22-bookworm-slim AS build

WORKDIR /app

ENV CI=1

RUN corepack enable

COPY package.json pnpm-lock.yaml pnpm-workspace.yaml ./
COPY apps/webclaw/package.json apps/webclaw/package.json
COPY apps/landing/package.json apps/landing/package.json
COPY packages/webclaw/package.json packages/webclaw/package.json

RUN pnpm install --frozen-lockfile --ignore-scripts

COPY . .

RUN pnpm -C apps/webclaw build

ENV NODE_ENV=production
ENV HOST=0.0.0.0
ENV PORT=3000

EXPOSE 3000

CMD ["pnpm", "-C", "apps/webclaw", "preview", "--host", "0.0.0.0", "--port", "3000"]
