cat <(printf "GET /status/200 HTTP/1.1\r\nHost: 127.0.0.1\r\nConnection: keep-alive\r\n\r\n") \
    <(printf "GET /status/200 HTTP/1.1\r\nHost: 127.0.0.1\r\nConnection: keep-alive\r\n\r\n") \
      <(printf "GET /status/200 HTTP/1.1\r\nHost: 127.0.0.1\r\nConnection: close\r\n\r\n") \
  | nc 127.0.0.1 80
