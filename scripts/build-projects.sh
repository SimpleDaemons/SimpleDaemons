#!/bin/bash
# Build projects script for SimpleDaemons
# Copyright 2024 SimpleDaemons

set -e

# Configuration
BUILD_TYPE=${BUILD_TYPE:-Release}
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

# Function to build a single project
build_project() {
    local project=$1
    local project_dir="projects/$project"
    
    if [ ! -d "$project_dir" ]; then
        log_error "Project directory not found: $project_dir"
        return 1
    fi
    
    log_info "Building $project..."
    
    cd "$project_dir"
    
    # Create build directory
    mkdir -p build
    cd build
    
    # Configure CMake
    log_info "Configuring $project with CMake..."
    cmake .. -DCMAKE_BUILD_TYPE="$BUILD_TYPE" \
             -DCMAKE_CXX_COMPILER="$CXX" \
             -DCMAKE_C_COMPILER="$CC"
    
    # Build
    log_info "Building $project..."
    make -j$(nproc 2>/dev/null || sysctl -n hw.ncpu 2>/dev/null || echo 4)
    
    # Create packages if requested
    if [ "$CREATE_PACKAGES" = "true" ]; then
        log_info "Creating packages for $project..."
        make package || log_warning "Package creation failed for $project"
    fi
    
    # Return to root directory
    cd ../../..
    
    log_success "Successfully built $project"
}

# Function to build projects by category
build_category() {
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
    
    log_info "Building $category projects: $projects"
    
    local failed_projects=()
    local successful_projects=()
    
    for project in $projects; do
        if build_project "$project"; then
            successful_projects+=("$project")
        else
            failed_projects+=("$project")
        fi
    done
    
    # Summary
    log_info "Build summary for $category projects:"
    log_success "Successful: ${#successful_projects[@]} projects"
    if [ ${#failed_projects[@]} -gt 0 ]; then
        log_error "Failed: ${#failed_projects[@]} projects"
        log_error "Failed projects: ${failed_projects[*]}"
        return 1
    fi
}

# Main execution
main() {
    log_info "Starting build process..."
    log_info "Build type: $BUILD_TYPE"
    log_info "Projects: $PROJECTS"
    log_info "CC: $CC"
    log_info "CXX: $CXX"
    
    # Check if we're in the right directory
    if [ ! -d "projects" ]; then
        log_error "This script must be run from the SimpleDaemons root directory"
        exit 1
    fi
    
    # Build projects
    if build_category "$PROJECTS"; then
        log_success "All projects built successfully!"
        exit 0
    else
        log_error "Some projects failed to build"
        exit 1
    fi
}

# Run main function
main "$@"
