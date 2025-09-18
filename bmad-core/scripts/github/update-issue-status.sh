#!/bin/bash
# Update issue status by moving it to a specific column on the project board

if [ $# -lt 2 ]; then
  echo '{"error": "Usage: $0 <issue_num> <column>"}' >&2
  exit 1
fi

ISSUE_NUM="$1"
COLUMN="$2"

# Validate inputs
if ! [[ "$ISSUE_NUM" =~ ^[0-9]+$ ]]; then
  echo '{"error": "Invalid issue number: '$ISSUE_NUM'. Must be numeric."}' >&2
  exit 1
fi

if [ -z "$COLUMN" ]; then
  echo '{"error": "Column name cannot be empty"}' >&2
  exit 1
fi

# Check dependencies
if ! command -v jq &> /dev/null; then
  echo '{"error": "jq is required but not installed. Install with: brew install jq"}' >&2
  exit 1
fi

source load-config.sh
if [ "$?" -ne 0 ]; then
  echo '{"error": "Failed to load config"}' >&2
  exit 1
fi

source ensure-project-board.sh
if [ "$?" -ne 0 ]; then
  echo '{"error": "Failed to ensure board"}' >&2
  exit 1
fi

# Verify issue exists
if ! gh issue view "$ISSUE_NUM" --repo "$REPO" >/dev/null 2>&1; then
  echo '{"error": "Issue #'$ISSUE_NUM' not found in repo '$REPO'"}' >&2
  exit 1
fi

# Get all columns and validate target column exists
COLUMNS_RESPONSE=$(gh api "repos/$REPO/projects/$BOARD_ID/columns" 2>&1)
if [ $? -ne 0 ]; then
  echo '{"error": "Failed to get board columns: '$COLUMNS_RESPONSE'"}' >&2
  exit 1
fi

COL_ID=$(echo "$COLUMNS_RESPONSE" | jq -r --arg name "$COLUMN" '[.[] | select(.name == $name)] | .[0].id // empty')
if [ -z "$COL_ID" ]; then
  AVAILABLE_COLUMNS=$(echo "$COLUMNS_RESPONSE" | jq -r '.[].name' | tr '\n' ',' | sed 's/,$//')
  echo '{"error": "Column not found: '$COLUMN'. Available: '$AVAILABLE_COLUMNS'"}' >&2
  exit 1
fi

# Search all columns for existing card
CARD_ID=""
CURRENT_COLUMN=""
ALL_COLUMN_IDS=$(echo "$COLUMNS_RESPONSE" | jq -r '.[].id')

for col_id in $ALL_COLUMN_IDS; do
  CARDS_RESPONSE=$(gh api "repos/$REPO/projects/$BOARD_ID/columns/$col_id/cards" 2>/dev/null)
  if [ $? -eq 0 ]; then
    FOUND_CARD=$(echo "$CARDS_RESPONSE" | jq -r --arg issue "$ISSUE_NUM" '[.[] | select(.content_url and (.content_url | endswith("/issues/'$ISSUE_NUM'"))) ] | .[0].id // empty')
    if [ -n "$FOUND_CARD" ]; then
      CARD_ID="$FOUND_CARD"
      CURRENT_COLUMN=$(echo "$COLUMNS_RESPONSE" | jq -r --arg id "$col_id" '[.[] | select(.id == ($id | tonumber))] | .[0].name // empty')
      break
    fi
  fi
done

# If card exists and is already in target column
if [ -n "$CARD_ID" ] && [ "$CURRENT_COLUMN" = "$COLUMN" ]; then
  echo '{"success": "Issue already in '$COLUMN'", "card_id": "'$CARD_ID'"}'
  exit 0
fi

# If card exists in different column, move it
if [ -n "$CARD_ID" ]; then
  MOVE_RESPONSE=$(gh api --method POST "repos/$REPO/projects/columns/cards/$CARD_ID/moves" \
    -f position="top" -f column_id="$COL_ID" 2>&1)
  if [ $? -eq 0 ]; then
    echo '{"success": "Issue moved from '$CURRENT_COLUMN' to '$COLUMN'", "card_id": "'$CARD_ID'"}'
  else
    echo '{"error": "Failed to move card: '$MOVE_RESPONSE'"}' >&2
    exit 1
  fi
else
  # Create new card in target column
  CREATE_RESPONSE=$(gh api --method POST "repos/$REPO/projects/$BOARD_ID/columns/$COL_ID/cards" \
    -f content_id="$ISSUE_NUM" -f content_type="Issue" 2>&1)
  if [ $? -eq 0 ]; then
    NEW_CARD_ID=$(echo "$CREATE_RESPONSE" | jq -r '.id // empty')
    echo '{"success": "Issue added to '$COLUMN'", "card_id": "'$NEW_CARD_ID'"}'
  else
    echo '{"error": "Failed to add issue to board: '$CREATE_RESPONSE'"}' >&2
    exit 1
  fi
fi