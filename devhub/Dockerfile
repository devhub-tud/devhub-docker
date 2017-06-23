FROM maven:3.5.0-jdk-8

MAINTAINER Jan-Willem Gmelig Meyling "j.gmeligmeyling@student.tudelft.nl"

RUN git clone --recursive https://github.com/devhub-tud/devhub.git && \
  cd devhub && \
  mvn package -B -DskipTests && \
  cp -R target/devhub-server-distribution/devhub-server /opt/devhub-server && \
  mkdir /opt/git-server/mirrors

COPY devhub-server.properties /opt/devhub-server/config/config.properties
COPY devhub-persistence.properties /opt/devhub-server/config/persistence.properties

EXPOSE 8080

VOLUME /opt/devhub-server/storage

ENTRYPOINT java -jar /opt/devhub-server/devhub-server.jar
