#!/bin/bash
# Implementation script for SimpleDaemons standardization
# This script helps implement the standardized build system across all projects

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATES_DIR="$SCRIPT_DIR"
PROJECT_CONFIGS_DIR="$TEMPLATES_DIR/project-configs"

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
    echo "  -l, --list          List available projects"
    echo "  -a, --all           Implement for all projects"
    echo "  -d, --dry-run       Show what would be done without making changes"
    echo "  -f, --force         Force overwrite existing files"
    echo ""
    echo "Available projects:"
    for config in "$PROJECT_CONFIGS_DIR"/*.conf; do
        if [ -f "$config" ]; then
            project_name=$(basename "$config" .conf)
            echo "  - $project_name"
        fi
    done
}

# Function to list available projects
list_projects() {
    print_status "Available projects:"
    for config in "$PROJECT_CONFIGS_DIR"/*.conf; do
        if [ -f "$config" ]; then
            project_name=$(basename "$config" .conf)
            echo "  - $project_name"
        fi
    done
}

# Function to load project configuration
load_project_config() {
    local project_name="$1"
    local config_file="$PROJECT_CONFIGS_DIR/$project_name.conf"
    
    if [ ! -f "$config_file" ]; then
        print_error "Configuration file not found: $config_file"
        return 1
    fi
    
    # Source the configuration
    source "$config_file"
    print_success "Loaded configuration for $project_name"
}

# Function to replace placeholders in template
replace_placeholders() {
    local template_file="$1"
    local output_file="$2"
    local project_name="$3"
    
    # Load project configuration
    load_project_config "$project_name"
    
    # Create output file with replacements
    sed -e "s/{{PROJECT_NAME}}/$PROJECT_NAME/g" \
        -e "s/{{PROJECT_DESCRIPTION}}/$PROJECT_DESCRIPTION/g" \
        -e "s/{{VERSION}}/$VERSION/g" \
        -e "s/{{YEAR}}/$YEAR/g" \
        -e "s/{{DEFAULT_PORT}}/$DEFAULT_PORT/g" \
        -e "s/{{SERVICE_NAME}}/$SERVICE_NAME/g" \
        -e "s/{{PROJECT_NAME_UPPER}}/$(echo $PROJECT_NAME | tr '[:lower:]' '[:upper:]')/g" \
        "$template_file" > "$output_file"
    
    print_success "Created $output_file for $project_name"
}

# Function to implement directory with template processing
implement_directory() {
    local template_dir="$1"
    local target_dir="$2"
    local project_name="$3"
    
    # Load project configuration
    load_project_config "$project_name"
    
    # Create target directory
    mkdir -p "$target_dir"
    
    # Process all files in template directory
    find "$template_dir" -type f | while read -r source_file; do
        # Get relative path from template directory
        local rel_path="${source_file#$template_dir/}"
        
        # Check if it's a template file
        if [[ "$rel_path" == *.template ]]; then
            # Remove .template extension
            local target_file="${rel_path%.template}"
        else
            # Use as-is
            local target_file="$rel_path"
        fi
        
        # Create target file path
        local full_target_path="$target_dir/$target_file"
        
        # Create target directory if needed
        local target_file_dir=$(dirname "$full_target_path")
        mkdir -p "$target_file_dir"
        
        # Process file (template or regular)
        if [[ "$rel_path" == *.template ]]; then
            replace_placeholders "$source_file" "$full_target_path" "$project_name"
        else
            cp "$source_file" "$full_target_path"
        fi
    done
    
    print_success "Created directory $target_dir for $project_name"
}

# Function to implement standardization for a single project
implement_project() {
    local project_name="$1"
    local dry_run="$2"
    local force="$3"
    
    print_status "Implementing standardization for $project_name..."
    
    # Check if project directory exists
    if [ ! -d "../$project_name" ]; then
        print_error "Project directory not found: ../$project_name"
        return 1
    fi
    
    cd "../$project_name"
    
    # Files to implement
    local files=(
        "Makefile:Makefile.template"
        "CMakeLists.txt:CMakeLists.template"
        ".travis.yml:.travis.yml"
        "Jenkinsfile:Jenkinsfile"
    )
    
    # Directories to implement
    local directories=(
        "scripts:scripts"
        "deployment:deployment"
    )
    
    for file_info in "${files[@]}"; do
        local target_file="${file_info%%:*}"
        local template_file="${file_info##*:}"
        local template_path="$TEMPLATES_DIR/$template_file"
        
        if [ ! -f "$template_path" ]; then
            print_error "Template file not found: $template_path"
            continue
        fi
        
        # Check if target file exists and force is not set
        if [ -f "$target_file" ] && [ "$force" != "true" ]; then
            print_warning "File $target_file already exists. Use --force to overwrite."
            continue
        fi
        
        if [ "$dry_run" = "true" ]; then
            print_status "Would create $target_file from $template_file"
        else
            replace_placeholders "$template_path" "$target_file" "$project_name"
        fi
    done
    
    # Process directories
    for dir_info in "${directories[@]}"; do
        local target_dir="${dir_info%%:*}"
        local template_dir="${dir_info##*:}"
        local template_path="$TEMPLATES_DIR/$template_dir"
        
        if [ ! -d "$template_path" ]; then
            print_error "Template directory not found: $template_path"
            continue
        fi
        
        # Check if target directory exists and force is not set
        if [ -d "$target_dir" ] && [ "$force" != "true" ]; then
            print_warning "Directory $target_dir already exists. Use --force to overwrite."
            continue
        fi
        
        if [ "$dry_run" = "true" ]; then
            print_status "Would create directory $target_dir from $template_dir"
        else
            implement_directory "$template_path" "$target_dir" "$project_name"
        fi
    done
    
    # Project-specific files are now handled through directory processing
    
    cd - > /dev/null
    print_success "Standardization implemented for $project_name"
}

# Function to create project-specific files
create_project_files() {
    local project_name="$1"
    local dry_run="$2"
    local force="$3"
    
    # Load project configuration
    load_project_config "$project_name"
    
    # Create deployment directory structure
    local deployment_dirs=(
        "deployment/systemd"
        "deployment/launchd"
        "deployment/windows"
        "deployment/logrotate.d"
    )
    
    for dir in "${deployment_dirs[@]}"; do
        if [ "$dry_run" = "true" ]; then
            print_status "Would create directory: $dir"
        else
            mkdir -p "$dir"
        fi
    done
    
    # Create systemd service file
    if [ "$dry_run" = "true" ]; then
        print_status "Would create deployment/systemd/$PROJECT_NAME.service"
    else
        cat > "deployment/systemd/$PROJECT_NAME.service" << EOF
[Unit]
Description=$PROJECT_DESCRIPTION
After=network.target

[Service]
Type=simple
User=$PROJECT_NAME
Group=$PROJECT_NAME
ExecStart=/usr/local/bin/$PROJECT_NAME
Restart=always
RestartSec=5
StandardOutput=journal
StandardError=journal
SyslogIdentifier=$PROJECT_NAME

[Install]
WantedBy=multi-user.target
EOF
        print_success "Created systemd service file"
    fi
    
    # Create launchd plist file
    if [ "$dry_run" = "true" ]; then
        print_status "Would create deployment/launchd/com.$PROJECT_NAME.$PROJECT_NAME.plist"
    else
        cat > "deployment/launchd/com.$PROJECT_NAME.$PROJECT_NAME.plist" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.$PROJECT_NAME.$PROJECT_NAME</string>
    <key>ProgramArguments</key>
    <array>
        <string>/usr/local/bin/$PROJECT_NAME</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <true/>
    <key>StandardOutPath</key>
    <string>/var/log/$PROJECT_NAME.log</string>
    <key>StandardErrorPath</key>
    <string>/var/log/$PROJECT_NAME.error.log</string>
</dict>
</plist>
EOF
        print_success "Created launchd plist file"
    fi
}

# Function to implement for all projects
implement_all() {
    local dry_run="$1"
    local force="$2"
    
    print_status "Implementing standardization for all projects..."
    
    for config in "$PROJECT_CONFIGS_DIR"/*.conf; do
        if [ -f "$config" ]; then
            project_name=$(basename "$config" .conf)
            implement_project "$project_name" "$dry_run" "$force"
        fi
    done
}

# Main function
main() {
    local project_name=""
    local dry_run="false"
    local force="false"
    local list_only="false"
    local all_projects="false"
    
    # Parse command line arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_usage
                exit 0
                ;;
            -l|--list)
                list_only="true"
                shift
                ;;
            -a|--all)
                all_projects="true"
                shift
                ;;
            -d|--dry-run)
                dry_run="true"
                shift
                ;;
            -f|--force)
                force="true"
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
    
    # Handle list option
    if [ "$list_only" = "true" ]; then
        list_projects
        exit 0
    fi
    
    # Validate arguments
    if [ "$all_projects" = "false" ] && [ -z "$project_name" ]; then
        print_error "No project specified. Use --help for usage information."
        exit 1
    fi
    
    if [ "$all_projects" = "true" ] && [ -n "$project_name" ]; then
        print_error "Cannot specify both --all and project name"
        exit 1
    fi
    
    # Show dry run warning
    if [ "$dry_run" = "true" ]; then
        print_warning "DRY RUN MODE - No files will be modified"
    fi
    
    # Implement standardization
    if [ "$all_projects" = "true" ]; then
        implement_all "$dry_run" "$force"
    else
        implement_project "$project_name" "$dry_run" "$force"
    fi
    
    print_success "Standardization implementation completed!"
}

# Run main function with all arguments
main "$@"
