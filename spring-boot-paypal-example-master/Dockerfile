# Step 1: Use Maven with JDK 8 to build the application
FROM maven:3.8.7-openjdk-8 AS build
WORKDIR /app

# Copy pom.xml and download dependencies (for faster caching)
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copy the entire project and build it
COPY src ./src
RUN mvn clean package -DskipTests

# Step 2: Use lightweight JDK image for running the app
FROM openjdk:8-jre-alpine
WORKDIR /app

# Copy the JAR file from the build stage
COPY --from=build /app/target/*.jar app.jar

# Expose application port (default Spring Boot port)
EXPOSE 9090

# Start the application
ENTRYPOINT ["java", "-jar", "app.jar"]
