#!/usr/bin/env python3
# -*- coding:utf-8 -*-

import requests
import argparse
from concurrent.futures import ThreadPoolExecutor

class Docker(object):
    def __init__(self, hub, repos, user, password):
        self.hub = hub
        self.repos = list(repos)
        self.user = user
        self.password = password

    @staticmethod
    def get_tag_list(hub, repo, user, password):
        # 获取这个repo的所有tags
        tag_list_url = '%s/v2/%s/tags/list' % (hub, repo)
        r1 = requests.get(url=tag_list_url,auth=(user, password))
        tag_list = r1.json().get('tags')
        return tag_list

    def main(self):
        thpool = ThreadPoolExecutor(10)
        for repo in self.repos:
            thpool.submit(self.delete_images, repo)

        thpool.shutdown(wait=True)

    def delete_images(self, repo):
        hub = self.hub
        user = self.user
        password = self.password
        tag_list = self.get_tag_list(hub=hub, repo=repo, user=user, password=password)
        num = 0
        try:
            # 保留最后十个版本的镜像
            for tag in tag_list[:-1]:
                # 获取image digest摘要信息
                get_info_url = '{}/v2/{}/manifests/{}'.format(hub, repo, tag)
                header = {"Accept": "application/vnd.docker.distribution.manifest.v2+json"}
                r2 = requests.get(url=get_info_url, auth=(user, password), headers=header, timeout=10)
                digest = r2.headers.get('Docker-Content-Digest')

                # 删除镜像
                delete_url = '%s/v2/%s/manifests/%s' % (hub, repo, digest)
                r3 = requests.delete(url=delete_url, auth=(user, password))
                if r3.status_code == 202:
                    num += 1

        except Exception as e:
            print(str(e))

        print('仓库%s 共删除了%i个历史镜像' % (repo, num))

if __name__ == '__main__':

  parser = argparse.ArgumentParser(description='Test for argparse')
  parser.add_argument('--dockerhub', '-hub', help='docker hub url: http://hub_domain:port', required=True)
  parser.add_argument('--user','-u', help='docker hub login user',required=True)
  parser.add_argument('--password','-p', help='docker hub login password',required=True)
  parser.add_argument('--repos','-r', help='docker iamge repo name', nargs='+', required=True)
  args = parser.parse_args()

  try:
    d = Docker(hub=args.dockerhub, user=args.user, password=args.password, repos=args.repos)
  except Exception as e:
    print(e)
  
  d.main()
