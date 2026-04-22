#!/bin/sh

PLUGIN_DIR="/opt/zoraxy/plugin/zoraxycrowdsecbouncer"
CONFIG_FILE="$PLUGIN_DIR/config.yaml"

echo "=== Zoraxy CrowdSec Bouncer Setup ==="

# config.yaml nur erstellen wenn sie noch nicht existiert
if [ ! -f "$CONFIG_FILE" ]; then
  echo "config.yaml nicht gefunden – wird automatisch erstellt..."

  # Pflichtfelder prüfen
  if [ -z "$CROWDSEC_API_KEY" ]; then
    echo "⚠️  WARNUNG: CROWDSEC_API_KEY ist nicht gesetzt! Bitte in den Container-Einstellungen eintragen."
    CROWDSEC_API_KEY="BITTE_API_KEY_EINTRAGEN"
  fi

  if [ -z "$CROWDSEC_AGENT_URL" ]; then
    echo "⚠️  WARNUNG: CROWDSEC_AGENT_URL ist nicht gesetzt! Standard wird verwendet."
    CROWDSEC_AGENT_URL="http://crowdsec:8080"
  fi

  # Standardwerte für optionale Variablen
  CROWDSEC_LOG_LEVEL="${CROWDSEC_LOG_LEVEL:-warning}"
  CROWDSEC_CLOUDFLARE="${CROWDSEC_CLOUDFLARE:-false}"

  mkdir -p "$PLUGIN_DIR"

  cat > "$CONFIG_FILE" <<EOF
# CrowdSec Bouncer Konfiguration
# Automatisch erstellt beim ersten Start
# Du kannst diese Datei jederzeit manuell bearbeiten.

api_key: ${CROWDSEC_API_KEY}
agent_url: ${CROWDSEC_AGENT_URL}
log_level: ${CROWDSEC_LOG_LEVEL}
is_proxied_behind_cloudflare: ${CROWDSEC_CLOUDFLARE}
EOF

  echo "✅ config.yaml wurde erstellt unter: $CONFIG_FILE"
else
  echo "✅ config.yaml bereits vorhanden – wird nicht überschrieben."
fi

echo "=== Starte Zoraxy ==="

# Originalen Zoraxy-Startbefehl ausführen
exec /zoraxy/zoraxy \
  -docker=true \
  -port=:8000
