FROM ubuntu:14.04
MAINTAINER Nicolas Lamirault <nicolas.lamirault@gmail.com>

RUN apt-get -y update && apt-get install -y software-properties-common

# RUN dpkg-reconfigure locales && \
#     locale-gen C.UTF-8 && \
#     /usr/sbin/update-locale LANG=C.UTF-8
# ENV LC_ALL C.UTF-8
RUN locale-gen en_US.UTF-8 && update-locale LANG=en_US.UTF-8

# Dependencies
RUN apt-get update && apt-get install -y \
    supervisor nginx-light wget

# Install Kibana
RUN mkdir -p /src/kibana && \
    cd /src/kibana && \
    wget -q https://download.elasticsearch.org/kibana/kibana/kibana-3.1.0.tar.gz && \
    tar xzf kibana-3.1.0.tar.gz --strip-components=1 && rm kibana-3.1.0.tar.gz

# Configuration
# -------------

# Nginx
ADD ./nginx.conf /etc/nginx/nginx.conf

# Supervisord
ADD ./supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Kibana
ADD ./config.js /src/kibana/config.js
ADD ./hyperion.json /src/kibana/app/dashboards/default.json

# Ports
# ------

# nginx
EXPOSE 80


# Volumes
# --------

VOLUME ["/var/lib/log/supervisor"]
VOLUME ["/var/lib/log/nginx"]


# Launch
# -------

CMD ["/usr/bin/supervisord"]
