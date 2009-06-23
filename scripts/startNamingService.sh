#! /bin/sh
#  Dieter Schneiders
#  (C) LHS Telekom GmbH & Co. KG, 2005. All rights reserved
#u
#u ------------------------------------------------------------------------
#u
#u  startNamingService.sh - starts the CORBA Naming Service of TAO.
#u
#u
#u     Synopsis: 
#u             startNamingService.sh [<port> [args]]
#u
#u  Description:
#u             [<port> [args]]   Optional command line parameters.
#u
#u             <port>            The mandatory port of the Internet Inter-ORB
#u                               Protocol address of the Naming Service.
#u
#u             [args]            Optional Naming Service properties.
#u      
#u             If [<port> [args]] is omitted, the script assumes the 
#u             environment variable $SOISRV_PORT to provide a valid
#u             port.
#u
#u             The Naming Server runs in persistent mode if -f option
#u             specifies a file name.
#u
#u             The host name must be available via UNIX command 'hostname' 
#u             or environment variable $HOSTNAME in order to support
#u             multiple network interfaces.
#u
#u      Example:
#u             startNamingService.sh 10051 -f NamingService_PersistenceFile
#u
#u ------------------------------------------------------------------------
#u

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

# Evaluate port.
if [ $# -ne 0 ];
then
    PORT=$1
    shift
elif [ -n "$SOISRV_PORT" ];
then
    PORT="$SOISRV_PORT"
else
    echo "\\n\\n  Could not evaluate port for ORBEndpoint option."
    grep "^#u" $0 | sed -e "s/^#u//"
    exit 1    
fi

# Evaluate executable of TAO Naming Service.
if [ ! -x "$ACE_ROOT/bin/Naming_Service" ];
then
    echo "\\n No Naming Service found.\\n"
    exit 1
fi

echo "\\n Start Naming_Service -ORBEndPoint iiop://${HOST}:${PORT} $@"
exec Naming_Service -ORBEndPoint iiop://${HOST}:${PORT} $@
