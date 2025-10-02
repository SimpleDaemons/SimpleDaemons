#!/bin/bash
# SimpleDaemons Automation Setup Script
# This script sets up the complete automation infrastructure for all projects

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AUTOMATION_DIR="$(dirname "$SCRIPT_DIR")"
ROOT_DIR="$(dirname "$AUTOMATION_DIR")"
STANDARDIZATION_DIR="$ROOT_DIR/projects/STANDARDIZATION_TEMPLATES"

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to show usage
show_usage() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  -h, --help          Show this help message"
    echo "  -d, --dry-run       Show what would be done without making changes"
    echo "  -f, --force         Force overwrite existing files"
    echo "  -p, --projects      Only setup project standardization"
    echo "  -v, --vagrant       Only setup Vagrant configurations"
    echo "  -a, --ansible       Only setup Ansible configurations"
    echo "  -s, --standardize   Run standardization implementation"
    echo ""
    echo "This script sets up the complete automation infrastructure:"
    echo "  - Implements standardization templates across all projects"
    echo "  - Updates Vagrantfile configurations"
    echo "  - Sets up Ansible playbooks and configurations"
    echo "  - Creates automation scripts and helpers"
}

# Function to check prerequisites
check_prerequisites() {
    print_status "Checking prerequisites..."
    
    # Check if we're in the right directory
    if [ ! -d "$STANDARDIZATION_DIR" ]; then
        print_error "Standardization templates directory not found: $STANDARDIZATION_DIR"
        exit 1
    fi
    
    # Check if projects directory exists
    if [ ! -d "$ROOT_DIR/projects" ]; then
        print_error "Projects directory not found: $ROOT_DIR/projects"
        exit 1
    fi
    
    # Check if standardization script exists
    if [ ! -f "$STANDARDIZATION_DIR/implement_standardization.sh" ]; then
        print_error "Standardization implementation script not found"
        exit 1
    fi
    
    print_success "Prerequisites check passed"
}

# Function to implement standardization for all projects
implement_standardization() {
    local dry_run="$1"
    local force="$2"
    
    print_status "Implementing standardization across all projects..."
    
    cd "$STANDARDIZATION_DIR"
    
    # Make the script executable
    chmod +x implement_standardization.sh
    
    # Run standardization implementation
    if [ "$dry_run" = "true" ]; then
        print_status "Running standardization in dry-run mode..."
        ./implement_standardization.sh --dry-run --all
    else
        local force_flag=""
        if [ "$force" = "true" ]; then
            force_flag="--force"
        fi
        
        print_status "Running standardization implementation..."
        ./implement_standardization.sh --all $force_flag
    fi
    
    cd - > /dev/null
    print_success "Standardization implementation completed"
}

