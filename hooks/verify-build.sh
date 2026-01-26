#!/bin/bash
set -euo pipefail

# Skip if no TypeScript changes
TS_FILES=$(git diff --cached --name-only | grep -E "\.(ts|tsx)$" || true)
if [ -z "$TS_FILES" ]; then exit 0; fi

echo ""
echo "🏗️ Verifying TypeScript build..."
echo ""

# Run type check (fast, no emit)
TSC_OUTPUT=$(bun tsc --noEmit 2>&1 || true)

# Filter for project errors (not node_modules)
PROJECT_ERRORS=$(echo "$TSC_OUTPUT" | grep -E "^(app|lib|components|convex)/.*\.ts.*: error TS" || true)

if [ -n "$PROJECT_ERRORS" ]; then
  ERROR_COUNT=$(echo "$PROJECT_ERRORS" | wc -l | tr -d ' ')

  echo "❌ TypeScript errors detected ($ERROR_COUNT total):"
  echo ""
  echo "$PROJECT_ERRORS" | head -20
  echo ""

  if [ "$ERROR_COUNT" -gt 20 ]; then
    echo "... and $((ERROR_COUNT - 20)) more errors"
    echo ""
  fi

  echo "💡 Fix with: bun tsc --noEmit"
  echo ""
  echo "⛔ BLOCKING: Build must succeed before commit"
  exit 1
fi

echo "✅ Build verification passed"
exit 0
