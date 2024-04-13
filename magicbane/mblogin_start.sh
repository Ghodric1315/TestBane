#!/bin/bash

LIB=build/bin/magicbane.jar

search=$(ps --pid `cat logs/login.pid` -o comm=)

if [ $search ]
        then
                echo "Exit - server is already running"
		exit 1
        else
                echo $$ > logs/login.pid
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

        exec java -server -agentlib:jdwp=transport=dt_socket,server=y,suspend=y,address=5000,server=y -cp "$CLASSPATH":"$LIB" engine.server.login.LoginServer
	else
	exec java -server -cp "$CLASSPATH":"$LIB" engine.server.login.LoginServer -Djava.awt.headless=true
fi
