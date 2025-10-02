# SimpleDaemons Developer Onboarding Guide

Welcome to SimpleDaemons! This guide will help you get up and running with the development environment quickly.

## 🎯 What You'll Learn

- How to set up your development environment
- How to work with SimpleDaemons projects
- How to use the automation tooling
- How to contribute to the project

## 📋 Prerequisites

Before you begin, ensure you have:

- **Vagrant** (2.2+) - [Download](https://www.vagrantup.com/downloads)
- **VirtualBox** (6.0+) - [Download](https://www.virtualbox.org/wiki/Downloads)
- **Ansible** (2.9+) - [Installation Guide](https://docs.ansible.com/ansible/latest/installation_guide/index.html)
- **Git** - [Download](https://git-scm.com/downloads)
- **Make** and **CMake** - Usually pre-installed on Linux/macOS

### Verify Installation

```bash
# Check versions
vagrant --version
ansible --version
git --version
make --version
cmake --version
```

## 🚀 Quick Setup (5 minutes)

### Step 1: Clone Repository

```bash
git clone <repository-url>
cd SimpleDaemons
```

### Step 2: Setup Automation

```bash
# This sets up all automation infrastructure
./automation/scripts/setup-automation.sh
```

### Step 3: Start Development VM

```bash
# Start Ubuntu development VM
./automation/scripts/vm-manager up ubuntu_dev

# SSH into VM
./automation/scripts/vm-manager ssh ubuntu_dev
```

### Step 4: Verify Setup

```bash
# Inside VM, switch to development user
su - nfsdev

# Check project status
./automation/scripts/project-automation status

# Try building a project
cd /opt/simple-daemons/simple-ntpd
make build
```

## 🏗️ Your First Build

Let's build and test the `simple-ntpd` project:

### Inside the VM

```bash
# Switch to development user
su - nfsdev

# Navigate to project
cd /opt/simple-daemons/simple-ntpd

# Build the project
make build

# Run tests
make test

# Install the project
make install

# Check if it's working
make service-install
make service-start
make service-status
```

### Expected Output

You should see:
- ✅ Successful build
- ✅ Tests passing
- ✅ Service installed and running
- ✅ Binary executable created

## 🔧 Development Workflow

### Daily Development Routine

```bash
# 1. Start your day
./automation/scripts/vm-manager up ubuntu_dev

# 2. SSH into VM
./automation/scripts/vm-manager ssh ubuntu_dev

# 3. Switch to development user
su - nfsdev

# 4. Work on your project
cd /opt/simple-daemons/simple-ntpd
make build
make test

# 5. End your day
exit  # Exit VM
./automation/scripts/vm-manager down ubuntu_dev
```

### Working with Multiple Projects

```bash
# Build all projects
./automation/scripts/project-automation all-build

# Test all projects
./automation/scripts/project-automation all-test

# Check status of all projects
./automation/scripts/project-automation status
```

## 📚 Understanding the Project Structure

### Project Layout

```
SimpleDaemons/
├── automation/           # Automation infrastructure
│   ├── scripts/         # Helper scripts
│   ├── playbook.yml     # Ansible playbook
│   └── inventory.ini    # Ansible inventory
├── projects/            # All SimpleDaemons projects
│   ├── simple-ntpd/     # NTP daemon
│   ├── simple-httpd/    # HTTP daemon
│   └── ...              # Other projects
└── virtuals/            # VM configurations
    ├── ubuntu_dev/      # Ubuntu development VM
    └── centos_dev/      # CentOS development VM
```

### Inside Each Project

```
simple-ntpd/
├── src/                 # Source code
├── include/             # Header files
├── tests/               # Test files
├── config/              # Configuration files
├── deployment/          # Service files
├── Makefile            # Build system
├── CMakeLists.txt      # CMake configuration
├── Jenkinsfile         # CI/CD pipeline
└── .travis.yml         # Travis CI configuration
```

## 🛠️ Available Tools

### VM Manager (`vm-manager`)

Manages development VMs:

```bash
# List available VMs
./automation/scripts/vm-manager list

# Start VM with specific project
PROJECT_NAME=simple-ntpd ./automation/scripts/vm-manager up ubuntu_dev

# SSH into VM
./automation/scripts/vm-manager ssh ubuntu_dev

# Check VM status
./automation/scripts/vm-manager status
```

### Project Automation (`project-automation`)

Handles project operations:

```bash
# Build specific project
./automation/scripts/project-automation build simple-ntpd

# Test specific project
./automation/scripts/project-automation test simple-ntpd

# Build all projects
./automation/scripts/project-automation all-build
```

### Makefile Targets

Each project has comprehensive build targets:

```bash
# Core targets
make build          # Build project
make test           # Run tests
make install        # Install project
make clean          # Clean build artifacts

# Development targets
make debug          # Debug build
make format         # Format code
make lint           # Static analysis
make security-scan  # Security scanning

# Package targets
make package        # Create packages
make package-deb    # DEB package
make package-rpm    # RPM package

# Service targets
make service-install # Install service
make service-start   # Start service
make service-status  # Check status
```

## 🧪 Testing Your Changes

### Unit Tests

```bash
# Run tests for current project
make test

# Run tests with verbose output
make test-verbose

# Generate coverage report
make coverage
```

### Integration Tests

```bash
# Test service installation
make service-install
make service-start
make service-status

# Test package creation
make package
ls dist/
```

### Multi-Platform Testing

```bash
# Test on Ubuntu
./automation/scripts/vm-manager up ubuntu_dev
# Run tests

# Test on CentOS
./automation/scripts/vm-manager up centos_dev
# Run tests
```

## 📦 Creating Packages

### Package Types

- **DEB**: Debian/Ubuntu packages
- **RPM**: RedHat/CentOS packages
- **MSI**: Windows packages
- **DMG**: macOS packages
- **ZIP/TAR.GZ**: Source packages

### Creating Packages

```bash
# Create all packages
make package-all

# Create specific package type
make package-deb    # For Debian/Ubuntu
make package-rpm    # For RedHat/CentOS
```

### Installing Packages

```bash
# Install DEB package
sudo dpkg -i simple-ntpd-0.1.0-Linux.deb

# Install RPM package
sudo rpm -i simple-ntpd-0.1.0-Linux.rpm
```

## 🔄 CI/CD Integration

### Travis CI

Each project has a `.travis.yml` file for automated testing:

```yaml
language: cpp
script:
  - make build
  - make test
  - make package
```

### Jenkins

Each project has a `Jenkinsfile` for comprehensive CI/CD:

```groovy
pipeline {
    stages {
        stage('Build') { steps { sh 'make build' } }
        stage('Test') { steps { sh 'make test' } }
        stage('Package') { steps { sh 'make package' } }
    }
}
```

## 🐛 Troubleshooting

### Common Issues

#### VM Won't Start

```bash
# Check VM status
./automation/scripts/vm-manager status

# Check VirtualBox
VBoxManage list vms

# Check Vagrant logs
cd virtuals/ubuntu_dev
vagrant up --debug
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
```

#### Service Issues

```bash
# Check service status
systemctl status simple-ntpd

# Check logs
journalctl -u simple-ntpd -f

# Restart service
systemctl restart simple-ntpd
```

### Getting Help

```bash
# Script help
./automation/scripts/vm-manager --help
./automation/scripts/project-automation --help

# Makefile help
make help
make help-build
make help-test
```

## 🎯 Best Practices

### Development

1. **Always use VMs** for development
2. **Test on multiple platforms** before committing
3. **Use automation scripts** instead of manual commands
4. **Check project status** regularly
5. **Clean builds** when switching projects

### Code Quality

1. **Run tests** before committing
2. **Use code formatting** (`make format`)
3. **Run static analysis** (`make lint`)
4. **Check security** (`make security-scan`)
5. **Follow coding standards**

### Git Workflow

1. **Create feature branches** for new work
2. **Write descriptive commit messages**
3. **Test thoroughly** before merging
4. **Use pull requests** for code review
5. **Keep commits focused** and atomic

## 🚀 Next Steps

### Explore Projects

```bash
# List all projects
./automation/scripts/project-automation list

# Check status of all projects
./automation/scripts/project-automation status

# Build all projects
./automation/scripts/project-automation all-build
```

### Learn More

- Read `DOCUMENTATION.md` for comprehensive information
- Check `QUICK_REFERENCE.md` for common commands
- Explore individual project README files
- Use `--help` with any script for detailed help

### Contribute

1. **Fork the repository**
2. **Create a feature branch**
3. **Make your changes**
4. **Test thoroughly**
5. **Submit a pull request**

## 📞 Getting Help

### Resources

- **Documentation**: `DOCUMENTATION.md`
- **Quick Reference**: `QUICK_REFERENCE.md`
- **Project READMEs**: Individual project documentation
- **Script Help**: Use `--help` with any script

### Support

- Check troubleshooting section above
- Review automation script help
- Check VM and project status
- Use `make help` for build system help

---

**Welcome to SimpleDaemons!** 🎉

You're now ready to start developing. Remember to use the automation tools and follow the best practices outlined in this guide. Happy coding!
