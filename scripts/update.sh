#!/bin/bash
set -e

echo "Step 1: Backing up database before update..."
./backup.sh

echo "Step 2: Building new app image..."
docker compose build app

echo "Step 3: Replacing the app container with the new image..."
docker compose up -d app

echo "Step 4: Verifying the new version is healthy..."
sleep 5

HEALTH_CHECK=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:3000/api/health || echo "000")

if [ "$HEALTH_CHECK" != "200" ]; then
    echo "ERROR: Health check failed (status: $HEALTH_CHECK). New version may be broken."
    exit 1
fi

echo "Update successful. App is healthy."