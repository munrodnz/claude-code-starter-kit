#!/bin/bash
set -euo pipefail

# Skip if not Convex project
if [ ! -d "convex" ]; then exit 0; fi

# Check git status for modified Convex files
MODIFIED_CONVEX=$(git status --short | grep -E "^\s*[AM]\s+convex/.*\.ts$" || true)
if [ -z "$MODIFIED_CONVEX" ]; then exit 0; fi

# Detect console.log (exclude commented lines)
CONSOLE_LOGS=$(grep -rn "^\s*console\.(log|debug|info|warn)" convex/ --include="*.ts" | grep -v "//" || true)

if [ -n "$CONSOLE_LOGS" ]; then
  echo ""
  echo "🚨 SECURITY/PERFORMANCE: console.log detected in Convex"
  echo ""
  echo "$CONSOLE_LOGS" | head -10
  echo ""
  echo "💡 Use structured logging instead:"
  echo "   import { logger } from './logger';"
  echo "   logger.info('message', { context });"
  echo ""
  echo "⛔ BLOCKING: Remove console.log statements"
  exit 1
fi

echo "✅ No console.log in Convex files"
exit 0
