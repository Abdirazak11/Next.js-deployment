#!/bin/bash

set -a
source .env
set +a

echo "=== System Health Check ==="

# Check Postgres
if docker exec postgres pg_isready -U "${POSTGRES_USER}" > /dev/null 2>&1; then
    echo "[OK] Postgres is healthy"
else
    echo "[FAIL] Postgres is NOT healthy"
fi

# Check Redis
if docker exec redis redis-cli ping | grep -q "PONG"; then
    echo "[OK] Redis is healthy"
else
    echo "[FAIL] Redis is NOT healthy"
fi

# Check App
HEALTH_CHECK=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:3000/api/health || echo "000")
if [ "$HEALTH_CHECK" == "200" ]; then
    echo "[OK] App is healthy"
else
    echo "[FAIL] App is NOT healthy (status: $HEALTH_CHECK)"
fi

echo "=== Health Check Complete ==="