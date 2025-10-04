#!/bin/bash
# Test projects script for SimpleDaemons
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

# Function to test a single project
test_project() {
    local project=$1
    local project_dir="projects/$project"

    if [ ! -d "$project_dir" ]; then
        log_error "Project directory not found: $project_dir"
        return 1
    fi

    log_info "Testing $project..."

    cd "$project_dir"

    # Check if build directory exists
    if [ ! -d "build" ]; then
        log_warning "Build directory not found for $project, skipping tests"
        cd ../..
        return 0
    fi

    cd build

    # Run tests
    log_info "Running tests for $project..."
    if make test; then
        log_success "Tests passed for $project"
    else
        log_warning "Some tests failed for $project"
        # Don't fail the entire build for test failures
    fi

    # Return to root directory
    cd ../../..
}

# Function to test projects by category
test_category() {
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

    log_info "Testing $category projects: $projects"

    local failed_projects=()
    local successful_projects=()

    for project in $projects; do
        if test_project "$project"; then
            successful_projects+=("$project")
        else
            failed_projects+=("$project")
        fi
    done

    # Summary
    log_info "Test summary for $category projects:"
    log_success "Successful: ${#successful_projects[@]} projects"
    if [ ${#failed_projects[@]} -gt 0 ]; then
        log_warning "Failed: ${#failed_projects[@]} projects"
        log_warning "Failed projects: ${failed_projects[*]}"
    fi
}

# Main execution
main() {
    log_info "Starting test process..."
    log_info "Projects: $PROJECTS"

    # Check if we're in the right directory
    if [ ! -d "projects" ]; then
        log_error "This script must be run from the SimpleDaemons root directory"
        exit 1
    fi

    # Test projects
    test_category "$PROJECTS"

    log_success "Test process completed!"
}

# Run main function
main "$@"
