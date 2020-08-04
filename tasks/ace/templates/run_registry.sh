docker load -i {{ pkg_dir }}/ACP/registry.tar
docker run -d         --restart=always         --name pkg-registry         -p 60080:5000         -v {{ pkg_dir }}/ACP/registry:/var/lib/registry         registry:latest
