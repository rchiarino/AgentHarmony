#!/bin/bash
# AgentHarmony Runner
# Simple demonstration runner for the agent system

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
AGENT_FILE=".opencode/agent/core/harmony-agent.md"
CONTEXT_DIR=".opencode/context"

# Functions
print_header() {
    echo -e "${BLUE}"
    echo "╔════════════════════════════════════════════════════════════╗"
    echo "║              AgentHarmony - AI Agent Runner               ║"
    echo "╚════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ $1${NC}"
}

# Check if running from correct directory
check_structure() {
    if [ ! -f "$AGENT_FILE" ]; then
        print_error "Agent file not found: $AGENT_FILE"
        print_info "Make sure you're running from the AgentHarmony root directory"
        exit 1
    fi

    if [ ! -d "$CONTEXT_DIR" ]; then
        print_error "Context directory not found: $CONTEXT_DIR"
        exit 1
    fi

    print_success "Directory structure validated"
}

# Load agent metadata
load_agent() {
    print_info "Loading agent from: $AGENT_FILE"

    # Extract agent name from frontmatter
    AGENT_NAME=$(grep "^name:" "$AGENT_FILE" | head -1 | cut -d':' -f2 | xargs)
    AGENT_DESC=$(grep "^description:" "$AGENT_FILE" | head -1 | cut -d':' -f2- | xargs)

    print_success "Agent loaded: $AGENT_NAME"
    print_info "Description: $AGENT_DESC"
    echo ""
}

# Simulate the agent workflow
simulate_workflow() {
    local user_input="$1"

    echo -e "${YELLOW}════════════════════════════════════════════════════════════${NC}"
    print_info "User Request: $user_input"
    echo -e "${YELLOW}════════════════════════════════════════════════════════════${NC}"
    echo ""

    # Stage 1: Analyze
    print_info "Stage 1: Analyzing request..."
    sleep 0.5

    if [[ "$user_input" == *"?"* ]] && [[ ! "$user_input" == *"create"* ]] && [[ ! "$user_input" == *"write"* ]]; then
        print_success "Identified as: Conversational (informational)"
        echo ""
        print_info "This appears to be a question. In a real implementation:"
        echo "  → Agent would answer directly"
        echo "  → No approval needed for informational queries"
        echo ""
        return
    else
        print_success "Identified as: Task Execution (requires approval)"
    fi
    echo ""

    # Stage 2: Discover Context
    print_info "Stage 2: Discovering relevant context..."
    sleep 0.5

    # Simulate ContextSniffer
    echo "  → Calling ContextSniffer subagent..."
    sleep 0.3
    print_success "ContextSniffer found relevant files:"
    echo "    • core/standards/code-quality.md (Critical)"
    echo "    • core/standards/security-patterns.md (High)"
    echo "    • project/tech-stack.md (Medium - if exists)"
    echo ""

    # Stage 3: Load Standards
    print_info "Stage 3: Loading standards..."
    sleep 0.5
    print_success "Loaded: code-quality.md"
    print_success "Loaded: security-patterns.md"
    echo ""

    # Stage 4: Propose Plan
    print_info "Stage 4: Proposing implementation plan..."
    echo ""
    echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║                 PROPOSED IMPLEMENTATION PLAN               ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo "Task: $user_input"
    echo ""
    echo "Steps:"
    echo "  1. Analyze requirements"
    echo "  2. Create implementation following standards"
    echo "  3. Validate against security checklist"
    echo "  4. Report completion"
    echo ""
    echo "Context Applied:"
    echo "  • Pure functions (< 50 lines)"
    echo "  • Input validation at boundaries"
    echo "  • Error handling with explicit returns"
    echo "  • No side effects in core logic"
    echo ""
    echo -e "${YELLOW}⚠ APPROVAL REQUIRED BEFORE PROCEEDING${NC}"
    echo ""

    # Simulate approval prompt
    read -p "Approve this plan? [y/n/details]: " approval

    if [[ "$approval" == "y" || "$approval" == "Y" ]]; then
        echo ""
        print_success "Plan approved! Proceeding to execution..."
        echo ""

        # Stage 5: Execute
        print_info "Stage 5: Executing implementation..."
        sleep 0.5

        # Simulate delegation for complex tasks
        if [[ "$user_input" == *"system"* ]] || [[ "$user_input" == *"complex"* ]]; then
            echo "  → Task is complex, delegating to CoderAgent..."
            sleep 0.3
            print_success "CoderAgent implementation complete"
        else
            echo "  → Implementing directly..."
            sleep 0.3
            print_success "Implementation complete"
        fi
        echo ""

        # Stage 6: Validate
        print_info "Stage 6: Validating implementation..."
        sleep 0.3
        print_success "Code quality standards: PASS"
        print_success "Security patterns: PASS"
        print_success "Function size (< 50 lines): PASS"
        echo ""

        # Stage 7: Summarize
        print_info "Stage 7: Summary"
        echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
        echo -e "${GREEN}║                      TASK COMPLETE                         ║${NC}"
        echo -e "${GREEN}╚════════════════════════════════════════════════════════════${NC}"
        echo ""
        echo "✓ Implementation following your standards"
        echo "✓ Security patterns applied"
        echo "✓ Code ready for review"
        echo ""
        print_info "Files created/modified would be listed here in real implementation"

    elif [[ "$approval" == "details" || "$approval" == "d" ]]; then
        echo ""
        print_info "Detailed Plan:"
        echo "  1. Load context files from .opencode/context/"
        echo "  2. Apply code-quality standards (modular, functional)"
        echo "  3. Apply security patterns (validation, error handling)"
        echo "  4. Generate code matching your patterns"
        echo "  5. Validate implementation"
        echo "  6. Report results"
        echo ""
        print_warning "Please run again and approve to proceed"
    else
        echo ""
        print_warning "Plan not approved. Task cancelled."
        print_info "You can modify your request and try again"
    fi
}

# Show help
show_help() {
    echo "AgentHarmony Runner"
    echo ""
    echo "Usage:"
    echo "  ./scripts/run.sh 'your request here'    Run the agent with a request"
    echo "  ./scripts/run.sh --help                 Show this help message"
    echo "  ./scripts/run.sh --demo                 Run a demo workflow"
    echo ""
    echo "Examples:"
    echo "  ./scripts/run.sh 'Create a function to validate emails'"
    echo "  ./scripts/run.sh 'How do I implement authentication?'"
    echo "  ./scripts/run.sh 'Create a user dashboard system'"
    echo ""
    echo "Note: This is a demonstration runner showing the workflow."
    echo "In a real implementation, this would connect to an AI provider."
}

# Demo mode
run_demo() {
    print_header
    check_structure
    load_agent

    echo ""
    echo -e "${BLUE}Running demo with sample requests...${NC}"
    echo ""

    # Demo 1: Simple question
    simulate_workflow "What are pure functions?"

    echo ""
    echo -e "${YELLOW}Press Enter to continue to next demo...${NC}"
    read

    # Demo 2: Task execution
    simulate_workflow "Create a function to format user names"
}

# Main
main() {
    if [ $# -eq 0 ]; then
        show_help
        exit 1
    fi

    case "$1" in
        --help|-h)
            show_help
            ;;
        --demo|-d)
            run_demo
            ;;
        *)
            print_header
            check_structure
            load_agent
            simulate_workflow "$1"
            ;;
    esac
}

main "$@"
