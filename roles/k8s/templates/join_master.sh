#!/bin/sh
{{ hostvars[groups[master_group][0]].join_command }} --experimental-control-plane --certificate-key {{ hostvars[groups[master_group][0]].cert_key }}
