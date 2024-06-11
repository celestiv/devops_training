FROM maven:3.8.6-jdk-8 as build

WORKDIR /app

COPY pom.xml ./pom.xml
COPY src ./src

RUN mvn package

FROM tomcat:8.5

COPY --from=build /app/target/demo.war /usr/local/tomcat/webapps/demo.war

RUN echo "export JAVA_OPTS=\"-Dapp.env=staging \${JAVA_OPTS}\"" >> /usr/local/t$

EXPOSE 8080

CMD ["catalina.sh", "run"]
