# -*- coding: utf-8 -*-

"""
    Homepage: https://github.com/ucloud/ucloud-sdk-python3
    Examples: https://github.com/ucloud/ucloud-sdk-python3/tree/master/examples
    Documentation: https://ucloud.github.io/ucloud-sdk-python3/
"""

from ucloud.core import exc
from ucloud.client import Client

def main():
    client = Client({
        "region": "cn-bj2",
        "project_id": "org-5wakzh",
        "public_key": ""
        "private_key": ""
        "base_url": "https://api.ucloud.cn",
    })

    try:
        resp = client.uhost().create_uhost_instance({
            "MachineType": "O",
            "ChargeType": "Dynamic", 
            "SecurityGroupId": "firewall-4fntbzvk",
            "Zone": "cn-bj2-03",
            "ImageId": "uimage-i2pcb2i3",
            "Password": "a4h3ljbn",
            "LoginMode": "Password",
            "Name": "test-",
            "CPU": 8,
            "Memory": 8192,
            "MaxCount": 1,
            "NetworkInterface": [
                {
                    "EIP": {
                        "Bandwidth": 300,
                        "PayMode": "Traffic",
                        "OperatorName": "Bgp"
                    }
                }
            ],
            "Disks": [
                {
                    "Type": "CLOUD_RSSD",
                    "IsBoot": "True",
                    "Size": 20
                }
            ]
        
        })
    except exc.UCloudException as e:
        print(e)
    else:
        print(resp['IPs'][0])

if __name__ == '__main__':
    main()

