#!/bin/bash

###############################################################################
# Agent Infrastructure Factory
# Automated factory for generating agent infrastructure projects
###############################################################################

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Base directory
FACTORY_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VERTICALS_DIR="$FACTORY_ROOT/verticals"

# Verticals (name|features format)
VERTICALS_LIST=(
    "healthcare|Healthcare AI|HIPAA compliance,Medical coding,Patient intake,Clinical decision,Drug interactions"
    "legal|Legal Tech|Contract review,Legal research,Compliance,Document discovery,Case analysis"
    "fintech|FinTech|Fraud detection,Trading algorithms,Risk assessment,KYC/AML,Financial reporting"
    "ecommerce|E-commerce|Product recommendations,Inventory management,Customer service,Price optimization,Order processing"
    "devops|DevOps|Infrastructure monitoring,Auto-remediation,CI/CD optimization,Cost optimization,Security scanning"
    "education|Education|Personalized tutoring,Content generation,Grading automation,Learning paths,Student engagement"
    "realestate|Real Estate|Property valuation,Lead qualification,Document processing,Market analysis,Tenant screening"
    "marketing|Marketing|Content creation,SEO optimization,Social media,Campaign optimization,Analytics"
    "hr|HR & Recruiting|Resume screening,Candidate matching,Interview scheduling,Onboarding,Employee engagement"
    "supply|Supply Chain|Demand forecasting,Route optimization,Vendor management,Inventory optimization,Risk monitoring"
)

# Package templates
PACKAGES_LIST=("core-agents" "tools-integration" "workflows" "templates" "connectors")

