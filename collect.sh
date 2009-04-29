#!/bin/sh
COUNT=0
LIMITE=$1
while [ ${COUNT} -le ${LIMITE} ]
do
  sh $HOME/AQUINO/cms.statistics
  sleep 5
  sh $HOME/AQUINO/cms.queue
  sleep 60
  COUNT=$(($COUNT+1))
done

