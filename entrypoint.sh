#!/bin/sh

PLUGIN_DEST="/opt/zoraxy/plugin/zoraxycrowdsecbouncer"
PLUGIN_SRC="/opt/zoraxy/plugin_bundled/zoraxycrowdsecbouncer"

echo "=== Zoraxy CrowdSec Bouncer Setup ==="

# Plugin-Dateien ins Volume kopieren wenn Binary fehlt
if [ ! -f "$PLUGIN_DEST/zoraxycrowdsecbouncer" ]; then
  echo "Plugin nicht im Volume gefunden – kopiere aus Image..."
  mkdir -p "$PLUGIN_DEST"
  cp -r "$PLUGIN_SRC/." "$PLUGIN_DEST/"
  chmod +x "$PLUGIN_DEST/zoraxycrowdsecbouncer"
  echo "✅ Plugin kopiert nach: $PLUGIN_DEST"
else
  echo "✅ Plugin bereits im Volume vorhanden."
fi

# Variablen setzen
if [ -z "$CROWDSEC_API_KEY" ]; then
  echo "⚠️  WARNUNG: CROWDSEC_API_KEY ist nicht gesetzt!"
  CROWDSEC_API_KEY="BITTE_API_KEY_EINTRAGEN"
fi

if [ -z "$CROWDSEC_AGENT_URL" ]; then
  CROWDSEC_AGENT_URL="http://crowdsec:8080"
fi

CROWDSEC_LOG_LEVEL="${CROWDSEC_LOG_LEVEL:-warning}"
CROWDSEC_CLOUDFLARE="${CROWDSEC_CLOUDFLARE:-false}"

# config.yaml Inhalt
CONFIG_CONTENT="# CrowdSec Bouncer Konfiguration
# Wird bei jedem Start mit den Container-Variablen aktualisiert
api_key: ${CROWDSEC_API_KEY}
agent_url: ${CROWDSEC_AGENT_URL}
log_level: ${CROWDSEC_LOG_LEVEL}
is_proxied_behind_cloudflare: ${CROWDSEC_CLOUDFLARE}"

# config.yaml an alle möglichen Orte schreiben
echo "$CONFIG_CONTENT" > "$PLUGIN_DEST/config.yaml"
echo "$CONFIG_CONTENT" > "/opt/zoraxy/config.yaml"
echo "$CONFIG_CONTENT" > "/opt/zoraxy/plugins/config.yaml" 2>/dev/null || true

echo "✅ config.yaml geschrieben nach:"
echo "   - $PLUGIN_DEST/config.yaml"
echo "   - /opt/zoraxy/config.yaml"

echo "=== Starte Zoraxy ==="
exec zoraxy -docker=true -port=:8000
