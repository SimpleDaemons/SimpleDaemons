#!/bin/bash
# SimpleDaemons Upstream Management Script
# This script helps manage upstream relationships between forks and original repositories

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
PROJECTS_DIR="$ROOT_DIR/projects"

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
    echo "  setup-upstream <project>    Setup upstream remote for project"
    echo "  setup-all-upstreams         Setup upstream remotes for all projects"
    echo "  sync-upstream <project>     Sync project with upstream"
    echo "  sync-all-upstreams          Sync all projects with upstream"
    echo "  status                      Show upstream status for all projects"
    echo "  help                        Show this help message"
    echo ""
    echo "Options:"
    echo "  -h, --help                 Show this help message"
    echo "  -v, --verbose              Verbose output"
    echo "  -f, --force                Force operations"
    echo ""
    echo "Examples:"
    echo "  $0 setup-upstream simple-ntpd    # Setup upstream for simple-ntpd"
    echo "  $0 setup-all-upstreams           # Setup upstream for all projects"
    echo "  $0 sync-upstream simple-ntpd     # Sync simple-ntpd with upstream"
    echo "  $0 status                         # Show status of all projects"
}

# Function to get upstream URL for project
get_upstream_url() {
    local project_name="$1"
    echo "https://github.com/SimpleDaemons/$project_name.git"
}

# Function to setup upstream remote for a project
setup_upstream() {
    local project_name="$1"
    local verbose="$2"
    
    if [ -z "$project_name" ]; then
        print_error "Project name required"
        echo "Usage: $0 setup-upstream <project>"
        exit 1
    fi
    
    local project_dir="$PROJECTS_DIR/$project_name"
    if [ ! -d "$project_dir" ]; then
        print_error "Project directory not found: $project_dir"
        exit 1
    fi
    
    local upstream_url=$(get_upstream_url "$project_name")
    
    print_status "Setting up upstream for $project_name"
    print_status "Upstream URL: $upstream_url"
    
    cd "$project_dir"
    
    # Check if upstream remote already exists
    if git remote get-url upstream > /dev/null 2>&1; then
        print_warning "Upstream remote already exists"
        if [ "$verbose" = "true" ]; then
            git remote -v
        fi
        return 0
    fi
    
    # Add upstream remote
    git remote add upstream "$upstream_url"
    
    # Fetch upstream
    if [ "$verbose" = "true" ]; then
        git fetch upstream
    else
        git fetch upstream > /dev/null 2>&1
    fi
    
    print_success "Upstream remote added for $project_name"
}

# Function to setup upstream for all projects
setup_all_upstreams() {
    local verbose="$1"
    
    print_status "Setting up upstream remotes for all projects..."
    
    # List of projects
    local projects=(
        "simple-dhcpd"
        "simple-dnsd"
        "simple-dummy"
        "simple-httpd"
        "simple-nfsd"
        "simple-ntpd"
        "simple-proxyd"
        "simple-rsyncd"
        "simple-sftpd"
        "simple-smbd"
        "simple-smtpd"
        "simple-snmpd"
        "simple-tftpd"
        "simple-utcd"
    )
    
    for project in "${projects[@]}"; do
        local project_dir="$PROJECTS_DIR/$project"
        if [ -d "$project_dir" ]; then
            echo ""
            setup_upstream "$project" "$verbose"
        else
            print_warning "Project directory not found: $project_dir"
        fi
    done
    
    print_success "Upstream setup completed for all projects"
}

