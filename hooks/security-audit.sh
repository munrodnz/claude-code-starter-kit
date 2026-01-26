#!/bin/bash
set -euo pipefail

# Detect modified sensitive files
SENSITIVE_FILES=$(git status --short | grep -E "^\s*[AM]\s+(.*auth.*|.*config.*|.*api.*|.*secret.*|.*key.*|lib/.*)\.(ts|tsx|js|jsx)$" || true)
if [ -z "$SENSITIVE_FILES" ]; then exit 0; fi

echo ""
echo "🔒 Running security audit on sensitive files..."
echo ""

SECURITY_ISSUES=""

# Check for hardcoded secrets
HARDCODED_SECRETS=$(grep -rn -E "(password|secret|api_key|apiKey|private_key)\s*=\s*['\"]" $(echo "$SENSITIVE_FILES" | awk '{print $2}') 2>/dev/null || true)

if [ -n "$HARDCODED_SECRETS" ]; then
  SECURITY_ISSUES="$SECURITY_ISSUES\n🚨 Hardcoded secrets detected:\n$HARDCODED_SECRETS"
fi

# Check for weak crypto
WEAK_CRYPTO=$(grep -rn -E "(MD5|SHA1|DES)" $(echo "$SENSITIVE_FILES" | awk '{print $2}') 2>/dev/null || true)

if [ -n "$WEAK_CRYPTO" ]; then
  SECURITY_ISSUES="$SECURITY_ISSUES\n⚠️ Weak cryptography detected:\n$WEAK_CRYPTO"
fi

# Check for SQL injection risks
SQL_INJECTION=$(grep -rn -E "query.*\+.*|execute.*\+.*|\`.*\$\{.*\}\`" $(echo "$SENSITIVE_FILES" | awk '{print $2}') 2>/dev/null | grep -i sql || true)

if [ -n "$SQL_INJECTION" ]; then
  SECURITY_ISSUES="$SECURITY_ISSUES\n⚠️ Potential SQL injection:\n$SQL_INJECTION"
fi

if [ -n "$SECURITY_ISSUES" ]; then
  echo -e "$SECURITY_ISSUES"
  echo ""
  echo "💡 Security best practices:"
  echo "   - Use environment variables for secrets"
  echo "   - Use bcrypt/Argon2 for password hashing"
  echo "   - Use parameterized queries for SQL"
  echo ""
  echo "⛔ BLOCKING: Fix security issues before continuing"
  exit 1
fi

echo "✅ Security audit passed"
exit 0
