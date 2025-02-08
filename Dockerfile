FROM eclipse-temurin:23

# Set the working directory inside the container
WORKDIR /app
COPY .mvn/ .mvn
COPY mvnw pom.xml ./

# Download project dependencies using 4 threads
RUN ./mvnw dependency:resolve -B -T 4C

# Copy the project source code
COPY src ./src

# Build the project, skip tests to increase speed
RUN ./mvnw package -DskipTests

#
COPY target ./target

# Expose the application port (if needed)
EXPOSE 8080

# Command to run the application
CMD ["java", "-jar", "target/spring-petclinic-3.4.0-SNAPSHOT.jar"]
