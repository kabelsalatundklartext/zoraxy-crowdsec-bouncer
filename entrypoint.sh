#!/bin/sh

PLUGIN_DIR="/opt/zoraxy/plugin/zoraxycrowdsecbouncer"
CONFIG_FILE="$PLUGIN_DIR/config.yaml"

echo "=== Zoraxy CrowdSec Bouncer Setup ==="

# config.yaml nur erstellen wenn sie noch nicht existiert
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

  mkdir -p "$PLUGIN_DIR"

  cat > "$CONFIG_FILE" <<EOF
# CrowdSec Bouncer Konfiguration
# Automatisch erstellt beim ersten Start
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

# Zoraxy Binary suchen und starten
if [ -f "/opt/zoraxy/zoraxy" ]; then
  exec /opt/zoraxy/zoraxy -docker=true -port=:8000
elif [ -f "/zoraxy" ]; then
  exec /zoraxy -docker=true -port=:8000
elif [ -f "/app/zoraxy" ]; then
  exec /app/zoraxy -docker=true -port=:8000
else
  # Fallback: originalen Entrypoint des Basis-Images nutzen
  echo "Zoraxy Binary nicht direkt gefunden – starte über originalen Entrypoint..."
  exec zoraxy -docker=true -port=:8000
fi
