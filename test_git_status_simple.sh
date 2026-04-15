#!/bin/bash

echo "🔍 SIMPLE GIT STATUS TEST"
echo "========================"

# Check git status porcelain output
echo "Git status --porcelain output:"
git status --porcelain

echo ""
echo "Checking if .github/workflows/build.yml is modified:"
if git status --porcelain | grep -q "\.github/workflows/build.yml"; then
    echo "✅ .github/workflows/build.yml is modified"
    
    # Check if it's staged or unstaged
    STATUS=$(git status --porcelain .github/workflows/build.yml)
    if [[ $STATUS == M* ]]; then
        echo "   Status: Staged (ready to commit)"
    elif [[ $STATUS == " M"* ]]; then
        echo "   Status: Unstaged (needs to be added)"
    else
        echo "   Status: $STATUS"
    fi
else
    echo "❌ .github/workflows/build.yml is NOT modified"
fi

echo ""
echo "Checking other modified files:"
git status --porcelain | grep -v "^$" | while read line; do
    echo "  $line"
done