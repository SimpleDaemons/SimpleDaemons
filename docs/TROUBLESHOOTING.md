# SimpleDaemons Troubleshooting Guide

This guide helps you diagnose and fix common issues with the SimpleDaemons automation tooling.

## 🔍 Quick Diagnostics

### Check System Status

```bash
# Check VM status
./automation/scripts/vm-manager status

# Check project status
./automation/scripts/project-automation status

# Check automation setup
./automation/scripts/setup-automation.sh --help
```

### Verify Prerequisites

```bash
# Check required tools
vagrant --version
ansible --version
git --version
make --version
cmake --version
```

## 🖥️ VM Issues

### VM Won't Start

#### Symptoms
- `vagrant up` fails
- VM doesn't appear in VirtualBox
- Error messages about VM creation

#### Diagnosis

```bash
# Check VM status
./automation/scripts/vm-manager status

# Check VirtualBox
VBoxManage list vms

# Check Vagrant logs
cd virtuals/ubuntu_dev
vagrant up --debug
```

#### Solutions

1. **VirtualBox Issues**
   ```bash
   # Restart VirtualBox service
   sudo systemctl restart vboxdrv
   
   # Check VirtualBox version
   VBoxManage --version
   
   # Reinstall VirtualBox if needed
   ```

2. **Vagrant Issues**
   ```bash
   # Check Vagrant version
   vagrant --version
   
   # Update Vagrant
   vagrant plugin update
   
   # Clean Vagrant cache
   vagrant box prune
   ```

3. **Resource Issues**
   ```bash
   # Check system resources
   free -h
   df -h
   
   # Reduce VM memory if needed
   export VM_MEMORY=1024
   ./automation/scripts/vm-manager up ubuntu_dev
   ```

4. **Network Issues**
   ```bash
   # Check network configuration
   ip addr show
   
   # Check if ports are available
   netstat -tulpn | grep 192.168.1
   
   # Use different IP range
   export VM_IP=192.168.2.100
   ```

### VM Starts But Can't SSH

#### Symptoms
- VM starts successfully
- SSH connection fails
- Timeout errors

#### Diagnosis

```bash
# Check VM status
vagrant status

# Check SSH configuration
vagrant ssh-config

# Test SSH manually
ssh -i ~/.vagrant.d/insecure_private_key vagrant@192.168.1.100
```

#### Solutions

1. **SSH Key Issues**
   ```bash
   # Regenerate SSH keys
   vagrant destroy
   vagrant up
   
   # Check SSH key permissions
   chmod 600 ~/.vagrant.d/insecure_private_key
   ```

2. **Network Issues**
   ```bash
   # Check VM network
   vagrant ssh
   # Inside VM:
   ip addr show
   ping 8.8.8.8
   ```

3. **Firewall Issues**
   ```bash
   # Check firewall status
   sudo ufw status
   
   # Allow Vagrant network
   sudo ufw allow from 192.168.1.0/24
   ```

### VM Provisioning Fails

#### Symptoms
- VM starts but Ansible provisioning fails
- Error messages about package installation
- Services not properly configured

#### Diagnosis

```bash
# Check Ansible configuration
ansible-playbook --check automation/playbook.yml

# Run with verbose output
ansible-playbook -v automation/playbook.yml

# Check inventory
ansible-inventory --list
```

#### Solutions

1. **Ansible Issues**
   ```bash
   # Check Ansible version
   ansible --version
   
   # Update Ansible
   pip install --upgrade ansible
   
   # Check Python interpreter
   ansible-playbook -e ansible_python_interpreter=/usr/bin/python3 automation/playbook.yml
   ```

2. **Package Installation Issues**
   ```bash
   # Check package repositories
   vagrant ssh
   # Inside VM:
   sudo apt update
   sudo apt upgrade
   
   # Check disk space
   df -h
   ```

3. **Permission Issues**
   ```bash
   # Check file permissions
   ls -la automation/
   
   # Fix permissions
   chmod +x automation/scripts/*
   ```

## 🏗️ Build Issues

### Build Failures

#### Symptoms
- `make build` fails
- Compilation errors
- Missing dependencies

#### Diagnosis

```bash
# Check project status
./automation/scripts/project-automation status simple-ntpd

# Check build output
cd projects/simple-ntpd
make build 2>&1 | tee build.log

# Check dependencies
make deps
```

#### Solutions

1. **Missing Dependencies**
   ```bash
   # Install build dependencies
   make deps
   
   # Install development dependencies
   make dev-deps
   
   # Check system packages
   sudo apt update
   sudo apt install build-essential cmake
   ```

2. **CMake Issues**
   ```bash
   # Check CMake version
   cmake --version
   
   # Clean CMake cache
   rm -rf build/CMakeCache.txt
   make build
   
   # Check CMake configuration
   cd build
   cmake .. -DCMAKE_BUILD_TYPE=Debug
   ```

3. **Compiler Issues**
   ```bash
   # Check compiler version
   gcc --version
   g++ --version
   
   # Use specific compiler
   export CC=gcc-9
   export CXX=g++-9
   make build
   ```

