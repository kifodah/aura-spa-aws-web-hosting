
#!/usr/bin/env bash

set -u

check_service() {
    local service="$1"

    if systemctl is-active --quiet "$service"; then
        echo "[OK] $service is running"
    else
        echo "[FAIL] $service is not running"
        return 1
    fi
}

failed=0

for service in apache2 bind9 postfix; do
    check_service "$service" || failed=1
done

if curl -fsSI --max-time 10 https://aura-spa.duckdns.org >/dev/null; then
    echo "[OK] HTTPS endpoint is responding"
else
    echo "[FAIL] HTTPS endpoint is not responding"
    failed=1
fi

exit "$failed"
