# Changelog

All notable changes to Claude Code Starter Kit will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-01-25

### Added
- Initial release with 8 quality enforcement hooks
- Base and Convex settings templates
- Install and update scripts
- Documentation and README

### Hooks Included
- `beads-context.sh` - Session start Beads context
- `block-console-logs.sh` - Prevent console.log in Convex
- `check-convex-types.sh` - Convex TypeScript validation
- `check-test-coverage.sh` - TDD enforcement warnings
- `landing-the-plane.sh` - Session completion checklist
- `pre-commit-lint.sh` - Pre-commit linting
- `security-audit.sh` - Security vulnerability scanning
- `verify-build.sh` - TypeScript build verification

