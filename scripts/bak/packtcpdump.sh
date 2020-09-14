#!/bin/bashi
nohup tcpdump tcp dst port 4433 -vv -w /tmp/gro4433.cap >/dev/null 2>&1 &
