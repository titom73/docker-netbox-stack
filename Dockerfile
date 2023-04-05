ARG NETBOX_VERSION=latest
FROM netboxcommunity/netbox:${NETBOX_VERSION}

RUN apt-get update && \
<<<<<<< HEAD
        apt-get install --yes -qq --no-install-recommends \
                inetutils-ping
=======
	apt-get install --yes -qq --no-install-recommends \
		inetutils-ping
>>>>>>> 5a2682f (feat: set default timezone)

COPY ./configuration/plugin_requirements.txt /
RUN /opt/netbox/venv/bin/pip install  --no-warn-script-location -r /plugin_requirements.txt
