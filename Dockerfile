FROM eclipse-temurin:21-jre-alpine
RUN apk add jq git setpriv

# Environment

ENV JVM_FLAGS="-Xms512M -Xmx1024M"

ENV PROXY_TYPE="vanilla"
ENV PROXY_VERSION="latest"
ENV PROXY_CUSTOM_URL=""

ENV UID=1000
ENV GID=1000

# Run the proxy

VOLUME /mc/proxy
WORKDIR /mc

COPY entry.sh .

EXPOSE 25565

ENTRYPOINT ["/bin/sh", "entry.sh"]
