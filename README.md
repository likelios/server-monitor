# Server Monitor for Mattermost and other  🚀

Bash script for monitoring server metrics and sending reports to Mattermost via webhook.

## Features
- 📊 CPU, Memory, Disk, Swap monitoring
- 🐳 Docker containers status
- 🛠️ System services monitoring
- 📡 MTProto Proxy detection
- 🚨 Critical alerts with thresholds
- 🎨 Color-coded Mattermost messages

## Quick Install
```bash
git clone https://github.com/likelios/server-monitor.git
cd server-monitor
chmod +x install.sh
sudo ./install.sh
```

## Usage

# Send one report
 server-monitor --once
# Continuous monitoring
 server-monitor --continuous
# Debug mode (local only)
server-monitor --debug