#!/bin/bash
trap sighandler 1 2 3 6 15

ITER=1
POSITIONAL=()
while [[ $# -gt 0 ]]; do
key="$1"

case $key in
    -l|--locator)
    LOCATOR="$2"
    shift # past argument
    shift # past value
    ;;
    -c|--callsign)
    CALLSIGN="$2"
    shift # past argument
    shift # past value
    ;;
    -i|--iterations)
    ITER="$2"
    shift # past argument
    shift # past value
    ;;
    -h|--help)
    HELP=YES
    shift # past argument
    ;;
    *)    # unknown option
    POSITIONAL+=("$1") # save it in an array for later
    shift # past argument
    ;;
esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

# remaining arguments are all frequencies
FREQLIST="$@"

#
#check arguments
#
for F in $FREQLIST; do
   if (( 1836599 > $F )) || ((144488500 < $F)) ; then
      echo "Frequency $F is not valid"
      HELP=YES
   fi
done
if [ -z ${CALLSIGN+x} ]; then
   echo "Callsign argument is required"
   HELP=YES
fi
if [ -z ${LOCATOR+x} ]; then
   echo "Grid locator argument is required"
   HELP=YES
fi

#
# do help
#
if [ "$HELP" == "YES" ]; then
   echo "`basename $0` OPTIONS freq1 ... freqn"
   echo "   Recieve WSPR transmissions on frequencies, and report them to http://wsprnet.org ."
   echo "   Frequencies must be in Hz."
   echo ""
   echo "OPTIONS:"
   echo "   -c --callsign  Amatuer callsign that will report spots."
   echo "   -l --locator   Grid locator of this receiver."
   echo "   -i --iterations Number of spotting iterations per band."
   echo "   -h --help      This help."
   exit 1
fi

CHILD=
#
# Signal trap handler
#
sighandler () {
   echo "Caught Signal, exiting"
   if [ ! -z "$CHILD" ]; then
      echo "Killing child process $CHILD"
      kill -9 "$CHILD"
   fi
   exit 1
}

#
# call rtlsdr_wspr
#
do_wspr () {
   FR="$1"
   CL="$2"
   GL="$3"
   ITR="$4"
   DS="0"
   GAIN="29"
   WSPRD="/usr/local/bin/rtlsdr_wsprd"

   if (( 24000000 > $FR )); then
      DS="2"
   fi

   echo "--------------------------------------------------------------------"
   date
   CMD="$WSPRD -d $DS -f $FR -c $CL -l $GL -n $ITR -g $GAIN"
   echo "$CMD"
   $CMD &
   CHILD=$!
   wait $CHILD
}

#
# main
#
while true; do
   for FREQ in $FREQLIST; do
      do_wspr "$FREQ" "$CALLSIGN" "$LOCATOR" "$ITER"
   done
   sleep 20
done

