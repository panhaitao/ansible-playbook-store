#!/bin/bash
# filename: get node res used
node_cpu_cores=`nproc`

#docker stats --no-stream --format "table {{ .Name }} \t {{ .CPUPerc }} \t {{ .MemUsage }}" | awk 'NR>1 {print $2"\t"$3" }' | sort | while read line
##do
#        node_cpu_used=`echo $line | awk '{print $1}'`
#        node_mem_used=`echo $line | awk '{print $2}'`
#        node_mem_type=`echo ${node_mem_used:-3}`
#        node_mem_size=`echo ${node_mem_used} ｜awk -F:$node_mem_type '{print $1}'`
#
#        node_cpu_total=`bc <<<$node_cpu_used*${node_cpu_cores}+$node_cpu_total`
#
#	case $mem_size_type in
#	    kiB) node_mem_total=`bc <<< $node_mem_size/1024/1024+${node_mem_total}`;
#	    MiB) node_mem_total=`bc <<< $node_mem_size/1024+${node_mem_total}`;
#	    GiB) node_mem_total=`bc <<< $node_mem_size+${node_mem_total}`;
#	    *) echo "Unkown Mem size type";
#	esas
#done


######### get k8s ns cpu mem limits total #########################################

cpu_total=0
mem_total=0

for ns in `kubectl get ns  | grep -Ev 'default|kube-system' | awk 'NR>1 {print $1}'`
do
    ns_cpu=$( kubectl describe ns $ns | grep limits.cpu | awk '{print $3} )   
    ns_mem=$( kubectl describe ns $ns | grep limits.memory | awk '{print $3} )   
    ns_mem_type=$( echo {ns_mem: -1} )
    ns_mem_size=$( echo {ns_mem} | awk -F$ns_name_type '{print $1}' )

    case $ns_mem_type in
           M) ns_mem=$( echo "scale=4; $node_mem_size/1024" | bc );
           G) ns_mem=$( echo "scale=4; $node_mem_size/1" | bc );
           *) echo "Unkown Mem size type";
    esas
    
    cpu_total=`echo "scale=4; $cpu_total+$ns_cpu" | bc`
    mem_total=`echo "scale=4; $mem_total+$ns_mem" | bc`
    echo "cpu_total: $cpu_total   mem_total: $mem_total" > /tmp/total
done

cat /tmp/total

######################################################################################
######### get k8s ns cpu mem limits uesd #########################################

cpu_total=0
mem_total=0

for ns in `kubectl get ns  | grep -Ev 'default|kube-system' | awk 'NR>1 {print $1}'`
do
    ns_cpu=$( kubectl describe ns $ns | grep limits.cpu | awk '{print $2} )   
    ns_cpu_type=$( echo {ns_cpu: -1} )

    case $ns_cpu_type in
           m) ns_cpu_size=$( echo ${ns_cpu} | awk -F$ns_cpu_type '{print $1}' ) ;;
    esas

    case $ns_cpu_type in
	m) ns_cpu_value=$(echo "scale=4; $ns_cpu_size/1000" | bc ) ;;
	*) ns_cpu_value=$(echo "scale=4; $ns_cpu_size/1" | bc ) ;;
    esac

    ns_mem=$( kubectl describe ns $ns | grep limits.memory | awk '{print $2} )   
    ns_mem_type=$( echo {ns_mem: -1} )
    case $ns_mem_type in
           M|G) ns_cpu_size=$( echo ${ns_cpu} | awk -F$ns_cpu_type '{print $1}' ) ;;
           *) ns_mem_size=${ns_mem} ;;
    esas

    case $ns_mem_type in
	M) ns_mem_value=$(echo "scale=4; $ns_mem_size/1024" | bc ) ;;
	G) ns_mem_value=$(echo "scale=4; $ns_mem_size/1" | bc ) ;;
	*) ns_mem_value=$(echo "scale=4; $ns_mem_size/1024/1024/1024" | bc ) ;;
    esac

    cpu_total=`echo "scale=4; $cpu_total+$ns_cpu_value" | bc`
    mem_total=`echo "scale=4; $mem_total+$ns_mem_value" | bc`
    echo "cpu_used: $cpu_total   mem_used: $mem_total" > /tmp/total
done

cat /tmp/total

###################################################################################
######### get k8s ns cpu mem request uesd #########################################

cpu_total=0
mem_total=0

for ns in `kubectl get ns  | grep -Ev 'default|kube-system' | awk 'NR>1 {print $1}'`
do
    ns_cpu=$( kubectl describe ns $ns | grep requests.cpu | awk '{print $2} )   
    ns_cpu_type=$( echo {ns_cpu: -1} )

    case $ns_cpu_type in
           m) ns_cpu_size=$( echo ${ns_cpu} | awk -F$ns_cpu_type '{print $1}' ) ;;
           *) ns_cpu_size=${ns_cpu} ;;
    esas

    case $ns_cpu_type in
	m) ns_cpu_value=$(echo "scale=4; $ns_cpu_size/1000" | bc ) ;;
	0) ns_cpu_value=$(echo "scale=4; $ns_cpu_size" | bc ) ;;
	*) ns_cpu_value=$(echo "scale=4; $ns_cpu_size/1" | bc ) ;;
    esac

    ns_mem=$( kubectl describe ns $ns | grep requests.memory | awk '{print $2} )   
    ns_mem_type=$( echo {ns_mem: -1} )
    case $ns_mem_type in
           m|M|G) ns_mem_size=$( echo ${ns_cpu} | awk -F$ns_cpu_type '{print $1}' ) ;;
           *) ns_mem_size=${ns_mem} ;;
    esas

    case $ns_mem_type in
	m|M) ns_mem_value=$(echo "scale=4; $ns_mem_size/1024" | bc ) ;;
	G) ns_mem_value=$(echo "scale=4; $ns_mem_size/1" | bc ) ;;
	0) ns_mem_value=$(echo "scale=4; $ns_mem_size" | bc ) ;;
	G) ns_mem_value=$(echo "scale=4; $ns_mem_size/1024/1024/1024" | bc ) ;;
    esac

    cpu_total=`echo "scale=4; $cpu_total+$ns_cpu_value" | bc`
    mem_total=`echo "scale=4; $mem_total+$ns_mem_value" | bc`
    echo "cpu_requests: $cpu_total   mem_requests: $mem_total" > /tmp/total
done

cat /tmp/total
###################################################################################

kubectl top nodes | awk 'NR>1 {print $2"\t"$4" }' | sort | while read line
do
    cpu_use=`echo  $line  | awk '{print $1}'`
    cpu_type=`echo ${cpu_use: -1}`
    cpu_size=`echo ${cpu_use} | awk -F$cpu_type '{print $1}'` 

    mem_use=`echo  $line  | awk '{print $2}'`
    mem_type=`echo ${mem_use: -2}`
    mem_size=`echo ${mem_use} | awk -F$mem_type '{print $1}'` 

    cpu_total=`echo "scale=4; $cpu_total+$cpu_size" | bc`
    mem_total=`echo "scale=4; $mem_total+$mem_size" | bc`
    echo "cpu_total: $cpu_total   mem_total: $mem_total" > /tmp/total
done    
   
cat /tmp/total
