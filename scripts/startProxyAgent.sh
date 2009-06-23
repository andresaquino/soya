#! /bin/sh
#  Dieter Schneiders
#  (C) LHS Telekom GmbH & Co. KG, 2006. All rights reserved
#u
#u ------------------------------------------------------------------------
#u
#u  startProxyAgent.sh - starts the SOP Proxy Agent.
#u
#u
#u     Synopsis:
#u             startProxyAgent.sh [<IP address of NamingService> 
#u                                 [<CNS initial context>]]
#u
#u  Description:
#u             If <IP address of NamingService> is omitted, the script
#u             assumes the environment variables $SOISRV_HOST and $SOISRV_PORT
#u             to provide a valid IIOP.
#u
#u             If <CNS initial context> is omitted, the script assumes
#u             'com/lhs/private/sop' as initial context in CORBA Naming
#u             Service, where managed applications are registered below.
#u
#u             The host name must be available via UNIX command 'hostname' 
#u             or environment variable $HOSTNAME in order to support
#u             multiple network interfaces.
#u
#u     Examples:
#              startProxyAgent.sh 
#u             startProxyAgent.sh toronto:10051
#u             startProxyAgent.sh toronto:10051 com/lhs/private/sop/test
#u
#u ------------------------------------------------------------------------    
#u
CMD_OPT="-Component proxyagent"


# Evaluate host (used for machines with multiple network interfaces).
HOST=`hostname`
if [ ! -n "${HOST}" ];
then
    HOST="$HOSTNAME"
    if [ ! -n "${HOST}" ];
    then
	echo "\\n\\n  Could not evaluate hostname for ORBEndpoint option."
	grep "^#u" $0 | sed -e "s/^#u//"
	exit 1
    fi
fi

CMD_OPT="${CMD_OPT} -ORBEndPoint iiop://${HOST}"


# Evaluate port and context.
if [ $# -ne 0 ];
then    
    IIOP=$1
    shift
    if [ $# -ne 0 ];
    then
	CXT=$1
    fi
elif [ -n "$SOISRV_HOST" -a -n "$SOISRV_PORT" ];
then
    IIOP="$SOISRV_HOST:$SOISRV_PORT"
else    
    grep "^#u" $0 | sed -e "s/^#u//"
    exit 1    
fi

if [ ! -n "${CTX}" ];
then	
    CTX="com/lhs/private/sop"
fi

CMD_OPT="${CMD_OPT} -ORBInitRef NameService=corbaloc:iiop:${IIOP}/NameService"
CMD_OPT="${CMD_OPT} -ORBSvcConf $BSCS_RESOURCE/svc.conf"
CMD_OPT="${CMD_OPT} -CNSInitialContext ${CTX}"

echo "\\nStart Proxy Agent"
echo "on       host '${HOST}'" 
echo "against  NamingService '${IIOP}'"
echo "below    initial context '${CTX}'"

exec proxyagent ${CMD_OPT}