#!/bin/bash

#This script is to set a background for i3lock

DIR=$HOME"/Pictures"

if [ ! -f $DIR/wallpp.png ]
then
    gnome-screenshot -f $DIR/wallpp.png
    convert -resize 10% $DIR/wallpp.png $DIR/wallpp.png
    convert -resize 1000% $DIR/wallpp.png $DIR/wallpp.png
else
    rm $DIR/wallpp.png
    gnome-screenshot -f $DIR/wallpp.png
    convert -resize 10% $DIR/wallpp.png $DIR/wallpp.png
    convert -resize 1000% $DIR/wallpp.png $DIR/wallpp.png

fi

i3lock -i $DIR/wallpp.png
