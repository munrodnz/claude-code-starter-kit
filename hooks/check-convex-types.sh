#!/bin/bash
# PostToolUse Hook: Validate Convex TypeScript types
# Runs after Write/Edit operations on Convex files

set -euo pipefail

# === Project Detection ===
if [ ! -d "convex" ] && [ ! -f "convex.json" ]; then
  exit 0  # Not a Convex project, skip silently
fi

# === Detect Modified Convex Files ===
# Check git status for recently modified .ts files in convex/
MODIFIED_CONVEX_FILES=$(git status --short | grep -E "^\s*[AM]\s+convex/.*\.ts$" || true)

if [ -z "$MODIFIED_CONVEX_FILES" ]; then
  exit 0  # No Convex TypeScript files modified
fi

# === Type Checking ===
echo ""
echo "🔍 Checking Convex TypeScript types..."
echo ""

# Run tsc and filter for ONLY convex/ directory errors
TSC_OUTPUT=$(bun tsc --noEmit --project tsconfig.json 2>&1 || true)

# Extract only errors from convex/ directory (not tests/convex)
CONVEX_ERRORS=$(echo "$TSC_OUTPUT" | grep -E "^convex/.*\.ts\([0-9]+,[0-9]+\): error TS[0-9]+" || true)

if [ -n "$CONVEX_ERRORS" ]; then
  echo "❌ Type errors detected in Convex files:"
  echo ""
  echo "$CONVEX_ERRORS" | head -20  # Show first 20 errors
  echo ""

  # Count total errors
  ERROR_COUNT=$(echo "$CONVEX_ERRORS" | wc -l | tr -d ' ')

  if [ "$ERROR_COUNT" -gt 20 ]; then
    echo "... and $((ERROR_COUNT - 20)) more errors"
    echo ""
  fi

  echo "💡 To fix all errors, run:"
  echo "   bun tsc --noEmit | grep 'convex/'"
  echo ""
  echo "⛔ BLOCKING: Cannot proceed with type errors in Convex files"
  echo ""

  # Block operations until errors are fixed
  exit 1
fi

echo "✅ No type errors in Convex files"
echo ""
exit 0
