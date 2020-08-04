#!/bin/bash
set -x
nohup nebula -config /etc/nebula/config.yml &> /dev/null &
