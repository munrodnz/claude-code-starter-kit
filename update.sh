#!/bin/bash
set -euo pipefail

# Claude Code Starter Kit Updater
# Usage: ./update.sh [target-directory]

TARGET_DIR="${1:-.}"
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CLAUDE_DIR="$TARGET_DIR/.claude"

echo ""
echo "🔄 Claude Code Starter Kit Updater"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Check if .claude exists
if [ ! -d "$CLAUDE_DIR" ]; then
  echo "❌ Error: .claude directory not found in $TARGET_DIR"
  echo "   Run ./install.sh first"
  exit 1
fi

# Backup existing hooks
echo "💾 Backing up existing hooks..."
BACKUP_DIR="$CLAUDE_DIR/hooks.backup.$(date +%Y%m%d_%H%M%S)"
cp -R "$CLAUDE_DIR/hooks" "$BACKUP_DIR"
echo "   Backup saved to: $BACKUP_DIR"
echo ""

# Update hooks
echo "📦 Updating hooks..."
UPDATED=0
for hook in "$SCRIPT_DIR/hooks/"*.sh; do
  hook_name=$(basename "$hook")
  if [ -f "$CLAUDE_DIR/hooks/$hook_name" ]; then
    cp -v "$hook" "$CLAUDE_DIR/hooks/$hook_name"
    chmod +x "$CLAUDE_DIR/hooks/$hook_name"
    ((UPDATED++))
  else
    echo "   New hook: $hook_name"
    cp "$hook" "$CLAUDE_DIR/hooks/$hook_name"
    chmod +x "$CLAUDE_DIR/hooks/$hook_name"
    ((UPDATED++))
  fi
done
echo ""
echo "   ✅ Updated $UPDATED hooks"
echo ""

# Check settings differences
echo "⚙️  Settings status:"
if [ -f "$CLAUDE_DIR/settings.json" ]; then
  echo "   ✅ Settings file exists (preserved)"
  echo "   💡 Review templates/ for new settings options"
else
  echo "   ⚠️  Warning: No settings.json found"
fi

echo ""
echo "✅ Update complete!"
echo ""
echo "📋 Summary:"
echo "   - Hooks updated: $UPDATED"
echo "   - Settings: preserved (manual review recommended)"
echo "   - Backup: $BACKUP_DIR"
echo ""

