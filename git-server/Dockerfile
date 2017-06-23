FROM maven:3.5.0-jdk-8

MAINTAINER Jan-Willem Gmelig Meyling "j.gmeligmeyling@student.tudelft.nl"

RUN git clone https://github.com/devhub-tud/git-server.git && \
  cd git-server && \
  mvn package -B -DskipTests && \
  cp -R git-server/target/git-server-distribution/git-server /opt/git-server && \
  mkdir /opt/git-server/mirrors

COPY git-server.properties /opt/git-server/config/config.properties

VOLUME /opt/git-server/repositories
VOLUME /opt/git-server/mirrors
EXPOSE 8081

ENTRYPOINT java -jar /opt/git-server/git-server.jar
