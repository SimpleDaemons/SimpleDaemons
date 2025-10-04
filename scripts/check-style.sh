#!/bin/bash
# Code style check script for SimpleDaemons
# Copyright 2024 SimpleDaemons

set -e

# Configuration
PROJECTS=${1:-all}

# Project categories
CORE_PROJECTS="simple-ntpd simple-httpd simple-proxyd simple-dhcpd simple-dnsd"
NETWORK_PROJECTS="simple-smtpd simple-tftpd simple-snmpd"
STORAGE_PROJECTS="simple-nfsd simple-rsyncd simple-sftpd simple-smbd"
SECURITY_PROJECTS="simple-utcd simple-dummy"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check style for a single project
check_style_project() {
    local project=$1
    local project_dir="projects/$project"
    
    if [ ! -d "$project_dir" ]; then
        log_error "Project directory not found: $project_dir"
        return 1
    fi
    
    log_info "Checking code style for $project..."
    
    cd "$project_dir"
    
    # Check if Makefile exists and has check-style target
    if [ -f "Makefile" ] && grep -q "check-style" Makefile; then
        log_info "Running make check-style for $project..."
        if make check-style; then
            log_success "Code style check passed for $project"
        else
            log_warning "Code style check failed for $project"
        fi
    else
        # Fallback to clang-format if no Makefile target
        log_info "Running clang-format check for $project..."
        local style_errors=0
        
        # Find C/C++ source files
        find src include -name "*.cpp" -o -name "*.hpp" -o -name "*.c" -o -name "*.h" | while read -r file; do
            if [ -f "$file" ]; then
                if ! clang-format --dry-run --Werror "$file" >/dev/null 2>&1; then
                    log_warning "Style issues found in $file"
                    style_errors=$((style_errors + 1))
                fi
            fi
        done
        
        if [ $style_errors -eq 0 ]; then
            log_success "Code style check passed for $project"
        else
            log_warning "Code style check found $style_errors issues in $project"
        fi
    fi
    
    # Return to root directory
    cd ../..
}

# Function to check style for projects by category
check_style_category() {
    local category=$1
    local projects=""
    
    case "$category" in
        "core")
            projects=$CORE_PROJECTS
            ;;
        "network")
            projects=$NETWORK_PROJECTS
            ;;
        "storage")
            projects=$STORAGE_PROJECTS
            ;;
        "security")
            projects=$SECURITY_PROJECTS
            ;;
        "all")
            projects="$CORE_PROJECTS $NETWORK_PROJECTS $STORAGE_PROJECTS $SECURITY_PROJECTS"
            ;;
        *)
            log_error "Unknown project category: $category"
            return 1
            ;;
    esac
    
    log_info "Checking code style for $category projects: $projects"
    
    local failed_projects=()
    local successful_projects=()
    
    for project in $projects; do
        if check_style_project "$project"; then
            successful_projects+=("$project")
        else
            failed_projects+=("$project")
        fi
    done
    
    # Summary
    log_info "Code style check summary for $category projects:"
    log_success "Successful: ${#successful_projects[@]} projects"
    if [ ${#failed_projects[@]} -gt 0 ]; then
        log_warning "Failed: ${#failed_projects[@]} projects"
        log_warning "Failed projects: ${failed_projects[*]}"
    fi
}

# Main execution
main() {
    log_info "Starting code style check process..."
    log_info "Projects: $PROJECTS"
    
    # Check if we're in the right directory
    if [ ! -d "projects" ]; then
        log_error "This script must be run from the SimpleDaemons root directory"
        exit 1
    fi
    
    # Check if clang-format is available
    if ! command -v clang-format >/dev/null 2>&1; then
        log_warning "clang-format not found, some style checks may be skipped"
    fi
    
    # Check style for projects
    check_style_category "$PROJECTS"
    
    log_success "Code style check process completed!"
}

# Run main function
main "$@"
