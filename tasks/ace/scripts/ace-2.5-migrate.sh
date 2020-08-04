#!/bin/bash
$(whereis -b kubectl | awk '{print $2}') get pod -n alauda-system -o wide | sed 1d | awk '{print $1}' >/tmp/pod.list
timeout 20 $(whereis -b kubectl | awk '{print $2}') exec -n alauda-system $(grep "architect-[a-z0-9]\{3,\}-[a-z0-9]\{3,\}$" /tmp/pod.list 2>/dev/null | head -n 1) sh /migrate.sh >>/alauda/alauda.log 2>&1
if [[ $? -ne 0 ]]; then echo -e "\033[41;37m architect migrate failed \033[0m" ;else echo "architect migrate successed" ;fi
timeout 20 $(whereis -b kubectl | awk '{print $2}') exec -n alauda-system $(grep "chen2-[a-z0-9]\{3,\}-[a-z0-9]\{3,\}$" /tmp/pod.list 2>/dev/null | head -n 1) sh /migrate.sh  >>/alauda/alauda.log 2>&1
if [[ $? -ne 0 ]]; then echo -e "\033[41;37m chen2 migrate failed \033[0m" ;else echo "chen2 migrate successed" ;fi
timeout 20 $(whereis -b kubectl | awk '{print $2}') exec -n alauda-system $(grep "chen2-[a-z0-9]\{3,\}-[a-z0-9]\{3,\}$" /tmp/pod.list 2>/dev/null | head -n 1) sh /sync_public_plugin_repo.sh  >>/alauda/alauda.log 2>&1
if [[ $? -ne 0 ]]; then echo -e "\033[41;37m chen2 migrate failed \033[0m" ;else echo "chen2 migrate successed" ;fi
timeout 20 $(whereis -b kubectl | awk '{print $2}') exec -n alauda-system $(grep "chen2-[a-z0-9]\{3,\}-[a-z0-9]\{3,\}$" /tmp/pod.list 2>/dev/null | head -n 1) sh /sync_public_repo.sh  >>/alauda/alauda.log 2>&1
if [[ $? -ne 0 ]]; then echo -e "\033[41;37m chen2 migrate failed \033[0m" ;else echo "chen2 migrate successed" ;fi
timeout 20 $(whereis -b kubectl | awk '{print $2}') exec -n alauda-system $(grep "darchrow-[a-z0-9]\{3,\}-[a-z0-9]\{3,\}$" /tmp/pod.list 2>/dev/null | head -n 1) python manage.py migrate  >>/alauda/alauda.log 2>&1
if [[ $? -ne 0 ]]; then echo -e "\033[41;37m darchrow migrate failed \033[0m" ;else echo "darchrow  migrate successed" ;fi
timeout 20 $(whereis -b kubectl | awk '{print $2}') exec -n alauda-system $(grep "davion-[a-z0-9]\{3,\}-[a-z0-9]\{3,\}$" /tmp/pod.list 2>/dev/null | head -n 1) python3 manage.py migrate  >>/alauda/alauda.log 2>&1
if [[ $? -ne 0 ]]; then echo -e "\033[41;37m davion migrate failed \033[0m" ;else echo "davion migrate successed" ;fi
timeout 20 $(whereis -b kubectl | awk '{print $2}') exec -n alauda-system $(grep "enigma-[a-z0-9]\{3,\}-[a-z0-9]\{3,\}$" /tmp/pod.list 2>/dev/null | head -n 1) sh /db-migrate.sh  >>/alauda/alauda.log 2>&1
if [[ $? -ne 0 ]]; then echo -e "\033[41;37m enigma migrate failed \033[0m" ;else echo "enigma migrate successed" ;fi
timeout 20 $(whereis -b kubectl | awk '{print $2}') exec -n alauda-system $(grep "enigma-[a-z0-9]\{3,\}-[a-z0-9]\{3,\}$" /tmp/pod.list 2>/dev/null | head -n 1) sleep 5  >>/alauda/alauda.log 2>&1
if [[ $? -ne 0 ]]; then echo -e "\033[41;37m enigma migrate failed \033[0m" ;else echo "enigma migrate successed" ;fi
timeout 20 $(whereis -b kubectl | awk '{print $2}') exec -n alauda-system $(grep "enigma-[a-z0-9]\{3,\}-[a-z0-9]\{3,\}$" /tmp/pod.list 2>/dev/null | head -n 1) sh /init-jenkins-template.sh  >>/alauda/alauda.log 2>&1
if [[ $? -ne 0 ]]; then echo -e "\033[41;37m enigma migrate failed \033[0m" ;else echo "enigma migrate successed" ;fi
timeout 20 $(whereis -b kubectl | awk '{print $2}') exec -n alauda-system $(grep "furion-[a-z0-9]\{3,\}-[a-z0-9]\{3,\}$" /tmp/pod.list 2>/dev/null | head -n 1) -c furion python manage.py migrate  >>/alauda/alauda.log 2>&1
if [[ $? -ne 0 ]]; then echo -e "\033[41;37m furion migrate failed \033[0m" ;else echo "furion migrate successed" ;fi
timeout 20 $(whereis -b kubectl | awk '{print $2}') exec -n alauda-system $(grep "heimdall-[a-z0-9]\{3,\}-[a-z0-9]\{3,\}$" /tmp/pod.list 2>/dev/null | head -n 1) sh /migrate.sh  >>/alauda/alauda.log 2>&1
if [[ $? -ne 0 ]]; then echo -e "\033[41;37m heimdall migrate failed \033[0m" ;else echo "heimdall migrate successed" ;fi
timeout 20 $(whereis -b kubectl | awk '{print $2}') exec -n alauda-system $(grep "jakiro-[a-z0-9]\{3,\}-[a-z0-9]\{3,\}$" /tmp/pod.list 2>/dev/null | head -n 1) python manage.py makemigrations >>/alauda/alauda.log 2>&1
if [[ $? -ne 0 ]]; then echo -e "\033[41;37m jakiro migrate failed \033[0m" ;else echo "jakiro migrate successed" ;fi
timeout 20 $(whereis -b kubectl | awk '{print $2}') exec -n alauda-system $(grep "jakiro-[a-z0-9]\{3,\}-[a-z0-9]\{3,\}$" /tmp/pod.list 2>/dev/null | head -n 1) python manage.py migrate  >>/alauda/alauda.log 2>&1
if [[ $? -ne 0 ]]; then echo -e "\033[41;37m jakiro migrate failed \033[0m" ;else echo "jakiro migrate successed" ;fi
timeout 20 $(whereis -b kubectl | awk '{print $2}') exec -n alauda-system $(grep "lightkeeper-[a-z0-9]\{3,\}-[a-z0-9]\{3,\}$" /tmp/pod.list 2>/dev/null | head -n 1) python manage.py migrate  >>/alauda/alauda.log 2>&1
if [[ $? -ne 0 ]]; then echo -e "\033[41;37m lightkeeper migrate failed \033[0m" ;else echo "lightkeeper migrate successed";fi
timeout 20 $(whereis -b kubectl | awk '{print $2}') exec -n alauda-system $(grep "lightkeeper-[a-z0-9]\{3,\}-[a-z0-9]\{3,\}$" /tmp/pod.list 2>/dev/null | head -n 1) sleep 5  >>/alauda/alauda.log 2>&1
if [[ $? -ne 0 ]]; then echo -e "\033[41;37m chen2 migrate failed \033[0m" ;else echo "lightkeeper migrate successed" ;fi
timeout 20 $(whereis -b kubectl | awk '{print $2}') exec -n alauda-system $(grep "lightkeeper-[a-z0-9]\{3,\}-[a-z0-9]\{3,\}$" /tmp/pod.list 2>/dev/null | head -n 1) bash /app/scripts/create_weblab_json.sh  >>/alauda/alauda.log 2>&1
if [[ $? -ne 0 ]]; then echo -e "\033[41;37m lightkeeper migrate failed \033[0m" ;else echo "lightkeeper migrate successed" ;fi
timeout 20 $(whereis -b kubectl | awk '{print $2}') exec -n alauda-system $(grep "lucifer-[a-z0-9]\{3,\}-[a-z0-9]\{3,\}$" /tmp/pod.list 2>/dev/null | head -n 1) python manage.py migrate  >>/alauda/alauda.log 2>&1
if [[ $? -ne 0 ]]; then echo -e "\033[41;37m lucifer migrate failed \033[0m" ;else echo  "lucifer migrate successed" ;fi
timeout 20 $(whereis -b kubectl | awk '{print $2}') exec -n alauda-system $(grep "razzil-[a-z0-9]\{3,\}-[a-z0-9]\{3,\}$" /tmp/pod.list 2>/dev/null | head -n 1) python manage.py migrate  >>/alauda/alauda.log 2>&1
if [[ $? -ne 0 ]]; then echo -e "\033[41;37m razzil migrate failed \033[0m" ;else echo "razzil migrate successed" ;fi
timeout 20 $(whereis -b kubectl | awk '{print $2}') exec -n alauda-system $(grep "razzil-[a-z0-9]\{3,\}-[a-z0-9]\{3,\}$" /tmp/pod.list 2>/dev/null | head -n 1) sh /razzil/scripts/loaddate_ci_envs_catalog.sh  >>/alauda/alauda.log 2>&1
if [[ $? -ne 0 ]]; then echo -e "\033[41;37m razzil migrate failed \033[0m" ;else echo "razzil migrate successed" ;fi
timeout 20 $(whereis -b kubectl | awk '{print $2}') exec -n alauda-system $(grep "tiny-[a-z0-9]\{3,\}-[a-z0-9]\{3,\}$" /tmp/pod.list 2>/dev/null | head -n 1) python manage.py migrate  >>/alauda/alauda.log 2>&1
if [[ $? -ne 0 ]]; then echo -e "\033[41;37m tiny migrate failed \033[0m" ;else echo "tiny migrate successed" ;fi
timeout 20 $(whereis -b kubectl | awk '{print $2}') exec -n alauda-system $(grep "morgans-[a-z0-9]\{3,\}-[a-z0-9]\{3,\}$" /tmp/pod.list 2>/dev/null | head -n 1) python migration/migrate.py  >>/alauda/alauda.log 2>&1
if [[ $? -ne 0 ]]; then echo -e "\033[41;37m morgans migrate failed \033[0m" ;else echo "morgans migrate successed" ;fi
#$(whereis -b kubectl | awk '{print $2}') exec -n alauda-system $(grep "titan-[a-z0-9]\{3,\}-[a-z0-9]\{3,\}$" /tmp/pod.list 2>/dev/null | head -n 1) sh ./migrate.sh
#$(whereis -b kubectl | awk '{print $2}') exec -n alauda-system $(grep "wisp-[a-z0-9]\{3,\}-[a-z0-9]\{3,\}$" /tmp/pod.list 2>/dev/null | head -n 1) ./migrate.sh
#$(whereis -b kubectl | awk '{print $2}') exec -n alauda-system $(grep "wisp-lords-[a-z0-9]\{3,\}-[a-z0-9]\{3,\}$" /tmp/pod.list 2>/dev/null | head -n 1) ./migrate.sh
echo -e "\033[44;37m 相关日志在master-1上的/alauda/alauda.log里 \033[0m"
