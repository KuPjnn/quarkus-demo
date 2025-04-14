# Bước 2: Copy binary ra container tối giản
FROM registry.access.redhat.com/ubi8/ubi-minimal

WORKDIR /opt/

COPY *-runner /opt/application

RUN chmod 755 /opt/application
EXPOSE 8080
USER 1001
ENTRYPOINT ["/opt/application", "-Dquarkus.http.host=0.0.0.0"]