# SimpleDaemons Automation Tooling Documentation

## 📚 Table of Contents

1. [Overview](#overview)
2. [Quick Start Guide](#quick-start-guide)
3. [VM Management](#vm-management)
4. [Project Automation](#project-automation)
5. [Development Workflows](#development-workflows)
6. [Build System](#build-system)
7. [CI/CD Integration](#cicd-integration)
8. [Package Management](#package-management)
9. [Service Management](#service-management)
10. [Troubleshooting](#troubleshooting)
11. [Advanced Usage](#advanced-usage)
12. [Reference](#reference)

## 🎯 Overview

The SimpleDaemons automation tooling provides a complete development and deployment infrastructure for all 14 SimpleDaemons projects. It includes:

- **Standardized build systems** across all projects
- **Automated VM provisioning** with development environments
- **Cross-platform package generation** (Linux, macOS, Windows)
- **CI/CD integration** with Travis CI and Jenkins
- **Service management** for production deployments
- **Helper scripts** for common development tasks

## 🚀 Quick Start Guide

### Prerequisites

- **Vagrant** (2.2+)
- **VirtualBox** (6.0+)
- **Ansible** (2.9+)
- **Git**
- **Make** and **CMake**

### Initial Setup

```bash
# 1. Clone the repository
git clone <repository-url>
cd SimpleDaemons

# 2. Setup automation infrastructure
./automation/scripts/setup-automation.sh

# 3. Start a development VM
./automation/scripts/vm-manager up ubuntu_dev

# 4. SSH into the VM
./automation/scripts/vm-manager ssh ubuntu_dev
```

### First Project Build

```bash
# Inside the VM (as nfsdev user)
cd /opt/simple-daemons/simple-ntpd
make build
make test
make install
```

## 🖥️ VM Management

The VM manager (`vm-manager`) provides a unified interface for managing development VMs.

### Available Commands

```bash
# List available VMs
./automation/scripts/vm-manager list

# Start a VM
./automation/scripts/vm-manager up ubuntu_dev

# Start VM with specific project
./automation/scripts/vm-manager up ubuntu_dev simple-ntpd

# SSH into VM
./automation/scripts/vm-manager ssh ubuntu_dev

# Check VM status
./automation/scripts/vm-manager status

# Stop VM
./automation/scripts/vm-manager down ubuntu_dev

# Re-provision VM
./automation/scripts/vm-manager provision ubuntu_dev
```

### VM Types

- **`ubuntu_dev`**: Ubuntu 22.04 LTS development environment
- **`centos_dev`**: CentOS 8 development environment

### Environment Variables

```bash
# Set project for VM
export PROJECT_NAME=simple-ntpd
./automation/scripts/vm-manager up ubuntu_dev

# Set custom project directory
export PROJECT_DIR=/path/to/custom/project
./automation/scripts/vm-manager up ubuntu_dev
```

## 🔧 Project Automation

The project automation script (`project-automation`) handles all project-related operations.

### Available Commands

```bash
# List available projects
./automation/scripts/project-automation list

# Build specific project
./automation/scripts/project-automation build simple-ntpd

# Test specific project
./automation/scripts/project-automation test simple-ntpd

# Install specific project
./automation/scripts/project-automation install simple-ntpd

# Package specific project
./automation/scripts/project-automation package simple-ntpd

# Clean specific project
./automation/scripts/project-automation clean simple-ntpd

# Show project status
./automation/scripts/project-automation status simple-ntpd

# Build all projects
./automation/scripts/project-automation all-build

# Test all projects
./automation/scripts/project-automation all-test

# Clean all projects
./automation/scripts/project-automation all-clean
```

### Options

```bash
# Verbose output
./automation/scripts/project-automation build simple-ntpd --verbose

# Force operations
./automation/scripts/project-automation clean simple-ntpd --force
```

## 💻 Development Workflows

### Daily Development Workflow

```bash
# 1. Start development VM
./automation/scripts/vm-manager up ubuntu_dev

# 2. SSH into VM
./automation/scripts/vm-manager ssh ubuntu_dev

# 3. Switch to development user
su - nfsdev

# 4. Work with projects
cd /opt/simple-daemons/simple-ntpd
make build
make test
make install

# 5. Check status
./automation/scripts/project-automation status simple-ntpd
```

### Multi-Project Development

```bash
# Build all projects
./automation/scripts/project-automation all-build

# Test all projects
./automation/scripts/project-automation all-test

# Check status of all projects
./automation/scripts/project-automation status
```

### Project-Specific Development

```bash
# Start VM with specific project
PROJECT_NAME=simple-ntpd ./automation/scripts/vm-manager up ubuntu_dev

# SSH and work with the project
./automation/scripts/vm-manager ssh ubuntu_dev
# Inside VM:
cd /opt/simple-daemons/simple-ntpd
make build
make test
```

## 🏗️ Build System

Each project now has a comprehensive Makefile with 50+ targets.

### Core Build Targets

```bash
# Basic build operations
make build          # Build the project
make clean          # Clean build artifacts
make rebuild        # Clean and rebuild
make install        # Install the project
make uninstall      # Uninstall the project

# Development builds
make debug          # Build with debug symbols
make release        # Build with optimizations
make sanitize       # Build with sanitizers
```

### Testing Targets

```bash
# Testing
make test           # Run unit tests
make test-verbose   # Run tests with verbose output
make test-integration # Run integration tests
make coverage       # Generate coverage report
```

### Code Quality Targets

```bash
# Code quality
make format         # Format source code
make check-style    # Check code style
make lint           # Run static analysis
make security-scan  # Run security scanning
make analyze        # Run static analysis
```

### Package Targets

```bash
# Package creation
make package        # Create platform-specific packages
make package-source # Create source packages
make package-all    # Create all packages

# Individual package types
make package-deb    # DEB package (Linux)
make package-rpm    # RPM package (Linux)
make package-msi    # MSI package (Windows)
make package-dmg    # DMG package (macOS)
make package-pkg    # PKG package (macOS)
```

### Service Management Targets

```bash
# Service management
make service-install   # Install system service
make service-uninstall # Uninstall system service
make service-start     # Start service
make service-stop      # Stop service
make service-restart   # Restart service
make service-status    # Check service status
make service-enable    # Enable service
make service-disable   # Disable service
```

### Help and Information

```bash
# Help
make help           # Show all available targets
make help-build     # Show build-related targets
make help-test      # Show test-related targets
make help-package   # Show package-related targets
make help-service   # Show service-related targets
```

## 🔄 CI/CD Integration

### Travis CI

Each project includes a `.travis.yml` file for automated testing:

```yaml
# Example .travis.yml structure
language: cpp
compiler:
  - gcc
  - clang
os:
  - linux
  - osx
script:
  - make build
  - make test
  - make package
```

### Jenkins

Each project includes a `Jenkinsfile` for comprehensive CI/CD:

```groovy
// Example Jenkinsfile structure
pipeline {
    agent any
    stages {
        stage('Build') {
            steps {
                sh 'make build'
            }
        }
        stage('Test') {
            steps {
                sh 'make test'
            }
        }
        stage('Package') {
            steps {
                sh 'make package'
            }
        }
    }
}
```

### Running CI Locally

```bash
# Test Travis CI configuration
travis lint .travis.yml

# Test Jenkins pipeline
jenkinsfile-runner --file Jenkinsfile
```

## 📦 Package Management

### Supported Package Formats

- **Linux**: DEB (Debian/Ubuntu), RPM (RedHat/CentOS)
- **macOS**: DMG, PKG
- **Windows**: MSI, ZIP
- **Source**: TAR.GZ, ZIP

### Package Creation

```bash
# Create all packages for a project
cd projects/simple-ntpd
make package-all

# Create specific package type
make package-deb    # For Debian/Ubuntu
make package-rpm    # For RedHat/CentOS
make package-msi    # For Windows
make package-dmg    # For macOS
```

### Package Installation

```bash
# Install DEB package
sudo dpkg -i simple-ntpd-0.1.0-Linux.deb

# Install RPM package
sudo rpm -i simple-ntpd-0.1.0-Linux.rpm

# Install MSI package (Windows)
msiexec /i simple-ntpd-0.1.0-Windows.msi

# Install DMG package (macOS)
open simple-ntpd-0.1.0-macOS.dmg
```

### Package Contents

Each package includes:
- **Binary executable**
- **Configuration files**
- **Service files** (systemd, launchd, Windows)
- **Documentation**
- **Dependencies**

## 🔧 Service Management

### Service Installation

```bash
# Install service
make service-install

# Start service
make service-start

# Check service status
make service-status

# Stop service
make service-stop
```

### Service Configuration

Services are configured for each platform:

- **Linux**: systemd service files
- **macOS**: launchd plist files
- **Windows**: Windows service configuration

### Service Files Location

- **Linux**: `/etc/systemd/system/simple-ntpd.service`
- **macOS**: `/Library/LaunchDaemons/com.simple-ntpd.simple-ntpd.plist`
- **Windows**: Windows Service Registry

### Log Management

```bash
# View service logs
journalctl -u simple-ntpd

# View application logs
tail -f /var/log/simple-daemons/simple-ntpd.log

# Configure log rotation
make log-rotate
```

## 🐛 Troubleshooting

### Common Issues

#### VM Won't Start

```bash
# Check VM status
./automation/scripts/vm-manager status

# Check Vagrant logs
cd virtuals/ubuntu_dev
vagrant up --debug

# Check VirtualBox
VBoxManage list vms
VBoxManage showvminfo simple-daemons-ubuntu-dev
```

#### Build Failures

```bash
# Check project status
./automation/scripts/project-automation status simple-ntpd

# Clean and rebuild
./automation/scripts/project-automation clean simple-ntpd
./automation/scripts/project-automation build simple-ntpd

# Check dependencies
make deps
make dev-deps
```

#### Ansible Provisioning Issues

```bash
# Check Ansible configuration
ansible-playbook --check automation/playbook.yml

# Run with verbose output
ansible-playbook -v automation/playbook.yml

# Check inventory
ansible-inventory --list
```

#### Service Issues

```bash
# Check service status
systemctl status simple-ntpd

# Check service logs
journalctl -u simple-ntpd -f

# Restart service
systemctl restart simple-ntpd
```

### Getting Help

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
make help-service
```

## 🔬 Advanced Usage

### Custom VM Configuration

```bash
# Create custom VM configuration
cp virtuals/ubuntu_dev/Vagrantfile virtuals/custom_dev/Vagrantfile

# Modify configuration
vim virtuals/custom_dev/Vagrantfile

# Use custom VM
./automation/scripts/vm-manager up custom_dev
```

### Custom Ansible Playbooks

```bash
# Create custom playbook
cp automation/playbook.yml automation/custom-playbook.yml

# Modify playbook
vim automation/custom-playbook.yml

# Use custom playbook
cd virtuals/ubuntu_dev
vagrant provision --provision-with ansible
```

### Project-Specific Customization

```bash
# Customize project configuration
vim projects/STANDARDIZATION_TEMPLATES/project-configs/simple-ntpd.conf

# Re-implement standardization
cd projects/STANDARDIZATION_TEMPLATES
./implement_standardization.sh simple-ntpd --force
```

### Docker Integration

```bash
# Build Docker image
cd projects/simple-ntpd
docker build -t simple-ntpd .

# Run with docker-compose
docker-compose up -d

# Check logs
docker-compose logs -f
```

### Multi-Platform Development

```bash
# Test on multiple platforms
./automation/scripts/vm-manager up ubuntu_dev
./automation/scripts/vm-manager up centos_dev

# Build for multiple platforms
./automation/scripts/project-automation build simple-ntpd
# Test on Ubuntu VM
# Test on CentOS VM
```

## 📖 Reference

### Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `PROJECT_NAME` | Project to work with | None |
| `PROJECT_DIR` | Custom project directory | `../<project>` |
| `VAGRANT_BOX` | Vagrant box to use | `ubuntu/jammy64` |
| `VM_HOSTNAME` | VM hostname | `simple-daemons-dev` |
| `VM_IP` | VM IP address | `192.168.1.100` |
| `VM_MEMORY` | VM memory (MB) | `2048` |
| `VM_CPUS` | VM CPU count | `2` |

### File Locations

| Component | Location |
|-----------|----------|
| Projects | `/opt/simple-daemons/` |
| Configs | `/etc/simple-daemons/` |
| Logs | `/var/log/simple-daemons/` |
| Services | `/etc/systemd/system/` |
| Packages | `projects/<project>/dist/` |

### Port Mappings

| Project | Port | Protocol |
|---------|------|----------|
| simple-dhcpd | 67, 68 | UDP |
| simple-dnsd | 53 | UDP/TCP |
| simple-httpd | 80, 443 | TCP |
| simple-ntpd | 123 | UDP |
| simple-rsyncd | 873 | TCP |
| simple-sftpd | 21, 990 | TCP |
| simple-snmpd | 161 | UDP |
| simple-tftpd | 69 | UDP |
| simple-utcd | 8080 | TCP |

### Dependencies

| Project | Dependencies |
|---------|--------------|
| Most projects | OpenSSL, JsonCPP |
| simple-tftpd | None (minimal) |
| All projects | CMake, Make, GCC/G++ |

## 🎯 Best Practices

### Development

1. **Always use VMs** for development to ensure consistency
2. **Test on multiple platforms** before deployment
3. **Use the automation scripts** instead of manual commands
4. **Check project status** regularly with `project-automation status`
5. **Clean builds** when switching between projects

### Deployment

1. **Test packages** before distribution
2. **Verify service installation** on target platforms
3. **Check log rotation** configuration
4. **Monitor service status** after deployment
5. **Use CI/CD pipelines** for automated testing

### Maintenance

1. **Update dependencies** regularly
2. **Keep VM images** up to date
3. **Test automation scripts** after changes
4. **Document customizations**
5. **Backup configurations** before major changes

---

This documentation provides comprehensive guidance for using all the SimpleDaemons automation tooling. For additional help, check the individual project README files or use the `--help` option with any automation script.
