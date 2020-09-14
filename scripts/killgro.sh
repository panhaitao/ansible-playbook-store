#!/bin/bash
ps -ef |grep gobench |awk -F ' ' '{print $2}' |xargs kill -9
