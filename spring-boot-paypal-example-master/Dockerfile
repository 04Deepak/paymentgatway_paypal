# Stage 1: Build the Maven project
FROM maven:3.8-openjdk-8 AS builder

WORKDIR /app

# Copy the pom.xml file from the subdirectory
COPY spring-paypal-example/pom.xml .

RUN mvn dependency:go-offline

# Copy the source code from the subdirectory
COPY spring-paypal-example/src ./src

# Package the application
RUN mvn package -DskipTests

# Stage 2: Create the final lightweight runtime image
FROM openjdk:8-jre-slim

WORKDIR /app

# Copy the built JAR from the correct target folder
COPY --from=builder /app/target/spring-paypal-example-0.0.1-SNAPSHOT.jar app.jar

EXPOSE 9090

ENTRYPOINT ["java", "-jar", "app.jar"]
