hub=127.0.0.1:5000
user=testuser
password=testpassword
num=10


hub=http://testuser:testpassword@127.0.0.1:5000

for repo in $( curl ${hub}/v2/_catalog  2>/dev/null |sed -e 's/^.*\[//' -e 's/\].*$//'  -e 's/\"//g' | tr ',' '\n' )
do
    for tag in $( curl ${hub}/v2/$repo/tags/list 2>/dev/null |sed -e 's/^.*\[//' -e 's/\].*$//'  -e 's/\"//g' | tr ',' '\n' )
    do
        echo $repo $tag
        Digest=$( curl -v --silent -H "Accept: application/vnd.docker.distribution.manifest.v2+json" \
             -X GET ${hub}/v2/$repo/manifests/$tag 2>&1 | grep Docker-Content-Digest  | awk '{print ($3)}')
        curl -v --silent -H "Accept: application/vnd.docker.distribution.manifest.v2+json" -X DELETE ${hub}/v2/$repo/manifests/$Digest
    done
done 

