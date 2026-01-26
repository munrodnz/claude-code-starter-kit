#!/bin/bash
set -euo pipefail

echo ""
echo "✈️ LANDING THE PLANE - Session Completion Checklist"
echo ""

# Check 1: Uncommitted changes
UNCOMMITTED=$(git status --short || true)
if [ -n "$UNCOMMITTED" ]; then
  echo "❌ Uncommitted changes detected"
  echo "$UNCOMMITTED" | head -10
  echo ""
  echo "💡 Action: Review and commit changes"
  echo ""
else
  echo "✅ No uncommitted changes"
fi

# Check 2: Unpushed commits
UNPUSHED=$(git log @{u}.. --oneline 2>/dev/null || true)
if [ -n "$UNPUSHED" ]; then
  echo "❌ CRITICAL: Unpushed commits detected"
  echo "$UNPUSHED"
  echo ""
  echo "⛔ MANDATORY: Run 'git push' before ending session"
  echo ""
else
  echo "✅ All commits pushed to remote"
fi

# Check 3: Beads issues in progress
if command -v bd &> /dev/null; then
  IN_PROGRESS=$(bd list --status=in_progress 2>/dev/null | grep "in_progress" || true)
  if [ -n "$IN_PROGRESS" ]; then
    echo "⚠️ In-progress Beads issues:"
    echo "$IN_PROGRESS"
    echo ""
    echo "💡 Action: Update status or close completed work"
    echo ""
  fi
fi

# Check 4: Tests passing
if [ -f "package.json" ]; then
  TEST_OUTPUT=$(bun test 2>&1 || true)
  if echo "$TEST_OUTPUT" | grep -q "FAIL"; then
    echo "❌ Failing tests detected"
    echo ""
    echo "💡 Action: Fix tests before ending session"
    echo ""
  else
    echo "✅ Tests passing"
  fi
fi

echo ""
echo "📋 See AGENTS.md for full landing-the-plane protocol"
echo ""

# Non-blocking: Always exit 0
exit 0
