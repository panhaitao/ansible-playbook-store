#!/bin/sh
kubectl set image deployments/morgans -n alauda-system morgans={{ init_ip }}:60080/alaudaorg/morgans:bf56f662f2b9df0cec2c4bc730589968de1afed4


docker tag index.alauda.cn/alaudaorg/architect:1d5074ce0ff89555784a5b73062e19b9cca5173a 10.213.107.213:60080/alaudaorg/architect:1d5074ce0ff89555784a5b73062e19b9cca5173a
docker tag index.alauda.cn/alaudaorg/jakiro:35675d438bfc1c93895e78ed3977bb4fbb6150eb 10.213.107.213:60080/alaudaorg/jakiro:35675d438bfc1c93895e78ed3977bb4fbb6150eb
docker tag index.alauda.cn/alaudaorg/morgans:bf56f662f2b9df0cec2c4bc730589968de1afed4 10.213.107.213:60080/alaudaorg/morgans:bf56f662f2b9df0cec2c4bc730589968de1afed4
docker tag index.alauda.cn/alaudaorg/rubick:8f083fba8d3b43d5fabfcadf8b9587d65c796574 10.213.107.213:60080/alaudaorg/rubick:8f083fba8d3b43d5fabfcadf8b9587d65c796574

docker push 10.213.107.213:60080/alaudaorg/architect:1d5074ce0ff89555784a5b73062e19b9cca5173a
docker push 10.213.107.213:60080/alaudaorg/jakiro:35675d438bfc1c93895e78ed3977bb4fbb6150eb
docker push 10.213.107.213:60080/alaudaorg/morgans:bf56f662f2b9df0cec2c4bc730589968de1afed4
docker push 10.213.107.213:60080/alaudaorg/rubick:8f083fba8d3b43d5fabfcadf8b9587d65c796574


kubectl set image deployments/morgans -n alauda-system morgans=10.213.107.213:60080/alaudaorg/morgans:bf56f662f2b9df0cec2c4bc730589968de1afed4
kubectl set image deployments/jakiro -n alauda-system jakiro=10.213.107.213:60080/alaudaorg/jakiro:35675d438bfc1c93895e78ed3977bb4fbb6150eb
kubectl set image deployments/architect -n alauda-system architect=10.213.107.213:60080/alaudaorg/architect:1d5074ce0ff89555784a5b73062e19b9cca5173a
kubectl set image deployments/rubick -n alauda-system rubick=10.213.107.213:60080/alaudaorg/rubick:8f083fba8d3b43d5fabfcadf8b9587d65c796574
