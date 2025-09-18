#!/bin/bash
# Create task issue as sub-issue of story, add to project board (Backlog column)

if [ $# -lt 4 ]; then
  echo '{"error": "Usage: $0 <story_num> <title> <body> <parent_story_num>"}' >&2
  exit 1
fi

STORY_NUM="$1"
TITLE="$2"
BODY="$3"
PARENT_STORY_NUM="$4"

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

# Enhance body with parent story reference
ENHANCED_BODY="$BODY

Parent Story: #$PARENT_STORY_NUM
Story: $STORY_NUM"

# Create task issue and capture the issue number directly
ISSUE_OUTPUT=$(gh issue create --repo "$REPO" --title "$TITLE" --body "$ENHANCED_BODY" --label "task,story-$STORY_NUM" --json number)
if [ $? -ne 0 ]; then
  echo '{"error": "Failed to create task issue"}' >&2
  exit 1
fi

TASK_NUM=$(echo "$ISSUE_OUTPUT" | jq -r '.number')
if [ -z "$TASK_NUM" ] || [ "$TASK_NUM" = "null" ]; then
  echo '{"error": "Failed to parse task issue number"}' >&2
  exit 1
fi

# Get milestone from parent story and assign to task
if [ -n "$PARENT_STORY_NUM" ] && [ "$PARENT_STORY_NUM" != "" ]; then
  PARENT_MILESTONE=$(gh issue view "$PARENT_STORY_NUM" --repo "$REPO" --json milestone 2>/dev/null | jq -r '.milestone.title // empty')
  if [ -n "$PARENT_MILESTONE" ] && [ "$PARENT_MILESTONE" != "null" ]; then
    MILESTONE_NUM=$(gh api "repos/$REPO/milestones" | jq -r --arg title "$PARENT_MILESTONE" '[.[] | select(.title == $title)] | .[0].number // empty')
    if [ -n "$MILESTONE_NUM" ]; then
      gh issue edit "$TASK_NUM" --milestone "$MILESTONE_NUM" --repo "$REPO"
      if [ $? -ne 0 ]; then
        echo '{"warning": "Failed to assign milestone"}' >&2
      fi
    else
      echo '{"warning": "Milestone not found: '$PARENT_MILESTONE'"}' >&2
    fi
  else
    echo '{"warning": "Parent story has no milestone or could not retrieve it"}' >&2
  fi
else
  echo '{"warning": "No parent story specified, skipping milestone assignment"}' >&2
fi

# Add to project board (Backlog column)
BACKLOG_COL_ID=$(gh api "repos/$REPO/projects/$BOARD_ID/columns" | jq -r --arg name "Backlog" '[.[] | select(.name == $name)] | .[0].id // empty')
if [ -n "$BACKLOG_COL_ID" ]; then
  # Add to board using projects API
  gh api --method POST "repos/$REPO/projects/$BOARD_ID/columns/$BACKLOG_COL_ID/cards" \
    -f content_id="$TASK_NUM" -f content_type="Issue" >/dev/null 2>&1
  if [ $? -eq 0 ]; then
    echo '{"success": "Task added to board"}'
  else
    echo '{"warning": "Failed to add to board, manual addition needed"}' >&2
  fi
else
  echo '{"error": "Backlog column not found"}' >&2
  exit 1
fi

# Add comment to parent story linking this task
if [ -n "$PARENT_STORY_NUM" ] && [ "$PARENT_STORY_NUM" != "" ]; then
  gh issue comment "$PARENT_STORY_NUM" --body "Task created: #$TASK_NUM - $TITLE" --repo "$REPO" >/dev/null 2>&1
  if [ $? -ne 0 ]; then
    echo '{"warning": "Failed to add comment to parent story"}' >&2
  fi
fi

echo "{\"task_number\": $TASK_NUM}"