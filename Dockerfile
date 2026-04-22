FROM zoraxydocker/zoraxy:latest

ARG PLUGIN_VERSION=v1.2.1

# Git installieren
RUN apk add --no-cache git

# Plugin ins Image an einen ANDEREN Ort klonen (nicht ins Volume!)
# Beim Container-Start kopiert entrypoint.sh die Dateien ins Volume
RUN git clone --depth 1 --branch ${PLUGIN_VERSION} \
    https://github.com/AnthonyMichaelTDM/zoraxy_crowdsec_bouncer.git \
    /opt/zoraxy/plugin_bundled/zoraxycrowdsecbouncer

# Vorkompilierte Binary herunterladen
ADD https://github.com/AnthonyMichaelTDM/zoraxy_crowdsec_bouncer/releases/download/${PLUGIN_VERSION}/zoraxycrowdsecbouncer \
    /opt/zoraxy/plugin_bundled/zoraxycrowdsecbouncer/zoraxycrowdsecbouncer

# Binary ausführbar machen
RUN chmod +x /opt/zoraxy/plugin_bundled/zoraxycrowdsecbouncer/zoraxycrowdsecbouncer

# Entrypoint kopieren
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Umgebungsvariablen
ENV CROWDSEC_API_KEY=""
ENV CROWDSEC_AGENT_URL="http://crowdsec:8080"
ENV CROWDSEC_LOG_LEVEL="warning"
ENV CROWDSEC_CLOUDFLARE="false"

ENTRYPOINT ["/entrypoint.sh"]
