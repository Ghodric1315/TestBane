#!/bin/bash

search=$(ps --pid `cat logs/world.pid` -o comm=)

LIB=build/bin/magicbane.jar

if [ $search ]
        then
                echo "Exit - server is already running"
		exit 1
        else
                echo $$ > logs/world.pid
fi

# Check that configuration is present

if [ -z "$MB_WORLD_NAME" ]; then

if test -f "mb.conf/magicbane.conf"; then
    CONFIGFILE="mb.conf/magicbane.conf"
   else
    CONFIGFILE="mb.data/magicbane.conf"
fi

echo Configure using $CONFIGFILE

set -a
. $CONFIGFILE
set +a

fi

if [ "$1" == "-debug" ]
	then
        exec java -server -agentlib:jdwp=transport=dt_socket,server=y,suspend=y,address=5000 -cp "$CLASSPATH":"$LIB" engine.server.world.WorldServer
fi

if [ "$1" == "-profile" ]
	then
        exec java -server -agentpath:/home/mbbox/YourKit/bin/linux-x86-64/libyjpagent.so=port=5000 -cp "$CLASSPATH":"$LIB" engine.server.world.WorldServer
fi

if [ "$1" == "" ]
        then
        exec java -server -cp "$CLASSPATH":"$LIB" engine.server.world.WorldServer
fi

