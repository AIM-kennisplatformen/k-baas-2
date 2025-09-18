#!/bin/bash
# List stories with optional filter

FILTER=${1:-"label:story state:open"}

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

# Parse filter into gh issue list arguments
GH_ARGS=""
if [[ "$FILTER" == *"label:"* ]]; then
  LABEL=$(echo "$FILTER" | sed -n 's/.*label:\([^ ]*\).*/\1/p')
  if [ -n "$LABEL" ]; then
    GH_ARGS="$GH_ARGS --label $LABEL"
  fi
fi

if [[ "$FILTER" == *"state:"* ]]; then
  STATE=$(echo "$FILTER" | sed -n 's/.*state:\([^ ]*\).*/\1/p')
  if [ -n "$STATE" ]; then
    GH_ARGS="$GH_ARGS --state $STATE"
  fi
fi

# If no specific args parsed, use default
if [ -z "$GH_ARGS" ]; then
  GH_ARGS="--label story --state open"
fi

# List issues
OUTPUT=$(gh issue list $GH_ARGS --json number,title,body,labels,assignees,milestone --limit 50 --repo "$REPO" 2>&1)
if [ $? -ne 0 ]; then
  echo '{"error": "Failed to list issues: '$OUTPUT'"}' >&2
  exit 1
fi

# Validate JSON output
if ! echo "$OUTPUT" | jq . >/dev/null 2>&1; then
  echo '{"error": "Invalid JSON response from gh issue list"}' >&2
  exit 1
fi

# Check if output is empty array (this is normal, not an error)
STORY_COUNT=$(echo "$OUTPUT" | jq '. | length')
if [ "$STORY_COUNT" -eq 0 ]; then
  echo '{"result": [], "count": 0, "message": "No stories found matching filter: '$FILTER'"}'
  exit 0
fi

# Return successful result with metadata
echo "$OUTPUT" | jq --arg filter "$FILTER" --arg count "$STORY_COUNT" '. + [{"_metadata": {"filter": $filter, "count": ($count | tonumber)}}]'