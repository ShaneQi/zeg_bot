SCRIPT=`readlink -f "$0"`
SCRIPTPATH=`dirname "$SCRIPT"`
PROJPATH=`dirname "$SCRIPTPATH"`
docker run \
-d \
--name zeg_bot \
-v $PROJPATH/:/zeg_bot \
-v /home/shane/persistence/telepost/:/telepost/ \
-w /zeg_bot \
swift:4.1 \
/bin/sh -c \
"\
swift run\
"
