#!/bin/bash

DIRNAME=$(dirname $0)
cd $DIRNAME

IP=$(./get_ip.sh)
PORT=8080
curl "http://$IP:$PORT"