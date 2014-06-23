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
    supervisor wget redis-server

# Install Redis
RUN mkdir -p /src/redis
RUN mkdir -p /var/lib/redis

# Install Logstash
RUN mkdir -p /src/logstash && cd /src/logstash && \
    wget -q https://download.elasticsearch.org/logstash/logstash/logstash-1.4.1.tar.gz && \
    tar xzf logstash-1.4.1.tar.gz --strip-components=1 && rm logstash-1.4.1.tar.gz

# Configuration
# -------------

# Supervisord
ADD ./supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Logstash
RUN mkdir -p /src/logstash/conf.d
ADD ./hyperion.conf /src/logstash/conf.d/hyperion.conf
ADD ./elasticsearch.conf /src/logstash/conf.d/elasticsearch.conf
ADD ./nginx.conf /src/logstash/conf.d/nginx.conf
ADD ./indexer.conf /src/logstash/conf.d/indexer.conf

# Ports
# ------

# Volumes
# --------

VOLUME ["/var/lib/log/supervisor"]
VOLUME ["/var/lib/redis"]


# Launch
# -------

CMD ["/usr/bin/supervisord"]
