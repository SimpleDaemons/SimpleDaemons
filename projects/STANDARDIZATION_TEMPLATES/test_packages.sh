#!/bin/bash
# Package testing script for SimpleDaemons projects
# This script tests package creation and validation

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

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
    echo "Usage: $0 [OPTIONS] PROJECT_NAME"
    echo ""
    echo "Options:"
    echo "  -h, --help          Show this help message"
    echo "  -a, --all           Test all package formats"
    echo "  -b, --binary        Test binary packages only"
    echo "  -s, --source        Test source packages only"
    echo "  -v, --verbose       Verbose output"
    echo "  -c, --clean         Clean before testing"
    echo ""
    echo "Package formats tested:"
    echo "  - DEB (Linux)"
    echo "  - RPM (Linux)"
    echo "  - MSI (Windows)"
    echo "  - ZIP (Windows)"
    echo "  - DMG (macOS)"
    echo "  - PKG (macOS)"
    echo "  - TAR.GZ (Source)"
    echo "  - ZIP (Source)"
}

# Function to test package creation
test_package() {
    local project_name="$1"
    local package_type="$2"
    local verbose="$3"
    
    print_status "Testing $package_type package creation for $project_name..."
    
    cd "../$project_name"
    
    # Clean if requested
    if [ "$4" = "true" ]; then
        make clean
    fi
    
    # Build project
    make build
    
    # Test package creation
    case "$package_type" in
        "deb")
            if [ "$(uname -s)" = "Linux" ]; then
                make package-deb
                if [ -f "dist/$project_name-*.deb" ]; then
                    print_success "DEB package created successfully"
                    if [ "$verbose" = "true" ]; then
                        dpkg -I dist/$project_name-*.deb
                    fi
                else
                    print_error "DEB package creation failed"
                    return 1
                fi
            else
                print_warning "DEB packages only supported on Linux"
            fi
            ;;
        "rpm")
            if [ "$(uname -s)" = "Linux" ]; then
                make package-rpm
                if [ -f "dist/$project_name-*.rpm" ]; then
                    print_success "RPM package created successfully"
                    if [ "$verbose" = "true" ]; then
                        rpm -qip dist/$project_name-*.rpm
                    fi
                else
                    print_error "RPM package creation failed"
                    return 1
                fi
            else
                print_warning "RPM packages only supported on Linux"
            fi
            ;;
        "msi")
            if [ "$(uname -s)" = "MINGW"* ] || [ "$(uname -s)" = "CYGWIN"* ]; then
                make package-msi
                if [ -f "dist/$project_name-*.msi" ]; then
                    print_success "MSI package created successfully"
                else
                    print_error "MSI package creation failed"
                    return 1
                fi
            else
                print_warning "MSI packages only supported on Windows"
            fi
            ;;
        "dmg")
            if [ "$(uname -s)" = "Darwin" ]; then
                make package-dmg
                if [ -f "dist/$project_name-*.dmg" ]; then
                    print_success "DMG package created successfully"
                    if [ "$verbose" = "true" ]; then
                        hdiutil info dist/$project_name-*.dmg
                    fi
                else
                    print_error "DMG package creation failed"
                    return 1
                fi
            else
                print_warning "DMG packages only supported on macOS"
            fi
            ;;
        "pkg")
            if [ "$(uname -s)" = "Darwin" ]; then
                make package-pkg
                if [ -f "dist/$project_name-*.pkg" ]; then
                    print_success "PKG package created successfully"
                    if [ "$verbose" = "true" ]; then
                        pkgutil --info dist/$project_name-*.pkg
                    fi
                else
                    print_error "PKG package creation failed"
                    return 1
                fi
            else
                print_warning "PKG packages only supported on macOS"
            fi
            ;;
        "source")
            make package-source
            if [ -f "dist/$project_name-*-src.tar.gz" ] && [ -f "dist/$project_name-*-src.zip" ]; then
                print_success "Source packages created successfully"
                if [ "$verbose" = "true" ]; then
                    tar -tzf dist/$project_name-*-src.tar.gz | head -10
                    unzip -l dist/$project_name-*-src.zip | head -10
                fi
            else
                print_error "Source package creation failed"
                return 1
            fi
            ;;
        "all")
            make package-all
            print_success "All packages created successfully"
            if [ "$verbose" = "true" ]; then
                ls -la dist/
            fi
            ;;
    esac
    
    cd - > /dev/null
}

