# Netbox Docker

Repository to build Netbox stack with its own customized Netbox image

```bash
docker compose build --no-cache --build-arg NETBOX_VERSION=latest
docker compose up -d
```

Create super-user during first start

```bash
docker compose exec netbox /opt/netbox/netbox/manage.py createsuperuser
```

## Docker image

To customize Netbox installation, you can deploy your own elements:

- Plugins
- Configuration
- Reports
- Scripts

### Build Arguments

- Netbox version can be set with `NETBOX_VERSION` (default is `latest`)

### Update plugins

- Update [requirements](./configuration/plugin_requirements.txt) file in configuration folder
- Update [configuration.py](./configuration/configuration.py) file with your
  plugin:

```python
# Enable installed plugins. Add the name of each plugin to the list.
PLUGINS = [
    "netbox_dns",
    "netbox_bgp",
    "netbox_acls",
]
```

## Docker compose stack

Generic docker-compose stack is defined in `docker-compose.yml` file and specific element are defined under `docker-compose.override.yml` such as build statement and port where netbox is listening

```yaml
services:
  netbox:
    build:
      context: .
      dockerfile: Dockerfile
    # image: netbox:latest-plugins
    networks:
      netbox_lan:
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.netbox.rule=Host(`netbox.as73.inetsix.net`)"
      - "traefik.http.routers.netbox.entrypoints=web"
      - "traefik.http.services.netbox.loadbalancer.server.port=8080"
      - "traefik.http.routers.api.entrypoints=http"
    ports:
      - 8000:8080
   environment:
      TIME_ZONE: "Europe/Paris"
      NAPALM_USERNAME: '< set your own NAPALM user >'
      NAPALM_PASSWORD: '< set your own NAPALM password >'
```

In order to be served by traeffik reverse-proxy, networks must be configured prior to start the stack and also labels __must__ be set first

```bash
docker network create --subnet 172.16.58.0/24 --attachable netbox_lan
```

## Import Device Types & Manufacturers

```bash
docker login ghcr.io

cat << EOF > env-develop
NETBOX_URL=http://< your netbox instance >
NETBOX_TOKEN=< netbox generated token >
REPO_URL=https://github.com/titom73/netbox-devicetype-library.git
REPO_BRANCH=homenetwork
IGNORE_SSL_ERRORS=False
EOF

docker run --rm --env-file=env-develop ghcr.io/titom73/nb-device-importer:dev --vendors Arista,"Intel NUC",Synology,"Raspberry Pi","Cisco Business",Netgear
```
