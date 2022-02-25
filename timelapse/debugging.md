In case there is a problem where you suspect ffmpeg might not be installed, 
replace the code in the doffpmeg.sh (updating the path to the debugoutput.txt
file as necessary)

\#!/usr/bin/bash
ffmpeg --help >> /config/debugoutput.txt