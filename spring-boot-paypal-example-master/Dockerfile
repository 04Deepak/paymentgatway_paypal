# Step 1: Use Maven with JDK 8 to build the application
FROM maven:3.8.8-eclipse-temurin-8 AS build
WORKDIR /app

# Copy pom.xml and download dependencies (cached)
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copy the rest of the source code and build
COPY src ./src
RUN mvn clean package -DskipTests

# Step 2: Use a lightweight JRE image for running the app
FROM eclipse-temurin:8-jre-alpine
WORKDIR /app

# Copy the jar file from the build stage
COPY --from=build /app/target/*.jar app.jar

# Expose application port
EXPOSE 8080

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
