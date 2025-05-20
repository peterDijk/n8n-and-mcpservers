#!/bin/bash

set -euo pipefail

DB_NAME="n8n"
DB_USER="changeUser"
CONTAINER_NAME="postgres"
DUMP_LOCAL_PATH="./postgres_db_dumps/"
DUMP_DEST_PATH="/tmp/"
DUMP_FILE="${1:-n8n_dump_mcp_test_complete.sql}"


if ! command -v docker &> /dev/null || ! docker compose version &> /dev/null; then
  echo "'docker compose' is not available. Please install Docker Compose V2."
  exit 1
fi

read -p "⚠️ Are you sure you want to DROP and RESTORE the '$DB_NAME' database in the '$CONTAINER_NAME' container? [y/N]: " confirm
if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
  echo "Aborted"
  exit 0
fi

if [[ ! -f "$DUMP_LOCAL_PATH$DUMP_FILE" ]]; then
  echo "Dump file '$DUMP_LOCAL_PATH$DUMP_FILE' not found."
  exit 1
fi

echo "Stopping n8n container..."
docker compose stop n8n

echo "Copying dump file to container..."
docker compose cp "$DUMP_LOCAL_PATH$DUMP_FILE" "$CONTAINER_NAME:$DUMP_DEST_PATH$DUMP_FILE"

echo "Dropping database '$DB_NAME'..."
docker compose exec -u postgres "$CONTAINER_NAME" psql -U "$DB_USER" -d postgres -c "DROP DATABASE IF EXISTS $DB_NAME;"

echo "Creating new database '$DB_NAME'..."
docker compose exec -u postgres "$CONTAINER_NAME" psql -U "$DB_USER" -d postgres -c "CREATE DATABASE $DB_NAME;"

echo "Restoring from dump..."
docker compose exec -u postgres "$CONTAINER_NAME" psql -U "$DB_USER" -d "$DB_NAME" -f "$DUMP_DEST_PATH$DUMP_FILE"

echo "Starting n8n container..."
docker compose start n8n

echo "Done. Database '$DB_NAME' has been restored."
