#!/bin/bash                                                                
# https://gist.githubusercontent.com/ikbear/56b28f5ecaed76ebb0ca/raw/27561527483fb18399fb5d558dc55dd4c4839ed3/idle.sh

echo "This is a idle script (infinite loop) to keep container running."    
                                                                           
cleanup ()                                                                 
{                                                                          
  kill -s SIGTERM $!                                                         
  exit 0                                                                     
}                                                                          
                                                                           
trap cleanup SIGINT SIGTERM                                                
                                                                           
while [ 1 ]                                                                
do                                                                         
  sleep 60 &                                                             
  wait $!                                                                
done
