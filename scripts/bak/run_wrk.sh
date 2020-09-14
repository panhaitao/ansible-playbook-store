nohup wrk -t2000 -c8000 -d300s -R40000 -L -s /home/post.lua  "https://api1.growingio.com:4433/v3/0a1b4118dd954ec3bcc69da5138bdb96/web/pv?stm=1597991043684" &> /dev/null &
#wrk -t1 -c1 -d 60s -R1 -L -s /home/post.lua  "https://api1.growingio.com:4433/v3/0a1b4118dd954ec3bcc69da5138bdb96/web/pv?stm=1597991043684"
