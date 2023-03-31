ARG NETBOX_VERSION=latest
FROM netboxcommunity/netbox:${NETBOX_VERSION}

COPY ./configuration/plugin_requirements.txt /
RUN /opt/netbox/venv/bin/pip install  --no-warn-script-location -r /plugin_requirements.txt
