#!/bin/bash
# This script installs development tools on a Debian-based system.
# Also create virtual environment in current directory and install Django in it

set -e
export DEBIAN_FRONTEND=noninteractive

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_info() {
  echo -e "${YELLOW}$1${NC}"
}

log_success() {
  echo -e "${GREEN}$1${NC}"
}

sudo apt-get update

# Install Docker
if ! command -v docker &>/dev/null; then
    log_info "Installing Docker..."  
    sudo apt-get install -y \
        ca-certificates \
        curl \
        gnupg \
        lsb-release

    sudo mkdir -m 0755 -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/$(. /etc/os-release && echo "$ID")/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/$(. /etc/os-release && echo "$ID") \
      $(lsb_release -cs) stable" | \
      sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    sudo apt-get update
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    log_success "Docker installed"
else
    log_success "Docker already installed"
fi

# Install Docker Compose
if ! docker compose version &>/dev/null && ! command -v docker-compose &>/dev/null; then
  log_info "Installing Docker Compose ..."
  sudo apt-get install -y docker-compose
  log_success "Docker Compose installed"
else
  log_success "Docker Compose already installed"
fi

# Install Python 3.9+
PYTHON_VERSION=$(python3 --version 2>/dev/null | grep -oP '\d+\.\d+')
if [[ -z "$PYTHON_VERSION" || $(( ${PYTHON_VERSION%%.*} < 3 || ( ${PYTHON_VERSION%%.*} == 3 && ${PYTHON_VERSION##*.} < 13 ) )) -eq 1 ]]; then
    log_info "Installing Python 3.9+..."  
    sudo apt-get install -y python3
    log_success "$(python3 --version) installed"
else    
    log_success "Python $PYTHON_VERSION already installed"
fi

# Install pip3
if ! command -v pip3 &> /dev/null; then
    log_info "Installing pip..."
    sudo apt-get install -y python3-pip
    log_success "pip3 installed"
else
    log_success "Python pip3 is already installed!"
fi

# Create virtual environment
if [ ! -d ".venv" ]; then
    log_info 'Creating virtual environment...'    
    sudo apt-get install python3-venv -y
    python3 -m venv .venv    
    log_success 'Virtual environment created'
else
    log_success 'Virtual environment already exists'
fi

source .venv/bin/activate

# Install Django
if ! python3 -m django --version &>/dev/null; then
    log_info "Installing Django via pip..."    
    python3 -m pip install django
    log_success "Django installed"
else
    DJANGO_VERSION=$(python3 -m django --version)
    log_success "Django $DJANGO_VERSION already installed"    
fi

log_success 'All packages have been installed successfully!'

