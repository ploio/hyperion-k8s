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
    supervisor nginx wget

# Install Grafana
RUN mkdir -p /src/grafana && cd /src/grafana && \
    wget http://grafanarel.s3.amazonaws.com/grafana-1.5.4.tar.gz && \
    tar xzvf grafana-1.5.4.tar.gz --strip-components=1 && rm grafana-1.5.4.tar.gz

# Install Confd
RUN curl -L https://github.com/kelseyhightower/confd/releases/download/v0.4.1/confd_0.4.1_linux_amd64.tar.gz | tar xz && \
    mv confd /usr/local/bin/confd && \
    mkdir -p /etc/confd/conf.d && \
    mkdir -p /etc/confd/templates


# Configuration
# ---------------

# Setup usign confd
#ADD ./influxdb_config.js /src/grafana/config.js
ADD ./influxdb_config.js.tmpl /etc/confd/templates/influxdb_config.js.tmpl
ADD ./influxdb_config.toml /etc/confd/conf.d/influxdb_config.toml

# Nginx
ADD ./nginx.conf /etc/nginx/nginx.conf

# Supervisord
ADD ./supervisord.conf /etc/supervisor/conf.d/supervisord.conf


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
