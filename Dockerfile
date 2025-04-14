# Bước 1: Build native binary bằng GraalVM container
FROM quay.io/quarkus/ubi-quarkus-mandrel-builder-image:jdk-21 AS build
WORKDIR /app/
COPY . .
RUN mvn clean install -Dnative

# Bước 2: Copy binary ra container tối giản
FROM registry.access.redhat.com/ubi8/ubi-minimal
WORKDIR /work/
COPY --from=build /app/target/*-runner /work/application
RUN chmod 755 /work/application
EXPOSE 8080
USER 1001
ENTRYPOINT ["/work/application", "-Dquarkus.http.host=0.0.0.0"]