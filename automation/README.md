# SimpleDaemons Automation Infrastructure

This directory contains the complete automation infrastructure for all SimpleDaemons projects, including Vagrant configurations, Ansible playbooks, and standardization templates.

## 📁 Directory Structure

```
automation/
├── README.md                    # This file
├── ansible.cfg                  # Ansible configuration
├── inventory.ini                # Ansible inventory
├── playbook.yml                 # Main Ansible playbook
├── vagrant-boxes.yml            # Vagrant box configurations
├── scripts/
│   ├── setup-automation.sh      # Main automation setup script
│   ├── vm-manager               # VM management helper
│   └── project-automation       # Project automation helper
└── STANDARDIZATION_TEMPLATES/   # Standardization templates
    ├── implement_standardization.sh
    ├── Makefile.template
    ├── CMakeLists.template
    ├── Jenkinsfile
    ├── project-configs/
    └── deployment/
```

## 🚀 Quick Start

### 1. Setup Automation Infrastructure

```bash
# Run the complete automation setup
./automation/scripts/setup-automation.sh

# Or run specific components
./automation/scripts/setup-automation.sh --vagrant    # Vagrant only
./automation/scripts/setup-automation.sh --ansible    # Ansible only
./automation/scripts/setup-automation.sh --projects   # Projects only
```

### 2. Start Development VM

```bash
# Using VM manager (recommended)
./automation/scripts/vm-manager up ubuntu_dev

# Or manually
cd virtuals/ubuntu_dev && vagrant up
```

### 3. Work with Projects

```bash
# Build a specific project
./automation/scripts/project-automation build simple-ntpd

# Test all projects
./automation/scripts/project-automation all-test

# Check project status
./automation/scripts/project-automation status
```

## 🛠️ Components

### Vagrant Configuration

- **Multi-project VMs**: Each VM can work with any SimpleDaemons project
- **Dynamic project mounting**: Projects are mounted based on `PROJECT_NAME` environment variable
- **Ansible provisioning**: VMs are automatically provisioned with development tools
- **Cross-platform support**: Ubuntu and CentOS development environments

#### Available VMs

- `ubuntu_dev`: Ubuntu 22.04 LTS development environment
- `centos_dev`: CentOS 8 development environment

#### Usage

```bash
# Start VM with specific project
PROJECT_NAME=simple-ntpd ./automation/scripts/vm-manager up ubuntu_dev

# SSH into VM
./automation/scripts/vm-manager ssh ubuntu_dev

# Check VM status
./automation/scripts/vm-manager status
```

### Ansible Playbooks

- **Development environment setup**: Installs all necessary build tools and dependencies
- **Project configuration**: Sets up project directories and permissions
- **Service management**: Configures systemd services and log rotation
- **Development tools**: Installs debugging and analysis tools

#### Key Features

- **Multi-platform support**: Works on Ubuntu/Debian and CentOS/RHEL
- **Development user**: Creates dedicated `nfsdev` user for development
- **Project symlinks**: Creates symlinks to all projects in `/opt/simple-daemons/`
- **Helper scripts**: Installs development helper functions and aliases

### Standardization Templates

- **Comprehensive Makefiles**: Based on the best-in-class `simple-ntpd` Makefile
- **CMake configurations**: Full package generation support (DEB, RPM, MSI, DMG, PKG)
- **CI/CD integration**: Travis CI and Jenkins configurations
- **Service files**: Systemd, launchd, and Windows service configurations
- **Docker support**: Containerization templates

#### Supported Projects

All SimpleDaemons projects are supported:
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

## 🔧 Helper Scripts

### VM Manager (`vm-manager`)

Manages development VMs:

```bash
# List available VMs
./automation/scripts/vm-manager list

# Start VM
./automation/scripts/vm-manager up ubuntu_dev

# Start VM with specific project
./automation/scripts/vm-manager up ubuntu_dev simple-ntpd

# SSH into VM
./automation/scripts/vm-manager ssh ubuntu_dev

# Check VM status
./automation/scripts/vm-manager status

# Provision VM
./automation/scripts/vm-manager provision ubuntu_dev
```

### Project Automation (`project-automation`)

Manages project builds and operations:

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

# Build all projects
./automation/scripts/project-automation all-build

# Test all projects
./automation/scripts/project-automation all-test

