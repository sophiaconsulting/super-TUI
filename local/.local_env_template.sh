# shellcheck shell=zsh

# ===================================================================
# LOCAL ENVIRONMENT CONFIGURATION
# ===================================================================
# This file contains local environment variables and settings
# DO NOT commit sensitive data like API keys to version control
#
# To set up your API keys securely:
# 1. Copy this file to ~/.local_env.sh (gitignored)
# 2. Set your actual API keys in that file
# 3. OR use system keychain/environment variables
# ===================================================================

# AI Service Configuration
# Set your actual API keys in ~/.local_env.sh or use keychain

# Ollama Configuration
export OLLAMA_HOST=''
export OLLAMA_API_BASE=''

# Alternative Ollama hosts (uncomment as needed)
# export OLLAMA_HOST='http://192.168.10.129:11434'
# export OLLAMA_API_BASE='http://192.168.10.129:11434'

# Local Aliases
alias fr='open .'
# alias archive-agent='/home/vaden/dev/projects/ai_rag/archive-agent.sh'  # Linux-specific path, commented out

# ===================================================================
# INSTRUCTIONS FOR SECURE KEY MANAGEMENT
# ===================================================================
# Option 1: Create ~/.local_env.sh with your actual keys:
  export OPENAI_API_KEY=''
  export ELEVENLABS_API_KEY=''
  export GOOGLE_CUSTOM_SEARCH_API_KEY=''
  export GH_TOKEN=''
  export HF_TOKEN=''
  export STABILITY_API_KEY=''
  # export ANTHROPIC_API_KEY='your-actual-key-here'
#   export MEM0_API_KEY='your-actual-key-here'
#
# Option 2: Use macOS Keychain or other secure storage
# Option 3: Set environment variables in your shell profile
# ===================================================================
