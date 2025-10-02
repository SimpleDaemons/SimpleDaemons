#!/bin/bash
# SimpleDaemons Submodule Management Script
# This script helps manage git submodules for all SimpleDaemons projects

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
    echo "  init                    Initialize all submodules"
    echo "  update                  Update all submodules to latest"
    echo "  status                  Show submodule status"
    echo "  add <project> <url>     Add new project submodule"
    echo "  remove <project>        Remove project submodule"
    echo "  sync                    Sync submodule URLs with .gitmodules"
    echo "  clean                   Clean submodule working directories"
    echo "  help                    Show this help message"
    echo ""
    echo "Options:"
    echo "  -h, --help              Show this help message"
    echo "  -v, --verbose           Verbose output"
    echo "  -f, --force             Force operations"
    echo ""
    echo "Examples:"
    echo "  $0 init                 # Initialize all submodules"
    echo "  $0 update               # Update all submodules"
    echo "  $0 status               # Show status of all submodules"
    echo "  $0 add simple-new https://github.com/user/simple-new.git"
    echo "  $0 remove simple-old    # Remove simple-old submodule"
}

# Function to initialize submodules
init_submodules() {
    local verbose="$1"
    
    print_status "Initializing all submodules..."
    
    cd "$ROOT_DIR"
    
    if [ "$verbose" = "true" ]; then
        git submodule update --init --recursive
    else
        git submodule update --init --recursive > /dev/null 2>&1
    fi
    
    print_success "All submodules initialized"
}

# Function to update submodules
update_submodules() {
    local verbose="$1"
    
    print_status "Updating all submodules to latest..."
    
    cd "$ROOT_DIR"
    
    if [ "$verbose" = "true" ]; then
        git submodule update --remote
    else
        git submodule update --remote > /dev/null 2>&1
    fi
    
    print_success "All submodules updated"
}

# Function to show submodule status
show_status() {
    print_status "Submodule status:"
    
    cd "$ROOT_DIR"
    git submodule status
    
    echo ""
    print_status "Project directories:"
    for project_dir in "$PROJECTS_DIR"/*/; do
        if [ -d "$project_dir" ]; then
            project_name=$(basename "$project_dir")
            if [ -d "$project_dir/.git" ]; then
                echo "  ✅ $project_name (submodule)"
            else
                echo "  ❌ $project_name (not a submodule)"
            fi
        fi
    done
}

# Function to add new submodule
add_submodule() {
    local project_name="$1"
    local project_url="$2"
    local verbose="$3"
    
    if [ -z "$project_name" ] || [ -z "$project_url" ]; then
        print_error "Project name and URL required"
        echo "Usage: $0 add <project> <url>"
        exit 1
    fi
    
    local project_path="projects/$project_name"
    
    if [ -d "$project_path" ]; then
        print_error "Project directory already exists: $project_path"
        exit 1
    fi
    
    print_status "Adding submodule: $project_name"
    print_status "URL: $project_url"
    print_status "Path: $project_path"
    
    cd "$ROOT_DIR"
    
    if [ "$verbose" = "true" ]; then
        git submodule add "$project_url" "$project_path"
    else
        git submodule add "$project_url" "$project_path" > /dev/null 2>&1
    fi
    
    print_success "Submodule added: $project_name"
    print_status "Don't forget to commit the changes:"
    echo "  git add .gitmodules $project_path"
    echo "  git commit -m \"Add $project_name submodule\""
}

# Function to remove submodule
remove_submodule() {
    local project_name="$1"
    local force="$2"
    
    if [ -z "$project_name" ]; then
        print_error "Project name required"
        echo "Usage: $0 remove <project>"
        exit 1
    fi
    
    local project_path="projects/$project_name"
    
    if [ ! -d "$project_path" ]; then
        print_error "Project directory not found: $project_path"
        exit 1
    fi
    
    if [ ! -d "$project_path/.git" ]; then
        print_error "Not a submodule: $project_path"
        exit 1
    fi
    
    print_warning "Removing submodule: $project_name"
    print_warning "This will remove the directory and update .gitmodules"
    
    if [ "$force" != "true" ]; then
        read -p "Are you sure? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            print_status "Operation cancelled"
            exit 0
        fi
    fi
    
    cd "$ROOT_DIR"
    
    # Remove submodule
    git submodule deinit -f "$project_path"
    git rm -f "$project_path"
    rm -rf ".git/modules/$project_path"
    
    print_success "Submodule removed: $project_name"
    print_status "Don't forget to commit the changes:"
    echo "  git commit -m \"Remove $project_name submodule\""
}

# Function to sync submodule URLs
sync_submodules() {
    print_status "Syncing submodule URLs..."
    
    cd "$ROOT_DIR"
    
    # Read .gitmodules and update URLs
    while IFS= read -r line; do
        if [[ $line == \[submodule* ]]; then
            # Extract submodule name
            submodule_name=$(echo "$line" | sed 's/\[submodule "\(.*\)"\]/\1/')
        elif [[ $line == url* ]]; then
            # Extract URL
            url=$(echo "$line" | sed 's/url = \(.*\)/\1/')
            
            if [ -n "$submodule_name" ] && [ -n "$url" ]; then
                print_status "Syncing $submodule_name -> $url"
                git config submodule."$submodule_name".url "$url"
            fi
        fi
    done < .gitmodules
    
    print_success "Submodule URLs synced"
}

# Function to clean submodule working directories
clean_submodules() {
    local force="$1"
    
    print_warning "Cleaning submodule working directories..."
    print_warning "This will remove all uncommitted changes in submodules"
    
    if [ "$force" != "true" ]; then
        read -p "Are you sure? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            print_status "Operation cancelled"
            exit 0
        fi
    fi
    
    cd "$ROOT_DIR"
    
    # Clean all submodules
    git submodule foreach --recursive git clean -fd
    git submodule foreach --recursive git reset --hard
    
    print_success "Submodule working directories cleaned"
}

# Function to list available projects
list_projects() {
    print_status "Available projects:"
    
    for project_dir in "$PROJECTS_DIR"/*/; do
        if [ -d "$project_dir" ]; then
            project_name=$(basename "$project_dir")
            if [ -d "$project_dir/.git" ]; then
                echo "  ✅ $project_name (submodule)"
            else
                echo "  ❌ $project_name (not a submodule)"
            fi
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
        init)
            init_submodules "$verbose"
            ;;
        update)
            update_submodules "$verbose"
            ;;
        status)
            show_status
            ;;
        add)
            add_submodule "$1" "$2" "$verbose"
            ;;
        remove)
            remove_submodule "$1" "$force"
            ;;
        sync)
            sync_submodules
            ;;
        clean)
            clean_submodules "$force"
            ;;
        list)
            list_projects
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
