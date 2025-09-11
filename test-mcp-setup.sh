#!/bin/bash

# Test script voor GitHub Project Manager MCP Server Setup
# Voer dit script uit om te testen of je installatie correct is

set -e

echo "🔧 GitHub Project Manager MCP Server Test Script"
echo "================================================"
echo ""

# Kleurcode functies
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Test 1: Check if .env file exists
print_status "Test 1: Controleren of .env bestand bestaat..."
if [ -f ".env" ]; then
    print_success ".env bestand gevonden"
    
    # Check if required variables are set
    if grep -q "GITHUB_TOKEN=" .env && ! grep -q "GITHUB_TOKEN=your_github_token_here" .env; then
        print_success "GitHub token is ingesteld"
    else
        print_error "GitHub token is niet correct ingesteld in .env"
        exit 1
    fi
    
    if grep -q "GITHUB_OWNER=HAN-AIM-CMD-WG" .env; then
        print_success "GitHub owner is correct ingesteld"
    else
        print_warning "GitHub owner is niet correct ingesteld (verwacht: HAN-AIM-CMD-WG)"
    fi
    
    if grep -q "GITHUB_REPO=k-baas-2" .env; then
        print_success "GitHub repo is correct ingesteld"
    else
        print_warning "GitHub repo is niet correct ingesteld (verwacht: k-baas-2)"
    fi
    
else
    print_error ".env bestand niet gevonden. Kopieer env.template naar .env en vul je API keys in."
    echo "  Commando: cp env.template .env"
    exit 1
fi

echo ""

# Test 2: Check if Node.js and npm are installed
print_status "Test 2: Controleren Node.js en npm installatie..."
if command -v node &> /dev/null; then
    NODE_VERSION=$(node --version)
    print_success "Node.js geïnstalleerd: $NODE_VERSION"
else
    print_error "Node.js is niet geïnstalleerd. Installeer Node.js eerst."
    exit 1
fi

if command -v npm &> /dev/null; then
    NPM_VERSION=$(npm --version)
    print_success "npm geïnstalleerd: $NPM_VERSION"
else
    print_error "npm is niet geïnstalleerd."
    exit 1
fi

echo ""

# Test 3: Test npx access to mcp-github-project-manager
print_status "Test 3: Testen van npx toegang tot mcp-github-project-manager..."
export $(cat .env | grep -v ^# | xargs)

# Create a simple test to see if the package can be accessed
echo "Testing npx access (this may take a moment to download the package)..."
timeout 30s npx -y mcp-github-project-manager --help > /dev/null 2>&1
if [ $? -eq 0 ]; then
    print_success "mcp-github-project-manager is toegankelijk via npx"
else
    print_warning "mcp-github-project-manager kon niet worden getest via npx (mogelijk eerste keer download)"
fi

echo ""

# Test 4: Check Cursor MCP configuration
print_status "Test 4: Controleren Cursor MCP configuratie..."
CURSOR_MCP_FILE="$HOME/.cursor/mcp_servers.json"

if [ -f "$CURSOR_MCP_FILE" ]; then
    print_success "Cursor MCP configuratie bestand gevonden"
    
    if grep -q "github-project-manager" "$CURSOR_MCP_FILE"; then
        print_success "GitHub Project Manager configuratie gevonden in Cursor"
        
        if grep -q "npx" "$CURSOR_MCP_FILE"; then
            print_success "npx commando correct geconfigureerd"
        else
            print_warning "npx commando mogelijk niet correct geconfigureerd"
        fi
    else
        print_error "GitHub Project Manager niet gevonden in Cursor configuratie"
        echo "  Voeg de configuratie toe aan $CURSOR_MCP_FILE"
        echo "  Zie MCP-GITHUB-PROJECT-MANAGER-SETUP.md voor details"
    fi
else
    print_error "Cursor MCP configuratie bestand niet gevonden"
    echo "  Maak het bestand aan: $CURSOR_MCP_FILE"
    echo "  Zie MCP-GITHUB-PROJECT-MANAGER-SETUP.md voor details"
fi

echo ""

# Test 5: Basic GitHub API test
print_status "Test 5: Testen GitHub API toegang..."
if [ -n "$GITHUB_TOKEN" ] && [ "$GITHUB_TOKEN" != "your_github_token_here" ]; then
    RESPONSE=$(curl -s -H "Authorization: token $GITHUB_TOKEN" https://api.github.com/user)
    if echo "$RESPONSE" | grep -q '"login"'; then
        USERNAME=$(echo "$RESPONSE" | grep '"login"' | cut -d '"' -f 4)
        print_success "GitHub API toegang werkt voor gebruiker: $USERNAME"
    else
        print_error "GitHub API toegang mislukt. Controleer je GITHUB_TOKEN"
        echo "  Response: $RESPONSE"
    fi
else
    print_warning "GitHub token niet ingesteld voor API test"
fi

echo ""

# Summary
echo "📋 Samenvatting Test Resultaten"
echo "==============================="
echo ""
echo "Als alle tests slagen:"
echo "1. Herstart Cursor volledig"
echo "2. Open een nieuwe chat in Cursor"
echo "3. Test een commando zoals: @github-project-manager list projects"
echo ""
echo "Bij problemen:"
echo "- Controleer de troubleshooting sectie in MCP-GITHUB-PROJECT-MANAGER-SETUP.md"
echo "- Zorg dat alle API keys correct zijn ingevuld"
echo "- Herstart Cursor na elke configuratie wijziging"
echo ""
print_success "Test script voltooid!" 