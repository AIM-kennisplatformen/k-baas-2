#!/bin/bash
# Generic validator for script outputs - checks for error keys and valid JSON

if [ $# -lt 1 ]; then
  echo '{"error": "Usage: $0 <json_output>"}' >&2
  exit 1
fi

JSON_OUTPUT="$1"

# Check dependencies
if ! command -v jq &> /dev/null; then
  echo '{"error": "jq is required but not installed. Install with: brew install jq"}' >&2
  exit 1
fi

# Check if input is empty
if [ -z "$JSON_OUTPUT" ]; then
  echo '{"error": "Empty input provided"}' >&2
  exit 1
fi

# Check if input is valid JSON
if ! echo "$JSON_OUTPUT" | jq . >/dev/null 2>&1; then
  echo '{"error": "Invalid JSON output"}' >&2
  exit 1
fi

# Check for error keys in the JSON (only if error field exists and is not null/empty)
if echo "$JSON_OUTPUT" | jq -e '.error and (.error != null) and (.error != "")' >/dev/null 2>&1; then
  ERROR_MSG=$(echo "$JSON_OUTPUT" | jq -r '.error')
  echo "Validation failed: $ERROR_MSG" >&2
  exit 1
fi

# Check for warnings (non-fatal but should be reported)
if echo "$JSON_OUTPUT" | jq -e '.warning and (.warning != null) and (.warning != "")' >/dev/null 2>&1; then
  WARNING_MSG=$(echo "$JSON_OUTPUT" | jq -r '.warning')
  echo "Validation warning: $WARNING_MSG" >&2
fi

# Check for success indicators
if echo "$JSON_OUTPUT" | jq -e '.success and (.success != null) and (.success != "")' >/dev/null 2>&1; then
  SUCCESS_MSG=$(echo "$JSON_OUTPUT" | jq -r '.success')
  echo "Validation passed: $SUCCESS_MSG"
  exit 0
fi

# Check for specific result indicators (epic_number, story_number, task_number, etc.)
if echo "$JSON_OUTPUT" | jq -e 'has("epic_number") or has("story_number") or has("task_number") or has("result") or has("count")' >/dev/null 2>&1; then
  echo "Validation passed: Valid result object"
  exit 0
fi

# If no explicit error or success, consider it valid if it's proper JSON
echo "Validation passed: Valid JSON output"
exit 0