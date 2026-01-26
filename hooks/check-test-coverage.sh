#!/bin/bash
set -euo pipefail

# Detect modified source files (not tests)
MODIFIED_SRC=$(git status --short | grep -E "^\s*[AM]\s+(app|lib|components|convex)/.*\.(ts|tsx)$" | grep -v "\.test\." | grep -v "\.spec\." || true)
if [ -z "$MODIFIED_SRC" ]; then exit 0; fi

echo ""
echo "🧪 Checking test coverage for modified files..."
echo ""

# Extract filenames
FILES=$(echo "$MODIFIED_SRC" | awk '{print $2}')

# Check if corresponding test files exist
MISSING_TESTS=""
for file in $FILES; do
  TEST_FILE_1="${file%.ts}.test.ts"
  TEST_FILE_2="${file%.tsx}.test.tsx"
  TEST_FILE_3="${file%.ts}.spec.ts"

  if [ ! -f "$TEST_FILE_1" ] && [ ! -f "$TEST_FILE_2" ] && [ ! -f "$TEST_FILE_3" ]; then
    MISSING_TESTS="$MISSING_TESTS\n  ❌ $file (no test file found)"
  fi
done

if [ -n "$MISSING_TESTS" ]; then
  echo "⚠️ TDD VIOLATION: Modified files without tests:"
  echo -e "$MISSING_TESTS"
  echo ""
  echo "📋 Standards from CLAUDE.md:"
  echo "   - Critical paths: 100% coverage"
  echo "   - Business logic: 90% coverage"
  echo "   - UI components: 80% coverage"
  echo ""
  echo "💡 Create test file: tests/unit/[filename].test.ts"
  echo ""
  echo "⚠️ WARNING: This violates TDD principles (run 'bun test' to verify)"
  # Non-blocking but loud warning
  exit 0
fi

echo "✅ All modified files have corresponding tests"
exit 0
