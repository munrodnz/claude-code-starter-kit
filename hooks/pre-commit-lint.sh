#!/bin/bash
set -euo pipefail

# Skip if no staged changes
STAGED=$(git diff --cached --name-only | grep -E "\.(ts|tsx|js|jsx)$" || true)
if [ -z "$STAGED" ]; then exit 0; fi

echo ""
echo "🔍 Running ESLint on staged files..."
echo ""

# Run ESLint only on staged files
LINT_OUTPUT=$(bun run lint --max-warnings=0 2>&1 || true)

if echo "$LINT_OUTPUT" | grep -q "error"; then
  echo "❌ Linting errors detected:"
  echo ""
  echo "$LINT_OUTPUT" | head -30
  echo ""
  echo "💡 Fix with: bun run lint --fix"
  echo ""
  echo "⛔ BLOCKING: Fix linting errors before committing"
  exit 1
fi

echo "✅ Linting passed"
exit 0
