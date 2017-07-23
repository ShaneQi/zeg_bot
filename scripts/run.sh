docker run \
-d \
--name zeg_bot \
-v `pwd`/:/zeg_bot \
-v /home/shane/persistence/zeg_bot/:/db/ \
-v /home/shane/persistence/telepost/:/telepost/ \
-w /zeg_bot \
swift:3.1.0 \
/bin/sh -c \
"\
apt-get update;\
apt-get install libxml2-dev uuid-dev libsqlite3-dev -y;\
swift build;\
./.build/debug/zeg_bot;\
"
