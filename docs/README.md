# SimpleDaemons Documentation

Welcome to the SimpleDaemons documentation! This directory contains comprehensive guides, references, and troubleshooting information for all SimpleDaemons projects and automation tooling.

## 📚 Documentation Overview

### 🚀 Getting Started
- **[Developer Onboarding](DEVELOPER_ONBOARDING.md)** - Complete guide for new developers
  - 5-minute setup guide
  - First build walkthrough
  - Daily development workflow
  - Understanding project structure

- **[Quick Reference](QUICK_REFERENCE.md)** - Essential commands and workflows
  - Essential setup commands
  - VM management shortcuts
  - Project automation commands
  - Build system targets
  - Troubleshooting quick fixes

### 📖 Comprehensive Guides
- **[Documentation](DOCUMENTATION.md)** - Complete user guide (12 sections)
  - VM Management
  - Project Automation
  - Development Workflows
  - Build System
  - CI/CD Integration
  - Package Management
  - Service Management
  - Advanced Usage
  - Reference

### 🔧 Infrastructure & Automation
- **[Automation Summary](AUTOMATION_SUMMARY.md)** - Implementation overview
  - What was implemented
  - Key features and benefits
  - Project status
  - Next steps

### 🐛 Problem Solving
- **[Troubleshooting](TROUBLESHOOTING.md)** - Common issues and solutions
  - VM issues
  - Build problems
  - Package issues
  - Service problems
  - CI/CD issues
  - Docker issues
  - Advanced diagnostics

## 🎯 Quick Navigation

### For New Developers
1. Start with **[Developer Onboarding](DEVELOPER_ONBOARDING.md)**
2. Use **[Quick Reference](QUICK_REFERENCE.md)** for daily tasks
3. Refer to **[Documentation](DOCUMENTATION.md)** for detailed information

### For Experienced Users
1. Check **[Quick Reference](QUICK_REFERENCE.md)** for commands
2. Use **[Troubleshooting](TROUBLESHOOTING.md)** when issues arise
3. Refer to **[Documentation](DOCUMENTATION.md)** for advanced topics

### For Project Managers
1. Review **[Automation Summary](AUTOMATION_SUMMARY.md)** for implementation status
2. Check **[Documentation](DOCUMENTATION.md)** for comprehensive overview
3. Use **[Troubleshooting](TROUBLESHOOTING.md)** for common issues

## 🚀 Essential Quick Start

### Prerequisites
- Vagrant (2.2+)
- VirtualBox (6.0+)
- Ansible (2.9+)
- Git, Make, CMake

### 5-Minute Setup
```bash
# 1. Clone repository
git clone <repository-url>
cd SimpleDaemons

# 2. Setup automation infrastructure
./automation/scripts/setup-automation.sh

# 3. Start development VM
./automation/scripts/vm-manager up ubuntu_dev

# 4. SSH into VM
./automation/scripts/vm-manager ssh ubuntu_dev
```

### First Build
```bash
# Inside VM (as nfsdev user)
cd /opt/simple-daemons/simple-ntpd
make build
make test
make install
```

## 🏗️ Projects Overview

| Project | Description | Port | Status |
|---------|-------------|------|--------|
| **simple-dhcpd** | DHCP server | 67, 68 (UDP) | ✅ Active |
| **simple-dnsd** | DNS server | 53 (UDP/TCP) | ✅ Active |
| **simple-dummy** | Test daemon | Variable | ✅ Active |
| **simple-httpd** | HTTP server | 80, 443 (TCP) | ✅ Active |
| **simple-nfsd** | NFS server | 2049 (TCP) | ✅ Active |
| **simple-ntpd** | NTP server | 123 (UDP) | ✅ Active |
| **simple-proxyd** | HTTP proxy | 8080 (TCP) | ✅ Active |
| **simple-rsyncd** | RSync server | 873 (TCP) | ✅ Active |
| **simple-sftpd** | SFTP server | 21, 990 (TCP) | ✅ Active |
| **simple-smbd** | SMB server | 445 (TCP) | ✅ Active |
| **simple-smtpd** | SMTP server | 25, 587 (TCP) | ✅ Active |
| **simple-snmpd** | SNMP agent | 161 (UDP) | ✅ Active |
| **simple-tftpd** | TFTP server | 69 (UDP) | ✅ Active |
| **simple-utcd** | UTC daemon | 8080 (TCP) | ✅ Active |

