#!/bin/bash

# first, create a data-only container
https_proxy='' http_proxy='' HTTP_PROXY='' HTTPS_PROXY='' \
docker create \
  --name elastic-data \
  merck/docker-logstash \
  -v /data \
  /bin/true

# then run a container that uses the data-only container's volumes
https_proxy='' http_proxy='' HTTP_PROXY='' HTTPS_PROXY='' \
docker run \
  -d \
  -h elk \
  --name elk \
  -p 9200:9200 \
  -p 9292:9292 \
  -p 5000:5000 \
  -p 5000:5000/udp \
  --volumes-from elastic-data \
  merck/docker-logstash
