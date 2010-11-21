#!/bin/sh 
# vim: set ts=3 sw=3 sts=3 et si ai: 
# 
# apptest.sh 
# =-=
# Andres Aquino <andres.aquino@gmail.com>
#

echo "WORM TEST"
cuteworm=0

while(true)
do
   sleep 1
   echo "wake up little little worm 1 - (`date`) "
   [ $cuteworm -eq 5  ] && echo "ujuu little little worm you're RUNNING OK"
   [ $cuteworm -gt 800  ] && break
   cuteworm=$(($cuteworm+1))
done

#
