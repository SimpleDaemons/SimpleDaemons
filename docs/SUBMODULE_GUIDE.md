# SimpleDaemons Submodule Guide

This guide explains how to work with the SimpleDaemons repository structure using git submodules.

## 🏗️ Repository Structure

SimpleDaemons uses a **main repository** with **individual project repositories** as git submodules:

```
SimpleDaemons/                    # Main repository
├── automation/                   # Automation infrastructure
├── docs/                        # Documentation
├── scripts/                     # Helper scripts
├── virtuals/                    # VM configurations
├── projects/                    # Individual project submodules
│   ├── simple-dhcpd/           # DHCP daemon (submodule)
│   ├── simple-dnsd/            # DNS daemon (submodule)
│   ├── simple-httpd/           # HTTP daemon (submodule)
│   ├── simple-ntpd/            # NTP daemon (submodule)
│   └── ...                     # Other daemon projects
├── .gitmodules                 # Submodule configuration
└── README.md                   # Main repository documentation
```

## 🚀 Getting Started

### Clone with Submodules

```bash
# Clone repository with all submodules
git clone --recursive <repository-url>
cd SimpleDaemons

# Or clone first, then initialize submodules
git clone <repository-url>
cd SimpleDaemons
git submodule update --init --recursive
```

### Verify Setup

```bash
# Check submodule status
./scripts/manage-submodules.sh status

# Check project directories
ls -la projects/
```

## 🔧 Working with Submodules

### Daily Development

```bash
# Update all submodules to latest
git submodule update --remote

# Work on a specific project
cd projects/simple-ntpd
# Make changes, commit, push to project repository
git add .
git commit -m "Add new feature"
git push origin main

# Update main repository
cd ../..
git add projects/simple-ntpd
git commit -m "Update simple-ntpd to latest version"
git push origin main
```

### Adding New Projects

```bash
# Add new project submodule
./scripts/manage-submodules.sh add simple-new https://github.com/user/simple-new.git

# Commit changes
git add .gitmodules projects/simple-new
git commit -m "Add simple-new submodule"
```

### Removing Projects

```bash
# Remove project submodule
./scripts/manage-submodules.sh remove simple-old

# Commit changes
git commit -m "Remove simple-old submodule"
```

## 🛠️ Submodule Management Scripts

### manage-submodules.sh

Comprehensive submodule management:

```bash
# Initialize all submodules
./scripts/manage-submodules.sh init

# Update all submodules to latest
./scripts/manage-submodules.sh update

# Show submodule status
./scripts/manage-submodules.sh status

# Add new submodule
./scripts/manage-submodules.sh add <project> <url>

# Remove submodule
./scripts/manage-submodules.sh remove <project>

# Sync submodule URLs
./scripts/manage-submodules.sh sync

# Clean submodule working directories
./scripts/manage-submodules.sh clean
```

### setup-submodules.sh

Initial submodule setup:

```bash
# Setup submodules from template
./scripts/setup-submodules.sh

# Preview changes
./scripts/setup-submodules.sh --dry-run

# Force overwrite existing files
./scripts/setup-submodules.sh --force
```

## 📋 Individual Project Workflow

### Working on a Project

```bash
# Navigate to project
cd projects/simple-ntpd

# Check project status
git status

# Make changes
vim src/main.cpp

# Commit changes
git add .
git commit -m "Implement new feature"

# Push to project repository
git push origin main
```

### Updating Main Repository

```bash
# Return to main repository
cd ../..

# Update submodule reference
git add projects/simple-ntpd
git commit -m "Update simple-ntpd to latest version"

# Push main repository
git push origin main
```

## 🔄 Collaboration Workflow

### Team Development

1. **Developer A** works on `simple-ntpd`:
   ```bash
   cd projects/simple-ntpd
   # Make changes, commit, push
   git push origin main
   ```

2. **Developer B** pulls latest changes:
   ```bash
   # Update main repository
   git pull origin main
   
   # Update submodules
   git submodule update --remote
   ```

3. **Developer B** works on `simple-httpd`:
   ```bash
   cd projects/simple-httpd
   # Make changes, commit, push
   git push origin main
   ```

### Release Process

