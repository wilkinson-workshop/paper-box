#!/bin/sh

JAVA_MODULES=`java -p velocity*.jar --list-modules | grep -v "file" | sed 's/@19.*/,/g' | awk '{print}' ORS='' | awk '{print substr($0, 1, length($0)-1)}'`

jlink \
    --module-path "$JAVA_HOME/jmods" \
    --add-modules $JAVA_MODULES \
    --verbose \
    --strip-debug \
    --compress 2 \
    --no-header-files \
    --no-man-pages \
    --output /opt/jre-minimal
