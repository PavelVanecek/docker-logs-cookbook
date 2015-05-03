#!/bin/bash

# feel free to use your own configuration
LOGSTASH_IP=$(boot2docker ip)
LOGSTASH_PORT=5000

https_proxy='' http_proxy='' HTTP_PROXY='' HTTPS_PROXY='' \
docker run \
  -d \
  -h logspout \
  --name logspout \
  -p 8000:80 \
  -v /var/run/docker.sock:/tmp/docker.sock \
  merck/logspout \
  logstash://${LOGSTASH_IP}:${LOGSTASH_PORT}
