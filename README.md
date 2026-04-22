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

Das Plugin ist bereits **vorinstalliert** – du musst nichts manuell herunterladen oder konfigurieren.

**CrowdSec selbst ist nicht enthalten** – du benötigst eine separate CrowdSec-Instanz (z.B. als eigener Docker-Container).

### Enthaltene Komponenten

| Komponente | Version |
|---|---|
| Zoraxy | latest |
| CrowdSec Bouncer Plugin | v1.2.1 |

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
| `/opt/zoraxy/plugin/` | Plugin-Daten inkl. CrowdSec Bouncer Config | `/mnt/user/appdata/zoraxy/plugin` |
| `/var/run/docker.sock` | Docker-Socket (für Docker-Modus) | `/var/run/docker.sock` |
| `/etc/localtime` | Zeitzone vom Host | `/etc/localtime` |

---

## Umgebungsvariablen

| Variable | Standard | Beschreibung |
|---|---|---|
| `FASTGEOIP` | `true` | Schnelle GeoIP-Datenbank aktivieren |
| `DOCKER` | `true` | Docker-Kompatibilitätsmodus |

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
   https://raw.githubusercontent.com/DEIN_GITHUB_NAME/zoraxy-crowdsec-bouncer/main/unraid-template.xml
   ```
3. Klicke **Load** – das Template wird automatisch befüllt

---

## Unraid Einstellungen

### Ports anpassen
Falls Port 80 oder 443 bereits belegt sind, kannst du die Host-Ports ändern:

| Feld | Standard | Beispiel geändert | Hinweis |
|------|---------|-------------------|---------|
| Host Port HTTP | `80` | `8080` | Nur den Host-Port ändern, Container-Port bleibt `80` |
| Host Port HTTPS | `443` | `8443` | Nur den Host-Port ändern, Container-Port bleibt `443` |
| Host Port WebUI | `8000` | `9000` | Zoraxy Verwaltungsoberfläche |

> ⚠️ Ändere **nur** den linken Wert (Host-Port), nicht den rechten (Container-Port)!

### Pfade anpassen
Standardmäßig landen alle Daten unter `/mnt/user/appdata/zoraxy/`.
Falls du einen anderen Speicherort möchtest:

| Feld | Standard | Beispiel Alternative |
|------|---------|---------------------|
| Config Pfad | `/mnt/user/appdata/zoraxy/config` | `/mnt/cache/appdata/zoraxy/config` |
| Plugin Pfad | `/mnt/user/appdata/zoraxy/plugin` | `/mnt/cache/appdata/zoraxy/plugin` |

> 💡 Tipp: Nutze `/mnt/cache/appdata/` wenn du eine SSD als Cache-Laufwerk hast – das ist schneller.

---

## CrowdSec Bouncer einrichten

### Schritt 1 – API-Key von CrowdSec holen
Führe diesen Befehl in deinem CrowdSec-Container aus:
```bash
docker exec -it crowdsec cscli bouncers add zoraxy-bouncer
```
Den angezeigten API-Key kopieren und aufbewahren.

### Schritt 2 – Config-Datei bearbeiten
Öffne die Datei auf deinem Unraid-Server:
```
/mnt/user/appdata/zoraxy/plugin/zoraxycrowdsecbouncer/config.yaml
```

Inhalt anpassen:
```yaml
api_key: DEIN_API_KEY_HIER
agent_url: http://IP-DEINES-CROWDSEC-CONTAINERS:8080
log_level: warning
is_proxied_behind_cloudflare: false  # auf true setzen wenn du Cloudflare nutzt
```

### Schritt 3 – Plugin in Zoraxy aktivieren
1. Öffne die Zoraxy WebUI: `http://DEINE-UNRAID-IP:8000`
2. Gehe zu **Plugins**
3. Das CrowdSec Bouncer Plugin sollte dort erscheinen → **Aktivieren**
4. Gehe zu **Tags** → Erstelle einen neuen Tag (z.B. `crowdsec-protected`)
5. Füge den Tag bei allen Proxy-Regeln hinzu, die du schützen möchtest

### Schritt 4 – Testen
Prüfe ob der Bouncer läuft:
```bash
docker exec -it zoraxy ls /opt/zoraxy/plugin/zoraxycrowdsecbouncer/
```
Du solltest `zoraxycrowdsecbouncer` und `config.yaml` sehen.

---

## Häufige Probleme

**Plugin erscheint nicht in der WebUI**
→ Prüfe ob der Plugin-Pfad korrekt gemountet ist
→ Starte den Container neu

