FROM zoraxydocker/zoraxy:latest

# Plugin version - update this when a new version is released
ARG PLUGIN_VERSION=v1.2.1

# Create plugin directory
RUN mkdir -p /opt/zoraxy/plugin/zoraxycrowdsecbouncer

# Download the pre-compiled plugin binary
ADD https://github.com/AnthonyMichaelTDM/zoraxy_crowdsec_bouncer/releases/download/${PLUGIN_VERSION}/zoraxycrowdsecbouncer \
    /opt/zoraxy/plugin/zoraxycrowdsecbouncer/zoraxycrowdsecbouncer

# Download default config
ADD https://github.com/AnthonyMichaelTDM/zoraxy_crowdsec_bouncer/releases/download/${PLUGIN_VERSION}/config.yaml \
    /opt/zoraxy/plugin/zoraxycrowdsecbouncer/config.yaml

# Make plugin executable
RUN chmod +x /opt/zoraxy/plugin/zoraxycrowdsecbouncer/zoraxycrowdsecbouncer
