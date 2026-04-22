FROM zoraxydocker/zoraxy:latest

# Plugin version - update this when a new version is released
ARG PLUGIN_VERSION=v1.2.1

# Create plugin directory
RUN mkdir -p /opt/zoraxy/plugin/zoraxycrowdsecbouncer

# Download the pre-compiled plugin binary
ADD https://github.com/AnthonyMichaelTDM/zoraxy_crowdsec_bouncer/releases/download/${PLUGIN_VERSION}/zoraxycrowdsecbouncer \
    /opt/zoraxy/plugin/zoraxycrowdsecbouncer/zoraxycrowdsecbouncer

# Make plugin executable
RUN chmod +x /opt/zoraxy/plugin/zoraxycrowdsecbouncer/zoraxycrowdsecbouncer

# Copy entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Umgebungsvariablen mit Standardwerten
ENV CROWDSEC_API_KEY=""
ENV CROWDSEC_AGENT_URL="http://crowdsec:8080"
ENV CROWDSEC_LOG_LEVEL="warning"
ENV CROWDSEC_CLOUDFLARE="false"

ENTRYPOINT ["/entrypoint.sh"]