**CrowdSec API nicht erreichbar**
→ Stelle sicher dass Zoraxy und CrowdSec im selben Docker-Netzwerk sind
→ Alternativ `host.docker.internal` als URL verwenden

**Port bereits belegt**
→ Ändere den Host-Port in den Unraid Container-Einstellungen (nur den linken Wert!)

---

# 🇬🇧 English

## What is this?

This Docker image combines [Zoraxy](https://github.com/tobychui/zoraxy) – a modern HTTP reverse proxy – with the [CrowdSec Bouncer Plugin](https://github.com/AnthonyMichaelTDM/zoraxy_crowdsec_bouncer), which automatically blocks malicious IPs.

The plugin is **pre-installed** – no manual download or setup required.

**CrowdSec itself is not included** – you need a separate CrowdSec instance (e.g. as its own Docker container).

### Included Components

| Component | Version |
|---|---|
| Zoraxy | latest |
| CrowdSec Bouncer Plugin | v1.2.1 |

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
| `/opt/zoraxy/plugin/` | Plugin data incl. CrowdSec bouncer config | `/mnt/user/appdata/zoraxy/plugin` |
| `/var/run/docker.sock` | Docker socket (for Docker mode) | `/var/run/docker.sock` |
| `/etc/localtime` | Timezone from host | `/etc/localtime` |

---

## Environment Variables

| Variable | Default | Description |
|---|---|---|
| `FASTGEOIP` | `true` | Enable fast GeoIP database |
| `DOCKER` | `true` | Docker compatibility mode |

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
   https://raw.githubusercontent.com/DEIN_GITHUB_NAME/zoraxy-crowdsec-bouncer/main/unraid-template.xml
   ```
3. Click **Load** – the template fills in automatically

---

## Unraid Settings

### Changing Ports
If port 80 or 443 are already in use, you can change the host ports:

| Field | Default | Example Changed | Note |
|-------|---------|-----------------|------|
| Host Port HTTP | `80` | `8080` | Only change the host port, container port stays `80` |
| Host Port HTTPS | `443` | `8443` | Only change the host port, container port stays `443` |
| Host Port WebUI | `8000` | `9000` | Zoraxy management interface |

> ⚠️ Only change the **left** value (host port), not the right one (container port)!

### Changing Paths
By default all data is stored under `/mnt/user/appdata/zoraxy/`.

| Field | Default | Alternative Example |
|-------|---------|---------------------|
| Config Path | `/mnt/user/appdata/zoraxy/config` | `/mnt/cache/appdata/zoraxy/config` |
| Plugin Path | `/mnt/user/appdata/zoraxy/plugin` | `/mnt/cache/appdata/zoraxy/plugin` |

> 💡 Tip: Use `/mnt/cache/appdata/` if you have an SSD as cache drive – it's faster.

---

## Setting up the CrowdSec Bouncer

### Step 1 – Get API key from CrowdSec
Run this command in your CrowdSec container:
```bash
docker exec -it crowdsec cscli bouncers add zoraxy-bouncer
```
Copy and save the displayed API key.

### Step 2 – Edit the config file
Open the file on your Unraid server:
```
/mnt/user/appdata/zoraxy/plugin/zoraxycrowdsecbouncer/config.yaml
```

Edit the content:
```yaml
api_key: YOUR_API_KEY_HERE
agent_url: http://IP-OF-YOUR-CROWDSEC-CONTAINER:8080
log_level: warning
is_proxied_behind_cloudflare: false  # set to true if you use Cloudflare
```

### Step 3 – Activate plugin in Zoraxy
1. Open Zoraxy WebUI: `http://YOUR-UNRAID-IP:8000`
2. Go to **Plugins**
3. The CrowdSec Bouncer Plugin should appear → **Activate**
4. Go to **Tags** → Create a new tag (e.g. `crowdsec-protected`)
5. Add the tag to all proxy rules you want to protect

### Step 4 – Verify
Check if the bouncer is running:
```bash
docker exec -it zoraxy ls /opt/zoraxy/plugin/zoraxycrowdsecbouncer/
```
You should see `zoraxycrowdsecbouncer` and `config.yaml`.

---

## Troubleshooting

**Plugin not showing in WebUI**
→ Check if the plugin path is correctly mounted
→ Restart the container

**CrowdSec API not reachable**
→ Make sure Zoraxy and CrowdSec are in the same Docker network
→ Alternatively use `host.docker.internal` as the URL

**Port already in use**
→ Change the host port in the Unraid container settings (left value only!)

---

## docker-compose (local testing)

```yaml
services:
  zoraxy:
    image: DEIN_DOCKERHUB_NAME/zoraxy-crowdsec-bouncer:latest
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
