FROM zoraxydocker/zoraxy:latest

# Plugin version
ARG PLUGIN_VERSION=v1.2.1

# Create plugin directory
RUN mkdir -p /opt/zoraxy/plugins/zoraxycrowdsecbouncer

# Download plugin binary
ADD https://github.com/AnthonyMichaelTDM/zoraxy_crowdsec_bouncer/releases/download/${PLUGIN_VERSION}/zoraxycrowdsecbouncer \
    /opt/zoraxy/plugins/zoraxycrowdsecbouncer/zoraxycrowdsecbouncer

# Make plugin executable
RUN chmod +x /opt/zoraxy/plugins/zoraxycrowdsecbouncer/zoraxycrowdsecbouncer

# Debug: Zeige wo Zoraxy liegt beim Build
RUN echo "=== Zoraxy Binary suchen ===" && \
    find / -name "zoraxy" -type f 2>/dev/null || echo "Nicht gefunden via find" && \
    which zoraxy 2>/dev/null || echo "Nicht im PATH" && \
    cat /proc/1/cmdline 2>/dev/null || echo "cmdline nicht lesbar"

# Copy entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Umgebungsvariablen
ENV CROWDSEC_API_KEY=""
ENV CROWDSEC_AGENT_URL="http://crowdsec:8080"
ENV CROWDSEC_LOG_LEVEL="warning"
ENV CROWDSEC_CLOUDFLARE="false"

ENTRYPOINT ["/entrypoint.sh"]
