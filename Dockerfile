# FROM tomcat:7.0
FROM openjdk:8

RUN 	apt update && apt install -y maven
RUN 	mkdir /project
ADD 	. /project
WORKDIR /project

