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
    supervisor wget

# Install InfluxDB
RUN mkdir -p /src/influxdb && \
    cd /src/influxdb && \
    wget -q http://s3.amazonaws.com/influxdb/influxdb-0.7.3.amd64.tar.gz && \
    tar xzf influxdb-0.7.3.amd64.tar.gz --strip-components=1 && rm influxdb-0.7.3.amd64.tar.gz


# Configuration
# -------------

# Supervisord
ADD ./supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# InfluxDB
ADD ./config.toml /src/influxdb/config.toml


# Ports
# ------

# InfluxDB
EXPOSE 8086
EXPOSE 8083
EXPOSE 8090
EXPOSE 8099


# Volumes
# --------

VOLUME ["/var/lib/log/supervisor"]
VOLUME ["/var/lib/influxdb"]


# Launch
# -------

CMD ["/usr/bin/supervisord"]