# Function to validate package contents
validate_package() {
    local project_name="$1"
    local package_file="$2"
    local package_type="$3"
    
    print_status "Validating $package_type package: $package_file"
    
    case "$package_type" in
        "deb")
            if command -v dpkg >/dev/null 2>&1; then
                dpkg -I "$package_file"
                dpkg -c "$package_file" | head -10
            fi
            ;;
        "rpm")
            if command -v rpm >/dev/null 2>&1; then
                rpm -qip "$package_file"
                rpm -qlp "$package_file" | head -10
            fi
            ;;
        "dmg")
            if command -v hdiutil >/dev/null 2>&1; then
                hdiutil info "$package_file"
            fi
            ;;
        "pkg")
            if command -v pkgutil >/dev/null 2>&1; then
                pkgutil --info "$package_file"
            fi
            ;;
        "tar.gz")
            tar -tzf "$package_file" | head -10
            ;;
        "zip")
            unzip -l "$package_file" | head -10
            ;;
    esac
}

# Function to test all packages
test_all_packages() {
    local project_name="$1"
    local verbose="$2"
    local clean="$3"
    
    print_status "Testing all package formats for $project_name..."
    
    # Test platform-specific packages
    case "$(uname -s)" in
        "Linux")
            test_package "$project_name" "deb" "$verbose" "$clean"
            test_package "$project_name" "rpm" "$verbose" "$clean"
            ;;
        "Darwin")
            test_package "$project_name" "dmg" "$verbose" "$clean"
            test_package "$project_name" "pkg" "$verbose" "$clean"
            ;;
        "MINGW"*|"CYGWIN"*)
            test_package "$project_name" "msi" "$verbose" "$clean"
            ;;
    esac
    
    # Test source packages (all platforms)
    test_package "$project_name" "source" "$verbose" "$clean"
    
    print_success "All package tests completed for $project_name"
}

# Main function
main() {
    local project_name=""
    local test_all="false"
    local test_binary="false"
    local test_source="false"
    local verbose="false"
    local clean="false"
    
    # Parse command line arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_usage
                exit 0
                ;;
            -a|--all)
                test_all="true"
                shift
                ;;
            -b|--binary)
                test_binary="true"
                shift
                ;;
            -s|--source)
                test_source="true"
                shift
                ;;
            -v|--verbose)
                verbose="true"
                shift
                ;;
            -c|--clean)
                clean="true"
                shift
                ;;
            -*)
                print_error "Unknown option: $1"
                show_usage
                exit 1
                ;;
            *)
                if [ -z "$project_name" ]; then
                    project_name="$1"
                else
                    print_error "Multiple project names specified"
                    exit 1
                fi
                shift
                ;;
        esac
    done
    
    # Validate arguments
    if [ -z "$project_name" ]; then
        print_error "No project specified. Use --help for usage information."
        exit 1
    fi
    
    # Check if project directory exists
    if [ ! -d "../$project_name" ]; then
        print_error "Project directory not found: ../$project_name"
        exit 1
    fi
    
    # Show package information
    cd "../$project_name"
    make package-info
    cd - > /dev/null
    
    # Run tests based on options
    if [ "$test_all" = "true" ]; then
        test_all_packages "$project_name" "$verbose" "$clean"
    elif [ "$test_binary" = "true" ]; then
        case "$(uname -s)" in
            "Linux")
                test_package "$project_name" "deb" "$verbose" "$clean"
                test_package "$project_name" "rpm" "$verbose" "$clean"
                ;;
            "Darwin")
                test_package "$project_name" "dmg" "$verbose" "$clean"
                test_package "$project_name" "pkg" "$verbose" "$clean"
                ;;
            "MINGW"*|"CYGWIN"*)
                test_package "$project_name" "msi" "$verbose" "$clean"
                ;;
        esac
    elif [ "$test_source" = "true" ]; then
        test_package "$project_name" "source" "$verbose" "$clean"
    else
        # Default: test all packages
        test_all_packages "$project_name" "$verbose" "$clean"
    fi
    
    print_success "Package testing completed successfully!"
}

# Run main function with all arguments
main "$@"
