# Claude Code Starter Kit

Reusable Claude Code hooks and settings for quality enforcement across projects.

## Features

- 🔒 **Security Audit** - Blocks hardcoded secrets, weak crypto, SQL injection
- 🧪 **Test Coverage** - Warns when source files lack corresponding tests
- 🏗️ **Build Verification** - Prevents commits with TypeScript errors
- 📝 **Pre-Commit Linting** - Runs ESLint before git commits
- ✈️ **Landing-the-Plane** - Session completion checklist (uncommitted changes, unpushed commits)
- 🚫 **Console.log Blocker** - Prevents console.log in Convex functions (Convex projects)
- 📋 **Beads Context** - Shows available issues at session start
- 🔧 **Convex Type Checker** - Validates Convex TypeScript on file changes

## Quick Start

### Install in New Project

```bash
# Clone this repo once (or use your fork)
git clone https://github.com/yourusername/claude-code-starter-kit.git ~/claude-code-starter-kit

# Install in new project (from project directory)
cd ~/my-new-project
~/claude-code-starter-kit/install.sh base .

# Or for Convex projects
~/claude-code-starter-kit/install.sh convex .
```

### One-Liner Install (GitHub)

```bash
# Base template
curl -fsSL https://raw.githubusercontent.com/yourusername/claude-code-starter-kit/main/install.sh | bash

# Convex template
curl -fsSL https://raw.githubusercontent.com/yourusername/claude-code-starter-kit/main/install.sh | bash -s convex
```

## Templates

- **base** - Universal hooks for all projects
- **convex** - Convex-specific hooks (includes console.log blocker, type checker, Beads integration)

## Update Existing Installation

```bash
cd ~/my-existing-project
~/claude-code-starter-kit/update.sh .
```

## Hooks Reference

### Blocking Hooks (prevent operations)

| Hook | Trigger | Blocks |
|------|---------|--------|
| `block-console-logs.sh` | PostToolUse | console.log in Convex files |
| `pre-commit-lint.sh` | Stop | Commits with linting errors |
| `verify-build.sh` | Stop | Commits with TypeScript errors |
| `security-audit.sh` | PostToolUse | Hardcoded secrets, weak crypto |

### Warning Hooks (informational)

| Hook | Trigger | Purpose |
|------|---------|---------|
| `check-test-coverage.sh` | PostToolUse | Warn about missing tests (TDD enforcement) |
| `landing-the-plane.sh` | SessionEnd | Session completion checklist |
| `beads-context.sh` | SessionStart | Show available Beads issues |

### Convex-Specific Hooks

| Hook | Trigger | Purpose |
|------|---------|---------|
| `check-convex-types.sh` | PostToolUse | Validate Convex TypeScript |

## Customization

### Add Project-Specific Hook

```bash
# Create custom hook in project
cat > .claude/hooks/custom-validation.sh << 'EOF'
#!/bin/bash
# Your custom logic here
EOF

chmod +x .claude/hooks/custom-validation.sh

# Add to .claude/settings.json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "",
        "hooks": [
          { "type": "command", "command": "bash .claude/hooks/custom-validation.sh" }
        ]
      }
    ]
  }
}
```

### Override Hook Behavior

Edit hooks in `.claude/hooks/` - they won't be overwritten by updates (backup is created).

## Maintenance

### Update Starter Kit Repository

```bash
cd ~/claude-code-starter-kit

# Make changes
vim hooks/security-audit.sh

# Update version
echo "1.1.0" > VERSION

# Commit
git add .
git commit -m "feat: improve security audit"
git push
```

### Deploy to All Projects

```bash
# Create deployment script
cat > ~/deploy-claude-updates.sh << 'EOF'
#!/bin/bash
PROJECTS=(
  ~/Projects/project1
  ~/Projects/project2
)

for project in "${PROJECTS[@]}"; do
  echo "Updating $project..."
  ~/claude-code-starter-kit/update.sh "$project"
done
EOF

chmod +x ~/deploy-claude-updates.sh
~/deploy-claude-updates.sh
```

## Version History

See [CHANGELOG.md](CHANGELOG.md) for version history.

## Contributing

1. Fork this repository
2. Create feature branch: `git checkout -b feature/new-hook`
3. Test changes in isolated project
4. Commit: `git commit -m 'feat: add new hook'`
5. Push: `git push origin feature/new-hook`
6. Create Pull Request

## License

MIT License - see [LICENSE](LICENSE) file

## Support

- Issues: https://github.com/yourusername/claude-code-starter-kit/issues
- Docs: See [docs/](docs/) directory

