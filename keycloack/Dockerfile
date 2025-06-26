FROM quay.io/keycloak/keycloak:latest

COPY realm-export.json /opt/keycloak/data/import/realm-export.json

ENV KEYCLOAK_ADMIN=admin
ENV KEYCLOAK_ADMIN_PASSWORD=password

ENTRYPOINT ["/opt/keycloak/bin/kc.sh", "start-dev", "--import-realm"]