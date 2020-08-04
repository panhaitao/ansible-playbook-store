docker run -d         --restart=always         --name=yum         -e KALDR_HOST="{{ init_ip }}:7000"         -p 7000:7000         {{ init_ip }}:60080/alaudaorg/kaldr:{{ kaldr_tag }}
