#!/bin/bash

echo "🔍 CURRENT GIT STATUS CHECK"
echo "=========================="

# Check if we're in a git repository
if [ ! -d .git ]; then
    echo "❌ Not in a git repository!"
    exit 1
fi

echo "✅ Git repository found"

echo ""
echo "📊 Current branch:"
git branch --show-current

echo ""
echo "📋 Git status (detailed):"
git status

echo ""
echo "📝 Staged changes (git diff --cached --name-only):"
git diff --cached --name-only

echo ""
echo "📝 Unstaged changes (git diff --name-only):"
git diff --name-only

echo ""
echo "📊 Recent commits (last 3):"
git log --oneline -3

echo ""
echo "🔍 Checking if workflow file has been modified:"
if git diff --name-only | grep -q "\.github/workflows/build.yml"; then
    echo "✅ .github/workflows/build.yml has uncommitted changes"
    echo ""
    echo "📋 Changes in workflow file:"
    git diff .github/workflows/build.yml | head -50
else
    echo "❌ .github/workflows/build.yml has NO uncommitted changes"
    echo "   (The Buildozer SDK/NDK directory fix may already be committed)"
fi

echo ""
echo "🚀 READY FOR PUSH STATUS:"
echo "------------------------"
if [ -n "$(git status --porcelain)" ]; then
    echo "⚠️ There are uncommitted changes"
    echo "   Run: ./execute_final_push.sh to commit and push"
else
    echo "✅ No uncommitted changes"
    echo "   The Buildozer SDK/NDK directory fix may already be pushed"
fi