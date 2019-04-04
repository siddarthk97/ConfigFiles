#!/bin/sh

#This script is to set a background for i3lock

DIR=$HOME"/Pictures/lock"

if [ ! -f $DIR/wallpp.png ]
then
    deepin-screenshot -f 
    mv $DIR/Deep* $DIR/wallpp.png
    #convert -resize 10% $DIR/wallpp.png $DIR/wallpp.png
    #convert -resize 1000% $DIR/wallpp.png $DIR/wallpp.png
else
    rm $DIR/wallpp.png
    deepin-screenshot -f 
    mv $DIR/Deep* $DIR/wallpp.png
    #convert -resize 10% $DIR/wallpp.png $DIR/wallpp.png
    #convert -resize 1000% $DIR/wallpp.png $DIR/wallpp.png

fi

i3lock -i $DIR/wallpp.png
