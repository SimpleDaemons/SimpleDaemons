# simple-dummy Deployment

This directory contains deployment configurations and examples for simple-dummy.

## Directory Structure

```
deployment/
├── systemd/                    # Linux systemd service files
│   └── simple-dummy.service
├── launchd/                    # macOS launchd service files
│   └── com.simple-dummy.simple-dummy.plist
├── logrotate.d/                # Linux log rotation configuration
│   └── simple-dummy
├── windows/                    # Windows service management
│   └── simple-dummy.service.bat
└── examples/                   # Deployment examples
    └── docker/                 # Docker deployment examples
        ├── docker-compose.yml
        └── README.md
```

## Platform-Specific Deployment

### Linux (systemd)

1. **Install the service file:**
   ```bash
   sudo cp deployment/systemd/simple-dummy.service /etc/systemd/system/
   sudo systemctl daemon-reload
   ```

2. **Create user and group:**
   ```bash
   sudo useradd --system --no-create-home --shell /bin/false simple-dummy
   ```

3. **Enable and start the service:**
   ```bash
   sudo systemctl enable simple-dummy
   sudo systemctl start simple-dummy
   ```

4. **Check status:**
   ```bash
   sudo systemctl status simple-dummy
   sudo journalctl -u simple-dummy -f
   ```

### macOS (launchd)

1. **Install the plist file:**
   ```bash
   sudo cp deployment/launchd/com.simple-dummy.simple-dummy.plist /Library/LaunchDaemons/
   sudo chown root:wheel /Library/LaunchDaemons/com.simple-dummy.simple-dummy.plist
   ```

2. **Load and start the service:**
   ```bash
   sudo launchctl load /Library/LaunchDaemons/com.simple-dummy.simple-dummy.plist
   sudo launchctl start com.simple-dummy.simple-dummy
   ```

3. **Check status:**
   ```bash
   sudo launchctl list | grep simple-dummy
   tail -f /var/log/simple-dummy.log
   ```

### Windows

1. **Run as Administrator:**
   ```cmd
   # Install service
   deployment\windows\simple-dummy.service.bat install
   
   # Start service
   deployment\windows\simple-dummy.service.bat start
   
   # Check status
   deployment\windows\simple-dummy.service.bat status
   ```

2. **Service management:**
   ```cmd
   # Stop service
   deployment\windows\simple-dummy.service.bat stop
   
   # Restart service
   deployment\windows\simple-dummy.service.bat restart
   
   # Uninstall service
   deployment\windows\simple-dummy.service.bat uninstall
   ```

## Log Rotation (Linux)

1. **Install logrotate configuration:**
   ```bash
   sudo cp deployment/logrotate.d/simple-dummy /etc/logrotate.d/
   ```

2. **Test logrotate configuration:**
   ```bash
   sudo logrotate -d /etc/logrotate.d/simple-dummy
   ```

3. **Force log rotation:**
   ```bash
   sudo logrotate -f /etc/logrotate.d/simple-dummy
   ```

## Docker Deployment

See [examples/docker/README.md](examples/docker/README.md) for detailed Docker deployment instructions.

### Quick Start

```bash
# Build and run with Docker Compose
cd deployment/examples/docker
docker-compose up -d

# Check status
docker-compose ps
docker-compose logs simple-dummy
```

## Configuration

### Service Configuration

Each platform has specific configuration requirements:

- **Linux**: Edit `/etc/systemd/system/simple-dummy.service`
- **macOS**: Edit `/Library/LaunchDaemons/com.simple-dummy.simple-dummy.plist`
- **Windows**: Edit the service binary path in the batch file

### Application Configuration

Place your application configuration in:
- **Linux/macOS**: `/etc/simple-dummy/simple-dummy.conf`
- **Windows**: `%PROGRAMFILES%\simple-dummy\simple-dummy.conf`

## Security Considerations

### User and Permissions

1. **Create dedicated user:**
   ```bash
   # Linux
   sudo useradd --system --no-create-home --shell /bin/false simple-dummy
   
   # macOS
   sudo dscl . -create /Users/_simple-dummy UserShell /usr/bin/false
   sudo dscl . -create /Users/_simple-dummy UniqueID 200
   sudo dscl . -create /Users/_simple-dummy PrimaryGroupID 200
   sudo dscl . -create /Groups/_simple-dummy GroupID 200
   ```

