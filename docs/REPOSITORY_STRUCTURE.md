# SimpleDaemons Repository Structure Guide

This guide explains the repository structure, fork relationships, and recommended workflows for the SimpleDaemons project.

## 🏗️ Repository Architecture

### **Main Repository Structure**
```
blburns/SimpleDaemons                    # Main repository (your fork)
├── automation/                          # Automation infrastructure
├── docs/                               # Documentation
├── scripts/                            # Management scripts
├── virtuals/                           # VM configurations
├── projects/                           # Individual project submodules
│   ├── simple-dhcpd/                  # Submodule → blburns/simple-dhcpd
│   ├── simple-dnsd/                    # Submodule → blburns/simple-dnsd
│   ├── simple-httpd/                   # Submodule → blburns/simple-httpd
│   ├── simple-ntpd/                    # Submodule → blburns/simple-ntpd
│   └── ...                             # Other projects
└── .gitmodules                         # Submodule configuration
```

### **Fork Relationships**
```
SimpleDaemons Organization (Upstream)
├── SimpleDaemons/simple-dhcpd          # Original repository
├── SimpleDaemons/simple-dnsd           # Original repository
├── SimpleDaemons/simple-httpd          # Original repository
├── SimpleDaemons/simple-ntpd           # Original repository
└── ...                                 # Other original repositories

blburns (Your Forks)
├── blburns/simple-dhcpd                # Your fork
├── blburns/simple-dnsd                 # Your fork
├── blburns/simple-httpd                # Your fork
├── blburns/simple-ntpd                 # Your fork
└── ...                                 # Other forks

blburns/SimpleDaemons                   # Main repository with submodules
└── projects/                           # Points to your forks
```

## 🎯 **Why This Structure?**

### **Advantages**
1. **Full Control** - You can modify any project without permission issues
2. **Customization** - Add your own features and modifications
3. **Independent Development** - Each project can be developed separately
4. **Easy Contribution** - Contribute back to upstream when ready
5. **Flexible Workflow** - Choose which projects to sync with upstream

### **Workflow Benefits**
- **Development**: Work on your forks with full control
- **Collaboration**: Share your main repository with others
- **Contribution**: Contribute back to SimpleDaemons organization
- **Maintenance**: Keep projects in sync with upstream as needed

## 🔄 **Development Workflow**

### **Daily Development**

```bash
# 1. Work on individual projects
cd projects/simple-ntpd
# Make changes, commit, push to your fork
git add .
git commit -m "Add new feature"
git push origin main

# 2. Update main repository
cd ../..
git add projects/simple-ntpd
git commit -m "Update simple-ntpd with new feature"
git push origin main
```

### **Syncing with Upstream**

```bash
# Setup upstream remotes (one time)
./scripts/manage-upstream.sh setup-all-upstreams

# Sync individual project with upstream
./scripts/manage-upstream.sh sync-upstream simple-ntpd

# Sync all projects with upstream
./scripts/manage-upstream.sh sync-all-upstreams

# Check status
./scripts/manage-upstream.sh status
```

### **Contributing Back to SimpleDaemons**

```bash
# 1. Sync with upstream
./scripts/manage-upstream.sh sync-upstream simple-ntpd

# 2. Make your changes
cd projects/simple-ntpd
# Make changes, commit, push to your fork

# 3. Create pull request to SimpleDaemons organization
# Go to GitHub and create PR from blburns/simple-ntpd to SimpleDaemons/simple-ntpd
```

## 🛠️ **Management Scripts**

### **Submodule Management**
```bash
# Initialize all submodules
./scripts/manage-submodules.sh init

# Update all submodules
./scripts/manage-submodules.sh update

# Show submodule status
./scripts/manage-submodules.sh status

# Add new submodule
./scripts/manage-submodules.sh add <project> <url>
```

### **Upstream Management**
```bash
# Setup upstream remotes
./scripts/manage-upstream.sh setup-all-upstreams

# Sync with upstream
./scripts/manage-upstream.sh sync-all-upstreams

# Check upstream status
./scripts/manage-upstream.sh status
```

## 📋 **Repository URLs**

### **Your Forks (Used in .gitmodules)**
- `https://github.com/blburns/simple-dhcpd.git`
- `https://github.com/blburns/simple-dnsd.git`
- `https://github.com/blburns/simple-dummy.git`
- `https://github.com/blburns/simple-httpd.git`
- `https://github.com/blburns/simple-nfsd.git`
- `https://github.com/blburns/simple-ntpd.git`
- `https://github.com/blburns/simple-proxyd.git`
- `https://github.com/blburns/simple-rsyncd.git`
- `https://github.com/blburns/simple-sftpd.git`
- `https://github.com/blburns/simple-smbd.git`
- `https://github.com/blburns/simple-smtpd.git`
- `https://github.com/blburns/simple-snmpd.git`
- `https://github.com/blburns/simple-tftpd.git`
- `https://github.com/blburns/simple-utcd.git`

### **Upstream Repositories**
- `https://github.com/SimpleDaemons/simple-dhcpd.git`
- `https://github.com/SimpleDaemons/simple-dnsd.git`
- `https://github.com/SimpleDaemons/simple-dummy.git`
- `https://github.com/SimpleDaemons/simple-httpd.git`
- `https://github.com/SimpleDaemons/simple-nfsd.git`
- `https://github.com/SimpleDaemons/simple-ntpd.git`
- `https://github.com/SimpleDaemons/simple-proxyd.git`
- `https://github.com/SimpleDaemons/simple-rsyncd.git`
- `https://github.com/SimpleDaemons/simple-sftpd.git`
- `https://github.com/SimpleDaemons/simple-smbd.git`
- `https://github.com/SimpleDaemons/simple-smtpd.git`
- `https://github.com/SimpleDaemons/simple-snmpd.git`
- `https://github.com/SimpleDaemons/simple-tftpd.git`
- `https://github.com/SimpleDaemons/simple-utcd.git`

