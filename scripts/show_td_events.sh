echo "## cck8s-td last 7D k8s events :"   
curl -q -XGET -H "Authorization:Token f771c9ea54222cd6dbb081b84f7ae4c65f97fb9e" "http://10.213.109.2:32001/v2/kevents/?start_time=1570155951&end_time=1570760751.242&cluster=cck8s-td&name=&kind=&namespace=&page=1&page_size=1000" | jq ".total_items"

echo "## calico-test last 7D k8s events :"   
curl -q -XGET -H "Authorization:Token f771c9ea54222cd6dbb081b84f7ae4c65f97fb9e" "http://10.213.109.2:32001/v2/kevents/?start_time=1570155951&end_time=1570760751.242&cluster=calico-test&name=&kind=&namespace=&page=1&page_size=1000" | jq ".total_items"

echo "## gk8s-td last 7D k8s events :"   
curl -q -XGET -H "Authorization:Token f771c9ea54222cd6dbb081b84f7ae4c65f97fb9e" "http://10.213.109.2:32001/v2/kevents/?start_time=1570155951&end_time=1570760751.242&cluster=gk8s-td&name=&kind=&namespace=&page=1&page_size=1000" | jq ".total_items"

echo "## devk8s-td last 7D k8s events :"   
curl -q -XGET -H "Authorization:Token f771c9ea54222cd6dbb081b84f7ae4c65f97fb9e" "http://10.213.109.2:32001/v2/kevents/?start_time=1570155951&end_time=1570760751.242&cluster=devk8s-td&name=&kind=&namespace=&page=1&page_size=1000" | jq ".total_items"