### Test Failures

#### Symptoms
- `make test` fails
- Tests timeout
- Test environment issues

#### Diagnosis

```bash
# Run tests with verbose output
make test-verbose

# Check test logs
cd build
ctest --verbose

# Check test configuration
cat CMakeLists.txt | grep -A 10 "add_test"
```

#### Solutions

1. **Test Environment Issues**
   ```bash
   # Check test dependencies
   make test-deps
   
   # Run individual tests
   cd build
   ctest -R "test_name" --verbose
   ```

2. **Permission Issues**
   ```bash
   # Check file permissions
   ls -la tests/
   
   # Fix permissions
   chmod +x tests/*
   ```

3. **Resource Issues**
   ```bash
   # Check system resources
   free -h
   df -h
   
   # Reduce parallel test jobs
   export CTEST_PARALLEL_LEVEL=1
   make test
   ```

## 📦 Package Issues

### Package Creation Fails

#### Symptoms
- `make package` fails
- Missing package files
- CPack errors

#### Diagnosis

```bash
# Check package configuration
cd build
cpack --config CPackConfig.cmake

# Check CMake package configuration
cat CMakeLists.txt | grep -A 20 "CPack"
```

#### Solutions

1. **CPack Issues**
   ```bash
   # Check CPack version
   cpack --version
   
   # Clean build directory
   make clean
   make build
   make package
   ```

2. **Missing Files**
   ```bash
   # Check file installation
   make install DESTDIR=/tmp/test
   ls -la /tmp/test/
   
   # Check CMake install rules
   cat CMakeLists.txt | grep -A 10 "install"
   ```

3. **Package Dependencies**
   ```bash
   # Check package dependencies
   dpkg -l | grep -E "(openssl|jsoncpp)"
   
   # Install missing packages
   sudo apt install libssl-dev libjsoncpp-dev
   ```

### Package Installation Fails

#### Symptoms
- Package installation fails
- Dependency conflicts
- Permission errors

#### Diagnosis

```bash
# Check package contents
dpkg -c simple-ntpd-0.1.0-Linux.deb

# Check package dependencies
dpkg -I simple-ntpd-0.1.0-Linux.deb

# Check system packages
dpkg -l | grep simple-ntpd
```

#### Solutions

1. **Dependency Issues**
   ```bash
   # Install dependencies
   sudo apt install libssl1.1 libjsoncpp1
   
   # Check dependency versions
   apt-cache policy libssl1.1
   ```

2. **Permission Issues**
   ```bash
   # Check file permissions
   ls -la /usr/local/bin/simple-ntpd
   
   # Fix permissions
   sudo chmod +x /usr/local/bin/simple-ntpd
   ```

3. **Conflicting Packages**
   ```bash
   # Remove conflicting packages
   sudo apt remove simple-ntpd
   
   # Clean package cache
   sudo apt clean
   sudo apt update
   ```

## 🔧 Service Issues

### Service Won't Start

#### Symptoms
- `make service-start` fails
- Service status shows failed
- Error messages in logs

#### Diagnosis

```bash
# Check service status
systemctl status simple-ntpd

# Check service logs
journalctl -u simple-ntpd -f

# Check service file
cat /etc/systemd/system/simple-ntpd.service
```

#### Solutions

1. **Service File Issues**
   ```bash
   # Check service file syntax
   systemd-analyze verify /etc/systemd/system/simple-ntpd.service
   
   # Reload systemd
   sudo systemctl daemon-reload
   ```

2. **Binary Issues**
   ```bash
   # Check binary exists
   ls -la /usr/local/bin/simple-ntpd
   
   # Check binary permissions
   sudo chmod +x /usr/local/bin/simple-ntpd
   
   # Test binary manually
   /usr/local/bin/simple-ntpd --help
   ```

3. **Configuration Issues**
   ```bash
   # Check configuration file
   ls -la /etc/simple-daemons/
   
   # Check configuration syntax
   simple-ntpd --config-check
   ```

### Service Crashes

#### Symptoms
- Service starts but crashes
- Error messages in logs
- Service restarts repeatedly

#### Diagnosis

```bash
# Check service logs
journalctl -u simple-ntpd -f

# Check system logs
dmesg | tail -20

# Check resource usage
top -p $(pgrep simple-ntpd)
```

#### Solutions

1. **Resource Issues**
   ```bash
   # Check memory usage
   free -h
   
   # Check disk space
   df -h
   
   # Check file descriptors
   lsof -p $(pgrep simple-ntpd)
   ```

2. **Configuration Issues**
   ```bash
   # Check configuration file
   cat /etc/simple-daemons/simple-ntpd.conf
   
   # Validate configuration
   simple-ntpd --config-check
   ```

3. **Dependency Issues**
   ```bash
   # Check library dependencies
   ldd /usr/local/bin/simple-ntpd
   
   # Check library versions
   ldconfig -p | grep ssl
   ```

## 🔄 CI/CD Issues

