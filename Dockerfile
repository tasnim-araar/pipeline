# Image de base Java
FROM eclipse-temurin:17-jdk-alpine

# Répertoire de travail dans le conteneur
WORKDIR /app

# Copier uniquement le livrable JAR
COPY target/*.jar app.jar

# Exposer le port 8080
EXPOSE 8080

# Lancer l'application Spring Boot
ENTRYPOINT ["java","-jar","app.jar"]
