#!/bin/bash

DIRNAME=$(dirname $0)
cd $DIRNAME/..

awk -F'@' '{print $2}' ansible/etc/hosts