#!/bin/bash
# Migrate existing Markdown story files to GitHub issues

# Check dependencies
if ! command -v jq &> /dev/null; then
  echo '{"error": "jq is required but not installed. Install with: brew install jq"}' >&2
  exit 1
fi

if ! command -v awk &> /dev/null; then
  echo '{"error": "awk is required but not available"}' >&2
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

# Find story directory - try multiple possible paths
STORY_DIR=""
POSSIBLE_PATHS=(
  "../../../docs/stories"    # From bmad-core/scripts/github/
  "../../docs/stories"       # From bmad-core/scripts/
  "docs/stories"             # From project root
  "./docs/stories"           # From project root (explicit)
)

for path in "${POSSIBLE_PATHS[@]}"; do
  if [ -d "$path" ]; then
    STORY_DIR="$path"
    break
  fi
done

if [ -z "$STORY_DIR" ]; then
  echo '{"error": "No existing story directory found. Tried: '${POSSIBLE_PATHS[*]}'"}' >&2
  exit 1
fi

# Check if directory has any .md files
if ! ls "$STORY_DIR"/*.md >/dev/null 2>&1; then
  echo '{"warning": "No .md files found in '$STORY_DIR'"}' >&2
  echo '{"success": "Migration completed", "epic_count": 0, "story_count": 0, "message": "No files to migrate"}'
  exit 0
fi

echo "Starting migration of Markdown stories to GitHub issues..."
echo "Story directory: $STORY_DIR"

# Array to track created issues
declare -A EPIC_ISSUES
declare -A STORY_ISSUES

MIGRATION_LOG="migration-log-$(date +%Y%m%d-%H%M%S).json"
echo '{"migration_started": "'$(date -Iseconds)'", "results": [' > "$MIGRATION_LOG"

FIRST_RESULT=true

# Function to extract section content from markdown
extract_section() {
  local file="$1"
  local section="$2"
  
  # Use awk to extract content between ## Section and next ## or end of file
  awk -v section="$section" '
    BEGIN { in_section = 0; content = "" }
    /^##/ { 
      if (in_section) exit
      if ($0 ~ "^## " section) in_section = 1
      next
    }
    in_section { 
      if (content != "") content = content "\n"
      content = content $0 
    }
    END { print content }
  ' "$file"
}

# Function to parse epic/story numbers from filename
parse_filename() {
  local filename="$1"
  # Extract pattern like 1.2.story-title.md -> epic=1, story=2
  if [[ $filename =~ ^([0-9]+)\.([0-9]+)\. ]]; then
    EPIC_NUM="${BASH_REMATCH[1]}"
    STORY_NUM="${BASH_REMATCH[2]}"
    return 0
  fi
  return 1
}

# Function to log result
log_result() {
  local type="$1"
  local file="$2"
  local issue_num="$3"
  local status="$4"
  local message="$5"
  
  if [ "$FIRST_RESULT" = false ]; then
    echo "," >> "$MIGRATION_LOG"
  fi
  FIRST_RESULT=false
  
  echo "  {" >> "$MIGRATION_LOG"
  echo "    \"type\": \"$type\"," >> "$MIGRATION_LOG"
  echo "    \"file\": \"$file\"," >> "$MIGRATION_LOG"
  echo "    \"issue_number\": $issue_num," >> "$MIGRATION_LOG"
  echo "    \"status\": \"$status\"," >> "$MIGRATION_LOG"
  echo "    \"message\": \"$message\"," >> "$MIGRATION_LOG"
  echo "    \"timestamp\": \"$(date -Iseconds)\"" >> "$MIGRATION_LOG"
  echo -n "  }" >> "$MIGRATION_LOG"
}

# First pass: Create epic issues if they don't exist
echo "Phase 1: Creating epic issues..."
for story_file in "$STORY_DIR"/*.md; do
  [ -f "$story_file" ] || continue
  
  filename=$(basename "$story_file")
  if parse_filename "$filename"; then
    if [ -z "${EPIC_ISSUES[$EPIC_NUM]}" ]; then
      echo "Creating epic issue for Epic $EPIC_NUM..."
      
      # Create basic epic issue
      EPIC_TITLE="Epic $EPIC_NUM: Migration from Markdown"
      EPIC_BODY="This epic was migrated from existing Markdown stories.

Stories in this epic:
$(find "$STORY_DIR" -name "$EPIC_NUM.*.md" -exec basename {} \; | sort)"
      
      RESULT=$(./create-epic-issue.sh "$EPIC_TITLE" "$EPIC_BODY" 2>&1)
      if echo "$RESULT" | jq -e '.epic_number' >/dev/null 2>&1; then
        EPIC_ISSUE_NUM=$(echo "$RESULT" | jq -r '.epic_number')
        EPIC_ISSUES[$EPIC_NUM]=$EPIC_ISSUE_NUM
        echo "Created epic issue #$EPIC_ISSUE_NUM for Epic $EPIC_NUM"
        log_result "epic" "Epic $EPIC_NUM" "$EPIC_ISSUE_NUM" "created" "Epic migrated successfully"
      else
        echo "Failed to create epic issue for Epic $EPIC_NUM: $RESULT"
        log_result "epic" "Epic $EPIC_NUM" "null" "failed" "Epic creation failed: $RESULT"
      fi
    fi
  fi
done

# Second pass: Create story issues
echo "Phase 2: Creating story issues..."
for story_file in "$STORY_DIR"/*.md; do
  [ -f "$story_file" ] || continue
  
  filename=$(basename "$story_file")
  echo "Processing story file: $filename"
  
  if parse_filename "$filename"; then
    EPIC_ISSUE_NUM=${EPIC_ISSUES[$EPIC_NUM]}
    if [ -z "$EPIC_ISSUE_NUM" ]; then
      echo "Warning: No epic issue found for Epic $EPIC_NUM, skipping story"
      log_result "story" "$filename" "null" "skipped" "No parent epic issue found"
      continue
    fi
    
    # Extract story content
    STORY_TITLE=$(head -n 1 "$story_file" | sed 's/^# *//')
    if [ -z "$STORY_TITLE" ]; then
      STORY_TITLE="Story $EPIC_NUM.$STORY_NUM"
    fi
    
    # Build story body from markdown sections
    STORY_SECTION=$(extract_section "$story_file" "Story")
    AC_SECTION=$(extract_section "$story_file" "Acceptance Criteria")
    TASKS_SECTION=$(extract_section "$story_file" "Tasks")
    DEV_NOTES=$(extract_section "$story_file" "Dev Notes")
    
    STORY_BODY="# $STORY_TITLE

