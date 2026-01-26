#!/bin/bash
set -euo pipefail

# Check if Beads is available
if ! command -v bd &> /dev/null; then
  exit 0
fi

echo ""
echo "📋 Beads Issue Context:"
echo ""

# Show ready issues (no blockers)
READY_ISSUES=$(bd ready 2>/dev/null || true)

if [ -n "$READY_ISSUES" ]; then
  echo "Available work (no blocking dependencies):"
  echo "$READY_ISSUES"
  echo ""
else
  echo "No issues ready to work (all blocked or completed)"
  echo ""
fi

# Show in-progress issues
IN_PROGRESS=$(bd list --status=in_progress 2>/dev/null || true)

if [ -n "$IN_PROGRESS" ]; then
  echo "In-progress issues:"
  echo "$IN_PROGRESS"
  echo ""
fi

echo "Run 'bd show <id>' for details or 'bd create' to add new work"
echo ""

exit 0
