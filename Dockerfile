### Stage 1: Build native binary with GraalVM container
FROM quay.io/quarkus/ubi-quarkus-mandrel-builder-image:jdk-21 AS build
WORKDIR /app/

# Copy only files related Maven build
COPY mvnw .
COPY .mvn .mvn
COPY pom.xml .

# Download dependencies and cache in layer
RUN chmod +x mvnw
RUN ./mvnw -B org.apache.maven.plugins:maven-dependency-plugin:3.8.1:go-offline

# Copy source
COPY src src

# Build native execute
RUN ./mvnw clean install -Dnative

### Stage 2: Build Docker image
FROM quay.io/quarkus/ubi9-quarkus-micro-image:2.0
WORKDIR /work/
COPY --from=build /app/target/*-runner /work/application
RUN chmod 755 /work/application
EXPOSE 8080
USER 1001
ENTRYPOINT ["/work/application", "-Dquarkus.http.host=0.0.0.0"]