# Function to update Vagrant configurations
update_vagrant_configs() {
    local dry_run="$1"
    local force="$2"
    
    print_status "Updating Vagrant configurations..."
    
    # Update main Vagrantfile template
    local vagrant_template="$ROOT_DIR/virtuals/Vagrantfile.template"
    if [ "$dry_run" = "true" ]; then
        print_status "Would update Vagrantfile template: $vagrant_template"
    else
        cat > "$vagrant_template" << 'EOF'
# -*- mode: ruby -*-
# vi: set ft=ruby -*-

# Multi-Project Vagrantfile Template
# This template can be customized for each VM type

Vagrant.configure("2") do |config|
  # VM configuration will be set by the parent Vagrantfile
  # This is a placeholder template for multi-project VMs
  
  # Default VM configuration
  config.vm.box = ENV['VAGRANT_BOX'] || "ubuntu/jammy64"
  config.vm.hostname = ENV['VM_HOSTNAME'] || "simple-daemons-dev"
  
  # Network configuration
  config.vm.network "private_network", ip: ENV['VM_IP'] || "192.168.1.100"
  
  # VM resources
  config.vm.provider "virtualbox" do |vb|
    vb.name = ENV['VM_NAME'] || "simple-daemons-dev"
    vb.memory = ENV['VM_MEMORY'] || "2048"
    vb.cpus = ENV['VM_CPUS'] || 2
    vb.gui = false
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
    vb.customize ["modifyvm", :id, "--vrde", "off"]
  end
  
  # Provisioning with Ansible
  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "../../automation/playbook.yml"
    ansible.inventory_path = "../../automation/inventory.ini"
    ansible.limit = "development"
    ansible.extra_vars = {
      git_repo_url: ".",
      git_branch: "main",
      project_name: ENV['PROJECT_NAME'] || ""
    }
    ansible.verbose = true
  end
  
  # Shared directories for development
  config.vm.synced_folder "../..", "/vagrant", type: "rsync", 
    rsync__exclude: [".git/", "dist/", "*.o", "*.so", "*.a", "virtuals/", ".vagrant/"]
  
  # Project-specific directories (dynamically mounted based on PROJECT_NAME)
  if ENV['PROJECT_NAME']
    project_name = ENV['PROJECT_NAME']
    project_dir = ENV['PROJECT_DIR'] || "../#{project_name}"
    
    # Mount the specific project
    config.vm.synced_folder project_dir, "/opt/simple-daemons/#{project_name}", type: "rsync"
    
    # Mount project build directory
    config.vm.synced_folder "#{project_dir}/build", "/opt/simple-daemons/#{project_name}/build", type: "rsync"
  end
  
  # Post-provisioning script
  config.vm.provision "shell", inline: <<-SHELL
    # Create log directories for all daemons
    sudo mkdir -p /var/log/simple-daemons
    sudo chown nfsdev:nfsdev /var/log/simple-daemons
    
    # Create configuration directory
    sudo mkdir -p /etc/simple-daemons
    sudo chown nfsdev:nfsdev /etc/simple-daemons
    
    # If PROJECT_NAME is set, set up the specific project
    if [ -n "$PROJECT_NAME" ]; then
      echo "Setting up project: $PROJECT_NAME"
      
      # Create project-specific directories
      sudo mkdir -p /opt/simple-daemons/$PROJECT_NAME
      sudo chown nfsdev:nfsdev /opt/simple-daemons/$PROJECT_NAME
      
      # Create project-specific log directory
      sudo mkdir -p /var/log/$PROJECT_NAME
      sudo chown nfsdev:nfsdev /var/log/$PROJECT_NAME
      
      # Create project-specific config directory
      sudo mkdir -p /etc/$PROJECT_NAME
      sudo chown nfsdev:nfsdev /etc/$PROJECT_NAME
      
      # Build the project if it exists
      if [ -f "/opt/simple-daemons/$PROJECT_NAME/CMakeLists.txt" ]; then
        echo "Building $PROJECT_NAME..."
        cd /opt/simple-daemons/$PROJECT_NAME
        sudo -u nfsdev mkdir -p build
        cd build
        sudo -u nfsdev cmake ..
        sudo -u nfsdev make
      fi
    fi
    
    # Show status
    echo "=== Simple Daemons VM Status ==="
    echo "VM Hostname: $(hostname)"
    echo "VM IP: $(hostname -I | awk '{print $1}')"
    echo "Project: ${PROJECT_NAME:-'none specified'}"
    echo ""
    
    if [ -n "$PROJECT_NAME" ]; then
      echo "=== $PROJECT_NAME Status ==="
      if [ -f "/opt/simple-daemons/$PROJECT_NAME/build/$PROJECT_NAME" ]; then
        echo "✅ $PROJECT_NAME binary found"
      else
        echo "❌ $PROJECT_NAME binary not found"
      fi
    fi
  SHELL
end
EOF
        print_success "Updated Vagrantfile template"
    fi
    
    # Update individual VM configurations
    local vm_configs=(
        "ubuntu_dev:ubuntu/jammy64:192.168.1.100:simple-daemons-ubuntu-dev"
        "centos_dev:centos/8:192.168.1.101:simple-daemons-centos-dev"
    )
    
    for vm_config in "${vm_configs[@]}"; do
        IFS=':' read -r vm_name vm_box vm_ip vm_hostname <<< "$vm_config"
        local vm_dir="$ROOT_DIR/virtuals/$vm_name"
        local vagrantfile="$vm_dir/Vagrantfile"
        
        if [ "$dry_run" = "true" ]; then
            print_status "Would update Vagrantfile for $vm_name: $vagrantfile"
        else
            # Create VM directory if it doesn't exist
            mkdir -p "$vm_dir"
            
            # Create VM-specific Vagrantfile
            cat > "$vagrantfile" << EOF
# -*- mode: ruby -*-
# vi: set ft=ruby -*-

# $vm_name VM Configuration
# Multi-project VM for all Simple Daemons

Vagrant.configure("2") do |config|
  # VM configuration
  config.vm.box = "$vm_box"
  config.vm.hostname = "$vm_hostname"
  
  # Network configuration
  config.vm.network "private_network", ip: "$vm_ip"
  
  # VM resources
  config.vm.provider "virtualbox" do |vb|
    vb.name = "$vm_hostname"
    vb.memory = "2048"
    vb.cpus = 2
    vb.gui = false
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
    vb.customize ["modifyvm", :id, "--vrde", "off"]
  end
  
  # Provisioning with Ansible
  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "../../automation/playbook.yml"
    ansible.inventory_path = "../../automation/inventory.ini"
    ansible.limit = "development"
    ansible.extra_vars = {
      git_repo_url: ".",
      git_branch: "main",
      project_name: ENV['PROJECT_NAME'] || ""
    }
    ansible.verbose = true
  end
  
  # Shared directories for development
  config.vm.synced_folder "../..", "/vagrant", type: "rsync", 
    rsync__exclude: [".git/", "dist/", "*.o", "*.so", "*.a", "virtuals/", ".vagrant/"]
  
  # Project-specific directories (dynamically mounted based on PROJECT_NAME)
  if ENV['PROJECT_NAME']
    project_name = ENV['PROJECT_NAME']
    project_dir = ENV['PROJECT_DIR'] || "../#{project_name}"
    
    # Mount the specific project
    config.vm.synced_folder project_dir, "/opt/simple-daemons/#{project_name}", type: "rsync"
    
    # Mount project build directory
    config.vm.synced_folder "#{project_dir}/build", "/opt/simple-daemons/#{project_name}/build", type: "rsync"
  end
  
  # Post-provisioning script
  config.vm.provision "shell", inline: <<-SHELL
    # Create log directories for all daemons
    sudo mkdir -p /var/log/simple-daemons
    sudo chown nfsdev:nfsdev /var/log/simple-daemons
    
    # Create configuration directory
    sudo mkdir -p /etc/simple-daemons
    sudo chown nfsdev:nfsdev /etc/simple-daemons
    
    # If PROJECT_NAME is set, set up the specific project
    if [ -n "$PROJECT_NAME" ]; then
      echo "Setting up project: $PROJECT_NAME"
      
      # Create project-specific directories
      sudo mkdir -p /opt/simple-daemons/$PROJECT_NAME
      sudo chown nfsdev:nfsdev /opt/simple-daemons/$PROJECT_NAME
      
      # Create project-specific log directory
      sudo mkdir -p /var/log/$PROJECT_NAME
      sudo chown nfsdev:nfsdev /var/log/$PROJECT_NAME
      
      # Create project-specific config directory
      sudo mkdir -p /etc/$PROJECT_NAME
      sudo chown nfsdev:nfsdev /etc/$PROJECT_NAME
      
      # Build the project if it exists
      if [ -f "/opt/simple-daemons/$PROJECT_NAME/CMakeLists.txt" ]; then
        echo "Building $PROJECT_NAME..."
        cd /opt/simple-daemons/$PROJECT_NAME
        sudo -u nfsdev mkdir -p build
        cd build
        sudo -u nfsdev cmake ..
        sudo -u nfsdev make
      fi
    fi
    
    # Show status
    echo "=== Simple Daemons VM Status ==="
    echo "VM Hostname: $(hostname)"
    echo "VM IP: $(hostname -I | awk '{print $1}')"
    echo "Project: ${PROJECT_NAME:-'none specified'}"
    echo ""
    
    if [ -n "$PROJECT_NAME" ]; then
      echo "=== $PROJECT_NAME Status ==="
      if [ -f "/opt/simple-daemons/$PROJECT_NAME/build/$PROJECT_NAME" ]; then
        echo "✅ $PROJECT_NAME binary found"
      else
        echo "❌ $PROJECT_NAME binary not found"
      fi
    fi
  SHELL
end
EOF
            print_success "Updated Vagrantfile for $vm_name"
        fi
    done
    
    print_success "Vagrant configurations updated"
}

