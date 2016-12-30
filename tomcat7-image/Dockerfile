FROM tomcat:7.0.73-jre8-alpine
MAINTAINER 77749770@qq.com

#RUN rm -rf /usr/local/tomcat/webapps/*
COPY bin/setenv.sh /usr/local/tomcat/bin/
COPY conf/server.xml /usr/local/tomcat/conf/
COPY tingyun /usr/local/tomcat/