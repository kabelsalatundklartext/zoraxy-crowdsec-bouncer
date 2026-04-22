FROM zoraxydocker/zoraxy:latest

# Plugin version
ARG PLUGIN_VERSION=v1.2.1

# Git installieren um das Repo zu klonen
RUN apk add --no-cache git

# Plugin Verzeichnis erstellen
RUN mkdir -p /opt/zoraxy/plugin/zoraxycrowdsecbouncer

# Komplettes Plugin Repository klonen
RUN git clone --depth 1 --branch ${PLUGIN_VERSION} \
    https://github.com/AnthonyMichaelTDM/zoraxy_crowdsec_bouncer.git \
    /opt/zoraxy/plugin/zoraxycrowdsecbouncer

# Vorkompilierte Binary herunterladen (ersetzt die im Repo falls vorhanden)
ADD https://github.com/AnthonyMichaelTDM/zoraxy_crowdsec_bouncer/releases/download/${PLUGIN_VERSION}/zoraxycrowdsecbouncer \
    /opt/zoraxy/plugin/zoraxycrowdsecbouncer/zoraxycrowdsecbouncer

# Binary ausführbar machen
RUN chmod +x /opt/zoraxy/plugin/zoraxycrowdsecbouncer/zoraxycrowdsecbouncer

# Entrypoint kopieren
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Umgebungsvariablen
ENV CROWDSEC_API_KEY=""
ENV CROWDSEC_AGENT_URL="http://crowdsec:8080"
ENV CROWDSEC_LOG_LEVEL="warning"
ENV CROWDSEC_CLOUDFLARE="false"

ENTRYPOINT ["/entrypoint.sh"]
