#!/bin/bash

set -euo pipefail

DB_NAME="n8n"
DB_USER="changeUser"
CONTAINER_NAME="postgres"
DUMP_LOCAL_PATH="./postgres_db_dumps/"
DUMP_FILE="${1:-n8n_dump_mcp_test_complete.sql}"

if ! command -v docker &> /dev/null || ! docker compose version &> /dev/null; then
  echo "'docker compose' is not available. Please install Docker Compose V2."
  exit 1
fi

mkdir -p "$DUMP_LOCAL_PATH"

echo "Dumping '$DB_NAME' database from container '$CONTAINER_NAME' to SQL file..."

docker compose exec -T "$CONTAINER_NAME" pg_dump -U "$DB_USER" -d "$DB_NAME" -f "/tmp/$DUMP_FILE"

echo "Copying dump to your local: $DUMP_LOCAL_PATH$DUMP_FILE"
docker compose cp "$CONTAINER_NAME:/tmp/$DUMP_FILE" "$DUMP_LOCAL_PATH$DUMP_FILE"

echo "Cleaning up container dump file..."
docker compose exec -T "$CONTAINER_NAME" rm "/tmp/$DUMP_FILE"

echo "Done. Dump saved to: $DUMP_LOCAL_PATH$DUMP_FILE"
