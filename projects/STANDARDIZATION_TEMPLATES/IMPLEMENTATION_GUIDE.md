# Standardization Implementation Guide

This guide will help you implement the standardized build system across all SimpleDaemons projects.

## Overview

The standardization package includes:
- **Makefile.template** - Comprehensive build system based on simple-ntpd
- **.travis.yml** - Travis CI configuration
- **Jenkinsfile** - Jenkins Pipeline configuration
- **Project-specific configurations** - Customized settings for each project

## Project-Specific Customizations

Each project needs the following customizations:

### 1. Project Information
- `{{PROJECT_NAME}}` - Project name (e.g., simple-ntpd, simple-httpd)
- `{{PROJECT_DESCRIPTION}}` - Brief description
- `{{VERSION}}` - Current version
- `{{YEAR}}` - Copyright year
- `{{DEFAULT_PORT}}` - Default service port
- `{{SERVICE_NAME}}` - Windows service name

### 2. Dependencies
- **SSL/TLS**: Most projects use OpenSSL
- **JSON**: Most projects use JsonCPP
- **Platform-specific**: Some projects may need additional libraries

### 3. Service Configuration
- **Port numbers**: Each daemon uses different ports
- **Service names**: Different for each project
- **Configuration files**: Project-specific configs

## Implementation Steps

### Step 1: Prepare Project Information

For each project, gather:
```bash
PROJECT_NAME="simple-ntpd"
PROJECT_DESCRIPTION="Simple NTP Daemon - A lightweight and secure NTP server"
VERSION="0.1.0"
YEAR="2024"
DEFAULT_PORT="123"
SERVICE_NAME="SimpleNTPDaemon"
```

### Step 2: Customize Templates

Use the provided script or manually replace placeholders:

```bash
# Example for simple-ntpd
sed -i 's/{{PROJECT_NAME}}/simple-ntpd/g' Makefile.template
sed -i 's/{{PROJECT_DESCRIPTION}}/Simple NTP Daemon - A lightweight and secure NTP server/g' Makefile.template
sed -i 's/{{VERSION}}/0.1.0/g' Makefile.template
sed -i 's/{{YEAR}}/2024/g' Makefile.template
sed -i 's/{{DEFAULT_PORT}}/123/g' Makefile.template
sed -i 's/{{SERVICE_NAME}}/SimpleNTPDaemon/g' Makefile.template
```

### Step 3: Project-Specific Files

Each project needs these additional files:

#### CMakeLists.txt
Ensure your CMakeLists.txt supports:
- Platform detection
- Package generation (CPack)
- Testing (CTest)
- Installation targets

#### Service Files
Create service files in `deployment/`:
- `systemd/{{PROJECT_NAME}}.service` (Linux)
- `launchd/com.{{PROJECT_NAME}}.{{PROJECT_NAME}}.plist` (macOS)
- Windows service configuration

#### Docker Support
- `Dockerfile` for containerization
- `docker-compose.yml` for local development

### Step 4: CI/CD Configuration

#### Travis CI
1. Enable Travis CI for your repository
2. Add `.travis.yml` to repository root
3. Configure environment variables in Travis dashboard

#### Jenkins
1. Create new Pipeline job
2. Point to Jenkinsfile in repository
3. Configure credentials and environment variables

### Step 5: Testing

Test the implementation:

```bash
# Basic build
make build

# Run tests
make test

# Check code style
make check-style

# Run static analysis
make lint

# Security scan
make security-scan

# Create packages
make package

# Service management
make service-install
make service-status
```

## Project-Specific Configurations

### simple-ntpd
- **Port**: 123 (UDP)
- **Dependencies**: OpenSSL, JsonCPP
- **Service**: SimpleNTPDaemon

### simple-httpd
- **Port**: 80, 443 (TCP)
- **Dependencies**: OpenSSL, JsonCPP
- **Service**: SimpleHTTPDaemon

### simple-rsyncd
- **Port**: 873 (TCP)
- **Dependencies**: OpenSSL, JsonCPP
- **Service**: SimpleRSyncDaemon

### simple-sftpd
- **Port**: 21, 990 (TCP)
- **Dependencies**: OpenSSL, JsonCPP
- **Service**: SimpleSFTPDaemon

### simple-snmpd
- **Port**: 161 (UDP)
- **Dependencies**: OpenSSL, JsonCPP
- **Service**: SimpleSNMPDaemon

### simple-tftpd
- **Port**: 69 (UDP)
- **Dependencies**: None (minimal)
- **Service**: SimpleTftpDaemon

### simple-utcd
- **Port**: 8080 (TCP)
- **Dependencies**: OpenSSL, JsonCPP
- **Service**: SimpleUTCDaemon

## Validation Checklist

- [ ] Makefile works on all platforms (Linux, macOS, Windows)
- [ ] All targets execute without errors
- [ ] Tests pass
- [ ] Code style checks pass
- [ ] Static analysis passes
- [ ] Security scans pass
- [ ] Packages are created successfully
- [ ] Service installation works
- [ ] Docker builds and runs
- [ ] CI/CD pipelines work
- [ ] Documentation is updated

## Troubleshooting

### Common Issues

1. **Missing dependencies**
   - Run `make deps` to install dependencies
   - Check platform-specific installation instructions

2. **Service installation fails**
   - Ensure service files exist in `deployment/` directory
   - Check file permissions

3. **Package creation fails**
   - Ensure CPack is configured in CMakeLists.txt
   - Check that all required files are included

4. **CI/CD failures**
   - Check environment variables
   - Verify build scripts work locally
   - Check platform-specific requirements

### Getting Help

- Check project-specific README files
- Review CI/CD logs for detailed error messages
- Test locally before pushing to CI/CD
- Use `make help` for available targets

## Maintenance

### Regular Updates
- Update dependencies regularly
- Keep CI/CD configurations current
- Test on all supported platforms
- Update documentation as needed

### Version Management
- Update version numbers consistently
- Tag releases appropriately
- Maintain changelog
- Update package metadata

## Next Steps

1. Implement standardization for one project as a pilot
2. Test thoroughly on all platforms
3. Gather feedback and refine templates
4. Roll out to remaining projects
5. Set up monitoring and maintenance procedures
