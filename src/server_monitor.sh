#!/bin/bash

# ==============================================
# Server Monitor for Mattermost
# Version: 1.0.0
# ==============================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source modules
source "$SCRIPT_DIR/lib/utils.sh"
source "$SCRIPT_DIR/modules/metrics.sh"
source "$SCRIPT_DIR/modules/docker.sh"
source "$SCRIPT_DIR/modules/services.sh"
source "$SCRIPT_DIR/modules/mattermost.sh"

# Configuration
CONFIG_FILE="/etc/server_monitor.conf"
LOCAL_CONFIG_DIR="$HOME/.config/server-monitor"
LOCAL_CONFIG_FILE="$LOCAL_CONFIG_DIR/config.conf"

# Default values
WEBHOOK_URL=""
REPORT_INTERVAL=3600
SERVICES="nginx postgresql mattermost"
MEMORY_THRESHOLD=90
DISK_THRESHOLD=90
CPU_THRESHOLD=1.0
COLOR_GREEN="#00FF00"
COLOR_YELLOW="#FFFF00"
COLOR_RED="#FF0000"

# Debug mode
DEBUG_MODE=false

# Load configuration
load_config

# Main function
main() {
    local server_hostname=$(get_hostname)
    log "Starting server monitoring for $server_hostname"

    # Get metrics
    metrics=$(get_system_metrics)

    if [ "$DEBUG_MODE" = true ]; then
        echo "🔍 Raw metrics: $metrics"
    fi

    # Generate and send report
    payload=$(create_json_payload "$metrics")
    send_to_mattermost "$payload"

    log "Report sent successfully at $(date)"
}

# Parse arguments
parse_arguments "$@"