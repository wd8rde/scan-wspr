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

if [ "$GRID"x == "x" ]; then
	echo "Please edit /home/pi/scan-wspr/scan_wspr.conf and set GRID"
	exit 1
fi

if [ "$CALL"x == "x" ]; then
	echo "Please edit /home/pi/scan-wspr/scan_wspr.conf and set CALL"
	exit 2
fi

/home/pi/scan-wspr/scan_wspr.sh -c "$CALL" -l "$GRID" -i "$ITER" $FREQLIST $ARGS >> /home/pi/scan-wspr/log/scan_wspr.log 2>&1 &
CHILD=$!
