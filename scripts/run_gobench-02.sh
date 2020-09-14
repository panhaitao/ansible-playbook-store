cd /home
nohup /tmp/gobench-2.0 -tr 30000 -tw 30000 -u 'https://api-test-xjh.growingio.com:4433/v3/0a1b4118dd954ec3bcc69da5138bdb96/web/pv?stm=1597991043684'  -c 100 -r 30000 -k=false -d /tmp/data.json &> /tmp/log &
