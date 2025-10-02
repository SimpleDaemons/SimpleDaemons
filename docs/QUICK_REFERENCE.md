# SimpleDaemons Quick Reference Guide

## 🚀 Essential Commands

### Setup
```bash
# Initial setup
./automation/scripts/setup-automation.sh

# Start development VM
./automation/scripts/vm-manager up ubuntu_dev

# SSH into VM
./automation/scripts/vm-manager ssh ubuntu_dev
```

### Project Operations
```bash
# Build project
./automation/scripts/project-automation build simple-ntpd

# Test project
./automation/scripts/project-automation test simple-ntpd

# Build all projects
./automation/scripts/project-automation all-build

# Check status
./automation/scripts/project-automation status
```

### VM Management
```bash
# List VMs
./automation/scripts/vm-manager list

# Start VM with project
PROJECT_NAME=simple-ntpd ./automation/scripts/vm-manager up ubuntu_dev

# Check VM status
./automation/scripts/vm-manager status

# Stop VM
./automation/scripts/vm-manager down ubuntu_dev
```

## 🏗️ Build Commands

### Inside VM (as nfsdev user)
```bash
# Basic build
make build
make test
make install

# Development
make debug
make clean
make rebuild

# Code quality
make format
make lint
make security-scan

# Packages
make package
make package-all

# Services
make service-install
make service-start
make service-status
```

## 📦 Package Commands

```bash
# Create packages
make package-deb    # Debian/Ubuntu
make package-rpm    # RedHat/CentOS
make package-msi    # Windows
make package-dmg    # macOS

# Install packages
sudo dpkg -i *.deb
sudo rpm -i *.rpm
```

## 🔧 Service Commands

```bash
# Service management
make service-install
make service-start
make service-stop
make service-restart
make service-status

# System commands
systemctl status simple-ntpd
journalctl -u simple-ntpd
```

## 🐳 Docker Commands

```bash
# Build and run
docker build -t simple-ntpd .
docker-compose up -d
docker-compose logs -f
```

## 🔍 Troubleshooting

### Common Issues
```bash
# VM won't start
./automation/scripts/vm-manager status
cd virtuals/ubuntu_dev && vagrant up --debug

# Build fails
./automation/scripts/project-automation clean simple-ntpd
./automation/scripts/project-automation build simple-ntpd

# Service issues
systemctl status simple-ntpd
journalctl -u simple-ntpd -f
```

### Help Commands
```bash
# Script help
./automation/scripts/setup-automation.sh --help
./automation/scripts/vm-manager --help
./automation/scripts/project-automation --help

# Makefile help
make help
make help-build
make help-test
make help-package
```

## 📁 Key Directories

| Directory | Purpose |
|-----------|---------|
| `/opt/simple-daemons/` | Project sources in VM |
| `/etc/simple-daemons/` | Configuration files |
| `/var/log/simple-daemons/` | Application logs |
| `projects/<project>/dist/` | Generated packages |
| `virtuals/` | VM configurations |

## 🌐 Ports

| Project | Port | Protocol |
|---------|------|----------|
| simple-ntpd | 123 | UDP |
| simple-httpd | 80, 443 | TCP |
| simple-rsyncd | 873 | TCP |
| simple-sftpd | 21, 990 | TCP |
| simple-snmpd | 161 | UDP |
| simple-tftpd | 69 | UDP |
| simple-utcd | 8080 | TCP |

## ⚡ Quick Workflows

### Daily Development
```bash
./automation/scripts/vm-manager up ubuntu_dev
./automation/scripts/vm-manager ssh ubuntu_dev
# Inside VM:
su - nfsdev
cd /opt/simple-daemons/simple-ntpd
make build && make test
```

### Multi-Project Testing
```bash
./automation/scripts/project-automation all-build
./automation/scripts/project-automation all-test
./automation/scripts/project-automation status
```

### Package Creation
```bash
cd projects/simple-ntpd
make package-all
ls dist/
```

### Service Deployment
```bash
make service-install
make service-start
make service-status
```

## 🎯 Environment Variables

```bash
# Set project for VM
export PROJECT_NAME=simple-ntpd

# Set custom project directory
export PROJECT_DIR=/path/to/project

# VM configuration
export VM_MEMORY=4096
export VM_CPUS=4
```

## 📋 Project List

- simple-dhcpd
- simple-dnsd
- simple-dummy
- simple-httpd
- simple-nfsd
- simple-ntpd
- simple-proxyd
- simple-rsyncd
- simple-sftpd
- simple-smbd
- simple-smtpd
- simple-snmpd
- simple-tftpd
- simple-utcd

---

**Need more help?** Check `DOCUMENTATION.md` for detailed information or use `--help` with any script.
