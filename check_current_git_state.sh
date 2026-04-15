#!/bin/bash

echo "🔍 CURRENT GIT STATE CHECK"
echo "=========================="
echo ""

# Check if we're in a git repo
if [ ! -d ".git" ]; then
    echo "❌ Not in a git repository"
    exit 1
fi

echo "📊 Git Status Summary:"
echo "---------------------"
git status

echo ""
echo "📝 Modified Files:"
echo "-----------------"
git status --porcelain

echo ""
echo "🔍 Checking workflow file status:"
echo "--------------------------------"
if [ -f ".github/workflows/build_fixed.yml" ]; then
    echo "✅ build_fixed.yml exists"
    
    # Check if it's tracked
    if git ls-files --error-unmatch .github/workflows/build_fixed.yml 2>/dev/null; then
        echo "✅ build_fixed.yml is tracked by git"
    else
        echo "⚠️ build_fixed.yml is NOT tracked by git"
    fi
    
    # Check if it's modified
    if git diff --quiet .github/workflows/build_fixed.yml 2>/dev/null; then
        echo "✅ build_fixed.yml has no uncommitted changes"
    else
        echo "📝 build_fixed.yml has uncommitted changes:"
        git diff --stat .github/workflows/build_fixed.yml
    fi
else
    echo "❌ build_fixed.yml not found"
fi

echo ""
echo "📋 What would be committed:"
echo "--------------------------"
git diff --cached --name-only

echo ""
echo "🚀 Ready to commit and push Java compatibility fix?"
echo "--------------------------------------------------"
echo "If build_fixed.yml shows modifications, run:"
echo "1. git add .github/workflows/build_fixed.yml"
echo "2. git commit -m 'Fix Java 17 compatibility issue with Android SDK tools'"
echo "3. git push origin main"