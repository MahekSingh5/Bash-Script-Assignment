#!/bin/bash

SERVICE_FILE="services.txt"
LOG_FILE="health_monitor.log"
DRY_RUN=false

if [[ "$1" == "--dry-run" ]]; then
    DRY_RUN=true
fi

total=0
healthy=0
recovered=0
failed=0

if [[ ! -f "$SERVICE_FILE" ]]; then
    echo "Error: services.txt not found"
    exit 1
fi

if [[ ! -s "$SERVICE_FILE" ]]; then
    echo "Error: services.txt is empty"
    exit 1
fi

log_event() {
    status=$1
    service=$2
    echo "$(date '+%Y-%m-%d %H:%M:%S') [$status] $service" >> "$LOG_FILE"
}

while read -r service
do
    if [[ -z "$service" ]]; then
        continue
    fi

    ((total++))
    echo "Checking $service..."

    if pgrep "$service" > /dev/null
    then
        echo "$service is running"
        ((healthy++))
    else
        echo "$service is NOT running"

        if [[ "$DRY_RUN" == true ]]; then
            echo "[DRY RUN] Would restart $service"
            log_event "DRY-RUN" "$service"
            continue
        fi

        echo "Trying to restart..."
        log_event "RESTART-ATTEMPT" "$service"

        sleep 5

        if pgrep "$service" > /dev/null
        then
            echo "$service recovered"
            ((recovered++))
            log_event "RECOVERED" "$service"
        else
            echo "$service failed"
            ((failed++))
            log_event "FAILED" "$service"
        fi
    fi

done < "$SERVICE_FILE"

echo ""
echo "Summary:"
echo "Total: $total"
echo "Healthy: $healthy"
echo "Recovered: $recovered"
echo "Failed: $failed"
