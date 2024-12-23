# Build stage
FROM maven:3.9.9-openjdk-17 AS builder

# Cache Maven dependencies
COPY ./pom.xml /tmp/
WORKDIR /tmp
RUN mvn dependency:go-offline

# Build application
WORKDIR /app
COPY . .
RUN mvn clean package -DskipTests

# Run stage
FROM openjdk:17-jre-slim

WORKDIR /app
COPY --from=builder /app/target/*.jar /app/app.jar

# Add healthcheck
HEALTHCHECK --interval=30s --timeout=3s \
  CMD curl -f http://localhost:8989/ || exit 1

# Expose the application port
EXPOSE 8989

ENTRYPOINT ["java", "-jar", "/app/app.jar"]