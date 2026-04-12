# ----Checkout Docker File----
# --- Stage 1: Build Stage ---
FROM node:20-alpine AS build
WORKDIR /usr/src/app
COPY . .
RUN yarn install --frozen-lockfile
RUN yarn build

# --- Stage 2: Final Runtime ---
FROM public.ecr.aws/amazonlinux/amazonlinux:2023

RUN dnf --setopt=install_weak_deps=False install -q -y \
    nodejs20 \
    shadow-utils \
    && \
    dnf clean all

RUN alternatives --install /usr/bin/node node /usr/bin/node-20 90

ENV APPUSER=appuser
ENV APPUID=1000
ENV APPGID=1000

RUN useradd \
    --home "/app" \
    --create-home \
    --user-group \
    --uid "$APPUID" \
    "$APPUSER"

WORKDIR /app
USER appuser

COPY --chown=appuser:appuser --from=build /usr/src/app/node_modules ./node_modules
COPY --chown=appuser:appuser --from=build /usr/src/app/dist ./dist

ENTRYPOINT [ "node", "dist/main.js" ]