#!/bin/bash

# =============================================================================
# AgentHarmony .opencode Configuration Installer
# =============================================================================
# This script downloads and installs the .opencode configuration from the
# AgentHarmony repository into your current project directory.
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/rchiarino/AgentHarmony/main/install.sh | bash
#   
#   Or download first for interactive mode:
#   curl -fsSL https://raw.githubusercontent.com/rchiarino/AgentHarmony/main/install.sh -o install.sh
#   chmod +x install.sh
#   ./install.sh
# =============================================================================

set -e

# Configuration
REPO_URL="https://github.com/rchiarino/AgentHarmony"
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

# Check if running interactively
is_interactive() {
    [ -t 0 ]
}

# =============================================================================
# Download Functions
# =============================================================================

download() {
    local url="$1"
    local output="$2"
    
    if command -v curl &> /dev/null; then
        curl -fsSL "$url" -o "$output"
    elif command -v wget &> /dev/null; then
        wget -q "$url" -O "$output"
    else
        log_error "Neither curl nor wget is installed"
        exit 1
    fi
}

download_via_repo() {
    log_info "Downloading AgentHarmony repository..."
    
    local zip_url="${REPO_URL}/archive/refs/heads/main.zip"
    local zip_file="${TMP_DIR}/agentharmony.zip"
    
    if ! download "$zip_url" "$zip_file"; then
        return 1
    fi
    
    log_info "Extracting .opencode directory..."
    
    if command -v unzip &> /dev/null; then
        unzip -q "$zip_file" "AgentHarmony-main/.opencode/*" -d "$TMP_DIR" 2>/dev/null || {
            log_error "Failed to extract archive"
            return 1
        }
        mv "${TMP_DIR}/AgentHarmony-main/.opencode" "${TMP_DIR}/.opencode"
        rm -rf "${TMP_DIR}/AgentHarmony-main"
    else
        log_error "unzip is required but not installed. Please install it first."
        exit 1
    fi
    
    rm -f "$zip_file"
    return 0
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
        
        # If running non-interactively (piped from curl), auto-backup
        if ! is_interactive; then
            local backup_name=".opencode.backup.$(date +%Y%m%d_%H%M%S)"
            log_info "Non-interactive mode: Creating backup as $backup_name"
            mv "$OPENCODE_DIR" "$backup_name"
            log_success "Backup created: $backup_name"
        else
            # Interactive mode - ask user
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
    fi
    
    # Download the configuration
    echo ""
    log_info "Downloading configuration from GitHub..."
    
    if ! download_via_repo; then
        log_error "Download failed!"
        echo ""
        echo "Possible reasons:"
        echo "  - Repository might be private (make it public to use raw URL install)"
        echo "  - Network connectivity issues"
        echo "  - GitHub is unreachable"
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
