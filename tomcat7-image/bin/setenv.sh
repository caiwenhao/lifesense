#!/usr/bin/env bash

if [ "${TingYun}" = 'true' ]; then
  TingYun="-javaagent:/usr/local/tomcat/tingyun/tingyun-agent-java.jar"
else
  TingYun=""
fi

if [ -z "$DISCONF_ENV" ]; then
    DISCONF_OPTS="-Ddisconf.env=local"
    OPTS="$OPTS -Dlog.level=debug"
else
    DISCONF_OPTS="-Ddisconf.env=$DISCONF_ENV"
fi

if [ "$DISCONF_ENV" = 'online' ] ; then
    JAVA_OPTS="-server -Xms100m -Xmx2048m -Xmn600m -Xss256k -XX:MetaspaceSize=10m -XX:MaxMetaspaceSize=256m -Duser.timezone=Asia/Shanghai -Dfile.encoding=UTF-8"
    sed -i 's/acceptCount="1024"/acceptCount="4096"/g' /usr/local/tomcat/conf/server.xml
else
    if [ "$DISCONF_ENV" = 'local' ] || [ "$DISCONF_ENV" = 'qa' ]; then
        OPTS="$OPTS -Dlog.level=debug"
    fi
    sed -i 's/512/125/g' /usr/local/tomcat/conf/server.xml
    JAVA_OPTS="-server -Xms100m -Xmx1024m -Xmn300m -Xss256k -XX:MetaspaceSize=10m -XX:MaxMetaspaceSize=256m -Duser.timezone=Asia/Shanghai -Dfile.encoding=UTF-8"
fi

OPTS="$OPTS -Dops.hostname=$HOSTNAME"
JAVA_OPTS="${JAVA_OPTS} ${DISCONF_OPTS} ${TingYun} ${OPTS} -XX:+UseCMSCompactAtFullCollection -XX:CMSFullGCsBeforeCompaction=0 -XX:SurvivorRatio=1 -XX:+UseConcMarkSweepGC -XX:+CMSParallelRemarkEnabled -XX:+UseFastAccessorMethods -XX:CMSInitiatingOccupancyFraction=70 -XX:SoftRefLRUPolicyMSPerMB=0 -XX:+UseParNewGC"
cd - >/dev/null 2>&1