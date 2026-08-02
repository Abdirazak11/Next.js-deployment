#!/bin/bash
set -e

# Load environment variables from .env
set -a
source .env
set +a

BACKUP_FILE="$1"

if [ -z "$BACKUP_FILE" ]; then
    echo "Usage: ./restore.sh <path-to-backup-file>"
    exit 1
fi

if [ ! -f "$BACKUP_FILE" ]; then
    echo "Error: backup file not found: $BACKUP_FILE"
    exit 1
fi

echo "WARNING: This will overwrite the current database (${POSTGRES_DB}) with the contents of:"
echo "  $BACKUP_FILE"
read -p "Are you sure you want to continue? (yes/no): " CONFIRM

if [ "$CONFIRM" != "yes" ]; then
    echo "Restore cancelled."
    exit 1
fi

# -i keeps STDIN open so the piped backup file contents actually reach psql inside the container
cat "$BACKUP_FILE" | docker exec -i postgres psql -U "${POSTGRES_USER}" "${POSTGRES_DB}"

echo "Restore complete."