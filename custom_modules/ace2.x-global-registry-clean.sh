#!/bin/bash

# 列出默认仓库的全部项目名字分类
#c curl -x "GET" -H "Authorization: Token xxxx" jakiro_lb:32001/v1/registries/cpaas/default-registry/projects/ | jq .[].project_name 

# 列出某个项目下的仓库列表
# curl -x "GET" -H "Authorization: Token xxxx" jakiro_lb:32001/v1/registries/cpaas/default-registry/projects/<project_name>/repositories | jq .[].name 

# 列出某个项目下的某个仓库的某个镜像tag
#curl -x "GET" -H "Authorization: Token xxxx" jakiro_lb:32001/v1/registries/cpaas/default-registry/projects/<project_name>/repositories/image_name/tags | jq .[].name 

# 删除某个项目下的某个仓库的某个镜像tag 版本
#curl -x "DELETE" -H "Authorization: Token xxxx" jakiro_lb:32001/v1/registries/cpaas/default-registry/projects/<project_name>/repositories/image_name/tags/<verison>


function get_projects()
{
	local api_endpoint=$1
        local token=$2

  if [[ "$api_endpoint" == "" || "$token" == "" ]];then
  {
    echo "ERROR: the args of get_projects() is empty!!!"
    exit 1
  }
  else
	result=$( curl  -XGET -H "Authorization: Token $token" ${api_endpoint}/v1/registries/cpaas/${reg_name}/projects/ ｜ jq .[].project_name )
	echo $result 
  fi
}

function get_repositories()
{

	  local api_endpoint=$1
    local token=$2
    local project_name=$3

  if [[ "$api_endpoint" == "" || "$token" == "" || "$project_name"== "" ]];then
  {
    echo "ERROR: the args of get_repositories() is empty!!!"
    exit 1
  }
  else
	result=$( curl  -XGET -H "Authorization: Token $token" ${api_endpoint}/v1/registries/cpaas/${reg_name}/projects/${project_name}/repositories | jq .[].name )
	echo $result 
  fi
}

function get_tags()
{

	local api_endpoint=$1
        local token=$2
        local project_name=$3
        local image_name=$4

  if [[ "$api_endpoint" == "" || "$token" == "" || "$project_name" == "" || "$image_name" == "" ]];then
  {
    echo "ERROR: the args of get_tags() is empty!!!"
    exit 1
  }
  else
	result=$( curl  -XGET -H "Authorization: Token $token" ${api_endpoint}/v1/registries/cpaas/${reg_name}/projects/${project_name}/repositories/${image_name}/tags | jq .[].name )
	echo $result 
  fi
}

function delete_image()
{
	local api_endpoint=$1
        local token=$2
        local project_name=$3
        local image_name=$4
        local tag=$( echo $5 | tr -d '\,' )
  if [[ "$api_endpoint" == "" || "$token" == "" || "$project_name" == "" || "$image_name" == "" || "$tag" == "" ]];then
  {
    echo "ERROR: func args is empty!!!"
    exit 1
  }
  else
	result=$( curl  -XDELETE -H "Authorization: Token $token" ${api_endpoint}/v1/registries/cpaas/${reg_name}/projects/${project_name}/repositories/${image_name}/tags/${tag} | jq .[].name )
	echo $result 
  fi

}

api_endpoint=http://10.213.107.193:32001
token-=xxx
reg_name=default_registry

projects=get_projects $api_endpoint $token

for project in $projects
  do
    p=$( echo $project | tr -d '\"' )
    repos=get_repositories $api_endpoint $token $p
    for image in $repos
    do
      i=$( echo $image | tr -d '\"')
      tags=get_tags  $api_endpoint $token $p $i
      tags_str=$( echo $tags | tr -d '\"')
      tags_arr=($tags_str)
      tags_len=${#tags_arr[@]}
      if (( $tags_len > 10 )); then
        max=$(( $tags_len-10 ))
        for index in $( seq 10 $max )
          do
	    echo curl  -XDELETE -H "Authorization: Token $token" ${api_endpoint}/v1/registries/cpaas/${reg_name}/projects/${p}/repositories/${i}/tags/${tags_arr[index]}  
            #delete_image $api_endpoint $token $p $i ${tags_arr[index]} 
          done
      fi
    done  
  done 
