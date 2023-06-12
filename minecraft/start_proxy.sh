#!/bin/sh

java \
    -Xms${JAVA_RUNTIME_XMS} \
    -Xmx${JAVA_RUNTIME_XMX} \
    -XX:+UseG1GC \
    -XX:G1HeapRegionSize=4M \
    -XX:+UnlockExperimentalVMOptions \
    -XX:+ParallelRefProcEnabled \
    -XX:+AlwaysPreTouch \
    -XX:MaxInlineLevel=15 \
    -jar /opt/jars/velocity*.jar
