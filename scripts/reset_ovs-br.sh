ovs-vsctl del-port br-int ens256
ovs-vsctl del-br br-int
ovs-vsctl add-br br-int
ovs-vsctl add-port br-int ens256 -- set Interface ens256 ofport_request=1
ovs-vsctl --columns=ofport list interface ens256
ip link set br-int up
ip link set ens256 up