### Travis CI Failures

#### Symptoms
- Travis CI builds fail
- Test failures in CI
- Environment issues

#### Diagnosis

```bash
# Check Travis configuration
travis lint .travis.yml

# Test locally
docker run -it ubuntu:20.04
# Inside container:
apt update && apt install -y build-essential cmake
make build
make test
```

#### Solutions

1. **Configuration Issues**
   ```bash
   # Validate Travis configuration
   travis lint .travis.yml
   
   # Check Travis status
   travis status
   ```

2. **Environment Issues**
   ```bash
   # Test with different Ubuntu versions
   # Update .travis.yml with different dist versions
   ```

### Jenkins Failures

#### Symptoms
- Jenkins pipeline fails
- Build failures
- Test failures

#### Diagnosis

```bash
# Check Jenkinsfile syntax
jenkinsfile-runner --file Jenkinsfile

# Test pipeline locally
docker run -it jenkins/jenkinsfile-runner
```

#### Solutions

1. **Pipeline Issues**
   ```bash
   # Check Jenkinsfile syntax
   jenkinsfile-runner --file Jenkinsfile
   
   # Test individual stages
   jenkinsfile-runner --file Jenkinsfile --stage Build
   ```

2. **Environment Issues**
   ```bash
   # Check Jenkins environment
   # Verify required tools are available
   # Check permissions
   ```

## 🐳 Docker Issues

### Docker Build Failures

#### Symptoms
- `docker build` fails
- Image creation errors
- Dependency issues

#### Diagnosis

```bash
# Check Docker version
docker --version

# Check Dockerfile syntax
docker build --no-cache -t simple-ntpd .

# Check build logs
docker build --progress=plain -t simple-ntpd .
```

#### Solutions

1. **Dockerfile Issues**
   ```bash
   # Check Dockerfile syntax
   docker build --no-cache -t simple-ntpd .
   
   # Test individual layers
   docker run -it ubuntu:20.04
   # Test commands manually
   ```

2. **Dependency Issues**
   ```bash
   # Check base image
   docker pull ubuntu:20.04
   
   # Check package availability
   docker run -it ubuntu:20.04
   apt update && apt search build-essential
   ```

### Docker Runtime Issues

#### Symptoms
- Container won't start
- Runtime errors
- Permission issues

#### Diagnosis

```bash
# Check container logs
docker logs simple-ntpd

# Check container status
docker ps -a

# Check container resources
docker stats simple-ntpd
```

#### Solutions

1. **Permission Issues**
   ```bash
   # Check file permissions
   docker exec simple-ntpd ls -la /usr/local/bin/
   
   # Fix permissions
   docker exec simple-ntpd chmod +x /usr/local/bin/simple-ntpd
   ```

2. **Resource Issues**
   ```bash
   # Check container resources
   docker stats simple-ntpd
   
   # Increase memory limit
   docker run -m 1g simple-ntpd
   ```

## 🔍 Advanced Troubleshooting

### System Diagnostics

```bash
# Check system resources
free -h
df -h
top

# Check network
ip addr show
netstat -tulpn

# Check processes
ps aux | grep simple-ntpd

# Check logs
journalctl -f
dmesg | tail -20
```

### Log Analysis

```bash
# Check application logs
tail -f /var/log/simple-daemons/simple-ntpd.log

# Check system logs
journalctl -u simple-ntpd -f

# Check error logs
grep -i error /var/log/syslog

# Check warning logs
grep -i warning /var/log/syslog
```

### Performance Issues

```bash
# Check CPU usage
top -p $(pgrep simple-ntpd)

# Check memory usage
ps aux | grep simple-ntpd

# Check disk I/O
iotop -p $(pgrep simple-ntpd)

# Check network usage
netstat -i
```

## 📞 Getting Help

### Self-Help Resources

1. **Check Documentation**
   - `DOCUMENTATION.md` - Comprehensive guide
   - `QUICK_REFERENCE.md` - Common commands
   - `DEVELOPER_ONBOARDING.md` - Getting started

2. **Use Help Commands**
   ```bash
   ./automation/scripts/setup-automation.sh --help
   ./automation/scripts/vm-manager --help
   ./automation/scripts/project-automation --help
   make help
   ```

3. **Check Status**
   ```bash
   ./automation/scripts/vm-manager status
   ./automation/scripts/project-automation status
   ```

### When to Ask for Help

- After trying all solutions in this guide
- When you have specific error messages
- When the issue affects multiple projects
- When you need to modify the automation infrastructure

### Information to Provide

When asking for help, include:

1. **System Information**
   - Operating system and version
   - Vagrant, VirtualBox, Ansible versions
   - Available memory and disk space

2. **Error Information**
   - Complete error messages
   - Steps that led to the error
   - Relevant log files

3. **Environment Information**
   - VM status and configuration
   - Project status
   - Any custom modifications

---

This troubleshooting guide should help you resolve most common issues. If you encounter problems not covered here, check the documentation or ask for help with detailed information about your specific situation.