# Function to setup Ansible configurations
setup_ansible_configs() {
    local dry_run="$1"
    
    print_status "Setting up Ansible configurations..."
    
    # Ansible configuration is already created, just verify it exists
    local ansible_cfg="$AUTOMATION_DIR/ansible.cfg"
    if [ ! -f "$ansible_cfg" ]; then
        print_error "Ansible configuration file not found: $ansible_cfg"
        exit 1
    fi
    
    # Playbook is already created, just verify it exists
    local playbook="$AUTOMATION_DIR/playbook.yml"
    if [ ! -f "$playbook" ]; then
        print_error "Ansible playbook not found: $playbook"
        exit 1
    fi
    
    # Inventory is already updated, just verify it exists
    local inventory="$AUTOMATION_DIR/inventory.ini"
    if [ ! -f "$inventory" ]; then
        print_error "Ansible inventory not found: $inventory"
        exit 1
    fi
    
    print_success "Ansible configurations verified"
}

# Function to create automation helper scripts
create_automation_scripts() {
    local dry_run="$1"
    
    print_status "Creating automation helper scripts..."
    
    # Create VM management script
    local vm_manager="$AUTOMATION_DIR/scripts/vm-manager"
    if [ "$dry_run" = "true" ]; then
        print_status "Would create VM manager script: $vm_manager"
    else
        cat > "$vm_manager" << 'EOF'
#!/bin/bash
# SimpleDaemons VM Manager
# This script helps manage development VMs for all projects

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AUTOMATION_DIR="$(dirname "$SCRIPT_DIR")"
ROOT_DIR="$(dirname "$AUTOMATION_DIR")"

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to show usage
show_usage() {
    echo "Usage: $0 [COMMAND] [OPTIONS]"
    echo ""
    echo "Commands:"
    echo "  up [vm] [project]     Start VM (optionally for specific project)"
    echo "  down [vm]             Stop VM"
    echo "  status [vm]           Show VM status"
    echo "  ssh [vm]              SSH into VM"
    echo "  provision [vm]        Re-provision VM"
    echo "  list                  List available VMs"
    echo "  projects              List available projects"
    echo ""
    echo "Options:"
    echo "  -h, --help            Show this help message"
    echo "  -v, --verbose          Verbose output"
    echo ""
    echo "Examples:"
    echo "  $0 up ubuntu_dev simple-ntpd    # Start Ubuntu VM with simple-ntpd"
    echo "  $0 ssh ubuntu_dev               # SSH into Ubuntu VM"
    echo "  $0 status                       # Show status of all VMs"
}

# Function to list available VMs
list_vms() {
    print_status "Available VMs:"
    for vm_dir in "$ROOT_DIR/virtuals"/*/; do
        if [ -d "$vm_dir" ] && [ -f "$vm_dir/Vagrantfile" ]; then
            vm_name=$(basename "$vm_dir")
            echo "  - $vm_name"
        fi
    done
}

# Function to list available projects
list_projects() {
    print_status "Available projects:"
    for project_dir in "$ROOT_DIR/projects"/*/; do
        if [ -d "$project_dir" ]; then
            project_name=$(basename "$project_dir")
            echo "  - $project_name"
        fi
    done
}

# Function to start VM
start_vm() {
    local vm_name="$1"
    local project_name="$2"
    
    if [ -z "$vm_name" ]; then
        print_error "VM name required"
        list_vms
        exit 1
    fi
    
    local vm_dir="$ROOT_DIR/virtuals/$vm_name"
    if [ ! -d "$vm_dir" ]; then
        print_error "VM directory not found: $vm_dir"
        list_vms
        exit 1
    fi
    
    print_status "Starting VM: $vm_name"
    if [ -n "$project_name" ]; then
        print_status "Project: $project_name"
        export PROJECT_NAME="$project_name"
    fi
    
    cd "$vm_dir"
    vagrant up
    
    print_success "VM $vm_name started successfully"
    
    if [ -n "$project_name" ]; then
        print_status "Project $project_name should be available at /opt/simple-daemons/$project_name"
    fi
}

# Function to stop VM
stop_vm() {
    local vm_name="$1"
    
    if [ -z "$vm_name" ]; then
        print_error "VM name required"
        list_vms
        exit 1
    fi
    
    local vm_dir="$ROOT_DIR/virtuals/$vm_name"
    if [ ! -d "$vm_dir" ]; then
        print_error "VM directory not found: $vm_dir"
        list_vms
        exit 1
    fi
    
    print_status "Stopping VM: $vm_name"
    
    cd "$vm_dir"
    vagrant halt
    
    print_success "VM $vm_name stopped successfully"
}

# Function to show VM status
show_status() {
    local vm_name="$1"
    
    if [ -n "$vm_name" ]; then
        local vm_dir="$ROOT_DIR/virtuals/$vm_name"
        if [ ! -d "$vm_dir" ]; then
            print_error "VM directory not found: $vm_dir"
            list_vms
            exit 1
        fi
        
        print_status "Status for VM: $vm_name"
        cd "$vm_dir"
        vagrant status
    else
        print_status "Status for all VMs:"
        for vm_dir in "$ROOT_DIR/virtuals"/*/; do
            if [ -d "$vm_dir" ] && [ -f "$vm_dir/Vagrantfile" ]; then
                vm_name=$(basename "$vm_dir")
                echo ""
                print_status "VM: $vm_name"
                cd "$vm_dir"
                vagrant status
            fi
        done
    fi
}

# Function to SSH into VM
ssh_vm() {
    local vm_name="$1"
    
    if [ -z "$vm_name" ]; then
        print_error "VM name required"
        list_vms
        exit 1
    fi
    
    local vm_dir="$ROOT_DIR/virtuals/$vm_name"
    if [ ! -d "$vm_dir" ]; then
        print_error "VM directory not found: $vm_dir"
        list_vms
        exit 1
    fi
    
    print_status "SSH into VM: $vm_name"
    
    cd "$vm_dir"
    vagrant ssh
}

# Function to provision VM
provision_vm() {
    local vm_name="$1"
    
    if [ -z "$vm_name" ]; then
        print_error "VM name required"
        list_vms
        exit 1
    fi
    
    local vm_dir="$ROOT_DIR/virtuals/$vm_name"
    if [ ! -d "$vm_dir" ]; then
        print_error "VM directory not found: $vm_dir"
        list_vms
        exit 1
    fi
    
    print_status "Provisioning VM: $vm_name"
    
    cd "$vm_dir"
    vagrant provision
    
    print_success "VM $vm_name provisioned successfully"
}

# Main function
main() {
    local command="$1"
    shift
    
    case "$command" in
        up)
            start_vm "$@"
            ;;
        down)
            stop_vm "$@"
            ;;
        status)
            show_status "$@"
            ;;
        ssh)
            ssh_vm "$@"
            ;;
        provision)
            provision_vm "$@"
            ;;
        list)
            list_vms
            ;;
        projects)
            list_projects
            ;;
        -h|--help|help)
            show_usage
            ;;
        *)
            print_error "Unknown command: $command"
            show_usage
            exit 1
            ;;
    esac
}

# Run main function with all arguments
main "$@"
EOF
        chmod +x "$vm_manager"
        print_success "Created VM manager script"
    fi
    
    # Create project automation script
    local project_automation="$AUTOMATION_DIR/scripts/project-automation"
    if [ "$dry_run" = "true" ]; then
        print_status "Would create project automation script: $project_automation"
    else
        cat > "$project_automation" << 'EOF'
#!/bin/bash
# SimpleDaemons Project Automation
# This script helps automate common project tasks

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AUTOMATION_DIR="$(dirname "$SCRIPT_DIR")"
ROOT_DIR="$(dirname "$AUTOMATION_DIR")"
STANDARDIZATION_DIR="$ROOT_DIR/projects/STANDARDIZATION_TEMPLATES"

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to show usage
show_usage() {
    echo "Usage: $0 [COMMAND] [PROJECT] [OPTIONS]"
    echo ""
    echo "Commands:"
    echo "  build [project]       Build a specific project"
    echo "  test [project]        Test a specific project"
    echo "  install [project]    Install a specific project"
    echo "  package [project]    Package a specific project"
    echo "  clean [project]      Clean a specific project"
    echo "  status [project]     Show project status"
    echo "  standardize [project] Implement standardization for project"
    echo "  all-build            Build all projects"
    echo "  all-test             Test all projects"
    echo "  all-clean            Clean all projects"
    echo "  list                 List available projects"
    echo ""
    echo "Options:"
    echo "  -h, --help           Show this help message"
    echo "  -v, --verbose         Verbose output"
    echo "  -f, --force          Force operation"
    echo ""
    echo "Examples:"
    echo "  $0 build simple-ntpd     # Build simple-ntpd"
    echo "  $0 test simple-httpd      # Test simple-httpd"
    echo "  $0 all-build              # Build all projects"
}

# Function to list available projects
list_projects() {
    print_status "Available projects:"
    for project_dir in "$ROOT_DIR/projects"/*/; do
        if [ -d "$project_dir" ]; then
            project_name=$(basename "$project_dir")
            echo "  - $project_name"
        fi
    done
}

# Function to get project directory
get_project_dir() {
    local project_name="$1"
    echo "$ROOT_DIR/projects/$project_name"
}

# Function to build project
build_project() {
    local project_name="$1"
    local verbose="$2"
    
    if [ -z "$project_name" ]; then
        print_error "Project name required"
        list_projects
        exit 1
    fi
    
    local project_dir=$(get_project_dir "$project_name")
    if [ ! -d "$project_dir" ]; then
        print_error "Project directory not found: $project_dir"
        list_projects
        exit 1
    fi
    
    print_status "Building project: $project_name"
    
    cd "$project_dir"
    
    # Create build directory if it doesn't exist
    if [ ! -d "build" ]; then
        mkdir build
    fi
    
    cd build
    
    # Configure with CMake
    if [ "$verbose" = "true" ]; then
        cmake .. -DCMAKE_BUILD_TYPE=Release
    else
        cmake .. -DCMAKE_BUILD_TYPE=Release > /dev/null 2>&1
    fi
    
    # Build
    if [ "$verbose" = "true" ]; then
        make -j$(nproc)
    else
        make -j$(nproc) > /dev/null 2>&1
    fi
    
    if [ $? -eq 0 ]; then
        print_success "Project $project_name built successfully"
    else
        print_error "Project $project_name build failed"
        exit 1
    fi
}

# Function to test project
test_project() {
    local project_name="$1"
    local verbose="$2"
    
    if [ -z "$project_name" ]; then
        print_error "Project name required"
        list_projects
        exit 1
    fi
    
    local project_dir=$(get_project_dir "$project_name")
    if [ ! -d "$project_dir" ]; then
        print_error "Project directory not found: $project_dir"
        list_projects
        exit 1
    fi
    
    print_status "Testing project: $project_name"
    
    cd "$project_dir"
    
    # Check if Makefile exists
    if [ -f "Makefile" ]; then
        if [ "$verbose" = "true" ]; then
            make test
        else
            make test > /dev/null 2>&1
        fi
    elif [ -d "build" ]; then
        cd build
        if [ "$verbose" = "true" ]; then
            ctest --verbose
        else
            ctest
        fi
    else
        print_error "No test configuration found for $project_name"
        exit 1
    fi
    
    if [ $? -eq 0 ]; then
        print_success "Project $project_name tests passed"
    else
        print_error "Project $project_name tests failed"
        exit 1
    fi
}

# Function to install project
install_project() {
    local project_name="$1"
    local verbose="$2"
    
    if [ -z "$project_name" ]; then
        print_error "Project name required"
        list_projects
        exit 1
    fi
    
    local project_dir=$(get_project_dir "$project_name")
    if [ ! -d "$project_dir" ]; then
        print_error "Project directory not found: $project_dir"
        list_projects
        exit 1
    fi
    
    print_status "Installing project: $project_name"
    
    cd "$project_dir"
    
    # Check if Makefile exists
    if [ -f "Makefile" ]; then
        if [ "$verbose" = "true" ]; then
            sudo make install
        else
            sudo make install > /dev/null 2>&1
        fi
    elif [ -d "build" ]; then
        cd build
        if [ "$verbose" = "true" ]; then
            sudo make install
        else
            sudo make install > /dev/null 2>&1
        fi
    else
        print_error "No install configuration found for $project_name"
        exit 1
    fi
    
    if [ $? -eq 0 ]; then
        print_success "Project $project_name installed successfully"
    else
        print_error "Project $project_name installation failed"
        exit 1
    fi
}

# Function to package project
package_project() {
    local project_name="$1"
    local verbose="$2"
    
    if [ -z "$project_name" ]; then
        print_error "Project name required"
        list_projects
        exit 1
    fi
    
    local project_dir=$(get_project_dir "$project_name")
    if [ ! -d "$project_dir" ]; then
        print_error "Project directory not found: $project_dir"
        list_projects
        exit 1
    fi
    
    print_status "Packaging project: $project_name"
    
    cd "$project_dir"
    
    # Check if Makefile exists
    if [ -f "Makefile" ]; then
        if [ "$verbose" = "true" ]; then
            make package
        else
            make package > /dev/null 2>&1
        fi
    elif [ -d "build" ]; then
        cd build
        if [ "$verbose" = "true" ]; then
            cpack
        else
            cpack > /dev/null 2>&1
        fi
    else
        print_error "No package configuration found for $project_name"
        exit 1
    fi
    
    if [ $? -eq 0 ]; then
        print_success "Project $project_name packaged successfully"
    else
        print_error "Project $project_name packaging failed"
        exit 1
    fi
}

# Function to clean project
clean_project() {
    local project_name="$1"
    
    if [ -z "$project_name" ]; then
        print_error "Project name required"
        list_projects
        exit 1
    fi
    
    local project_dir=$(get_project_dir "$project_name")
    if [ ! -d "$project_dir" ]; then
        print_error "Project directory not found: $project_dir"
        list_projects
        exit 1
    fi
    
    print_status "Cleaning project: $project_name"
    
    cd "$project_dir"
    
    # Check if Makefile exists
    if [ -f "Makefile" ]; then
        make clean
    elif [ -d "build" ]; then
        rm -rf build
    fi
    
    print_success "Project $project_name cleaned"
}

# Function to show project status
show_status() {
    local project_name="$1"
    
    if [ -n "$project_name" ]; then
        local project_dir=$(get_project_dir "$project_name")
        if [ ! -d "$project_dir" ]; then
            print_error "Project directory not found: $project_dir"
            list_projects
            exit 1
        fi
        
        print_status "Status for project: $project_name"
        echo ""
        
        # Check if binary exists
        if [ -f "$project_dir/build/$project_name" ]; then
            echo "  ✅ Binary: Found"
        else
            echo "  ❌ Binary: Not found"
        fi
        
        # Check if service is installed
        if systemctl list-unit-files | grep -q "$project_name.service"; then
            echo "  ✅ Service: Installed"
            systemctl is-active "$project_name.service" > /dev/null 2>&1
            if [ $? -eq 0 ]; then
                echo "  ✅ Status: Running"
            else
                echo "  ⚠️  Status: Stopped"
            fi
        else
            echo "  ❌ Service: Not installed"
        fi
        
        # Check if packages exist
        if [ -d "$project_dir/dist" ]; then
            echo "  ✅ Packages: Found"
            ls -la "$project_dir/dist/"
        else
            echo "  ❌ Packages: Not found"
        fi
    else
        print_status "Status for all projects:"
        echo ""
        
        for project_dir in "$ROOT_DIR/projects"/*/; do
            if [ -d "$project_dir" ]; then
                project_name=$(basename "$project_dir")
                echo "Project: $project_name"
                
                # Check if binary exists
                if [ -f "$project_dir/build/$project_name" ]; then
                    echo "  ✅ Binary: Found"
                else
                    echo "  ❌ Binary: Not found"
                fi
                
                # Check if service is installed
                if systemctl list-unit-files | grep -q "$project_name.service"; then
                    echo "  ✅ Service: Installed"
                    systemctl is-active "$project_name.service" > /dev/null 2>&1
                    if [ $? -eq 0 ]; then
                        echo "  ✅ Status: Running"
                    else
                        echo "  ⚠️  Status: Stopped"
                    fi
                else
                    echo "  ❌ Service: Not installed"
                fi
                
                echo ""
            fi
        done
    fi
}

# Function to standardize project
standardize_project() {
    local project_name="$1"
    local force="$2"
    
    if [ -z "$project_name" ]; then
        print_error "Project name required"
        list_projects
        exit 1
    fi
    
    local project_dir=$(get_project_dir "$project_name")
    if [ ! -d "$project_dir" ]; then
        print_error "Project directory not found: $project_dir"
        list_projects
        exit 1
    fi
    
    print_status "Standardizing project: $project_name"
    
    cd "$STANDARDIZATION_DIR"
    
    local force_flag=""
    if [ "$force" = "true" ]; then
        force_flag="--force"
    fi
    
    ./implement_standardization.sh "$project_name" $force_flag
    
    print_success "Project $project_name standardized"
}

# Function to build all projects
build_all() {
    local verbose="$1"
    
    print_status "Building all projects..."
    
    for project_dir in "$ROOT_DIR/projects"/*/; do
        if [ -d "$project_dir" ]; then
            project_name=$(basename "$project_dir")
            echo ""
            build_project "$project_name" "$verbose"
        fi
    done
    
    print_success "All projects built successfully"
}

# Function to test all projects
test_all() {
    local verbose="$1"
    
    print_status "Testing all projects..."
    
    for project_dir in "$ROOT_DIR/projects"/*/; do
        if [ -d "$project_dir" ]; then
            project_name=$(basename "$project_dir")
            echo ""
            test_project "$project_name" "$verbose"
        fi
    done
    
    print_success "All projects tested successfully"
}

# Function to clean all projects
clean_all() {
    print_status "Cleaning all projects..."
    
    for project_dir in "$ROOT_DIR/projects"/*/; do
        if [ -d "$project_dir" ]; then
            project_name=$(basename "$project_dir")
            echo ""
            clean_project "$project_name"
        fi
    done
    
    print_success "All projects cleaned successfully"
}

# Main function
main() {
    local command="$1"
    local project="$2"
    local verbose="false"
    local force="false"
    
    # Parse options
    shift 2
    while [[ $# -gt 0 ]]; do
        case $1 in
            -v|--verbose)
                verbose="true"
                shift
                ;;
            -f|--force)
                force="true"
                shift
                ;;
            -h|--help)
                show_usage
                exit 0
                ;;
            *)
                print_error "Unknown option: $1"
                show_usage
                exit 1
                ;;
        esac
    done
    
    case "$command" in
        build)
            build_project "$project" "$verbose"
            ;;
        test)
            test_project "$project" "$verbose"
            ;;
        install)
            install_project "$project" "$verbose"
            ;;
        package)
            package_project "$project" "$verbose"
            ;;
        clean)
            clean_project "$project"
            ;;
        status)
            show_status "$project"
            ;;
        standardize)
            standardize_project "$project" "$force"
            ;;
        all-build)
            build_all "$verbose"
            ;;
        all-test)
            test_all "$verbose"
            ;;
        all-clean)
            clean_all
            ;;
        list)
            list_projects
            ;;
        -h|--help|help)
            show_usage
            ;;
        *)
            print_error "Unknown command: $command"
            show_usage
            exit 1
            ;;
    esac
}

