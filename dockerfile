# Build stage
FROM maven:3.9-openjdk-17 AS builder

# Cache Maven dependencies
WORKDIR /app
COPY pom.xml .
RUN mvn dependency:go-offline

# Copy source code and build
COPY src ./src
RUN mvn package -DskipTests

# Run stage
FROM openjdk:17-slim

WORKDIR /app
COPY --from=builder /app/target/*.jar app.jar

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
