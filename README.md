# zoraxy-crowdsec-bouncer

Zoraxy reverse proxy with the **CrowdSec Bouncer plugin pre-installed**.  
This Docker image bundles [Zoraxy](https://github.com/tobychui/zoraxy) together with the [zoraxy_crowdsec_bouncer](https://github.com/AnthonyMichaelTDM/zoraxy_crowdsec_bouncer) plugin, so you don't have to install the plugin manually.

---

## What's included

- ✅ Zoraxy (latest)
- ✅ CrowdSec Bouncer Plugin v1.2.1 (pre-installed)

CrowdSec itself is **not included** – you need a running CrowdSec instance separately (e.g. as a second Docker container).

---

## Ports

| Port | Description |
|------|-------------|
| 80   | HTTP traffic |
| 443  | HTTPS traffic |
| 8000 | Zoraxy WebUI |

---

## Quick Start (docker-compose)

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

## Setup CrowdSec Bouncer Plugin

After the container is running:

1. Open Zoraxy WebUI: `http://YOUR-IP:8000`
2. Go to **Plugins** – you should see the CrowdSec Bouncer listed
3. Edit the config file at:
   `/mnt/user/appdata/zoraxy/plugin/zoraxycrowdsecbouncer/config.yaml`

```yaml
api_key: YOUR_CROWDSEC_API_KEY
agent_url: http://YOUR-CROWDSEC-IP:8080
log_level: warning
is_proxied_behind_cloudflare: false
```

4. Get your API key from CrowdSec:
```bash
docker exec -it crowdsec cscli bouncers add zoraxy-bouncer
```

5. Add the plugin to a **Tag** in Zoraxy and assign your proxy rules to that tag.

---

## Unraid

Install via Community Applications – search for `zoraxy-crowdsec-bouncer`.

Or add the template URL manually:
```
https://raw.githubusercontent.com/DEIN_GITHUB_NAME/zoraxy-crowdsec-bouncer/main/unraid-template.xml
```

---

## Credits & Licenses

This project bundles the following open source software:

| Project | Author | License | Link |
|---------|--------|---------|------|
| Zoraxy | tobychui | AGPL v3 | https://github.com/tobychui/zoraxy |
| zoraxy_crowdsec_bouncer | AnthonyMichaelTDM | MIT | https://github.com/AnthonyMichaelTDM/zoraxy_crowdsec_bouncer |
| CrowdSec | CrowdSec | MIT | https://github.com/crowdsecurity/crowdsec |

MIT License for zoraxy_crowdsec_bouncer:  
Copyright (c) 2025 Anthony Rubick

This Docker image / template is maintained separately and is not affiliated with the above projects.
