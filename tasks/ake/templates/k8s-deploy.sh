{%- set k8s_cha = cha_ip -%}
{%- set pkg_ip  = pkg_ip -%}
./ake deploy --kubernetes-version=v1.9.6                                        \
             --dockercfg=/root/mini-alauda/daemon.json                          \
             --kube_apiserver_host={{ k8s_cha }}       \
             --apiserver={{ k8s_cha }}:6443            \
             --network-opt="backend_type=host-gw"                               \
             --network-interface=eth0                                           \
             --network-opt="cidr=10.222.0.0/16"                                 \
             --ssh-username=root --ssh-key-path="/root/.ssh/id_rsa"             \
             --pkg_repo="http://{{ pkg_ip }}:7000"                   \
             --registry="{{ pkg_ip }}:60080"                         \
             --masters="{%- for item in groups['master'] -%} {{ hostvars[item]['ansible_ssh_host'] }}{% if not loop.last %};{% endif %} {%- endfor -%}" \
             --etcds="{%- for item in groups['master'] -%} {{ hostvars[item]['ansible_ssh_host'] }}{% if not loop.last %};{% endif %} {%- endfor -%}" \
             --nodes="{%- for item in groups['node'] -%} {{ hostvars[item]['ansible_ssh_host'] }}{% if not loop.last %};{% endif %} {%- endfor -%}" \
             --kube_apiserver_advertise_address={{ k8s_cha }}  --debug