## Story
$STORY_SECTION

## Acceptance Criteria
$AC_SECTION

## Tasks / Subtasks
$TASKS_SECTION

## Dev Notes
$DEV_NOTES

---
*Migrated from: $filename*"
    
    echo "Creating story issue: $STORY_TITLE"
    RESULT=$(./create-story-issue.sh "$EPIC_NUM" "$STORY_TITLE" "$STORY_BODY" "$EPIC_ISSUE_NUM" 2>&1)
    
    if echo "$RESULT" | jq -e '.story_number' >/dev/null 2>&1; then
      STORY_ISSUE_NUM=$(echo "$RESULT" | jq -r '.story_number')
      STORY_ISSUES["$EPIC_NUM.$STORY_NUM"]=$STORY_ISSUE_NUM
      echo "Created story issue #$STORY_ISSUE_NUM for $filename"
      log_result "story" "$filename" "$STORY_ISSUE_NUM" "created" "Story migrated successfully"
      
      # Add migration label
      gh issue edit "$STORY_ISSUE_NUM" --add-label "migrated" --repo "$REPO" >/dev/null 2>&1
      
    else
      echo "Failed to create story issue for $filename: $RESULT"
      log_result "story" "$filename" "null" "failed" "Story creation failed: $RESULT"
    fi
  else
    echo "Could not parse filename format: $filename"
    log_result "story" "$filename" "null" "skipped" "Filename format not recognized"
  fi
done

# Close migration log
echo "" >> "$MIGRATION_LOG"
echo '], "migration_completed": "'$(date -Iseconds)'"}' >> "$MIGRATION_LOG"

echo ""
echo "Migration completed!"

# Get accurate counts using array length
EPIC_COUNT=${#EPIC_ISSUES[@]}
STORY_COUNT=${#STORY_ISSUES[@]}

echo "Created $EPIC_COUNT epic issues"
echo "Created $STORY_COUNT story issues"
echo "Migration log saved to: $MIGRATION_LOG"
echo ""
echo "Summary:"
if [ $EPIC_COUNT -gt 0 ]; then
  echo "Epic Issues: ${EPIC_ISSUES[@]}"
else
  echo "Epic Issues: None"
fi
if [ $STORY_COUNT -gt 0 ]; then
  echo "Story Issues: ${STORY_ISSUES[@]}"
else
  echo "Story Issues: None"
fi
echo ""
echo "Next steps:"
echo "1. Review issues on GitHub project board"
echo "2. Update issue statuses as needed using update-issue-status.sh"
echo "3. Create task sub-issues if needed using create-task-issue.sh"
echo "4. Archive or move original Markdown files"

echo '{"success": "Migration completed", "epic_count": '$EPIC_COUNT', "story_count": '$STORY_COUNT', "log_file": "'$MIGRATION_LOG'", "story_dir": "'$STORY_DIR'"}'