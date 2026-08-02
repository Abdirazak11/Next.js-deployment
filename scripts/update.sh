#!/bin/bash
set -e

echo "Pulling latest code..."
git pull

echo "Rebuilding app image..."
docker compose build app

echo "Recreating app container with new image..."
docker compose up -d app

echo "Update complete."