# Check project status
./automation/scripts/project-automation status
```

## 📋 Development Workflow

### 1. Initial Setup

```bash
# Clone repository
git clone <repository-url>
cd SimpleDaemons

# Setup automation infrastructure
./automation/scripts/setup-automation.sh

# Start development VM
./automation/scripts/vm-manager up ubuntu_dev
```

### 2. Daily Development

```bash
# SSH into VM
./automation/scripts/vm-manager ssh ubuntu_dev

# Switch to development user
su - nfsdev

# Work with projects
cd /opt/simple-daemons/simple-ntpd
make build
make test
make install
```

### 3. Project Management

```bash
# Build specific project
./automation/scripts/project-automation build simple-ntpd

# Test all projects
./automation/scripts/project-automation all-test

# Check status
./automation/scripts/project-automation status
```

## 🐳 Docker Support

Each project includes Docker support:

```bash
# Build Docker image
cd projects/simple-ntpd
docker build -t simple-ntpd .

# Run with docker-compose
docker-compose up -d

# Check logs
docker-compose logs -f
```

## 🔍 Monitoring and Logs

### Log Locations

- **Application logs**: `/var/log/simple-daemons/`
- **Project-specific logs**: `/var/log/<project-name>/`
- **System logs**: `journalctl -u <project-name>`

### Service Management

```bash
# Check service status
systemctl status simple-ntpd

# Start service
systemctl start simple-ntpd

# Stop service
systemctl stop simple-ntpd

# Restart service
systemctl restart simple-ntpd
```

## 🧪 Testing

### Unit Tests

```bash
# Run tests for specific project
cd projects/simple-ntpd
make test

# Run tests for all projects
./automation/scripts/project-automation all-test
```

### Integration Tests

```bash
# Start test environment
./automation/scripts/vm-manager up ubuntu_dev

# SSH and run integration tests
./automation/scripts/vm-manager ssh ubuntu_dev
# Inside VM:
cd /opt/simple-daemons/simple-ntpd
make test-integration
```

## 📦 Packaging

### Supported Package Formats

- **Linux**: DEB (Debian/Ubuntu), RPM (RedHat/CentOS)
- **macOS**: DMG, PKG
- **Windows**: MSI, ZIP
- **Source**: TAR.GZ, ZIP

### Package Creation

```bash
# Create packages for specific project
cd projects/simple-ntpd
make package

# Create packages for all projects
./automation/scripts/project-automation all-package
```

## 🔧 Troubleshooting

### Common Issues

1. **VM won't start**
   ```bash
   # Check VM status
   ./automation/scripts/vm-manager status
   
   # Check Vagrant logs
   cd virtuals/ubuntu_dev
   vagrant up --debug
   ```

2. **Ansible provisioning fails**
   ```bash
   # Check Ansible configuration
   ansible-playbook --check automation/playbook.yml
   
   # Run with verbose output
   ansible-playbook -v automation/playbook.yml
   ```

3. **Project build fails**
   ```bash
   # Check project status
   ./automation/scripts/project-automation status simple-ntpd
   
   # Clean and rebuild
   ./automation/scripts/project-automation clean simple-ntpd
   ./automation/scripts/project-automation build simple-ntpd
   ```

### Getting Help

- Check project-specific README files in `projects/<project-name>/`
- Review Ansible playbook logs
- Check VM logs with `vagrant ssh` and `journalctl`
- Use `make help` in project directories for available targets

## 🔄 Maintenance

### Regular Updates

- Update dependencies quarterly
- Keep CI/CD configurations current
- Test on all supported platforms
- Update documentation as needed

### Adding New Projects

1. Create project configuration in `STANDARDIZATION_TEMPLATES/project-configs/`
2. Run standardization implementation
3. Test on development VMs
4. Update documentation

## 📞 Support

For questions or issues:
1. Check this README and project-specific documentation
2. Review the [comprehensive documentation](../docs/DOCUMENTATION.md)
3. Check the [troubleshooting guide](../docs/TROUBLESHOOTING.md)
4. Review automation script help: `./automation/scripts/setup-automation.sh --help`
5. Check VM manager help: `./automation/scripts/vm-manager --help`
6. Check project automation help: `./automation/scripts/project-automation --help`

---

**Note**: This automation infrastructure provides a complete development environment for all SimpleDaemons projects with standardized build systems, CI/CD integration, and comprehensive testing capabilities.

