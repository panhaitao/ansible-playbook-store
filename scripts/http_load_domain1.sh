rm -f /tmp/log1
ulimit -n 1000000
nohup ab -p /home/test.json  -T application/json -n 1000000 -c 3000 "https://api1.growingio.com:4433/v3/0a1b4118dd954ec3bcc69da5138bdb96/web/pv?stm=1597991043684" &>> /tmp/log1 &