## 🔧 **Configuration Files**

### **.gitmodules**
```ini
[submodule "projects/simple-ntpd"]
	path = projects/simple-ntpd
	url = https://github.com/blburns/simple-ntpd.git
	# Upstream: https://github.com/SimpleDaemons/simple-ntpd.git
```

### **Individual Project Remotes**
Each project has two remotes:
- **origin**: Points to your fork (`blburns/simple-*`)
- **upstream**: Points to original repository (`SimpleDaemons/simple-*`)

## 🚀 **Getting Started**

### **Initial Setup**
```bash
# 1. Clone main repository with submodules
git clone --recursive https://github.com/blburns/SimpleDaemons.git
cd SimpleDaemons

# 2. Setup upstream remotes
./scripts/manage-upstream.sh setup-all-upstreams

# 3. Verify setup
./scripts/manage-submodules.sh status
./scripts/manage-upstream.sh status
```

### **Working on Projects**
```bash
# 1. Work on individual project
cd projects/simple-ntpd

# 2. Check remotes
git remote -v
# Should show:
# origin    https://github.com/blburns/simple-ntpd.git (fetch)
# origin    https://github.com/blburns/simple-ntpd.git (push)
# upstream  https://github.com/SimpleDaemons/simple-ntpd.git (fetch)
# upstream  https://github.com/SimpleDaemons/simple-ntpd.git (push)

# 3. Make changes, commit, push
git add .
git commit -m "Add new feature"
git push origin main

# 4. Update main repository
cd ../..
git add projects/simple-ntpd
git commit -m "Update simple-ntpd with new feature"
git push origin main
```

## 🔄 **Sync Workflows**

### **Regular Sync with Upstream**
```bash
# Sync all projects with upstream
./scripts/manage-upstream.sh sync-all-upstreams

# Update main repository
git add projects/
git commit -m "Sync all projects with upstream"
git push origin main
```

### **Selective Sync**
```bash
# Sync only specific projects
./scripts/manage-upstream.sh sync-upstream simple-ntpd
./scripts/manage-upstream.sh sync-upstream simple-httpd

# Update main repository
git add projects/simple-ntpd projects/simple-httpd
git commit -m "Sync simple-ntpd and simple-httpd with upstream"
git push origin main
```

## 📊 **Status Monitoring**

### **Check Submodule Status**
```bash
./scripts/manage-submodules.sh status
```

### **Check Upstream Status**
```bash
./scripts/manage-upstream.sh status
```

### **Check Individual Project**
```bash
cd projects/simple-ntpd
git status
git remote -v
git log --oneline -5
```

## 🎯 **Best Practices**

### **Development**
1. **Always work in your forks** - Don't modify upstream directly
2. **Keep forks up to date** - Regularly sync with upstream
3. **Use descriptive commits** - Clear commit messages for both levels
4. **Test thoroughly** - Ensure changes work before pushing
5. **Document changes** - Update documentation for significant changes

### **Collaboration**
1. **Share main repository** - Others can clone your main repository
2. **Use pull requests** - For both individual projects and main repository
3. **Communicate changes** - Let team know about significant updates
4. **Review changes** - Use code review for both levels
5. **Tag releases** - Tag both individual projects and main repository

### **Maintenance**
1. **Regular sync** - Keep projects in sync with upstream
2. **Monitor status** - Check submodule and upstream status regularly
3. **Clean working directories** - Remove uncommitted changes regularly
4. **Backup repositories** - Ensure both forks and main repository are backed up
5. **Update documentation** - Keep this guide current

## 🔍 **Troubleshooting**

### **Common Issues**

#### Submodules Not Showing as Links
```bash
# Check .gitmodules file
cat .gitmodules

# Initialize submodules
./scripts/manage-submodules.sh init

# Check submodule status
./scripts/manage-submodules.sh status
```

#### Upstream Sync Issues
```bash
# Check upstream remotes
./scripts/manage-upstream.sh status

# Setup upstream if missing
./scripts/manage-upstream.sh setup-all-upstreams

# Sync with upstream
./scripts/manage-upstream.sh sync-all-upstreams
```

#### Repository Access Issues
```bash
# Check repository URLs
cd projects/simple-ntpd
git remote -v

# Update remote URLs if needed
git remote set-url origin https://github.com/blburns/simple-ntpd.git
git remote set-url upstream https://github.com/SimpleDaemons/simple-ntpd.git
```

## 📞 **Support**

### **Getting Help**
1. **Check this guide** for common workflows
2. **Use management scripts** with `--help` option
3. **Review git submodule documentation**
4. **Check individual project documentation**

### **Resources**
- **Git Submodule Documentation**: https://git-scm.com/book/en/v2/Git-Tools-Submodules
- **GitHub Fork Documentation**: https://docs.github.com/en/get-started/quickstart/fork-a-repo
- **Management Scripts**: Use `--help` with any script

---

This repository structure provides maximum flexibility while maintaining clear relationships between your forks and the upstream SimpleDaemons organization. You have full control over your development while being able to contribute back to the community when ready.
