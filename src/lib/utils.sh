#!/bin/bash

# Utility functions

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

get_hostname() {
    hostname -s 2>/dev/null || hostname 2>/dev/null || echo "unknown"
}

is_numeric() {
    [[ "$1" =~ ^[0-9]+(\.[0-9]+)?$ ]]
}

safe_num() {
    if is_numeric "$1"; then
        echo "$1"
    else
        echo "$2"
    fi
}

parse_arguments() {
    case "${1:-}" in
        --debug)
            DEBUG_MODE=true
            load_config
            main
            ;;
        --once)
            DEBUG_MODE=false
            load_config
            main
            ;;
        --continuous)
            DEBUG_MODE=false
            load_config
            log "Starting continuous monitoring (interval: ${REPORT_INTERVAL}s)"
            while true; do
                main
                sleep $REPORT_INTERVAL
            done
            ;;
        --version)
            echo "Server Monitor v1.0.0"
            ;;
        --help)
            echo "Usage: server-monitor [OPTION]"
            echo "  --debug       Run in debug mode (local output only)"
            echo "  --once        Send one report to Mattermost"
            echo "  --continuous  Run continuously"
            echo "  --version     Show version"
            echo "  --help        Show this help"
            ;;
        *)
            echo "Usage: server-monitor [--debug|--once|--continuous|--version|--help]"
            exit 1
            ;;
    esac
}