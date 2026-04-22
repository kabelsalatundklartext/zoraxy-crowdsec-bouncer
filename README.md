# zoraxy-crowdsec-bouncer

> Zoraxy Reverse Proxy mit vorinstalliertem CrowdSec Bouncer Plugin – fertig für Unraid und Docker.

![Zoraxy](https://img.shields.io/badge/Zoraxy-latest-blue)
![Plugin](https://img.shields.io/badge/CrowdSec_Bouncer-v1.2.1-green)
![License](https://img.shields.io/badge/License-MIT%20%2F%20AGPL--3.0-orange)

---

## Inhaltsverzeichnis / Table of Contents

- [🇩🇪 Deutsch](#-deutsch)
- [🇬🇧 English](#-english)
- [Credits & Lizenzen](#credits--lizenzen--licenses)

---

# 🇩🇪 Deutsch

## Was ist das?

Dieses Docker-Image kombiniert [Zoraxy](https://github.com/tobychui/zoraxy) – einen modernen HTTP Reverse Proxy – mit dem [CrowdSec Bouncer Plugin](https://github.com/AnthonyMichaelTDM/zoraxy_crowdsec_bouncer), welches bösartige IPs automatisch blockiert.

**Das Plugin ist bereits vorinstalliert** – du musst nichts manuell herunterladen.

**Die `config.yaml` wird beim ersten Start automatisch erstellt** – du trägst einfach deinen CrowdSec API Key und die URL direkt in den Unraid Container-Einstellungen ein, ganz ohne die Datei manuell bearbeiten zu müssen.

**CrowdSec selbst ist nicht enthalten** – du benötigst eine separate CrowdSec-Instanz (z.B. als eigener Docker-Container).

### Enthaltene Komponenten

| Komponente | Version |
|---|---|
| Zoraxy | latest |
| CrowdSec Bouncer Plugin | v1.2.1 |

---

## Umgebungsvariablen

Diese Werte trägst du direkt in Unraid (oder docker-compose) ein – die `config.yaml` wird beim ersten Start automatisch daraus erstellt.

| Variable | Standard | Pflicht? | Beschreibung |
|---|---|---|---|
| `CROWDSEC_API_KEY` | *(leer)* | ✅ Ja | API Key deiner CrowdSec-Instanz |
| `CROWDSEC_AGENT_URL` | `http://crowdsec:8080` | ✅ Ja | URL deiner CrowdSec-Instanz |
| `CROWDSEC_LOG_LEVEL` | `warning` | ❌ Nein | Log-Level: `trace` / `debug` / `info` / `warning` / `error` |
| `CROWDSEC_CLOUDFLARE` | `false` | ❌ Nein | `true` wenn Zoraxy hinter Cloudflare läuft |
| `FASTGEOIP` | `true` | ❌ Nein | Schnelle GeoIP-Datenbank |
| `DOCKER` | `true` | ❌ Nein | Docker-Kompatibilitätsmodus |

> 💡 Die `config.yaml` wird **nur beim ersten Start** erstellt. Wenn die Datei bereits existiert, wird sie **nicht überschrieben** – du kannst sie also auch manuell bearbeiten.

---

## Ports

| Port | Beschreibung | Änderbar? |
|------|-------------|-----------|
| `80` | HTTP-Traffic | ✅ Ja |
| `443` | HTTPS-Traffic | ✅ Ja |
| `8000` | Zoraxy WebUI (Verwaltung) | ✅ Ja |

---

## Volumes / Pfade

| Container-Pfad | Beschreibung | Unraid Standard-Pfad |
|---|---|---|
| `/opt/zoraxy/config/` | Zoraxy Konfiguration, Zertifikate, Logs | `/mnt/user/appdata/zoraxy/config` |
| `/opt/zoraxy/plugin/` | Plugin-Daten inkl. automatisch erstellter `config.yaml` | `/mnt/user/appdata/zoraxy/plugin` |
| `/var/run/docker.sock` | Docker-Socket (für Docker-Modus) | `/var/run/docker.sock` |
| `/etc/localtime` | Zeitzone vom Host | `/etc/localtime` |

---

## Unraid Installation

### Methode 1 – Über Community Applications (empfohlen)

1. Öffne **Community Applications** in Unraid
2. Suche nach `zoraxy-crowdsec-bouncer`
3. Klicke **Install**
4. Passe die Einstellungen wie unten beschrieben an

### Methode 2 – Template manuell hinzufügen

1. Gehe in Unraid zu **Docker** → **Add Container**
2. Scrolle ganz unten zu **Template URL** und füge ein:
   ```
   https://raw.githubusercontent.com/kabelsalatundklartext/zoraxy-crowdsec-bouncer/main/unraid-template.xml
   ```
3. Klicke **Load** – das Template wird automatisch befüllt

---

## Unraid Einstellungen

### Pflichtfelder (immer sichtbar)

| Feld | Beispiel | Beschreibung |
|------|---------|-------------|
| **CrowdSec API Key** | `abc123xyz...` | Wird beim Eintippen versteckt (masked) |
| **CrowdSec Agent URL** | `http://192.168.1.100:8080` | IP deines CrowdSec Containers |
| **WebUI Port** | `8000` | Zoraxy Verwaltungsoberfläche |
| **HTTP Port** | `80` | HTTP-Traffic |
| **HTTPS Port** | `443` | HTTPS-Traffic |
| **Config Folder** | `/mnt/user/appdata/zoraxy/config` | Zoraxy Konfigurationsdaten |
| **Plugin Folder** | `/mnt/user/appdata/zoraxy/plugin` | Plugin inkl. `config.yaml` |

### Erweiterte Felder (unter "Advanced")

| Feld | Standard | Beschreibung |
|------|---------|-------------|
| Log Level | `warning` | Wie viel der Bouncer loggt |
| Cloudflare Proxy | `false` | `true` wenn du Cloudflare nutzt |
| Fast GeoIP | `true` | GeoIP-Datenbank |
| Docker Mode | `true` | Docker-Kompatibilität |

### Ports anpassen
Falls Port 80 oder 443 bereits belegt sind:

| Feld | Standard | Beispiel geändert | Hinweis |
|------|---------|-------------------|---------|
| Host Port HTTP | `80` | `8080` | Nur den Host-Port ändern, Container-Port bleibt `80` |
| Host Port HTTPS | `443` | `8443` | Nur den Host-Port ändern, Container-Port bleibt `443` |
| Host Port WebUI | `8000` | `9000` | Zoraxy Verwaltungsoberfläche |

> ⚠️ Ändere **nur** den linken Wert (Host-Port), nicht den rechten (Container-Port)!

### Pfade anpassen

| Feld | Standard | Alternative (SSD/Cache) |
|------|---------|------------------------|
| Config Pfad | `/mnt/user/appdata/zoraxy/config` | `/mnt/cache/appdata/zoraxy/config` |
| Plugin Pfad | `/mnt/user/appdata/zoraxy/plugin` | `/mnt/cache/appdata/zoraxy/plugin` |

> 💡 Tipp: Nutze `/mnt/cache/appdata/` wenn du eine SSD als Cache-Laufwerk hast – das ist schneller.

---

## CrowdSec API Key holen

Führe diesen Befehl in deinem CrowdSec-Container aus:
```bash
docker exec -it crowdsec cscli bouncers add zoraxy-bouncer
```
Den angezeigten Key kopieren und in das Feld **CrowdSec API Key** in Unraid eintragen.

---

## Plugin in Zoraxy aktivieren

Nach dem ersten Start:

1. Öffne die Zoraxy WebUI: `http://DEINE-UNRAID-IP:8000`
2. Gehe zu **Plugins** – der CrowdSec Bouncer sollte erscheinen → **Aktivieren**
3. Gehe zu **Tags** → Neuen Tag erstellen (z.B. `crowdsec-protected`)
4. Tag bei allen Proxy-Regeln hinzufügen, die du schützen möchtest

---

## Häufige Probleme

**Plugin erscheint nicht in der WebUI**
→ Prüfe ob der Plugin-Pfad korrekt gemountet ist
→ Starte den Container neu

**`config.yaml` hat falschen API Key**
→ Datei löschen unter `/mnt/user/appdata/zoraxy/plugin/zoraxycrowdsecbouncer/config.yaml`
→ Container neu starten – sie wird neu erstellt mit den aktuellen Variablen

**CrowdSec API nicht erreichbar**
→ Stelle sicher dass Zoraxy und CrowdSec im selben Docker-Netzwerk sind
→ Alternativ die direkte IP verwenden: `http://192.168.1.xxx:8080`

**Port bereits belegt**
→ Ändere den Host-Port in den Unraid Container-Einstellungen (nur den linken Wert!)

---

# 🇬🇧 English

## What is this?

This Docker image combines [Zoraxy](https://github.com/tobychui/zoraxy) – a modern HTTP reverse proxy – with the [CrowdSec Bouncer Plugin](https://github.com/AnthonyMichaelTDM/zoraxy_crowdsec_bouncer), which automatically blocks malicious IPs.

**The plugin is pre-installed** – no manual download required.

**The `config.yaml` is created automatically on first start** – simply enter your CrowdSec API key and URL directly in the Unraid container settings, no need to edit files manually.

**CrowdSec itself is not included** – you need a separate CrowdSec instance (e.g. as its own Docker container).

### Included Components

| Component | Version |
|---|---|
| Zoraxy | latest |
| CrowdSec Bouncer Plugin | v1.2.1 |

---

## Environment Variables

Enter these values directly in Unraid (or docker-compose) – the `config.yaml` is created automatically on first start.

| Variable | Default | Required? | Description |
|---|---|---|---|
| `CROWDSEC_API_KEY` | *(empty)* | ✅ Yes | API key of your CrowdSec instance |
| `CROWDSEC_AGENT_URL` | `http://crowdsec:8080` | ✅ Yes | URL of your CrowdSec instance |
| `CROWDSEC_LOG_LEVEL` | `warning` | ❌ No | Log level: `trace` / `debug` / `info` / `warning` / `error` |
| `CROWDSEC_CLOUDFLARE` | `false` | ❌ No | `true` if Zoraxy runs behind Cloudflare |
| `FASTGEOIP` | `true` | ❌ No | Enable fast GeoIP database |
| `DOCKER` | `true` | ❌ No | Docker compatibility mode |

> 💡 The `config.yaml` is only created on **first start**. If the file already exists, it will **not be overwritten** – you can also edit it manually.

---

## Ports

| Port | Description | Changeable? |
|------|-------------|-------------|
| `80` | HTTP traffic | ✅ Yes |
| `443` | HTTPS traffic | ✅ Yes |
| `8000` | Zoraxy WebUI (management) | ✅ Yes |

---

## Volumes / Paths

| Container Path | Description | Unraid Default Path |
|---|---|---|
| `/opt/zoraxy/config/` | Zoraxy config, certificates, logs | `/mnt/user/appdata/zoraxy/config` |
| `/opt/zoraxy/plugin/` | Plugin data incl. auto-created `config.yaml` | `/mnt/user/appdata/zoraxy/plugin` |
| `/var/run/docker.sock` | Docker socket (for Docker mode) | `/var/run/docker.sock` |
| `/etc/localtime` | Timezone from host | `/etc/localtime` |

---

## Unraid Installation

### Method 1 – Via Community Applications (recommended)

1. Open **Community Applications** in Unraid
2. Search for `zoraxy-crowdsec-bouncer`
3. Click **Install**
4. Adjust the settings as described below

### Method 2 – Add template manually

1. Go to Unraid **Docker** → **Add Container**
2. Scroll to the bottom and find **Template URL**, paste:
   ```
   https://raw.githubusercontent.com/kabelsalatundklartext/zoraxy-crowdsec-bouncer/main/unraid-template.xml
   ```
3. Click **Load** – the template fills in automatically

---

## Unraid Settings

### Required fields (always visible)

| Field | Example | Description |
|-------|---------|-------------|
| **CrowdSec API Key** | `abc123xyz...` | Hidden when typing (masked) |
| **CrowdSec Agent URL** | `http://192.168.1.100:8080` | IP of your CrowdSec container |
| **WebUI Port** | `8000` | Zoraxy management interface |
| **HTTP Port** | `80` | HTTP traffic |
| **HTTPS Port** | `443` | HTTPS traffic |
| **Config Folder** | `/mnt/user/appdata/zoraxy/config` | Zoraxy configuration data |
| **Plugin Folder** | `/mnt/user/appdata/zoraxy/plugin` | Plugin incl. `config.yaml` |

### Advanced fields (under "Advanced")

| Field | Default | Description |
|-------|---------|-------------|
| Log Level | `warning` | How much the bouncer logs |
| Cloudflare Proxy | `false` | `true` if you use Cloudflare |
| Fast GeoIP | `true` | GeoIP database |
| Docker Mode | `true` | Docker compatibility |

### Changing Ports
If port 80 or 443 are already in use:

| Field | Default | Example Changed | Note |
|-------|---------|-----------------|------|
| Host Port HTTP | `80` | `8080` | Only change the host port, container port stays `80` |
| Host Port HTTPS | `443` | `8443` | Only change the host port, container port stays `443` |
| Host Port WebUI | `8000` | `9000` | Zoraxy management interface |

> ⚠️ Only change the **left** value (host port), not the right one (container port)!

### Changing Paths

| Field | Default | Alternative (SSD/Cache) |
|-------|---------|------------------------|
| Config Path | `/mnt/user/appdata/zoraxy/config` | `/mnt/cache/appdata/zoraxy/config` |
| Plugin Path | `/mnt/user/appdata/zoraxy/plugin` | `/mnt/cache/appdata/zoraxy/plugin` |

> 💡 Tip: Use `/mnt/cache/appdata/` if you have an SSD as cache drive – it's faster.

---

## Getting the CrowdSec API Key

Run this command in your CrowdSec container:
```bash
docker exec -it crowdsec cscli bouncers add zoraxy-bouncer
```
Copy the displayed key and paste it into the **CrowdSec API Key** field in Unraid.

---

## Activating the Plugin in Zoraxy

After the first start:

1. Open Zoraxy WebUI: `http://YOUR-UNRAID-IP:8000`
2. Go to **Plugins** – the CrowdSec Bouncer should appear → **Activate**
3. Go to **Tags** → Create a new tag (e.g. `crowdsec-protected`)
4. Add the tag to all proxy rules you want to protect

---

## Troubleshooting

**Plugin not showing in WebUI**
→ Check if the plugin path is correctly mounted
→ Restart the container

**`config.yaml` has wrong API key**
→ Delete the file at `/mnt/user/appdata/zoraxy/plugin/zoraxycrowdsecbouncer/config.yaml`
→ Restart the container – it will be recreated with the current variables

**CrowdSec API not reachable**
→ Make sure Zoraxy and CrowdSec are in the same Docker network
→ Alternatively use the direct IP: `http://192.168.1.xxx:8080`

**Port already in use**
→ Change the host port in the Unraid container settings (left value only!)

---

## docker-compose (local testing)

```yaml
services:
  zoraxy:
    image: ghcr.io/kabelsalatundklartext/zoraxy-crowdsec-bouncer:latest
    container_name: zoraxy
    restart: unless-stopped
    ports:
      - "80:80"
      - "443:443"
      - "8000:8000"
    volumes:
      - ./config:/opt/zoraxy/config/
      - ./plugin:/opt/zoraxy/plugin/
      - /var/run/docker.sock:/var/run/docker.sock
      - /etc/localtime:/etc/localtime
    extra_hosts:
      - "host.docker.internal:host-gateway"
    environment:
      - CROWDSEC_API_KEY=DEIN_API_KEY
      - CROWDSEC_AGENT_URL=http://crowdsec:8080
      - CROWDSEC_LOG_LEVEL=warning
      - CROWDSEC_CLOUDFLARE=false
      - FASTGEOIP=true
      - DOCKER=true
```

---

# Credits & Lizenzen / Licenses

Dieses Projekt verwendet folgende Open-Source-Software / This project uses the following open source software:

| Projekt / Project | Autor / Author | Lizenz / License | Link |
|---|---|---|---|
| Zoraxy | tobychui | AGPL v3 | https://github.com/tobychui/zoraxy |
| zoraxy_crowdsec_bouncer | AnthonyMichaelTDM | MIT | https://github.com/AnthonyMichaelTDM/zoraxy_crowdsec_bouncer |
| CrowdSec | CrowdSec | MIT | https://github.com/crowdsecurity/crowdsec |

**MIT License – zoraxy_crowdsec_bouncer**
Copyright (c) 2025 Anthony Rubick

Dieses Docker-Image / Template wird unabhängig gepflegt und ist nicht mit den oben genannten Projekten affiliiert.
This Docker image / template is independently maintained and is not affiliated with the projects listed above.
