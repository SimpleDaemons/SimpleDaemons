#!/bin/bash
# SimpleDaemons Submodule Setup Script
# This script sets up the git submodule structure for all projects

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
    echo "  -u, --urls <file>   Use custom URLs file (default: .gitmodules.template)"
    echo ""
    echo "This script sets up the git submodule structure:"
    echo "  - Creates .gitmodules file from template"
    echo "  - Sets up project directories as submodules"
    echo "  - Initializes submodules"
    echo ""
    echo "Examples:"
    echo "  $0                  # Setup with default URLs"
    echo "  $0 --dry-run        # Preview changes"
    echo "  $0 --urls custom.txt # Use custom URLs"
}

# Function to setup submodules
setup_submodules() {
    local dry_run="$1"
    local force="$2"
    local urls_file="$3"
    
    print_status "Setting up git submodules..."
    
    cd "$ROOT_DIR"
    
    # Check if .gitmodules already exists
    if [ -f ".gitmodules" ] && [ "$force" != "true" ]; then
        print_warning ".gitmodules already exists. Use --force to overwrite."
        return 1
    fi
    
    # Use template or custom URLs file
    local source_file="$urls_file"
    if [ -z "$source_file" ]; then
        source_file=".gitmodules.template"
    fi
    
    if [ ! -f "$source_file" ]; then
        print_error "URLs file not found: $source_file"
        exit 1
    fi
    
    if [ "$dry_run" = "true" ]; then
        print_status "Would create .gitmodules from $source_file"
        print_status "Would initialize submodules"
        return 0
    fi
    
    # Create .gitmodules from template
    cp "$source_file" ".gitmodules"
    print_success "Created .gitmodules from $source_file"
    
    # Initialize submodules
    print_status "Initializing submodules..."
    git submodule update --init --recursive
    
    print_success "Submodules initialized"
}

# Function to create individual project repositories
create_project_repos() {
    local dry_run="$1"
    local force="$2"
    
    print_status "Creating individual project repositories..."
    
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
        local project_dir="projects/$project"
        
        if [ -d "$project_dir" ]; then
            if [ "$force" = "true" ]; then
                print_warning "Removing existing $project directory"
                rm -rf "$project_dir"
            else
                print_warning "Project directory exists: $project_dir (use --force to overwrite)"
                continue
            fi
        fi
        
        if [ "$dry_run" = "true" ]; then
            print_status "Would create repository for $project"
            continue
        fi
        
        # Create project directory
        mkdir -p "$project_dir"
        
        # Initialize git repository
        cd "$project_dir"
        git init
        
        # Create basic project structure
        mkdir -p src include tests config deployment docs
        
        # Create basic README
        cat > README.md << EOF
# $project

A lightweight and secure $project daemon.

## Description

TODO: Add project description

## Building

\`\`\`bash
make build
make test
make install
\`\`\`

## Usage

\`\`\`bash
$project --help
\`\`\`

## Configuration

Configuration files are located in \`config/\`

## Documentation

See \`docs/\` for detailed documentation.

## License

MIT License - see LICENSE file for details.
EOF
        
        # Create basic Makefile
        cat > Makefile << EOF
# $project Makefile

PROJECT_NAME = $project
VERSION = 0.1.0

# Default target
all: build

# Build the project
build:
	@echo "Building \$(PROJECT_NAME)..."
	@mkdir -p build
	@cd build && cmake .. && make

# Run tests
test:
	@echo "Running tests for \$(PROJECT_NAME)..."
	@cd build && ctest

# Install the project
install:
	@echo "Installing \$(PROJECT_NAME)..."
	@cd build && make install

# Clean build artifacts
clean:
	@echo "Cleaning \$(PROJECT_NAME)..."
	@rm -rf build

# Show help
help:
	@echo "Available targets:"
	@echo "  build    - Build the project"
	@echo "  test     - Run tests"
	@echo "  install  - Install the project"
	@echo "  clean    - Clean build artifacts"
	@echo "  help     - Show this help"
EOF
        
        # Create basic CMakeLists.txt
        cat > CMakeLists.txt << EOF
cmake_minimum_required(VERSION 3.10)
project($project VERSION 0.1.0 LANGUAGES CXX)

# Set C++ standard
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Add executable
add_executable(\${PROJECT_NAME} src/main.cpp)

# Include directories
target_include_directories(\${PROJECT_NAME} PRIVATE include)

# Install
install(TARGETS \${PROJECT_NAME} DESTINATION bin)
EOF
        
        # Create basic source file
        mkdir -p src
        cat > src/main.cpp << EOF
#include <iostream>
#include <string>

int main(int argc, char* argv[]) {
    std::cout << "$project v0.1.0" << std::endl;
    std::cout << "TODO: Implement $project daemon" << std::endl;
    return 0;
}
EOF
        
        # Create basic header file
        mkdir -p include
        cat > include/$project.hpp << EOF
#pragma once

#include <string>

namespace $project {
    class Daemon {
    public:
        Daemon();
        ~Daemon();
        
        bool start();
        bool stop();
        bool isRunning() const;
        
    private:
        bool m_running = false;
    };
}
EOF
        
        # Create LICENSE file
        cat > LICENSE << EOF
MIT License

Copyright (c) 2024 SimpleDaemons

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
EOF
        
        # Create .gitignore
        cat > .gitignore << EOF
# Build artifacts
build/
dist/
*.o
*.so
*.a
*.exe
*.dll
*.dylib

# IDE and editor files
.vscode/
.idea/
*.swp
*.swo
*~

# Temporary files
*.tmp
*.temp
*.log
*.pid
*.lock

# Package files
*.deb
*.rpm
*.msi
*.dmg
*.pkg
*.zip
*.tar.gz

# OS generated files
.DS_Store
.DS_Store?
._*
.Spotlight-V100
.Trashes
ehthumbs.db
Thumbs.db
EOF
        
        # Initial commit
        git add .
        git commit -m "Initial commit: $project v0.1.0"
        
        cd "$ROOT_DIR"
        print_success "Created repository for $project"
    done
}

# Main function
main() {
    local dry_run="false"
    local force="false"
    local urls_file=""
    
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
            -u|--urls)
                urls_file="$2"
                shift 2
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
    
    # Setup submodules
    setup_submodules "$dry_run" "$force" "$urls_file"
    
    print_success "Submodule setup completed!"
    
    # Show next steps
    echo ""
    print_status "Next steps:"
    echo "  1. Create individual project repositories:"
    echo "     ./scripts/setup-submodules.sh --create-repos"
    echo ""
    echo "  2. Push repositories to remote:"
    echo "     # For each project:"
    echo "     cd projects/simple-ntpd"
    echo "     git remote add origin https://github.com/simpledaemons/simple-ntpd.git"
    echo "     git push -u origin main"
    echo ""
    echo "  3. Update .gitmodules with actual URLs"
    echo ""
    echo "  4. Commit submodule changes:"
    echo "     git add .gitmodules projects/"
    echo "     git commit -m \"Add project submodules\""
}

# Run main function with all arguments
main "$@"
