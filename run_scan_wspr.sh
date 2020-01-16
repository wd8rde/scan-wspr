#!/bin/bash
trap sighandler 1 2 3 6 9 15
sighandler () {
   if [ -z $CHILD ]; then
      kill -9 $CHILD
   fi
}
echo "Starting scan_wspr.sh, logging to /home/pi/scan-wspr/log/scan_wspr.log"
mkdir -p /home/pi/scan-wspr/log/

#source config variables
. /home/pi/scan-wspr/scan_wspr.conf

/home/pi/scan-wspr/scan_wspr.sh -c "$CALL" -l "$GRID" -i "$ITER" $FREQLIST >> /home/pi/scan-wspr/log/scan_wspr.log 2>&1 &
CHILD=$!
