#! /bin/sh
#  Dieter Schneiders
#  (C) LHS Telekom GmbH & Co. KG, 2005. All rights reserved
#u
#u ------------------------------------------------------------------------
#u
#u  killNamingService.sh - kills all TAO Naming Service(s) owned by $LOGNAME.
#u
#u
#u     Synopsis: 
#u             killNamingService.sh
#u
#u ------------------------------------------------------------------------
#u
if [ "$1" = "-h" ];
then
    grep "^#u" $0 | sed -e "s/^#u//"
    exit 1
fi 

PIDS=`ps -fe`
PIDS=`echo "$PIDS" | grep -e $LOGNAME | awk -F" " '/Naming_Service/ {print $2}'`

if [ "" = "$PIDS" ];
then
    echo "\\n No Naming Service left to kill.\\n"
    exit 1
fi 

echo "\\n About to kill" $PIDS
kill $PIDS
echo "\\n" $PIDS "killed.\\n"