# SimpleDaemons

A collection of lightweight, secure, and efficient daemon services for modern systems.

## 🏗️ Repository Structure

This is the **main repository** that contains:
- **Automation infrastructure** for all SimpleDaemons projects
- **Documentation** and guides
- **VM configurations** and development environments
- **Individual project repositories** as git submodules

### 📁 Directory Structure

```
SimpleDaemons/                    # Main repository
├── automation/                   # Automation infrastructure
├── docs/                        # Comprehensive documentation
├── virtuals/                    # VM configurations
├── projects/                    # Individual project submodules
│   ├── simple-dhcpd/           # DHCP daemon (submodule)
│   ├── simple-dnsd/            # DNS daemon (submodule)
│   ├── simple-httpd/           # HTTP daemon (submodule)
│   ├── simple-ntpd/            # NTP daemon (submodule)
│   └── ...                     # Other daemon projects
└── README.md                   # This file
```

## 🎯 Overview

SimpleDaemons provides a comprehensive suite of network services implemented in C++ with a focus on simplicity, security, and performance. Each daemon is designed to be lightweight, easy to configure, and suitable for both development and production environments.

## 📚 Documentation

All documentation is now organized in the `docs/` directory:

### Getting Started
- **[docs/Developer Onboarding](docs/DEVELOPER_ONBOARDING.md)** - Complete guide for new developers
- **[docs/Quick Reference](docs/QUICK_REFERENCE.md)** - Essential commands and workflows
- **[docs/Documentation](docs/DOCUMENTATION.md)** - Comprehensive user guide

### Automation & Infrastructure
- **[docs/Automation Summary](docs/AUTOMATION_SUMMARY.md)** - Overview of automation infrastructure
- **[automation/README](automation/README.md)** - Detailed automation documentation
- **[docs/Troubleshooting](docs/TROUBLESHOOTING.md)** - Common issues and solutions

### Documentation Index
- **[docs/README](docs/README.md)** - Complete documentation index and navigation
- **[docs/Submodule Guide](docs/SUBMODULE_GUIDE.md)** - Working with git submodules

### Project-Specific Documentation
Each project has its own detailed documentation:
- `projects/simple-ntpd/README.md` - NTP daemon documentation
- `projects/simple-httpd/README.md` - HTTP daemon documentation
- `projects/simple-rsyncd/README.md` - RSync daemon documentation
- And more...

## 🚀 Quick Start

### Prerequisites
- Vagrant (2.2+)
- VirtualBox (6.0+)
- Ansible (2.9+)
- Git, Make, CMake

### Setup (5 minutes)
```bash
# 1. Clone repository with submodules
git clone --recursive <repository-url>
cd SimpleDaemons

# 2. Setup automation infrastructure
./automation/scripts/setup-automation.sh

# 3. Start development VM
./automation/scripts/vm-manager up ubuntu_dev

# 4. SSH into VM
./automation/scripts/vm-manager ssh ubuntu_dev
```

### Working with Submodules

```bash
# Clone repository (if not done recursively)
git clone <repository-url>
cd SimpleDaemons
git submodule update --init --recursive

# Update all submodules to latest
git submodule update --remote

# Work on a specific project
cd projects/simple-ntpd
# Make changes, commit, push to project repository
# Then update main repository
cd ../..
git add projects/simple-ntpd
git commit -m "Update simple-ntpd to latest version"
```

### First Build
```bash
# Inside VM (as nfsdev user)
cd /opt/simple-daemons/simple-ntpd
make build
make test
make install
```

## 🏗️ Projects

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

## 🛠️ Features

### Standardized Build System
- **Comprehensive Makefiles** with 50+ targets
- **CMake integration** with full package support
- **Multi-platform** builds (Linux, macOS, Windows)
- **Automated testing** with CTest integration

### Package Generation
- **Linux**: DEB (Debian/Ubuntu), RPM (RedHat/CentOS)
- **macOS**: DMG, PKG
- **Windows**: MSI, ZIP
- **Source**: TAR.GZ, ZIP

### Service Management
- **Systemd services** for Linux
- **Launchd plists** for macOS
- **Windows services** for Windows
- **Log rotation** and management

### CI/CD Integration
- **Travis CI** for automated testing
- **Jenkins** for comprehensive pipelines
- **Automated testing** across platforms
- **Security scanning** and code analysis

### Development Environment
- **Automated VM provisioning** with Vagrant
- **Ansible playbooks** for environment setup
- **Cross-platform** development support
- **Helper scripts** for common tasks

## 🔧 Automation Tools

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

## 📦 Installation

### From Source
```bash
# Build and install
make build
make install
make service-install
make service-start
```

### From Packages
```bash
# Debian/Ubuntu
sudo dpkg -i simple-ntpd-0.1.0-Linux.deb

# RedHat/CentOS
sudo rpm -i simple-ntpd-0.1.0-Linux.rpm

# Windows
msiexec /i simple-ntpd-0.1.0-Windows.msi
```

### Docker
```bash
# Build and run
docker build -t simple-ntpd .
docker-compose up -d
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

### Multi-Platform Testing
```bash
# Test on multiple platforms
./automation/scripts/vm-manager up ubuntu_dev
./automation/scripts/vm-manager up centos_dev
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

### Metrics
```bash
# Check resource usage
top -p $(pgrep simple-ntpd)
ps aux | grep simple-ntpd
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

### Getting Help
- Check the [troubleshooting guide](TROUBLESHOOTING.md)
- Use `--help` with any script
- Review project-specific documentation

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🎯 Roadmap

### Current Status
- ✅ All 14 projects implemented
- ✅ Standardized build system
- ✅ Automation infrastructure
- ✅ CI/CD integration
- ✅ Package generation
- ✅ Service management

### Future Plans
- 🔄 Performance optimizations
- 🔄 Additional security features
- 🔄 Extended configuration options
- 🔄 Monitoring and metrics
- 🔄 Documentation improvements

## 📞 Support

### Resources
- **Documentation**: Comprehensive guides and references
- **Automation Tools**: Helper scripts for common tasks
- **CI/CD**: Automated testing and deployment
- **Community**: Issue tracking and discussions

### Getting Help
1. Check the [troubleshooting guide](docs/TROUBLESHOOTING.md)
2. Review the [documentation](docs/DOCUMENTATION.md)
3. Use the automation tools with `--help`
4. Check project-specific README files

---

**SimpleDaemons** - Lightweight, secure, and efficient network services for modern systems.

For detailed information, start with the [Developer Onboarding Guide](docs/DEVELOPER_ONBOARDING.md) or check the [Quick Reference](docs/QUICK_REFERENCE.md) for essential commands.