from ubuntu:12.04
MAINTAINER Nicolas Lamirault <nicolas.lamirault@gmail.com>

run echo 'deb http://us.archive.ubuntu.com/ubuntu/ precise universe' >> /etc/apt/sources.list
run apt-get -y update
run apt-get -y upgrade

#run apt-get -y install software-properties-common
# Install package  that provides add-apt-repository
RUN apt-get install -y python-software-properties

# Dependencies
run add-apt-repository -y ppa:chris-lea/node.js
run apt-get -y update

run apt-get -y install python-django-tagging python-simplejson python-memcache \
               python-ldap python-cairo python-django python-twisted   \
               python-pysqlite2 python-support python-pip gunicorn     \
	       supervisor nginx-light nodejs git wget curl collectd

# Elasticsearch
# fake fuse
run  apt-get install libfuse2 &&\
     cd /tmp ; apt-get download fuse &&\
     cd /tmp ; dpkg-deb -x fuse_* . &&\
     cd /tmp ; dpkg-deb -e fuse_* &&\
     cd /tmp ; rm fuse_*.deb &&\
     cd /tmp ; echo -en '#!/bin/bash\nexit 0\n' > DEBIAN/postinst &&\
     cd /tmp ; dpkg-deb -b . /fuse.deb &&\
     cd /tmp ; dpkg -i /fuse.deb
run cd ~ && wget https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.1.1.deb
run cd ~ && dpkg -i elasticsearch-1.1.1.deb && rm elasticsearch-1.1.1.deb
run apt-get -y install openjdk-7-jre
run /usr/share/elasticsearch/bin/plugin -install royrusso/elasticsearch-HQ
run /usr/share/elasticsearch/bin/plugin -install mobz/elasticsearch-head
run /usr/share/elasticsearch/bin/plugin -install karmi/elasticsearch-paramedic

# Install statsd
run mkdir /src && git clone https://github.com/etsy/statsd.git /src/statsd

# Install collectd
RUN adduser --system --group --no-create-home collectd

# Install Whisper, Carbon and Graphite-Web
run pip install whisper
run pip install --install-option="--prefix=/var/lib/graphite" \
    --install-option="--install-lib=/var/lib/graphite/lib" \
    carbon
run pip install --install-option="--prefix=/var/lib/graphite" \
    --install-option="--install-lib=/var/lib/graphite/webapp" \
    graphite-web

# Install Grafana
run mkdir -p /src/grafana && cd /src/grafana && \
    wget http://grafanarel.s3.amazonaws.com/grafana-1.5.4.tar.gz && \
    tar xzvf grafana-1.5.4.tar.gz --strip-components=1 && rm grafana-1.5.4.tar.gz

# Configuration
# -------------

# Elasticsearch
add ./elasticsearch/run /usr/local/bin/run_elasticsearch
#run chown -R elasticsearch:elasticsearch /var/lib/elasticsearch
#run mkdir -p /var/lib/elasticsearch/elasticsearch && chown elasticsearch:elasticsearch /tmp/elasticsearch

# statsd
add ./statsd/config.js /src/statsd/config.js

# collectd
ADD collectd/collectd.conf /etc/collectd/

# Whisper, Carbon and Graphite-Web
add ./graphite/initial_data.json /var/lib/graphite/webapp/graphite/initial_data.json
add ./graphite/local_settings.py /var/lib/graphite/webapp/graphite/local_settings.py
add ./graphite/carbon.conf /var/lib/graphite/conf/carbon.conf
add ./graphite/storage-schemas.conf /var/lib/graphite/conf/storage-schemas.conf
run mkdir -p /var/lib/graphite/storage/whisper
run touch /var/lib/graphite/storage/graphite.db /var/lib/graphite/storage/index
run chown -R www-data /var/lib/graphite/storage
run chmod 0775 /var/lib/graphite/storage /var/lib/graphite/storage/whisper
run chmod 0664 /var/lib/graphite/storage/graphite.db
run cd /var/lib/graphite/webapp/graphite && python manage.py syncdb --noinput

# Grafana
add ./grafana/config.js /src/grafana/config.js
#add ./grafana/scripted.json /src/grafana/app/dashboards/default.json

# Nginx
add ./nginx/nginx.conf /etc/nginx/nginx.conf

# Supervisord
add ./supervisord/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Ports
# ------

# graphite
expose	8000

# grafana
#expose  81

# nginx
expose 80

# elasticsearch HTTP
expose 9200
# elasticsearch transport
EXPOSE 9300

# Carbon line receiver port
expose	2003
# Carbon pickle receiver port
expose	2004
# Carbon cache query port
expose	7002

# Statsd UDP port
expose	8125/udp
# Statsd Management port
expose	8126


# Volumes
# --------

volume ["/var/lib/elasticsearch"]
volume ["/var/lib/storage/whisper"]
volume ["/var/lib/log/supervisor"]
volume ["/var/lib/log/nginx"]


# Launch
# -------

cmd ["/usr/bin/supervisord"]
