#!/bin/bash

echo "🔍 Git Issue Diagnostic"
echo "======================="
echo ""

echo "1. Checking git version:"
git --version
echo ""

echo "2. Checking current branch:"
git branch --show-current
echo ""

echo "3. Checking remote branches:"
git branch -r
echo ""

echo "4. Checking if we can fetch:"
git fetch --dry-run
echo ""

echo "5. Checking git config for push.default:"
git config push.default
echo ""

echo "6. Checking if main branch exists:"
if git show-ref --verify --quiet refs/heads/main; then
    echo "✅ Main branch exists locally"
else
    echo "❌ Main branch doesn't exist locally"
fi
echo ""

echo "7. Checking if origin/main exists:"
if git show-ref --verify --quiet refs/remotes/origin/main; then
    echo "✅ origin/main exists"
else
    echo "❌ origin/main doesn't exist"
fi
echo ""

echo "8. Simple test - can we pull without changes?"
echo "Trying git pull --ff-only..."
git pull origin main --ff-only --dry-run
echo ""

echo "9. Checking for any git hooks that might interfere:"
if [ -d .git/hooks ]; then
    echo "Git hooks directory exists"
    ls -la .git/hooks/
else
    echo "No git hooks directory"
fi
echo ""

echo "10. Checking git status one more time:"
git status
echo ""

echo "📋 Summary:"
echo "If you see 'fatal: refusing to merge unrelated histories', you may need to use:"
echo "  git pull origin main --allow-unrelated-histories"
echo ""
echo "If you see 'error: cannot pull with rebase: You have unstaged changes',"
echo "you need to stash changes first with: git stash"