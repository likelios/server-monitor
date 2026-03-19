
### 📄 `install.sh`
```bash
#!/bin/bash

set -e

echo "🚀 Installing Server Monitor for Mattermost..."

# Create directories
sudo mkdir -p /opt/server-monitor/{src,config}
sudo mkdir -p /usr/local/bin

# Copy files
sudo cp src/server_monitor.sh /opt/server-monitor/src/
sudo cp -r src/modules /opt/server-monitor/src/
sudo cp -r src/lib /opt/server-monitor/src/

# Create config if not exists
if [ ! -f /etc/server_monitor.conf ]; then
    sudo cp config/server_monitor.conf.example /etc/server_monitor.conf
    echo "📝 Please edit /etc/server_monitor.conf and add your webhook URL"
fi

# Create symlink
sudo ln -sf /opt/server-monitor/src/server_monitor.sh /usr/local/bin/server-monitor
sudo chmod +x /usr/local/bin/server-monitor

# Make scripts executable
sudo find /opt/server-monitor -name "*.sh" -exec chmod +x {} \;

echo "✅ Installation complete!"
echo ""
echo "Next steps:"
echo "1. Edit config: sudo nano /etc/server_monitor.conf"
echo "2. Test: server-monitor --debug"
echo "3. Run: server-monitor --once"