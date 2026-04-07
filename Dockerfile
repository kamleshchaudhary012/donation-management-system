# Stage 1: Build
FROM maven:3.9.6-eclipse-temurin-17 AS builder

WORKDIR /app
COPY . .

RUN mvn clean package

# Stage 2: Run Tomcat
FROM tomcat:10.1-jdk17

RUN rm -rf /usr/local/tomcat/webapps/*

COPY --from=builder /app/target/*.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080

# FROM tomcat:9.0

# RUN rm -rf /usr/local/tomcat/webapps/*

# COPY target/*.war /usr/local/tomcat/webapps/ROOT.war

# EXPOSE 8080
# CMD ["catalina.sh", "run"]