print_header() {
    echo -e "${CYAN}"
    echo "╔═══════════════════════════════════════════════════════════╗"
    echo "║         AGENT INFRASTRUCTURE FACTORY                      ║"
    echo "╚═══════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

print_status() { echo -e "${BLUE}▶ $1${NC}"; }
print_success() { echo -e "${GREEN}✓ $1${NC}"; }
print_warning() { echo -e "${YELLOW}⚠ $1${NC}"; }
print_error() { echo -e "${RED}✗ $1${NC}"; }

# Initialize factory
init_factory() {
    print_header
    print_status "Initializing factory..."
    
    mkdir -p "$VERTICALS_DIR"
    
    # Create factory config
    cat > "$FACTORY_ROOT/factory.config.json" << EOF
{
  "version": "1.0.0",
  "github_org": "yksanjo",
  "author": "Yoshi Kondo <yoshi@musicailab.com>",
  "license": "MIT",
  "verticals_count": ${#VERTICALS_LIST[@]},
  "packages_per_vertical": ${#PACKAGES_LIST[@]},
  "total_repos_target": $((${#VERTICALS_LIST[@]} * ${#PACKAGES_LIST[@]})),
  "created_at": "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
}
EOF
    
    print_success "Factory initialized at $FACTORY_ROOT"
    print_status "Verticals defined: ${#VERTICALS_LIST[@]}"
    print_status "Packages per vertical: ${#PACKAGES_LIST[@]}"
    print_status "Total potential repos: $((${#VERTICALS_LIST[@]} * ${#PACKAGES_LIST[@]}))"
}

# Plan a vertical
plan_vertical() {
    local vertical=$1
    local found=""
    
    for v in "${VERTICALS_LIST[@]}"; do
        IFS='|' read -r key name features <<< "$v"
        if [[ "$key" == "$vertical" ]]; then
            found="yes"
            break
        fi
    done
    
    if [[ -z "$found" ]]; then
        print_error "Unknown vertical: $vertical"
        echo "Available: healthcare legal fintech ecommerce devops education realestate marketing hr supply"
        exit 1
    fi
    
    print_header
    print_status "Planning vertical: $vertical"
    
    IFS='|' read -r key name features <<< "$v"
    
    echo ""
    echo "╔═══════════════════════════════════════════════════════════╗"
    echo "║  VERTICAL: $vertical"
    echo "╠═══════════════════════════════════════════════════════════╣"
    echo "║  Name: $name"
    echo "╠═══════════════════════════════════════════════════════════╣"
    echo "║  Features:"
    IFS=',' read -ra FEAT_ARRAY <<< "$features"
    for i in "${!FEAT_ARRAY[@]}"; do
        echo "║    $((i+1)). ${FEAT_ARRAY[$i]}"
    done
    echo "╠═══════════════════════════════════════════════════════════╣"
    echo "║  Packages:"
    for pkg in "${PACKAGES_LIST[@]}"; do
        echo "║    - $vertical-$pkg"
    done
    echo "╚═══════════════════════════════════════════════════════════╝"
    echo ""
    
    # Create vertical directory
    local vertical_dir="$VERTICALS_DIR/$vertical"
    mkdir -p "$vertical_dir"
    
    # Generate plan document
    cat > "$vertical_dir/PLAN.md" << EOF
# $name ($vertical)

## Overview
Automated agent infrastructure for $name.

## Features
$(for i in "${!FEAT_ARRAY[@]}"; do echo "$((i+1)). **${FEAT_ARRAY[$i]}**"; done)

## Packages

| Package | Description | Status |
|---------|-------------|--------|
$(for pkg in "${PACKAGES_LIST[@]}"; do echo "| $vertical-$pkg | Specialized $pkg for $name | ⏳ Pending |"; done)

## GitHub Repos

\`\`\`bash
$(for pkg in "${PACKAGES_LIST[@]}"; do echo "git clone https://github.com/yksanjo/$vertical-$pkg.git"; done)
\`\`\`

## Timeline
- Plan: $(date +%Y-%m-%d)
- Build: TBD
- Deploy: TBD
EOF
    
    print_success "Plan created: $vertical_dir/PLAN.md"
}

# Build a vertical
build_vertical() {
    local vertical=$1
    local v_name=""
    local v_features=""
    
    for v in "${VERTICALS_LIST[@]}"; do
        IFS='|' read -r key name features <<< "$v"
        if [[ "$key" == "$vertical" ]]; then
            v_name="$name"
            v_features="$features"
            break
        fi
    done
    
    if [[ -z "$v_name" ]]; then
        print_error "Unknown vertical: $vertical"
        exit 1
    fi
    
    print_header
    print_status "Building vertical: $vertical"
    
    local vertical_dir="$VERTICALS_DIR/$vertical"
    mkdir -p "$vertical_dir"
    
    # Create packages
    for pkg in "${PACKAGES_LIST[@]}"; do
        local pkg_name="$vertical-$pkg"
        local pkg_dir="$vertical_dir/$pkg_name"
        
        print_status "Creating package: $pkg_name"
        mkdir -p "$pkg_dir"/{src,tests,examples,docs}
        
        # package.json
        cat > "$pkg_dir/package.json" << EOF
{
  "name": "@agent-infra/$pkg_name",
  "version": "1.0.0",
  "description": "$pkg for $v_name",
  "main": "src/index.js",
  "type": "module",
  "scripts": {
    "test": "jest",
    "start": "node src/index.js",
    "dev": "node --watch src/index.js"
  },
  "keywords": ["$vertical", "$pkg", "agent", "ai"],
  "author": "Yoshi Kondo <yoshi@musicailab.com>",
  "license": "MIT",
  "repository": {
    "type": "git",
    "url": "https://github.com/yksanjo/$pkg_name.git"
  }
}
EOF
        
        # README.md
        cat > "$pkg_dir/README.md" << EOF
# $pkg_name

> $pkg for $v_name

## Installation

\`\`\`bash
npm install @agent-infra/$pkg_name
\`\`\`

## Usage

\`\`\`javascript
import { Agent } from '@agent-infra/$pkg_name';

const agent = new Agent();
await agent.execute();
\`\`\`

## License

MIT
EOF
        
        # Basic src/index.js
        cat > "$pkg_dir/src/index.js" << EOF
/**
 * $pkg_name
 * $pkg for $v_name
 */

export class Agent {
  constructor(options = {}) {
    this.name = '$pkg_name';
    this.options = options;
  }

  async execute(task) {
    return {
      success: true,
      vertical: '$vertical',
      package: '$pkg',
      task,
    };
  }
}

export default Agent;
EOF
        
        print_success "Created: $pkg_name"
    done
    
    print_success "Vertical $vertical built successfully!"
    print_status "Packages created: ${#PACKAGES_LIST[@]}"
}

# Push to GitHub
push_vertical() {
    local vertical=$1
    
    print_header
    print_status "Pushing vertical to GitHub: $vertical"
    
    local vertical_dir="$VERTICALS_DIR/$vertical"
    
    if [[ ! -d "$vertical_dir" ]]; then
        print_error "Vertical not found: $vertical"
        print_status "Run 'build' first"
        exit 1
    fi
    
    # Check auth
    if ! gh auth status &>/dev/null; then
        print_warning "Not authenticated with GitHub"
        print_status "Run: gh auth login"
        return 1
    fi
    
    for pkg in "${PACKAGES_LIST[@]}"; do
        local pkg_name="$vertical-$pkg"
        local pkg_dir="$vertical_dir/$pkg_name"
        
        print_status "Pushing: $pkg_name"
        cd "$pkg_dir"
        
        # Initialize git if needed
        if [[ ! -d ".git" ]]; then
            git init -q
            git branch -m main
        fi
        
        # Add remote
        git remote remove origin 2>/dev/null || true
        git remote add origin "https://github.com/yksanjo/$pkg_name.git"
        
        # Create repo if not exists and push
        if ! gh repo view "yksanjo/$pkg_name" &>/dev/null; then
            print_status "Creating GitHub repo: $pkg_name"
            gh repo create "yksanjo/$pkg_name" --public --description "$pkg for $v_name" --source=. --remote=origin --push -y
        else
            git add -A
            git commit -m "feat: Initial release - $pkg for $v_name" --allow-empty
            git push -u origin main -f
        fi
        
        print_success "Pushed: $pkg_name"
        cd - > /dev/null
    done
    
    print_success "Vertical $vertical pushed to GitHub!"
}

# Run full loop
run_vertical() {
    local vertical=$1
    plan_vertical "$vertical"
    build_vertical "$vertical"
    push_vertical "$vertical"
}

# Run all verticals
run_all() {
    print_header
    print_status "Running factory for all verticals..."
    
    for v in "${VERTICALS_LIST[@]}"; do
        IFS='|' read -r vertical name _ <<< "$v"
        echo ""
        echo "═══════════════════════════════════════════════════════════"
        echo "  Processing: $vertical ($name)"
        echo "═══════════════════════════════════════════════════════════"
        echo ""
        
        plan_vertical "$vertical"
        build_vertical "$vertical"
        # push_vertical "$vertical"  # Uncomment when auth ready
    done
    
    print_header
    print_success "Factory run complete!"
    print_status "Verticals processed: ${#VERTICALS_LIST[@]}"
    print_status "Total packages: $((${#VERTICALS_LIST[@]} * ${#PACKAGES_LIST[@]}))"
}

# Show status
show_status() {
    print_header
    print_status "Factory Status"
    echo ""
    echo "Verticals: ${#VERTICALS_LIST[@]}"
    echo "Packages per vertical: ${#PACKAGES_LIST[@]}"
    echo "Total potential repos: $((${#VERTICALS_LIST[@]} * ${#PACKAGES_LIST[@]}))"
    echo ""
    echo "Available verticals:"
    for v in "${VERTICALS_LIST[@]}"; do
        IFS='|' read -r key name _ <<< "$v"
        echo "  - $key ($name)"
    done
}

# Main
case "${1:-help}" in
    init) init_factory ;;
    plan) plan_vertical "$2" ;;
    build) build_vertical "$2" ;;
    push) push_vertical "$2" ;;
    run) run_vertical "$2" ;;
    run-all) run_all ;;
    status) show_status ;;
    help|*) 
        print_header
        echo "Usage: \$0 <command> [options]"
        echo ""
        echo "Commands:"
        echo "  init              Initialize factory"
        echo "  plan <vertical>   Plan a vertical"
        echo "  build <vertical>  Build packages"
        echo "  push <vertical>   Push to GitHub"
        echo "  run <vertical>    Full loop: plan → build → push"
        echo "  run-all           Run all verticals"
        echo "  status            Show status"
        echo ""
        echo "Verticals: healthcare legal fintech ecommerce devops education realestate marketing hr supply"
        ;;
esac
