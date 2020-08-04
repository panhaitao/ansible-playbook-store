#!/bin/sh
{{ hostvars[groups[master_group][0]].join_command }}
