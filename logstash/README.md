merck/logstash docker image
===========================

    FROM pblittle/docker-logstash

A [Docker](https://www.docker.com/) image that runs
[Logstash](http://logstash.net/) +
[Elasticsearch](https://github.com/elastic/elasticsearch) +
[Kibana](https://github.com/elastic/kibana).

This example shows how to

1. Setup logstash to accept incoming syslogs on custom port
2. Provide your own configuration file
3. Provide your own key + certificate
4. Persist the elastic search data

This example does not show how to

- Scale elastic search

Structure
---------

Please consider these files as templates. Fork and modify as appropriate.

### `Dockerfile`

Copies the configuration file and keys.

### `build.sh`

Builds the Dockerfile and assigns tag.

### `run.sh`

Creates the docker data-only container and runs the elk stack that uses this as volume.
