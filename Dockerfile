# Build stage
FROM eclipse-temurin:23 AS build

WORKDIR /app
COPY .mvn/ .mvn
COPY mvnw pom.xml ./

RUN ./mvnw dependency:resolve -B -T 4C

COPY src ./src

# Build the project, skip tests to increase speed
RUN ./mvnw package -DskipTests

# Runtime stage
FROM openjdk:23-jdk-slim AS runtime

WORKDIR /app
COPY --from=build /app/target /app/target

# Expose application port
EXPOSE 8080

# Run the application
CMD ["java", "-jar", "target/spring-petclinic-3.4.0-SNAPSHOT.jar"]
