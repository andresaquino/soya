#! /bin/sh
##
## Check and set mandatory parameters
##

ALLARGS=$@
APPNAME="billsrv"
NAMESPACE_ROOT="com/lhs/private/soi"
APPIDX_EXT="-ApplIndex 0"
APPNUM=0
SECURITY_SWITCH=""

##
## Evaluation of environment variables and script command line parameter
##

if [ -n "$SVAPPLINDEX" ]
    then
        APPIDX_EXT="-ApplIndex ${SVAPPLINDEX}"
        APPNUM=${SVAPPLINDEX}
fi


if [ -n "$BSCS_RESOURCE" ]
    then
        RESOURCE_ROOT="$BSCS_RESOURCE"
else
        RESOURCE_ROOT="$MPDE_ROOT/src/billsrv/resource"
fi


if [ -n "$SOISRV_HOST" ]
    then
        NAMESRV_HOST=${SOISRV_HOST}
else
        NAMESRV_HOST=${HOSTNAME}
fi


##
## Extract some values to be used e.g. in Naming Service
##
## Some command line parameter overrule environment variable
##
while [ $# -gt 0 ]
  do
    if [ -n "${1}" -a -n "${2}" ]
        then
            if [ "-appname" = ${1} ]
                then APPNAME=${2}
            fi
            if [ "-port" = ${1} ]
                then SOISRV_PORT=${2}
            fi
            if [ "-naminghost" = ${1} ]
                then NAMESRV_HOST=${2}
            fi
            if [ "-UseSecurity" = ${1} ]
                then SECURITY_SWITCH="1"
            fi
            if [ "-ApplIndex" = ${1} ]
                then APPIDX_EXT=""; APPNUM=${2}
            fi
    fi
  shift
done

##
## USE_DEBUG is set => Security is switched OFF per default, if not specified
##
## USE_DEBUG is NOT set => Security is switched ON per default, if not specified
##
if [ "${SECURITY_SWITCH}" = "" ]
    then
        if [ "${USE_DEBUG}" = "1" ]
            then
            ALLARGS="${ALLARGS} -UseSecurity false"
        else
            ALLARGS="${ALLARGS} -UseSecurity true"
        fi
fi


##
## If environment variable is set use it, otherwise use unique user id
##
if [ -n "$SOISRV_PORT" ]
    then
                PORT="$SOISRV_PORT"
    else
                PORT=${UID}
fi

##
## Build name from common part + applname + applnum
##
if [ -n "$SOI_NAMEING" ]
    then
                SOI_NAMEING="${SOI_NAMEING}/${APPNAME}/${HOSTNAME}/${APPNUM}"
    else
                SOI_NAMEING="${APPNAME}/${HOSTNAME}/${APPNUM}"
fi

##
## If environment variable is set, use it otherwise use default
##

SOISRV_REGDIR="$RESOURCE_ROOT/billsrv"


##
## If environment variable is set, use it otherwise use default
##
if [ -n "$TAO_SVCCONF" ]
    then
                TAO_SVCCONF="${TAO_SVCCONF}"
    else
        if [ -n "$BSCS_RESOURCE" ]
            then
            TAO_SVCCONF="$BSCS_RESOURCE/svc.conf"
        else
            TAO_SVCCONF="$RESOURCE_ROOT/billsrv/svc.conf"
        fi
fi

##
## Use this setting only, if a firewall exists between BILLSRV and FedFactory or JCIL.
## Uncomment and define a port number. Open the port in the firewall.
##
## BILLSRV_PORT=<port number>
## ORBSERVERPORT="-ORBEndPoint iiop://"${HOSTNAME}:${BILLSRV_PORT}

##
## SOP feature needs SVAPPLINDEX and SVAPPLHOST name
##
if [ -n "$SVAPPLINDEX" ];
then
    CMD_OPT="-SVAPPLINDEX $SVAPPLINDEX"
fi

if [ -n "$SVAPPLHOST" ];
then
    # SOP feature.
    CMD_OPT="$CMD_OPT -SVAPPLHOST $SVAPPLHOST"
fi

##
## Output to screen
##
echo "Start Billing Server with "${ORBSERVERPORT}" -ORBInitRef NameService=corbaloc:iiop:${NAMESRV_HOST}:${PORT}/NameService -SOINamingRoot ${NAMESPACE_ROOT} -SOINaming ${SOI_NAMEING} -ORBSvcConf ${TAO_SVCCONF} -Component billsrv ${APPIDX_EXT} ${CMD_OPT} ${ALLARGS} "


##
## Start with additional parameters
##
exec billsrv ${ORBSERVERPORT} -ORBInitRef NameService=corbaloc:iiop:${NAMESRV_HOST}:${PORT}/NameService -SOINamingRoot ${NAMESPACE_ROOT} -SOINaming ${SOI_NAMEING} -ORBSvcConf ${TAO_SVCCONF} -Component billsrv ${APPIDX_EXT} ${CMD_OPT} ${ALLARGS}