# Run main function with all arguments
main "$@"
EOF
        chmod +x "$project_automation"
        print_success "Created project automation script"
    fi
    
    print_success "Automation helper scripts created"
}

# Main function
main() {
    local dry_run="false"
    local force="false"
    local projects_only="false"
    local vagrant_only="false"
    local ansible_only="false"
    local standardize_only="false"
    
    # Parse command line arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_usage
                exit 0
                ;;
            -d|--dry-run)
                dry_run="true"
                shift
                ;;
            -f|--force)
                force="true"
                shift
                ;;
            -p|--projects)
                projects_only="true"
                shift
                ;;
            -v|--vagrant)
                vagrant_only="true"
                shift
                ;;
            -a|--ansible)
                ansible_only="true"
                shift
                ;;
            -s|--standardize)
                standardize_only="true"
                shift
                ;;
            -*)
                print_error "Unknown option: $1"
                show_usage
                exit 1
                ;;
            *)
                print_error "Unknown argument: $1"
                show_usage
                exit 1
                ;;
        esac
    done
    
    # Show dry run warning
    if [ "$dry_run" = "true" ]; then
        print_warning "DRY RUN MODE - No files will be modified"
    fi
    
    # Check prerequisites
    check_prerequisites
    
    # Run specific tasks based on options
    if [ "$standardize_only" = "true" ]; then
        implement_standardization "$dry_run" "$force"
    elif [ "$projects_only" = "true" ]; then
        implement_standardization "$dry_run" "$force"
        create_automation_scripts "$dry_run"
    elif [ "$vagrant_only" = "true" ]; then
        update_vagrant_configs "$dry_run" "$force"
    elif [ "$ansible_only" = "true" ]; then
        setup_ansible_configs "$dry_run"
    else
        # Run all tasks
        implement_standardization "$dry_run" "$force"
        update_vagrant_configs "$dry_run" "$force"
        setup_ansible_configs "$dry_run"
        create_automation_scripts "$dry_run"
    fi
    
    print_success "Automation setup completed!"
    
    # Show next steps
    echo ""
    print_status "Next steps:"
    echo "  1. Start a development VM:"
    echo "     cd virtuals/ubuntu_dev && vagrant up"
    echo ""
    echo "  2. Or use the VM manager:"
    echo "     ./automation/scripts/vm-manager up ubuntu_dev"
    echo ""
    echo "  3. Use project automation:"
    echo "     ./automation/scripts/project-automation build simple-ntpd"
    echo ""
    echo "  4. SSH into VM:"
    echo "     ./automation/scripts/vm-manager ssh ubuntu_dev"
    echo ""
    echo "  5. Check project status:"
    echo "     ./automation/scripts/project-automation status"
}

# Run main function with all arguments
main "$@"
