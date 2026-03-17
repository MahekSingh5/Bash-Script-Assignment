# Bash Script Assignment – Service Monitor

## Overview

This project is a Bash script that monitors services, detects failures, attempts recovery, and logs events.

## Features

* Reads services from `services.txt`
* Checks if services are running
* Attempts restart if a service is down
* Waits 5 seconds and re-checks
* Logs events with timestamp
* Displays summary (total, healthy, recovered, failed)
* Supports `--dry-run` mode (simulation without restart)

## Files

* `bash_assignment.sh` → Main script
* `services.txt` → List of services
* `health_monitor.log` → Log output

## How to Run

```bash
chmod +x bash_assignment.sh
./bash_assignment.sh
```

## Dry Run Mode

```bash
./bash_assignment.sh --dry-run
```

## Note

This script was adapted for macOS using `pgrep` instead of `systemctl` (Linux).
