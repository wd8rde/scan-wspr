#!/bin/bash
trap sighandler 1 2 3 6 9 15
sighandler () {
   if [ -z $CHILD ]; then
      kill -9 $CHILD
   fi
}
echo "Starting scan_wspr.sh, logging to /home/pi/scan_wspr/log/scan_wspr.log"
mkdir -p /home/pi/scan_wspr/log/
/home/pi/scan_wspr.sh -c WD8RDE -l EM69sr -i 3 1836600 3592600 7038600 14095600  28124600 >> /home/pi/scan_wspr/log/scan_wspr.log 2>&1 &
CHILD=$!
