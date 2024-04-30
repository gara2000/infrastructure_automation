#!/bin/bash

DIRNAME=$(dirname $0)
cd $DIRNAME

HOST=$(./get_ip.sh)
PORT=8080
echo "==== Curling the Home page ===="
curl "http://$HOST:$PORT"

echo "==== Making a prediction ===="
# POST method predict
curl -d '{  
   "CHAS":{  
      "0":0
   },
   "RM":{  
      "0":6.575
   },
   "TAX":{  
      "0":296.0
   },
   "PTRATIO":{  
      "0":15.3
   },
   "B":{  
      "0":396.9
   },
   "LSTAT":{  
      "0":4.98
   }
}'\
     -H "Content-Type: application/json" \
     -X POST http://$HOST:$PORT/predict