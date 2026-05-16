# ----Catalog Docker File----
# --- Stage 1: Build Stage ---
FROM public.ecr.aws/amazonlinux/amazonlinux:2023-minimal AS build-env

# Install only what's needed to build
RUN microdnf --setopt=install_weak_deps=0 install -y \
    git \
    golang \
    && \
    microdnf clean all

RUN mkdir -p "${GOPATH}/src" "${GOPATH}/bin" /appsrc

WORKDIR /appsrc

ENV GOPROXY=https://goproxy.io,direct

COPY go.mod go.sum ./
RUN go mod download

COPY . .

RUN go build -o main main.go

# --- Stage 2: Final Runtime ---
FROM public.ecr.aws/amazonlinux/amazonlinux:2023-minimal

ENV APPUSER=appuser
ENV APPUID=1000
ENV APPGID=1000

RUN microdnf --setopt=install_weak_deps=0 install -y \
    shadow-utils \
    && \
    microdnf clean all

RUN useradd \
    --home "/app" \
    --create-home \
    --user-group \
    --uid "$APPUID" \
    "$APPUSER"

WORKDIR /app
USER appuser

COPY --chown=appuser:appuser --from=build-env /appsrc/main /app/

COPY ./ATTRIBUTION.md ./LICENSES.md

ENV GIN_MODE=release

ENTRYPOINT ["/app/main"]
