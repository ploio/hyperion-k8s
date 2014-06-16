FROM ubuntu:14.04
MAINTAINER Nicolas Lamirault <nicolas.lamirault@gmail.com>

RUN apt-get -y update && apt-get install -y software-properties-common

# RUN dpkg-reconfigure locales && \
#     locale-gen C.UTF-8 && \
#     /usr/sbin/update-locale LANG=C.UTF-8
# ENV LC_ALL C.UTF-8
RUN locale-gen en_US.UTF-8 && update-locale LANG=en_US.UTF-8

# Dependencies
RUN \
  echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
  echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections && \
  add-apt-repository -y ppa:webupd8team/java && \
  apt-get update && \
  apt-get install -y oracle-java7-installer

# Install Elasticsearch
RUN mkdir -p /src/elasticsearch && cd /src/elasticsearch && \
    wget https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.2.1.tar.gz && \
    tar xzf elasticsearch-1.2.1.tar.gz --strip-components=1 && rm elasticsearch-1.2.1.tar.gz
RUN /src/elasticsearch/bin/plugin -v -i mobz/elasticsearch-head
RUN /src/elasticsearch/bin/plugin -v -i royrusso/elasticsearch-HQ
RUN /src/elasticsearch/bin/plugin -v -i lmenezes/elasticsearch-kopf

# Configure Elasticsearch
ADD ./elasticsearch.yml /src/elasticsearch/elasticsearch.yml

# Supervisord
ADD ./supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Ports
# ------

# elasticsearch HTTP
EXPOSE 9200
# elasticsearch transport
EXPOSE 9300

# Volumes
# --------

VOLUME ["/var/lib/elasticsearch"]


# Launch
# -------

CMD ["/usr/bin/supervisord"]
