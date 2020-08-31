rm -f /tmp/log
ulimit -n 1000000
nohup ab -p /home/test.json  -T application/json -n 1000000 -c 1000 "https://api-test-xjh.growingio.com:4433/v3/0a1b4118dd954ec3bcc69da5138bdb96/web/pv?stm=1597991043684" &>> /tmp/log &
