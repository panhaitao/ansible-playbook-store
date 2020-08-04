#!/bin/sh
docker ps | grep -E 'chartmuseum|kaldr' | awk '{print $1}' | xargs docker rm -f