## 🛠️ Automation Tools

### VM Manager
```bash
# Manage development VMs
./automation/scripts/vm-manager up ubuntu_dev
./automation/scripts/vm-manager ssh ubuntu_dev
./automation/scripts/vm-manager status
```

### Project Automation
```bash
# Manage projects
./automation/scripts/project-automation build simple-ntpd
./automation/scripts/project-automation test simple-ntpd
./automation/scripts/project-automation all-build
```

### Build System
```bash
# Comprehensive build targets
make build          # Build project
make test           # Run tests
make package        # Create packages
make service-install # Install service
make help           # Show all targets
```

## 📦 Package Support

### Supported Formats
- **Linux**: DEB (Debian/Ubuntu), RPM (RedHat/CentOS)
- **macOS**: DMG, PKG
- **Windows**: MSI, ZIP
- **Source**: TAR.GZ, ZIP

### Package Creation
```bash
# Create all packages
make package-all

# Create specific package type
make package-deb    # For Debian/Ubuntu
make package-rpm    # For RedHat/CentOS
```

## 🔧 Service Management

### Service Commands
```bash
# Service management
make service-install
make service-start
make service-stop
make service-restart
make service-status
```

### System Commands
```bash
# Check service status
systemctl status simple-ntpd
journalctl -u simple-ntpd -f
```

## 🧪 Testing

### Unit Tests
```bash
# Run tests
make test
make test-verbose
make coverage
```

### Integration Tests
```bash
# Test service installation
make service-install
make service-start
make service-status
```

## 🔍 Monitoring

### Service Status
```bash
# Check service status
systemctl status simple-ntpd
make service-status
```

### Logs
```bash
# View logs
journalctl -u simple-ntpd -f
tail -f /var/log/simple-daemons/simple-ntpd.log
```

## 🤝 Contributing

### Development Workflow
1. **Fork the repository**
2. **Create a feature branch**
3. **Make your changes**
4. **Test thoroughly**
5. **Submit a pull request**

### Code Standards
- Follow existing code style
- Write comprehensive tests
- Update documentation
- Use the automation tools

## 📞 Getting Help

### Self-Help Resources
1. **Check Documentation** - Start with the appropriate guide above
2. **Use Help Commands** - `--help` with any script
3. **Check Status** - Use automation scripts to check system status
4. **Review Logs** - Check application and system logs

### When to Ask for Help
- After trying all solutions in the troubleshooting guide
- When you have specific error messages
- When the issue affects multiple projects
- When you need to modify the automation infrastructure

## 📄 Additional Resources

### Project-Specific Documentation
Each project has its own detailed documentation:
- `projects/simple-ntpd/README.md` - NTP daemon documentation
- `projects/simple-httpd/README.md` - HTTP daemon documentation
- `projects/simple-rsyncd/README.md` - RSync daemon documentation
- And more...

### Automation Documentation
- `automation/README.md` - Detailed automation infrastructure guide
- `automation/scripts/` - Helper script documentation

---

**Need help getting started?** Begin with the [Developer Onboarding Guide](DEVELOPER_ONBOARDING.md) for a complete walkthrough, or check the [Quick Reference](QUICK_REFERENCE.md) for essential commands.

**Having issues?** Check the [Troubleshooting Guide](TROUBLESHOOTING.md) for solutions to common problems.

**Want to learn more?** Explore the [Comprehensive Documentation](DOCUMENTATION.md) for detailed information about all features and capabilities.
