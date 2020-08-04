#!/usr/bin/env python3

import argparse
import jsonpatch
from kubernetes import client, config

def do_k8s_resource_patch(config, json_patch, json_value):

    patch = '[{"op": "add", "path": json_patch, "value": json_value}]'
    res = jsonpatch.apply_patch(config, patch)

def get_k8s_resource(namespace,resource_type, resource_name):
    config.kube_config.load_kube_config(config_file="/root/.kube/config")


###
    config.load_kube_config()


    with open(path.join(path.dirname(__file__), "nginx-deployment.yaml")) as f:
        dep = yaml.safe_load(f)
        k8s_apps_v1 = client.AppsV1Api()
        resp = k8s_apps_v1.create_namespaced_deployment(
            body=dep, namespace="default")
        print("Deployment created. status='%s'" % resp.metadata.name)



if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Test for argparse')
    parser.add_argument('--namespace', '-ns', help='k8s cluster namespace', required=True)
    parser.add_argument('--resource_type','-type', help='k8s cluster resource_type',required=True)
    parser.add_argument('--resource_name','-name', help='k8s cluster resource_name',required=True)
    parser.add_argument('--json_path','-path', help='resource json path for patching',required=True)
    parser.add_argument('--json_value','-vaule', help='resource json vaule for patching',required=True)
    args = parser.parse_args()

    try:
        test_for_sys(args.namespace, args.resource_type, args.resource_name, args.json_path, args.json_value)
    except Exception as e:
        print(e)
