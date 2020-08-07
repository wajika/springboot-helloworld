FROM relateiq/oracle-java8

ENV MAVEN_VERSION 3.2.5

RUN curl -sSL http://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz | tar xzf - -C /usr/share \
  && mv /usr/share/apache-maven-$MAVEN_VERSION /usr/share/maven \
  && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

ENV MAVEN_HOME /usr/share/maven
ENV JAVA_OPTS="-javaagent:/data/springboot-helloworld/elastic-apm-agent-1.18.0.RC1.jar -Delastic.apm.service_name=springboot -Delastic.apm.application_packages=org.example,org.another.example -Delastic.apm.server_urls=http://192.168.10.145:8200"

COPY . /data/springboot-helloworld
WORKDIR /data/springboot-helloworld

RUN ["mvn", "clean", "install"]

EXPOSE 8080

#CMD ["java", "-javaagent:/data/springboot-helloworld/elastic-apm-agent-1.18.0.RC1.jar -Delastic.apm.service_name=springboot -Delastic.apm.application_packages=org.example,org.another.example -Delastic.apm.server_urls=http://192.168.10.145:8200 -jar", "target/helloworld-0.0.1-SNAPSHOT.jar"]
#CMD ["java", "-jar", "target/helloworld-0.0.1-SNAPSHOT.jar"]

ENTRYPOINT exec java $JAVA_OPTS -jar "target/helloworld-0.0.1-SNAPSHOT.jar"
