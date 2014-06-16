Hyperion ChangeLog
======================

# Version 0.5.0 (2014-06-16)

- [#7][] : Update Tox / Python tests configuration to test CoreOS hyperion
- Change Elasticsearch setup using archive and no longer the Debian package
- Update CoreOS setup using Etcd and Fleet
- [#6][] : Add shared volume on Vagrant installation
- [#4][] : Upgrade to Elasticsearch 1.2.1

# Version 0.4.0 (2014-06-05)

- Add CoreOS support
- Add logstash Redis indexer
- `FIX` French timezone on Graphite configuration
- Initialize unit tests
- Configure Logstash to manage nginx logs
- Add Kibana
- Add Logstash
- Add Redis

# Version 0.3.0 (2014-05-23)

- Add Hyperion default dashboard for Grafana
- Update base image to Ubuntu 14.04
- Add Wercker configuration

# Version 0.2.0 (2014-05-21)

- Add Hyperion description file
- Add ElasticSearch plugins
- Configure Nginx
- Add a Statsd client to sent metric to hyperion
- Update Statsd configuration

# Version 0.1.0 (2014-05-16)

- Grafana and Graphite web UI available on the host
- Configure StatsD
- Configure ElasticSearch
- Configure Graphite
- Configure Graphana
- Init project



[#4]: https://github.com/nlamirault/hyperion/issues/4
[#6]: https://github.com/nlamirault/hyperion/issues/6
