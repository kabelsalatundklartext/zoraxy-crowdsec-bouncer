#!/bin/sh

PLUGIN_DEST="/opt/zoraxy/plugin/zoraxycrowdsecbouncer"
PLUGIN_SRC="/opt/zoraxy/plugin_bundled/zoraxycrowdsecbouncer"
CONFIG_FILE="$PLUGIN_DEST/config.yaml"

echo "=== Zoraxy CrowdSec Bouncer Setup ==="

# Plugin-Dateien aus dem Image ins Volume kopieren (nur wenn Binary fehlt)
if [ ! -f "$PLUGIN_DEST/zoraxycrowdsecbouncer" ]; then
  echo "Plugin nicht im Volume gefunden – kopiere aus Image..."
  mkdir -p "$PLUGIN_DEST"
  cp -r "$PLUGIN_SRC/." "$PLUGIN_DEST/"
  chmod +x "$PLUGIN_DEST/zoraxycrowdsecbouncer"
  echo "✅ Plugin kopiert nach: $PLUGIN_DEST"
else
  echo "✅ Plugin bereits im Volume vorhanden."
fi

# config.yaml erstellen wenn sie nicht existiert
if [ ! -f "$CONFIG_FILE" ]; then
  echo "config.yaml nicht gefunden – wird automatisch erstellt..."

  if [ -z "$CROWDSEC_API_KEY" ]; then
    echo "⚠️  WARNUNG: CROWDSEC_API_KEY ist nicht gesetzt!"
    CROWDSEC_API_KEY="BITTE_API_KEY_EINTRAGEN"
  fi

  if [ -z "$CROWDSEC_AGENT_URL" ]; then
    echo "⚠️  WARNUNG: CROWDSEC_AGENT_URL ist nicht gesetzt!"
    CROWDSEC_AGENT_URL="http://crowdsec:8080"
  fi

  CROWDSEC_LOG_LEVEL="${CROWDSEC_LOG_LEVEL:-warning}"
  CROWDSEC_CLOUDFLARE="${CROWDSEC_CLOUDFLARE:-false}"

  cat > "$CONFIG_FILE" <<YAML
# CrowdSec Bouncer Konfiguration
# Automatisch erstellt beim ersten Start
api_key: ${CROWDSEC_API_KEY}
agent_url: ${CROWDSEC_AGENT_URL}
log_level: ${CROWDSEC_LOG_LEVEL}
is_proxied_behind_cloudflare: ${CROWDSEC_CLOUDFLARE}
YAML

  echo "✅ config.yaml erstellt unter: $CONFIG_FILE"
else
  echo "✅ config.yaml bereits vorhanden – wird nicht überschrieben."
fi

echo "=== Starte Zoraxy ==="
exec zoraxy -docker=true -port=:8000
