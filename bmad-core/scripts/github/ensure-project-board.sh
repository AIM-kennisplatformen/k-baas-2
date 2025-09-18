#!/bin/bash
# Ensure GitHub project board exists; create if not, update config

# Check dependencies
if ! command -v jq &> /dev/null; then
  echo '{"error": "jq is required but not installed. Install with: brew install jq"}' >&2
  exit 1
fi

if ! command -v gh &> /dev/null; then
  echo '{"error": "GitHub CLI (gh) is required but not installed. Install with: brew install gh"}' >&2
  exit 1
fi

# Check GitHub authentication
if ! gh auth status &> /dev/null; then
  echo '{"error": "GitHub CLI not authenticated. Run: gh auth login"}' >&2
  exit 1
fi

source load-config.sh
if [ "$?" -ne 0 ]; then
  echo '{"error": "Failed to load config"}' >&2
  exit 1
fi

# Check if board exists (using classic projects API)
BOARD_EXISTS=false
if [ -n "$BOARD_ID" ]; then
  # Test if board exists by trying to get its columns
  if gh api "repos/$REPO/projects/$BOARD_ID" >/dev/null 2>&1; then
    BOARD_EXISTS=true
  fi
fi

if [ "$BOARD_EXISTS" = false ]; then
  echo "Creating project board..."
  # Create classic project board
  RESPONSE=$(gh api --method POST "repos/$REPO/projects" \
    -H "Accept: application/vnd.github.v3+json" \
    -f name="BMAD Project" \
    -f body="BMAD Issue Board for story/task management")
  
  if [ $? -ne 0 ] || [ -z "$RESPONSE" ]; then
    echo '{"error": "Failed to create board"}' >&2
    exit 1
  fi
  
  # Parse ID with jq
  NEW_BOARD_ID=$(echo "$RESPONSE" | jq -r '.id // empty')
  if [ -z "$NEW_BOARD_ID" ] || [ "$NEW_BOARD_ID" = "null" ]; then
    echo '{"error": "Failed to parse board ID from response"}' >&2
    exit 1
  fi
  
  # Update config using the CONFIG_FILE variable from load-config.sh
  yq eval ".github.project_board = \"$NEW_BOARD_ID\"" -i "$CONFIG_FILE"
  if [ $? -ne 0 ]; then
    echo '{"error": "Failed to update config file"}' >&2
    exit 1
  fi
  
  BOARD_ID="$NEW_BOARD_ID"
  echo "Board created and config updated: $BOARD_ID"
fi

# Create columns (idempotent)
COLUMNS=("Backlog" "Next Milestone" "Ready" "In Progress" "Review" "Done")
COLUMNS_RESPONSE=$(gh api "repos/$REPO/projects/$BOARD_ID/columns" 2>/dev/null)
if [ $? -ne 0 ]; then
  echo '{"error": "Failed to get board columns. Board may not exist or access denied."}' >&2
  exit 1
fi

for col in "${COLUMNS[@]}"; do
  # Check if column exists
  EXISTS=$(echo "$COLUMNS_RESPONSE" | jq --arg name "$col" '[.[] | select(.name == $name)] | length')
  if [ "$EXISTS" -eq 0 ]; then
    echo "Creating column: $col"
    COLUMN_RESPONSE=$(gh api --method POST "repos/$REPO/projects/$BOARD_ID/columns" -f name="$col" 2>&1)
    if [ $? -ne 0 ]; then
      echo '{"error": "Failed to create column '$col': '$COLUMN_RESPONSE'"}' >&2
      exit 1
    fi
  fi
done

echo '{"success": "Board ready", "id": "'$BOARD_ID'", "columns_verified": true}'