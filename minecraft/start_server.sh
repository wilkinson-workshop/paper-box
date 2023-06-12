#!/bin/sh

java \
    -Xms${JAVA_RUNTIME_XMS} \
    -Xmx${JAVA_RUNTIME_XMX} \
    -jar /opt/jars/paper*.jar \
    --nogui
