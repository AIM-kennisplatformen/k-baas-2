#!/bin/bash
# Load GitHub config from core-config.yaml (requires yq installed)

# Check if yq is installed
if ! command -v yq &> /dev/null; then
  echo '{"error": "yq is required but not installed. Install with: brew install yq"}' >&2
  exit 1
fi

# Find config file - check relative paths and current directory
CONFIG_FILE=""
if [ -f "../../core-config.yaml" ]; then
  CONFIG_FILE="../../core-config.yaml"
elif [ -f "core-config.yaml" ]; then
  CONFIG_FILE="core-config.yaml"
elif [ -f "bmad-core/core-config.yaml" ]; then
  CONFIG_FILE="bmad-core/core-config.yaml"
else
  echo '{"error": "core-config.yaml not found. Run from project root or scripts/github directory."}' >&2
  exit 1
fi

# Load repo configuration
REPO=$(yq eval '.github.repo' "$CONFIG_FILE" 2>/dev/null || echo "")
if [ -z "$REPO" ] || [ "$REPO" = "null" ]; then
  echo '{"error": "No github.repo configured in core-config.yaml"}' >&2
  exit 1
fi

# Validate repo format (owner/repo)
if [[ ! "$REPO" =~ ^[^/]+/[^/]+$ ]]; then
  echo '{"error": "Invalid repo format. Expected: owner/repo, got: '$REPO'"}' >&2
  exit 1
fi

REPO_OWNER=$(echo "$REPO" | cut -d'/' -f1)
REPO_NAME=$(echo "$REPO" | cut -d'/' -f2)

# Validate owner and name are not empty
if [ -z "$REPO_OWNER" ] || [ -z "$REPO_NAME" ]; then
  echo '{"error": "Failed to parse repo owner/name from: '$REPO'"}' >&2
  exit 1
fi

BOARD_ID=$(yq eval '.github.project_board' "$CONFIG_FILE" 2>/dev/null || echo "")
# Board ID can be empty (will be created by ensure-project-board.sh)

# Export variables for other scripts
export REPO REPO_OWNER REPO_NAME BOARD_ID CONFIG_FILE
echo '{"success": "Config loaded", "repo": "'$REPO'", "config_file": "'$CONFIG_FILE'"}'