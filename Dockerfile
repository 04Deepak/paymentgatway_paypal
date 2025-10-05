# Stage 1: Build the Maven project
# Use a Maven image that includes JDK 8, which matches your pom.xml <java.version>
FROM maven:3.8-openjdk-8 AS builder

# Set the working directory inside the container
WORKDIR /app

# Copy the pom.xml file to leverage Docker's layer caching
# This step will only be re-run if the pom.xml changes
COPY pom.xml .

# Download all the dependencies defined in the pom.xml
RUN mvn dependency:go-offline

# Copy the rest of your application's source code
COPY src ./src

# Package the application, skipping the tests.
# This will create the JAR file in the /app/target/ directory.
RUN mvn package -DskipTests

# Stage 2: Create the final lightweight runtime image
# Use a slim JRE (Java Runtime Environment) image for Java 8
FROM openjdk:8-jre-slim

# Set the working directory for the runtime container
WORKDIR /app

# Copy the executable JAR from the builder stage to the final image.
# The JAR name is derived from your <artifactId> and <version> in pom.xml.
COPY --from=builder /app/target/spring-paypal-example-0.0.1-SNAPSHOT.jar app.jar

# Expose the port the application runs on. The Spring Boot default is 8080.
EXPOSE 9090

# The command to run your application when the container starts
ENTRYPOINT ["java", "-jar", "app.jar"]
