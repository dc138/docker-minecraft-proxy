FROM eclipse-temurin:17-jre-alpine
RUN apk add jq git

VOLUME /mc/proxy
WORKDIR /mc

ENV KEEP_ALIVE="false"
ENV PROXY_TYPE="vanilla"
ENV PROXY_VERSION="latest"
ENV PROXY_CUSTOM_URL=""

COPY entry.sh .

EXPOSE 25565

ENTRYPOINT ["/bin/sh", "entry.sh"]
