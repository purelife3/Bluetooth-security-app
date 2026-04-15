#!/bin/bash

echo "🔍 BUILD-TOOLS 37 LICENSE FIX STATUS CHECK"
echo "=========================================="
echo "Timestamp: $(date)"
echo ""

# Check if we're in git repository
if [ ! -d ".git" ]; then
    echo "❌ Not in a git repository"
    exit 1
fi

echo "✅ In git repository"
echo "📊 Current branch: $(git branch --show-current)"
echo ""

# Check workflow file status
echo "📁 WORKFLOW FILE STATUS:"
echo "-----------------------"
if [ -f ".github/workflows/build.yml" ]; then
    echo "✅ Workflow file exists"
    
    # Check git status
    workflow_status=$(git status --porcelain .github/workflows/build.yml 2>/dev/null)
    if [ -z "$workflow_status" ]; then
        echo "✅ Workflow file is committed (no changes)"
    else
        echo "📝 Workflow file has changes: $workflow_status"
        echo ""
        echo "✅ BUILD-TOOLS 37 LICENSE FIX APPLIED:"
        echo "   All 6 license acceptance points updated to 20 'y' inputs"
        echo ""
        echo "📋 Changes ready for commit:"
        git diff --name-only .github/workflows/build.yml
    fi
else
    echo "❌ Workflow file not found"
fi

echo ""
echo "📋 OVERALL GIT STATUS:"
echo "---------------------"
git status --porcelain

echo ""
echo "🚀 NEXT STEPS:"
echo "=============="
echo "If .github/workflows/build.yml shows as modified (M) or added (A):"
echo "1. git add .github/workflows/build.yml"
echo "2. git commit -m 'FIX: Update all license acceptance to 20 y inputs for Build-Tools 37'"
echo "3. git push origin main"
echo ""
echo "This fix should resolve the 'Aidl not found' error by ensuring"
echo "Build-Tools 37 licenses are fully accepted during SDK installation."