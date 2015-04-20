#!/bin/bash

https_proxy='' http_proxy='' HTTP_PROXY='' HTTPS_PROXY='' \
docker build -t merck/logspout .
