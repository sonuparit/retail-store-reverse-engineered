# ----Cart Docker File----
# --- Stage 1: Build Stage ---
FROM public.ecr.aws/amazonlinux/amazonlinux:2023-minimal AS build-env

# Install only what's needed to build
RUN microdnf --setopt=install_weak_deps=0 install -y \
    maven \
    java-21-amazon-corretto-headless \
    which \
    tar \
    gzip \
    && \
    microdnf clean all

VOLUME /tmp
WORKDIR /

COPY .mvn .mvn
COPY mvnw .
COPY pom.xml .

# Force Linux line endings and ensure it's executable
RUN sed -i 's/\r$//' mvnw && chmod +x mvnw

RUN ./mvnw dependency:go-offline -B -q

COPY ./src ./src

RUN ./mvnw -DskipTests package -q && \
    mv /target/carts-0.0.1-SNAPSHOT.jar /app.jar

# --- Stage 2: Final Runtime ---
FROM public.ecr.aws/amazonlinux/amazonlinux:2023-minimal

RUN microdnf --setopt=install_weak_deps=0 install -y \
    java-21-amazon-corretto-headless \
    shadow-utils \
    && microdnf clean all

ENV APPUSER=appuser
ENV APPUID=1000
ENV APPGID=1000

RUN useradd \
    --home "/app" \
    --create-home \
    --user-group \
    --uid "$APPUID" \
    "$APPUSER"

ENV SPRING_PROFILES_ACTIVE=prod

WORKDIR /app
USER appuser

COPY ./ATTRIBUTION.md ./LICENSES.md

COPY --from=build-env --chown=appuser:appuser /app.jar .

EXPOSE 8080

ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar /app/app.jar"]
