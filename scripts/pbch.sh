echo "pbch.sh was started with parameters: $*"

NUM_BCH=1
ARGS=""
RESULT=0

# feature 281754: BEGIN
#while getopts "n:h\?d:b:P:D:M:S:R:C:" name
while getopts "n:h\?d:b:P:D:M:S:R:C:U:" name
# feature 281754: END
do 
    echo $name;
    case $name in 
      n) NUM_BCH=$OPTARG;;
      C) CONT_BILLREQ=$OPTARG; ARGS="$ARGS -$name$OPTARG ";;
      b) BC=$OPTARG; ARGS="$ARGS -$name$OPTARG ";;
      h|\?) ARGS="-h";;
# feature 281754: BEGIN
#      d|P|D|M|S|R) ARGS="$ARGS -$name$OPTARG ";;
      d|P|D|M|S|R|U) ARGS="$ARGS -$name$OPTARG ";;
# feature 281754: END
      *) echo "Invalid parameter $name"; ARGS="-h"; break;;
    esac;
done

case $ARGS in 

*-b*)
    # check write permissions for file with bill sequence number
    BSN_DIR="/tmp"
    export BSN_FILE="$BSN_DIR/LastBSN.txt"
    if test ! -d $BSN_DIR; then
        echo "$BSN_DIR directory does not exist!"
        exit 1
    else 
        if   test ! -w $BSN_DIR; then
            echo "Write permissions on $BSN_DIR directory required!"
            exit 2
        fi
    fi 

    # start packaging BCH instance
    echo "Start bill cycle run for bill cycle $BC"
    echo "Create customer packages for bill cycle with: bch -Apo $ARGS"
    bch -Apo $ARGS
    RESULT=$?
    if [ 0 -ne "$RESULT" ]; then
        echo "Package generation failed!"
        exit 3
    fi

    # extract bill sequence number from fle
    if test -f $BSN_FILE; then
        BILLSEQNO=`cat $BSN_FILE`
    else
        echo "Cannot retrieve bill sequence number"
        exit 4
    fi

    # start BCH instances for billing request
    echo "Start $NUM_BCH instances for billing request $BILLSEQNO with: bch -r $BILLSEQNO"
    ITER=1
    while [ "$ITER" -le "$NUM_BCH" ]
    do
        echo "Start $ITER. BCH instance"
        bch -r $BILLSEQNO &
        ITER=`expr $ITER + 1`
    done

    # reset file name for storing bill sequence number
    rm $BSN_FILE
    unset BSN_FILE
    unset BILLSEQNO

    exit 0
    ;;

*-C*)
    # check write permissions for file with bill sequence number
    BSN_DIR="/tmp"
    export BSN_FILE="$BSN_DIR/LastBSN.txt"
    if test ! -d $BSN_DIR; then
        echo "$BSN_DIR directory does not exist!"
        exit 1
    else 
        if   test ! -w $BSN_DIR; then
            echo "Write permissions on $BSN_DIR directory required!"
            exit 2
        fi
    fi 

    # start packaging BCH instance
    echo "Start BCH instance for repackaging of bill request $CONT_BILLREQ"
    echo "ReCreate customer packages for bill request with: bch -C $CONT_BILLREQ"
    bch -C $CONT_BILLREQ

    RESULT=$?
    if [ 0 -ne "$RESULT" ]; then
        echo "Package generation failed!"
        exit 3
    fi

    # extract bill sequence number from fle
    if test -f $BSN_FILE; then
        BILLSEQNO=`cat $BSN_FILE`
    else
        echo "Cannot retrieve bill sequence number"
        exit 4
    fi

    # start BCH instances for billing request
    echo "Start $NUM_BCH instances for billing request $BILLSEQNO with: bch -r $BILLSEQNO"
    ITER=1
    while [ "$ITER" -le "$NUM_BCH" ]
    do
        echo "Start $ITER. BCH instance"
        bch -r $BILLSEQNO &
        ITER=`expr $ITER + 1`
    done

    # reset file name for storing bill sequence number
    rm $BSN_FILE
    unset BSN_FILE
    unset BILLSEQNO

    exit 0
    ;;

*)
    echo "Valid options"
    echo "-? List all valid options "
    echo "-h List all valid options "
    echo "-n Number of BCH instances to be started for bill cycle billing "
    echo "-d Reference data store: 'db'   = database (default)"
    echo "                         'xref' = XREF files"
    echo "                         'shm' = shared memory"
    echo "-b Bill cycle "
    echo "-P Posting Period (format YYYYMM) "
    echo "-D Due date (format YYYYMMDD) "
# feature 281754: BEGIN
#    echo "-M Billing mode: 'real', 'sim' (simulation) or 'inf' (information) "
#    echo "-S Virtual start date (format YYYY-MM-DD:hh:mm:ss) "
    echo "-M Billing mode: 'real', 'sim' (simulation), 'inf' (information) or 'accrual' "
    echo "-U Unbilled accrual start date (in accrual mode) (format YYYYMMDD) "
    echo "-S Virtual start date (format YYYY-MM-DD:hh:mm:ss) [accrual end date in accrual mode]"
# feature 281754: END
    echo "-C Continue (restart) <BillRequestNumber> "
    exit 0
    ;;

esac