2. **Set proper permissions:**
   ```bash
   # Configuration files
   sudo chown root:simple-dummy /etc/simple-dummy/simple-dummy.conf
   sudo chmod 640 /etc/simple-dummy/simple-dummy.conf
   
   # Log files
   sudo chown simple-dummy:simple-dummy /var/log/simple-dummy/
   sudo chmod 755 /var/log/simple-dummy/
   ```

### Firewall Configuration

Configure firewall rules as needed:

```bash
# Linux (ufw)
sudo ufw allow 67/tcp

# Linux (firewalld)
sudo firewall-cmd --permanent --add-port=67/tcp
sudo firewall-cmd --reload

# macOS
sudo pfctl -f /etc/pf.conf
```

## Monitoring

### Health Checks

1. **Service status:**
   ```bash
   # Linux
   sudo systemctl is-active simple-dummy
   
   # macOS
   sudo launchctl list | grep simple-dummy
   
   # Windows
   sc query simple-dummy
   ```

2. **Port availability:**
   ```bash
   netstat -tlnp | grep 67
   ss -tlnp | grep 67
   ```

3. **Process monitoring:**
   ```bash
   ps aux | grep simple-dummy
   top -p $(pgrep simple-dummy)
   ```

### Log Monitoring

1. **Real-time logs:**
   ```bash
   # Linux
   sudo journalctl -u simple-dummy -f
   
   # macOS
   tail -f /var/log/simple-dummy.log
   
   # Windows
   # Use Event Viewer or PowerShell Get-WinEvent
   ```

2. **Log analysis:**
   ```bash
   # Search for errors
   sudo journalctl -u simple-dummy --since "1 hour ago" | grep -i error
   
   # Count log entries
   sudo journalctl -u simple-dummy --since "1 day ago" | wc -l
   ```

## Troubleshooting

### Common Issues

1. **Service won't start:**
   - Check configuration file syntax
   - Verify user permissions
   - Check port availability
   - Review service logs

2. **Permission denied:**
   - Ensure service user exists
   - Check file permissions
   - Verify directory ownership

3. **Port already in use:**
   - Check what's using the port: `netstat -tlnp | grep 67`
   - Stop conflicting service or change port

4. **Service stops unexpectedly:**
   - Check application logs
   - Verify resource limits
   - Review system logs

### Debug Mode

Run the service in debug mode for troubleshooting:

```bash
# Linux/macOS
sudo -u simple-dummy /usr/local/bin/simple-dummy --debug

# Windows
simple-dummy.exe --debug
```

### Log Levels

Adjust log level for more verbose output:

```bash
# Set log level in configuration
log_level = debug

# Or via environment variable
export SIMPLE-DUMMY_LOG_LEVEL=debug
```

## Backup and Recovery

### Configuration Backup

```bash
# Backup configuration
sudo tar -czf simple-dummy-config-backup-$(date +%Y%m%d).tar.gz /etc/simple-dummy/

# Backup logs
sudo tar -czf simple-dummy-logs-backup-$(date +%Y%m%d).tar.gz /var/log/simple-dummy/
```

### Service Recovery

```bash
# Stop service
sudo systemctl stop simple-dummy

# Restore configuration
sudo tar -xzf simple-dummy-config-backup-YYYYMMDD.tar.gz -C /

# Start service
sudo systemctl start simple-dummy
```

## Updates

### Service Update Process

1. **Stop service:**
   ```bash
   sudo systemctl stop simple-dummy
   ```

2. **Backup current version:**
   ```bash
   sudo cp /usr/local/bin/simple-dummy /usr/local/bin/simple-dummy.backup
   ```

3. **Install new version:**
   ```bash
   sudo cp simple-dummy /usr/local/bin/
   sudo chmod +x /usr/local/bin/simple-dummy
   ```

4. **Start service:**
   ```bash
   sudo systemctl start simple-dummy
   ```

5. **Verify update:**
   ```bash
   sudo systemctl status simple-dummy
   simple-dummy --version
   ```
