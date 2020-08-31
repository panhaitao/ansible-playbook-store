ansible -i hosts/ab-bench all -m script -a scripts/check_bench_log.sh -o
#ansible -i hosts/ab-bench all -m script -a scripts/http_load.sh
