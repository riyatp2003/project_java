# -------- BUILD STAGE --------
FROM maven:4.0.0-eclipse-temurin-24 AS build
WORKDIR /app

# Copy pom first to cache dependencies
COPY pom.xml .
RUN mvn dependency:go-offline

# Copy source and build
COPY src ./src
RUN mvn clean package -DskipTests

# -------- RUNTIME STAGE --------
FROM eclipse-temurin:24-jre
WORKDIR /app

# Copy jar from build stage
COPY --from=build /app/target/*.jar app.jar

# Render provides PORT env variable
EXPOSE 8080

# Run the app
ENTRYPOINT ["java", "-jar", "app.jar"]
