#!/bin/sh

# ##############################################################################
#
#                         Copy DaTA Queues on Failover
#                     
# This script just comes with a simple example of moving DaTA queues using the
# mv-command. That may be adapted to the needs of the indiviual installation.
#
# ##############################################################################


#echo "#### >>>> START COPYING DATA QUEUES ..."

# 
# move queues
#
mv -f $COUNTERPART_DATA_SERVER_WORKDIR/QUEUES $DATA_SERVER_WORKDIR/QUEUES.001
RETURN_CODE=$?
if [ 0 != $RETURN_CODE ]; then
  exit 1;
fi

#
# create new /QUEUES directory
#
mkdir $COUNTERPART_DATA_SERVER_WORKDIR/QUEUES
RETURN_CODE=$?
if [ 0 != $RETURN_CODE ]; then
  exit 1;
fi

#echo "#### >>>> ... COPYING DATA QUEUES DONE"

exit $RETURN_CODE;
