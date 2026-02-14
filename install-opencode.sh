#!/bin/bash

# =============================================================================
# AgentHarmony .opencode Configuration Installer
# =============================================================================
# This script downloads and installs the .opencode configuration from the
# AgentHarmony repository into your current project directory.
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/rchiarino/AgentHarmony/main/install-opencode.sh | bash
#   
#   Or download first:
#   curl -fsSL https://raw.githubusercontent.com/rchiarino/AgentHarmony/main/install-opencode.sh -o install-opencode.sh
#   chmod +x install-opencode.sh
#   ./install-opencode.sh
# =============================================================================

set -e

# Configuration
REPO_URL="https://github.com/rchiarino/AgentHarmony"
RAW_URL="https://raw.githubusercontent.com/rchiarino/AgentHarmony/main"
OPENCODE_DIR=".opencode"
TMP_DIR=$(mktemp -d)

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# =============================================================================
# Helper Functions
# =============================================================================

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

cleanup() {
    if [ -d "$TMP_DIR" ]; then
        rm -rf "$TMP_DIR"
    fi
}

trap cleanup EXIT

# =============================================================================
# Download Functions
# =============================================================================

download_file() {
    local remote_path="$1"
    local local_path="$2"
    local url="${RAW_URL}/${remote_path}"
    
    # Create directory structure if needed
    mkdir -p "$(dirname "$local_path")"
    
    if command -v curl &> /dev/null; then
        curl -fsSL "$url" -o "$local_path" 2>/dev/null
    elif command -v wget &> /dev/null; then
        wget -q "$url" -O "$local_path" 2>/dev/null
    else
        log_error "Neither curl nor wget is installed. Please install one of them."
        exit 1
    fi
}

download_directory() {
    local dir_path="$1"
    local api_url="https://api.github.com/repos/rchiarino/AgentHarmony/contents/${dir_path}"
    
    # Get directory contents from GitHub API
    local response
    if command -v curl &> /dev/null; then
        response=$(curl -fsSL "$api_url" 2>/dev/null)
    elif command -v wget &> /dev/null; then
        response=$(wget -qO- "$api_url" 2>/dev/null)
    fi
    
    if [ -z "$response" ]; then
        log_error "Failed to fetch directory listing from GitHub API"
        exit 1
    fi
    
    # Parse and download each item
    echo "$response" | grep -o '"path":"[^"]*"' | cut -d'"' -f4 | while read -r item; do
        local item_type=$(echo "$response" | grep -A5 "\"path\":\"$item\"" | grep '"type":' | head -1 | cut -d'"' -f4)
        
        if [ "$item_type" = "file" ]; then
            local target_path="${TMP_DIR}/${item}"
            log_info "Downloading: $item"
            download_file "$item" "$target_path"
        elif [ "$item_type" = "dir" ]; then
            download_directory "$item"
        fi
    done
}

# Alternative: Use git archive or download zip for better reliability
download_via_zip() {
    log_info "Downloading AgentHarmony repository..."
    
    local zip_url="${REPO_URL}/archive/refs/heads/main.zip"
    local zip_file="${TMP_DIR}/agentharmony.zip"
    
    if command -v curl &> /dev/null; then
        curl -fsSL "$zip_url" -o "$zip_file"
    elif command -v wget &> /dev/null; then
        wget -q "$zip_url" -O "$zip_file"
    fi
    
    if [ ! -f "$zip_file" ]; then
        log_error "Failed to download repository"
        exit 1
    fi
    
    log_info "Extracting .opencode directory..."
    
    # Extract only .opencode directory
    if command -v unzip &> /dev/null; then
        unzip -q "$zip_file" "AgentHarmony-main/.opencode/*" -d "$TMP_DIR"
        mv "${TMP_DIR}/AgentHarmony-main/.opencode" "${TMP_DIR}/.opencode"
        rm -rf "${TMP_DIR}/AgentHarmony-main"
    elif command -v tar &> /dev/null && tar --help 2>&1 | grep -q unzip; then
        # Some tar versions can handle zip
        tar -xf "$zip_file" -C "$TMP_DIR" "AgentHarmony-main/.opencode"
        mv "${TMP_DIR}/AgentHarmony-main/.opencode" "${TMP_DIR}/.opencode"
        rm -rf "${TMP_DIR}/AgentHarmony-main"
    else
        log_error "unzip is required but not installed. Please install unzip."
        exit 1
    fi
    
    rm -f "$zip_file"
}

# =============================================================================
# Main Installation
# =============================================================================

main() {
    echo -e "${GREEN}"
    echo "╔════════════════════════════════════════════════════════════════╗"
    echo "║     AgentHarmony .opencode Configuration Installer             ║"
    echo "╚════════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    
    log_info "Target directory: $(pwd)"
    
    # Check if .opencode already exists
    if [ -d "$OPENCODE_DIR" ]; then
        echo ""
        log_warn "An existing .opencode directory was found!"
        echo ""
        echo "Options:"
        echo "  1) Overwrite (delete existing and install fresh)"
        echo "  2) Backup then install (backup existing as .opencode.backup.YYYYMMDD_HHMMSS)"
        echo "  3) Cancel installation"
        echo ""
        read -p "Enter your choice (1-3): " choice
        
        case "$choice" in
            1)
                log_info "Removing existing .opencode directory..."
                rm -rf "$OPENCODE_DIR"
                log_success "Existing directory removed"
                ;;
            2)
                local backup_name=".opencode.backup.$(date +%Y%m%d_%H%M%S)"
                log_info "Creating backup: $backup_name"
                mv "$OPENCODE_DIR" "$backup_name"
                log_success "Backup created: $backup_name"
                ;;
            3|*)
                log_info "Installation cancelled by user"
                exit 0
                ;;
        esac
    fi
    
    # Download the configuration
    echo ""
    log_info "Downloading configuration from GitHub..."
    
    if ! download_via_zip; then
        log_error "Download failed"
        exit 1
    fi
    
    # Verify download
    if [ ! -d "${TMP_DIR}/.opencode" ]; then
        log_error "Downloaded content not found"
        exit 1
    fi
    
    # Move to target location
    log_info "Installing .opencode to current directory..."
    mv "${TMP_DIR}/.opencode" "$OPENCODE_DIR"
    
    # Set executable permissions on scripts
    log_info "Setting executable permissions..."
    find "$OPENCODE_DIR" -type f -name "*.sh" -exec chmod +x {} \; 2>/dev/null || true
    
    # Summary
    echo ""
    log_success "Installation complete!"
    echo ""
    echo "Installed files:"
    find "$OPENCODE_DIR" -type f | head -20 | while read -r file; do
        echo "  ✓ ${file#./}"
    done
    
    local total_files=$(find "$OPENCODE_DIR" -type f | wc -l)
    if [ "$total_files" -gt 20 ]; then
        local remaining=$((total_files - 20))
        echo "  ... and $remaining more files"
    fi
    
    echo ""
    log_info "Next steps:"
    echo "  1. Your .opencode configuration is now installed"
    echo "  2. Run 'opencode' in this directory to use your custom settings"
    echo "  3. Check .opencode/AGENTS.md for available agent configurations"
    echo ""
    log_success "Happy coding with AgentHarmony!"
}

# Run main function
main "$@"
