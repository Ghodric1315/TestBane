#!/bin/bash

# MagicBox : © 2022 Magicbane Project (www.magicbane.com)
# File:      dockerentry.sh
# Purpose:   Entry point for docker image to start services and import
#            'patchings' data.

# reset pid 1
exec $@

# Load config data but use default values
# to get MagicBox running if not found

if test -f "mb.conf/magicbane.conf"; then
    CONFIGFILE="mb.conf/magicbane.conf"
   else
    CONFIGFILE="mb.data/magicbane.conf"
fi

echo Configure using $CONFIGFILE

set -a
. $CONFIGFILE
set +a

# Set default build target
MBBUILD="master"

# Will need the classpath to do anything!

export CLASSPATH=/usr/share/java/*

echo $MB_DATABASE_ADDRESS

if [ $MB_DATABASE_ADDRESS == "localhost" ]; then

# Starup sql if configured to be local

sudo service mysql start

sudo mysql -u root -e "GRANT ALL PRIVILEGES ON *.* TO 'magicbox'@'localhost';"
sudo mysql -u root -e "FLUSH PRIVILEGES;"
sudo mysql -u root -e "SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));"

echo "Looking for patchings..."

# Process 'patchings' db modifications if exists

MBPDIR=( /home/mbbox/magicbane/mb.conf/*.mbp )

if [ -f ${MBPDIR[0]} ]; then
   MBBUILD=$( basename ${MBPDIR[0]} .mbp )
   echo "Processing patchings file: $MBBUILD"
   mysql < ${MBPDIR[0]}
else
   echo "No Patchings file found"
fi

fi

# extract heightmaps (Save on image size)
tar xf mb.data/heightmaps.tar.gz -C mb.data/

# be nice and install nano for them
sudo apt-get -qq install nano

# build target
./mbbuild.sh $MBBUILD

# startup the game
./mbstart.sh &

echo "Magicbane is running!"

# spin spin spin 
# replace with console tail?
sleep infinity
