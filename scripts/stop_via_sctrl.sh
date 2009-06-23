#! /bin/sh
# File:     stop_via_sctrl.sh
# Purpose:  Generic script to stop a BSCS SOI server via "server control"
# Author:   J. Karlinger
#
# Note: This scripts is currently only working in a UNIX environment, 
# as requirement for this script is to be started from Supervisor

#u
#u USAGE:        stop_via_sctrl.sh
#u 
#u REQUIREMENTS: Following env vars are mandatory:
#u               - MNAME (module name)
#u               - SVAPPLINDEX (application index, by Supervisor)
#u               - SOISRV_HOST 
#u               - SOISRV_PORT 
#u 
#u EXAMPLE:      stop_via_sctrl.sh 
#u 


NAMESPACE_ROOT="com/lhs/private/soi"

if [ $# -ne 0 ] ; then
        grep "^#u" $0 | sed -e "s/^#u//"
        exit 1
fi

# ensure MNAME was there
if [ ! -n "${MNAME}" ];
then
  grep "^#u" $0 | sed -e "s/^#u//"
  exit 1
else
  MODULE="$MNAME"
fi

# ensure SVAPPLINDEX was there
if [ ! -n "${SVAPPLINDEX}" ];
then
  grep "^#u" $0 | sed -e "s/^#u//"
  exit 1
else
  APPLINDEX="$SVAPPLINDEX"
fi

# take content from $BSCS_PROC or use default if not set
if [ ! -n "${BSCS_PROC}" ];
then
echo "TERMINATE" > "$BSCS_LOG/proc/$SOISRV_HOST""_""$SOISRV_PORT/$NAMESPACE_ROOT/$MODULE/$HOSTNAME/$APPLINDEX/control"
else
echo "TERMINATE" > "$BSCS_PROC/$SOISRV_HOST""_""$SOISRV_PORT/$NAMESPACE_ROOT/$MODULE/$HOSTNAME/$APPLINDEX/control"
fi

