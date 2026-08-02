#!/bin/bash
set -e

# Load environment variables from .env
set -a
source .env
set +a

TIMESTAMP=$(date +%Y-%m-%d_%H%M%S)
BACKUP_DIR="./backups"
BACKUP_FILE="${BACKUP_DIR}/backup_${TIMESTAMP}.sql"
RETENTION_COUNT=7

mkdir -p "$BACKUP_DIR"

# Reach into the running postgres container and dump the database
docker exec postgres pg_dump -U "${POSTGRES_USER}" "${POSTGRES_DB}" > "$BACKUP_FILE"
echo "Backup created: $BACKUP_FILE"

# Retention policy: keep only the most recent N backups, delete anything older
ls -1t "${BACKUP_DIR}"/backup_*.sql | tail -n +$((RETENTION_COUNT + 1)) | xargs -r rm --