# Function to sync project with upstream
sync_upstream() {
    local project_name="$1"
    local verbose="$2"
    
    if [ -z "$project_name" ]; then
        print_error "Project name required"
        echo "Usage: $0 sync-upstream <project>"
        exit 1
    fi
    
    local project_dir="$PROJECTS_DIR/$project_name"
    if [ ! -d "$project_dir" ]; then
        print_error "Project directory not found: $project_dir"
        exit 1
    fi
    
    print_status "Syncing $project_name with upstream..."
    
    cd "$project_dir"
    
    # Check if upstream remote exists
    if ! git remote get-url upstream > /dev/null 2>&1; then
        print_error "Upstream remote not found. Run 'setup-upstream $project_name' first."
        exit 1
    fi
    
    # Fetch upstream
    if [ "$verbose" = "true" ]; then
        git fetch upstream
    else
        git fetch upstream > /dev/null 2>&1
    fi
    
    # Check current branch
    local current_branch=$(git branch --show-current)
    
    # Merge upstream changes
    if [ "$verbose" = "true" ]; then
        git merge upstream/$current_branch
    else
        git merge upstream/$current_branch > /dev/null 2>&1
    fi
    
    print_success "Synced $project_name with upstream"
}

# Function to sync all projects with upstream
sync_all_upstreams() {
    local verbose="$1"
    
    print_status "Syncing all projects with upstream..."
    
    # List of projects
    local projects=(
        "simple-dhcpd"
        "simple-dnsd"
        "simple-dummy"
        "simple-httpd"
        "simple-nfsd"
        "simple-ntpd"
        "simple-proxyd"
        "simple-rsyncd"
        "simple-sftpd"
        "simple-smbd"
        "simple-smtpd"
        "simple-snmpd"
        "simple-tftpd"
        "simple-utcd"
    )
    
    for project in "${projects[@]}"; do
        local project_dir="$PROJECTS_DIR/$project"
        if [ -d "$project_dir" ]; then
            echo ""
            sync_upstream "$project" "$verbose"
        else
            print_warning "Project directory not found: $project_dir"
        fi
    done
    
    print_success "All projects synced with upstream"
}

# Function to show upstream status
show_status() {
    print_status "Upstream status for all projects:"
    echo ""
    
    # List of projects
    local projects=(
        "simple-dhcpd"
        "simple-dnsd"
        "simple-dummy"
        "simple-httpd"
        "simple-nfsd"
        "simple-ntpd"
        "simple-proxyd"
        "simple-rsyncd"
        "simple-sftpd"
        "simple-smbd"
        "simple-smtpd"
        "simple-snmpd"
        "simple-tftpd"
        "simple-utcd"
    )
    
    for project in "${projects[@]}"; do
        local project_dir="$PROJECTS_DIR/$project"
        if [ -d "$project_dir" ]; then
            echo "Project: $project"
            cd "$project_dir"
            
            # Check if upstream remote exists
            if git remote get-url upstream > /dev/null 2>&1; then
                echo "  ✅ Upstream remote: $(git remote get-url upstream)"
                
                # Check if there are upstream changes
                git fetch upstream > /dev/null 2>&1
                local current_branch=$(git branch --show-current)
                local behind=$(git rev-list --count HEAD..upstream/$current_branch 2>/dev/null || echo "0")
                local ahead=$(git rev-list --count upstream/$current_branch..HEAD 2>/dev/null || echo "0")
                
                if [ "$behind" -gt 0 ]; then
                    echo "  ⚠️  Behind upstream by $behind commits"
                fi
                if [ "$ahead" -gt 0 ]; then
                    echo "  ✅ Ahead of upstream by $ahead commits"
                fi
                if [ "$behind" -eq 0 ] && [ "$ahead" -eq 0 ]; then
                    echo "  ✅ Up to date with upstream"
                fi
            else
                echo "  ❌ No upstream remote configured"
            fi
            
            echo ""
        fi
    done
}

# Main function
main() {
    local command="$1"
    local verbose="false"
    local force="false"
    
    # Parse options
    shift
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
                break
                ;;
        esac
    done
    
    case "$command" in
        setup-upstream)
            setup_upstream "$1" "$verbose"
            ;;
        setup-all-upstreams)
            setup_all_upstreams "$verbose"
            ;;
        sync-upstream)
            sync_upstream "$1" "$verbose"
            ;;
        sync-all-upstreams)
            sync_all_upstreams "$verbose"
            ;;
        status)
            show_status
            ;;
        help|--help|-h)
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
