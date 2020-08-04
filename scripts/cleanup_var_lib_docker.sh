# 清理异常的容器实例
docker ps -a | grep -v Up | awk '{print $1}' | xargs docker rm

# 清理当前节点不再使用的容器镜像


docker images |awk '{print $1":"$2 }' | sort | uniq > images.list
docker ps | awk '{print $2}' | sort | uniq | grep : > current.list
comm -3 images.list  current.list | xargs docker rmi
#trackbackRdf ($trackbackUtils.getContentIdentifier($page) $page.title $trackbackUtils.getPingUrl($page)) 
