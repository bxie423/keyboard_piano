#!/bin/bash
# keyboard_piano -- plays varying notes depending on the keyboard
# usage: keyboard_piano

# The piano samples used in this program are based off of samples recorded
# by the University of Iowa, found below
# http://theremin.music.uiowa.edu/MIS.html

# Check if mplayer is installed

which mplayer > /dev/null
if [ $? != 0 ]
then
    echo "ERROR: mplayer needs to be installed.  Please do so using your distribution's package manager."
    exit 1
fi

echo "Welcome to the keyboard piano!
The keys q through i correspond to C5 through C6.
The keys a through k correspond to C4 through C5.
The keys z through , correspond to C3 through C4.
In order to play a sharp, simply hold down SHIFT while pressing a note.
In order to exit, press the '\`' (backtick) key.

NOTE:  If this program exits incorrectly, you might need to type 'stty echo' in order to be able to see what you are typing again."

# Turn off screen echo
stty -echo

dir=./samples

# Saving some typing.  Sending errors and output to /dev/null to avoid
# cluttering up the screen
function play_note {
    eval 'mplayer ${dir}/${1}.wav > /dev/null 2>&1 &'
}

# An associative array of keypress-note pairs
declare -A KEYMAP=( ["q"]=C5 ["Q"]=Db5 ["w"]=D5 ["W"]=Eb5 ["e"]=E5 ["r"]=F5 ["R"]=Gb5 ["t"]=G5 ["T"]=Ab5 ["y"]=A5 ["Y"]=Bb5 ["u"]=B5 ["i"]=C6 ["a"]=C4 ["A"]=Db4 ["s"]=D4 ["S"]=Eb4 ["d"]=E4 ["f"]=F4 ["F"]=Gb4 ["g"]=G4 ["G"]=Ab4 ["h"]=A4 ["H"]=Bb4 ["j"]=B4 ["k"]=C5 ["z"]=C3 ["Z"]=Db3 ["x"]=D3 ["X"]=Eb3 ["c"]=E3 ["v"]=F3 ["V"]=Gb3 ["b"]=G3 ["B"]=Ab3 ["n"]=A3 ["N"]=Bb3 ["m"]=B3 [","]=C4 )

# Hopefully this loads every WAV file into memory, eliminating the delay
# that users would experience when they press a note for the first time
for note in "${KEYMAP[@]}"
do
    mplayer -volume 0 ${dir}/${note}.wav > /dev/null 2>&1 &
done

# Most of the magic happens here
while [ "$PRESS" != "\`" ]
do
    read -n 1 PRESS
    play_note ${KEYMAP[$PRESS]}
done

# Turn screen echo back on
stty echo

exit 0
