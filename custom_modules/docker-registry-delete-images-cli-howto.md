# how to 

# 运行测试环境

mkdir auth
docker run --entrypoint htpasswd registry:2 -Bbn testuser testpassword > auth/htpasswd
docker run -d -p 5000:5000 --name registry         \ 
  -v "$(pwd)"/auth:/auth                           \
  -e REGISTRY_STORAGE_DELETE_ENABLED="true"        \
  -e "REGISTRY_AUTH=htpasswd"                      \
  -e "REGISTRY_AUTH_HTPASSWD_REALM=Registry Realm" \
  -e REGISTRY_AUTH_HTPASSWD_PATH=/auth/htpasswd    \
  registry:2

docker login -u testuser -p testpassword 127.0.0.1:5000

for f in {1..100};  
do
  docker tag registry:2  127.0.0.1:5000/test:$f
  docker push 127.0.0.1:5000/registry:$f
done

python3 docker-registry-delete-images-cli.py --dockerhub http://127.0.0.1:5000 --user testuser --password testpassword  --repos test

最后进入registry 容器执行：

docker exec -it registry  /bin/registry garbage-collect  /etc/docker/registry/config.yml

## 参考

* https://blog.csdn.net/ywq935/article/details/83828888
* https://blog.csdn.net/nklinsirui/article/details/80705306#%E5%88%A0%E9%99%A4registry%E4%B8%AD%E7%9A%84%E9%95%9C%E5%83%8F
