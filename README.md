# Installation
```
git clone https://github.com/wd8rde/scan-wspr.git
cd scan-wspr
./install.sh
sudo reboot
```

# scan_wspr
Scripts to use rtlsd-wspr to scan a list of frequecies as report spots
scan_wspr.sh provides a bash shell script which will envoke rtlsdr-wspr on a list of frequencies for a given number of iterations. This allows a single RTL device to be used to scan more than one band for WSPR Spots.
```
   scan_wspr OPTIONS freq1 ... freqn
      Recieve WSPR transmissions on frequencies, and report them to http://wsprnet.org .
      Frequencies must be in Hz.

   OPTIONS:
      -c --callsign  Amatuer callsign that will report spots.
      -l --locator   Grid locator of this receiver.
      -i --iterations Number of spotting iterations per band.
      -h --help      This help.
```
# run-scan-wspr
Launches, and configures scan_wspr. Redirects stdout and stderr to a logging file. This logging file is rotated by the /etc/logrotate.d/scn_wspr configuration file.
The frequencies, and other scan_wspr arguments may be changed by modifing the line:
```
/home/pi/scan_wspr.sh -c WD8RDE -l EM69sr -i 3 1836600 3592600 7038600 14095600  28124600
```