```bash
# Update all submodules to latest
git submodule update --remote

# Commit submodule updates
git add projects/
git commit -m "Update all projects to latest versions"

# Tag release
git tag -a v1.0.0 -m "Release v1.0.0"
git push origin v1.0.0
```

## 🏗️ Creating New Projects

### Using the Setup Script

```bash
# Create individual project repositories
./scripts/setup-submodules.sh --create-repos

# Add to submodules
./scripts/manage-submodules.sh add simple-new https://github.com/user/simple-new.git
```

### Manual Creation

```bash
# Create project directory
mkdir projects/simple-new
cd projects/simple-new

# Initialize git repository
git init

# Create basic structure
mkdir -p src include tests config deployment docs
# Add source files, Makefile, CMakeLists.txt, etc.

# Initial commit
git add .
git commit -m "Initial commit: simple-new v0.1.0"

# Add remote and push
git remote add origin https://github.com/user/simple-new.git
git push -u origin main

# Add as submodule
cd ../..
git submodule add https://github.com/user/simple-new.git projects/simple-new
```

## 🔍 Troubleshooting

### Common Issues

#### Submodules Not Initialized

```bash
# Initialize submodules
git submodule update --init --recursive

# Or use management script
./scripts/manage-submodules.sh init
```

#### Submodule Out of Sync

```bash
# Update all submodules
git submodule update --remote

# Or use management script
./scripts/manage-submodules.sh update
```

#### Submodule URL Changes

```bash
# Sync submodule URLs
./scripts/manage-submodules.sh sync

# Or manually update
git config submodule.projects/simple-ntpd.url https://new-url.git
```

#### Working Directory Issues

```bash
# Clean submodule working directories
./scripts/manage-submodules.sh clean

# Or manually clean
git submodule foreach --recursive git clean -fd
git submodule foreach --recursive git reset --hard
```

### Getting Help

```bash
# Script help
./scripts/manage-submodules.sh --help
./scripts/setup-submodules.sh --help

# Git submodule help
git submodule --help
```

## 📚 Best Practices

### Development

1. **Always work in project directories** - Don't modify submodules from the main repository
2. **Commit project changes first** - Push to project repository before updating main
3. **Use descriptive commit messages** - Clear messages for both project and main repository
4. **Test thoroughly** - Ensure changes work before updating main repository
5. **Keep submodules up to date** - Regularly update to latest versions

### Collaboration

1. **Communicate changes** - Let team know about significant project updates
2. **Use branches** - Create feature branches for major changes
3. **Review changes** - Use pull requests for both project and main repository
4. **Tag releases** - Tag both individual projects and main repository
5. **Document changes** - Update documentation for both levels

### Maintenance

1. **Regular updates** - Keep submodules current with latest changes
2. **Clean working directories** - Remove uncommitted changes regularly
3. **Monitor submodule status** - Check for issues with submodule management
4. **Backup repositories** - Ensure both project and main repositories are backed up
5. **Test automation** - Verify automation scripts work with submodule structure

## 🎯 Benefits of Submodule Structure

### Advantages

1. **Independent Development** - Each project can be developed independently
2. **Version Control** - Track specific versions of each project
3. **Modular Releases** - Release projects individually or together
4. **Team Collaboration** - Different teams can work on different projects
5. **Clean History** - Separate commit histories for each project
6. **Selective Updates** - Update only specific projects as needed

### Use Cases

1. **Microservices Architecture** - Each daemon is a separate service
2. **Independent Releases** - Release projects on different schedules
3. **Team Ownership** - Different teams own different projects
4. **Version Pinning** - Use specific versions of projects in production
5. **Selective Deployment** - Deploy only needed projects

## 📞 Support

### Resources

- **Git Submodule Documentation**: https://git-scm.com/book/en/v2/Git-Tools-Submodules
- **Management Scripts**: Use `--help` with any script
- **Troubleshooting**: Check this guide and git documentation

### Getting Help

1. **Check this guide** for common workflows
2. **Use management scripts** with `--help` option
3. **Review git submodule documentation**
4. **Check project-specific documentation** in individual repositories

---

This submodule structure provides a flexible and maintainable way to manage multiple related projects while keeping them independent and allowing for selective updates and releases.
