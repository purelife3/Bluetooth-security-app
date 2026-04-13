#!/bin/bash

# Push Updates to GitHub Script
# This script helps push all updated workflow files to GitHub

echo "🚀 GitHub Actions Update Pusher"
echo "================================"

# Check if we're in a git repository
if [ ! -d ".git" ]; then
    echo "❌ Not a git repository. Please run 'git init' first."
    exit 1
fi

# Check git status
echo "📊 Checking git status..."
git status

echo ""
echo "📁 Files to be updated:"
echo "-----------------------"
ls -la .github/workflows/

echo ""
read -p "Do you want to add and commit these files? (y/n): " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
    # Add all workflow files
    echo "➕ Adding workflow files..."
    git add .github/workflows/
    
    # Commit
    echo "💾 Committing changes..."
    git commit -m "Update GitHub Actions workflows to Node.js 24 compatible versions
    
    - Updated all actions to Node.js 24 compatible versions
    - Added Ubuntu 24.04 runner for native Node.js 24 support
    - Fixed Node.js 20 deprecation warnings
    - Added new optimized workflows"
    
    # Push
    echo "📤 Pushing to GitHub..."
    git push origin main
    
    echo ""
    echo "✅ Successfully pushed updates to GitHub!"
    echo ""
    echo "📋 Next steps:"
    echo "1. Go to GitHub → Actions"
    echo "2. Run the new 'Test Build Setup (Node.js 24 Optimized)' workflow"
    echo "3. Verify no Node.js 20 deprecation warnings appear"
else
    echo "❌ Cancelled. No changes were pushed."
fi