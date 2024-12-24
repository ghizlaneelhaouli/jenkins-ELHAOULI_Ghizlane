# Utiliser une image de base Maven pour la phase de build
FROM maven:3.8.8-eclipse-temurin-17 AS builder

# Définir le répertoire de travail
WORKDIR /app

# Copier le fichier pom.xml et télécharger les dépendances
COPY pom.xml .
RUN mvn dependency:go-offline

# Copier le reste du code source et construire le projet
COPY src ./src
RUN mvn package -DskipTests

# Utiliser une image OpenJDK pour exécuter l'application
FROM openjdk:17-slim

# Définir le répertoire de travail
WORKDIR /app

# Copier le fichier JAR généré depuis l'étape précédente
COPY --from=builder /app/target/*.jar app.jar

# Exposer le port utilisé par l'application
EXPOSE 8080

# Commande pour exécuter l'application
ENTRYPOINT ["java", "-jar", "app.jar"]
