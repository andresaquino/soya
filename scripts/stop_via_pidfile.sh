#! /bin/sh
# File:     stop_via_pidfile.sh
# Purpose:  Generic script to stop a BSCS Module by removing its pidfile
# Author:   J. Karlinger
#
# Note: This scripts is currently only working in a UNIX environment, 
# as our windows modules don't support a PID file.

#u
#u USAGE:        stop_via_pidfile.sh
#u 
#u REQUIREMENTS: Following env vars are mandatory:
#u               - $MNAME (modulename, case sensitive)
#u               - $PIDFILEDIR (the PID file directory, case sensitive)
#u               - $SVPID (set to the Process ID e.g. by SUPERVISOR)
#u               - $PIDFILEEXT (file suffix) e.g. ".IND")
#u 
#u 

if [ $# -ne 0 ] ; then
        grep "^#u" $0 | sed -e "s/^#u//"
        exit 1
fi

# ensure that only the correct PIDFILE is deleted, avoid "catch all"
if [ -n "${SVPID}" ]
then 
  PID="$SVPID"
else    
  PID="00000"
fi

# ensure MNAME was there
if [ ! -n "${MNAME}" ];
then
  grep "^#u" $0 | sed -e "s/^#u//"
  exit 1
else
  MODULE="$MNAME"
fi

# ensure PIDFILEDIR was there
if [ ! -n "${PIDFILEDIR}" ];
then
  grep "^#u" $0 | sed -e "s/^#u//"
  exit 1
else
  PIFIDI="$PIDFILEDIR"
fi

# ensure PIDFILEEXT was there
if [ ! -n "${PIDFILEEXT}" ];
then
  grep "^#u" $0 | sed -e "s/^#u//"
  exit 1
else
  SUFFIX="$PIDFILEEXT"
fi


find "$PIFIDI/" -name "*$MODULE*$PID*$SUFFIX" | xargs rm -f