FROM ubuntu:14.04
MAINTAINER Nicolas Lamirault <nicolas.lamirault@gmail.com>

RUN apt-get -y update && apt-get install -y software-properties-common

# RUN dpkg-reconfigure locales && \
#     locale-gen C.UTF-8 && \
#     /usr/sbin/update-locale LANG=C.UTF-8
# ENV LC_ALL C.UTF-8
RUN locale-gen en_US.UTF-8 && update-locale LANG=en_US.UTF-8

# Dependencies
RUN add-apt-repository -y ppa:chris-lea/node.js
RUN apt-get update && apt-get install -y \
    build-essential python-dev python-pip python-virtualenv \
    libffi-dev libcairo2 python-cairo gunicorn \
    supervisor nginx-light nodejs git wget curl

# Install Elasticsearch
RUN \
  echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
  echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections && \
  add-apt-repository -y ppa:webupd8team/java && \
  apt-get update && \
  apt-get install -y oracle-java7-installer
RUN mkdir -p /src/elasticsearch && cd /src/elasticsearch && \
    wget https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.2.1.tar.gz && \
    tar xzf elasticsearch-1.2.1.tar.gz --strip-components=1 && rm elasticsearch-1.2.1.tar.gz
RUN /src/elasticsearch/bin/plugin -v -i mobz/elasticsearch-head
RUN /src/elasticsearch/bin/plugin -v -i royrusso/elasticsearch-HQ
RUN /src/elasticsearch/bin/plugin -v -i lmenezes/elasticsearch-kopf

# Install statsd
RUN mkdir -p /src/statsd && cd /src/statsd && \
    wget https://github.com/etsy/statsd/archive/v0.7.1.tar.gz && \
    tar xzvf v0.7.1.tar.gz --strip-components=1 && rm v0.7.1.tar.gz

# Install Graphite dependencies
RUN pip install 'Twisted<12.0'
RUN pip install django==1.4.9 django-tagging

# Install Whisper, Carbon and Graphite-Web
RUN pip install whisper
RUN pip install --install-option="--prefix=/var/lib/graphite" \
    --install-option="--install-lib=/var/lib/graphite/lib" \
    carbon
RUN pip install --install-option="--prefix=/var/lib/graphite" \
    --install-option="--install-lib=/var/lib/graphite/webapp" \
    graphite-web

# Install Grafana
RUN mkdir -p /src/grafana && cd /src/grafana && \
    wget http://grafanarel.s3.amazonaws.com/grafana-1.5.4.tar.gz && \
    tar xzvf grafana-1.5.4.tar.gz --strip-components=1 && rm grafana-1.5.4.tar.gz

# Install Redis
RUN apt-get install -y redis-server
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

# Install InfluxDB
RUN mkdir -p /src/influxdb && \
    cd /src/influxdb && \
    wget -q http://s3.amazonaws.com/influxdb/influxdb-0.7.3.amd64.tar.gz && \
    tar xzf influxdb-0.7.3.amd64.tar.gz --strip-components=1 && rm influxdb-0.7.3.amd64.tar.gz


# Configuration
# -------------

# hyperion
ADD ./hyperion /src/hyperion

# Elasticsearch
#ADD ./elasticsearch/run /usr/local/bin/run_elasticsearch
#ADD ./elasticsearch/logging.yml /usr/share/elasticsearch/config
ADD ./elasticsearch/elasticsearch.yml /src/elasticsearch/elasticsearch.yml
#RUN chown -R elasticsearch:elasticsearch /var/lib/elasticsearch
#RUN mkdir -p /var/lib/elasticsearch/elasticsearch && chown elasticsearch:elasticsearch /tmp/elasticsearch

# statsd
ADD ./statsd/config.js /src/statsd/config.js

# Whisper, Carbon and Graphite-Web
ADD ./graphite/initial_data.json /var/lib/graphite/webapp/graphite/initial_data.json
ADD ./graphite/local_settings.py /var/lib/graphite/webapp/graphite/local_settings.py
ADD ./graphite/carbon.conf /var/lib/graphite/conf/carbon.conf
ADD ./graphite/storage-schemas.conf /var/lib/graphite/conf/storage-schemas.conf
RUN mkdir -p /var/lib/graphite/storage/whisper
RUN touch /var/lib/graphite/storage/graphite.db /var/lib/graphite/storage/index
RUN chown -R www-data /var/lib/graphite/storage
RUN chmod 0775 /var/lib/graphite/storage /var/lib/graphite/storage/whisper
RUN chmod 0664 /var/lib/graphite/storage/graphite.db
RUN cd /var/lib/graphite/webapp/graphite && python manage.py syncdb --noinput

# Grafana
ADD ./grafana/config.js /src/grafana/config.js
ADD ./grafana/hyperion.json /src/grafana/app/dashboards/default.json

# Nginx
ADD ./nginx/nginx.conf /etc/nginx/nginx.conf

# Supervisord
ADD ./supervisord/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Redis
ADD ./redis/redis.conf /src/redis/redis.conf

# Logstash
RUN mkdir /src/logstash/conf.d
ADD ./logstash/hyperion.conf /src/logstash/conf.d/hyperion.conf
ADD ./logstash/elasticsearch.conf /src/logstash/conf.d/elasticsearch.conf
ADD ./logstash/nginx.conf /src/logstash/conf.d/nginx.conf
ADD ./logstash/indexer.conf /src/logstash/conf.d/indexer.conf

# Kibana
ADD ./kibana/config.js /src/kibana/config.js
ADD ./kibana/hyperion.json /src/kibana/app/dashboards/default.json

# Ports
# ------

# graphite
EXPOSE	8000

# grafana
#EXPOSE  81

# nginx
EXPOSE 80

# elasticsearch HTTP
EXPOSE 9200
# elasticsearch transport
EXPOSE 9300

# Carbon line receiver port
EXPOSE	2003
# Carbon pickle receiver port
EXPOSE	2004
# Carbon cache query port
EXPOSE	7002

# Statsd UDP port
EXPOSE	8125/udp
# Statsd Management port
EXPOSE	8126

# Redis
EXPOSE 6379

# InfluxDB
EXPOSE 8086
EXPOSE 8083

# Volumes
# --------

VOLUME ["/var/lib/elasticsearch"]
VOLUME ["/var/lib/storage/whisper"]
VOLUME ["/var/lib/log/supervisor"]
VOLUME ["/var/lib/log/nginx"]
VOLUME ["/var/lib/redis"]


# Launch
# -------

CMD ["/usr/bin/supervisord"]
