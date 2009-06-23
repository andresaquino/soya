#! /bin/sh
#
#u
#u
#u      startMMAS.sh - starts the MMAS server with the passed arguments.
#u
#u	Synopsis: 
#u			startMMAS.sh [port]  
#u
#u       The [port] argument can be ommitted if 
#u       env. var SOISRV_PORT contains the port
#u
#u	Example:
#u			startMMAS.sh 14567
#u			startMMAS.sh
#u
#u
 
NAMESPACE_ROOT="com/lhs/private/soi"

APPLINDEX=0
# Evaluate optional application index for the SOP feature from environment.
if [ -n "$SVAPPLINDEX" ];
then 
    CMD_OPT="-SVAPPLINDEX $SVAPPLINDEX"
    APPLINDEX=$SVAPPLINDEX
fi


# Evaluate local hostname (used for machines with multiple network interfaces).
HOST="$SVAPPLHOST"
if [ -n "$HOST" ];
then
    # SOP feature.
    CMD_OPT="$CMD_OPT -SVAPPLHOST $HOST"
else
    HOST=`hostname`
    if [ ! -n "$HOST" ];
    then
	HOST="$HOSTNAME"
	if [ ! -n "$HOST" ];
        then
	    echo "\\n\\n  Could not evaluate hostname for ORBEndpoint."
	    grep "^#u" $0 | sed -e "s/^#u//"
	    exit 1
	fi
    fi
fi

if [ $# -gt 1 ] ; then
        grep "^#u" $0 | sed -e "s/^#u//"
        exit 1
fi

if [ -n "$BSCS_RESOURCE" ]
    then 
        RESOURCE_ROOT="$BSCS_RESOURCE"
else    
        RESOURCE_ROOT="$MPDE_ROOT/resource"
fi

## env var there?
if [ -n "$SOISRV_PORT" ]
    then
    PORT="$SOISRV_PORT"
fi

## how many params? --> assign values
if [ $# -eq 1 ] ; then
	PORT="${1}"
fi

CMD_OPT="$CMD_OPT -ORBEndPoint iiop://$HOST"

# PN 00304118_mmas - CCM - Adapting fix to MMAS script.
# The lines below should be uncommented in case of using a firewall
# MMAS_PORT=<port_number>
# CMD_OPT="$CMD_OPT:$MMAS_PORT"

IIOP="$HOST:$PORT"
SOINaming="mmas/$HOST/$APPLINDEX"

CMD_OPT="$CMD_OPT -ORBInitRef NameService=corbaloc:iiop:${IIOP}/NameService"
CMD_OPT="$CMD_OPT -ORBSvcConf $BSCS_RESOURCE/svc.conf"
CMD_OPT="$CMD_OPT -Component mmas"
CMD_OPT="$CMD_OPT -SOINaming ${SOINaming}"
CMD_OPT="$CMD_OPT -UseSecurity true"

echo "\\nStart MMAS"
echo "with     Application Index '${SVAPPLINDEX}'"
echo "on       host '${HOST}'" 
echo "against  NamingService '${IIOP}'\n"

echo mmas $CMD_OPT
exec mmas $CMD_OPT
