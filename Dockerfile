FROM maven:3.9-eclipse-temurin-17-alpine as build
COPY . /app
WORKDIR /app
RUN mvn clean package -DskipTests


FROM eclipse-temurin:17-jre-alpine
LABEL author="Viswanath"
LABEL project="Spring-Pet-Clinic"
RUN mkdir -p /usr/share/spc && \
    adduser -D -h /usr/share/spc -s /bin/sh spc && \
    chown -R spc:spc /usr/share/spc
USER spc
WORKDIR /usr/share/spc
COPY --from=build --chown=spc:spc /app/target/*.jar app.jar
EXPOSE 8080/tcp
ENTRYPOINT  ["java", "-jar", "app.jar"]
