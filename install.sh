#!/bin/bash
set -euo pipefail

# Claude Code Starter Kit Installer
# Usage: ./install.sh [template] [target-directory]

TEMPLATE="${1:-base}"
TARGET_DIR="${2:-.}"
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo ""
echo "🚀 Claude Code Starter Kit Installer"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Validate target directory
if [ ! -d "$TARGET_DIR" ]; then
  echo "❌ Error: Target directory '$TARGET_DIR' does not exist"
  exit 1
fi

# Create .claude directory structure
CLAUDE_DIR="$TARGET_DIR/.claude"
mkdir -p "$CLAUDE_DIR/hooks"

echo "📁 Installing to: $CLAUDE_DIR"
echo ""

# Copy hooks
echo "📦 Installing hooks..."
for hook in "$SCRIPT_DIR/hooks/"*.sh; do
  hook_name=$(basename "$hook")
  cp -v "$hook" "$CLAUDE_DIR/hooks/$hook_name"
  chmod +x "$CLAUDE_DIR/hooks/$hook_name"
done
echo ""

# Install settings
echo "⚙️  Configuring settings (template: $TEMPLATE)..."

SETTINGS_FILE="$CLAUDE_DIR/settings.json"
BASE_SETTINGS="$SCRIPT_DIR/templates/settings.base.json"
TEMPLATE_SETTINGS="$SCRIPT_DIR/templates/settings.$TEMPLATE.json"

if [ ! -f "$BASE_SETTINGS" ]; then
  echo "❌ Error: Base settings template not found at $BASE_SETTINGS"
  exit 1
fi

# Copy base settings
cp "$BASE_SETTINGS" "$SETTINGS_FILE"

# Merge template-specific settings if exists
if [ -f "$TEMPLATE_SETTINGS" ] && [ "$TEMPLATE" != "base" ]; then
  echo "   Merging $TEMPLATE template..."
  if command -v jq &> /dev/null; then
    jq -s '.[0] * .[1]' "$SETTINGS_FILE" "$TEMPLATE_SETTINGS" > "$SETTINGS_FILE.tmp"
    mv "$SETTINGS_FILE.tmp" "$SETTINGS_FILE"
    echo "   ✅ Settings merged"
  else
    echo "   ⚠️  Warning: jq not found. Install jq for template merging: brew install jq"
    echo "   Falling back to base template only"
  fi
fi

echo ""
echo "✅ Installation complete!"
echo ""
echo "📋 Installed:"
echo "   - $(ls -1 "$CLAUDE_DIR/hooks" | wc -l | tr -d ' ') hook scripts"
echo "   - Settings: $SETTINGS_FILE"
echo ""
echo "📖 Next steps:"
echo "   1. Review settings: cat $SETTINGS_FILE"
echo "   2. Test hooks: git status"
echo "   3. Start Claude Code session"
echo ""

