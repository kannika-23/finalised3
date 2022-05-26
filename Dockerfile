FROM maven:3.8.1-openjdk-17-slim  AS mvnbuild
WORKDIR ./
COPY src /project/src
COPY pom.xml /project
RUN mvn -file /project/pom.xml clean package -Dmaven.test.skip

FROM eclipse-temurin:17-jre-alpine
WORKDIR ./
COPY --from=mvnbuild /project/target/process-pension-executable.jar ./
EXPOSE 8100
ENTRYPOINT ["java","-jar","process-pension-executable.jar","-Dspring.config.additional-location=/application.yml"]