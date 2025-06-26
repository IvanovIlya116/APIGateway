#!/bin/bash

set -e

KEYCLOAK_URL=http://localhost:30005
REALM=government-data
ADMIN_USER=admin
ADMIN_PASSWORD=password
OUTPUT_FILE=realm-export.json

echo "🔑 Получение токена администратора Keycloak..."
ACCESS_TOKEN=$(curl -s -X POST "$KEYCLOAK_URL/realms/master/protocol/openid-connect/token" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "grant_type=password" \
  -d "client_id=admin-cli" \
  -d "username=$ADMIN_USER" \
  -d "password=$ADMIN_PASSWORD" | jq -r .access_token)

if [[ -z "$ACCESS_TOKEN" || "$ACCESS_TOKEN" == "null" ]]; then
  echo "❌ Не удалось получить access token. Проверь имя пользователя и пароль."
  exit 1
fi

echo "📥 Экспорт настроек Realm '$REALM'..."
REALM_DATA=$(curl -s -X GET "$KEYCLOAK_URL/admin/realms/$REALM" \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -H "Content-Type: application/json")

echo "📦 Экспорт клиентов Realm '$REALM'..."
CLIENTS_DATA=$(curl -s -X GET "$KEYCLOAK_URL/admin/realms/$REALM/clients?max=1000" \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -H "Content-Type: application/json")

echo "💾 Сохранение в '$OUTPUT_FILE'..."
echo "$REALM_DATA" | jq --argjson clients "$CLIENTS_DATA" '.clients = $clients' | jq -s '.' > "$OUTPUT_FILE"

echo "✅ Экспорт завершён: $OUTPUT_FILE"