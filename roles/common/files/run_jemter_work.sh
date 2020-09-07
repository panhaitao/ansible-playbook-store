#!/bin/bash
export JAVA_HOME=/home/jdk1.8.0_231
nohup /home/apache-jmeter-5.2.1/bin/jmeter-server &> /tmp/apache-jmeter.log & 
