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
    supervisor nginx-light wget redis-server

# Install Redis
RUN mkdir -p /src/redis
RUN mkdir -p /var/lib/redis

# Install Logstash
RUN mkdir -p /src/logstash && cd /src/logstash && \
    wget -q https://download.elasticsearch.org/logstash/logstash/logstash-1.4.1.tar.gz && \
    tar xzf logstash-1.4.1.tar.gz --strip-components=1 && rm logstash-1.4.1.tar.gz

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

# Logstash
RUN mkdir -p /src/logstash/conf.d
ADD ./hyperion.conf /src/logstash/conf.d/hyperion.conf
ADD ./elasticsearch.conf /src/logstash/conf.d/elasticsearch.conf
ADD ./nginx.conf /src/logstash/conf.d/nginx.conf
ADD ./indexer.conf /src/logstash/conf.d/indexer.conf

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
VOLUME ["/var/lib/redis"]


# Launch
# -------

CMD ["/usr/bin/supervisord"]
