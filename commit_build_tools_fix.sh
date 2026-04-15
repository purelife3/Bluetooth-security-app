#!/bin/bash

echo "=== Build-Tools 37 License Fix Commit Script ==="
echo ""

# Check if we're in a git repository
if [ ! -d ".git" ]; then
    echo "❌ Not a git repository"
    exit 1
fi

# Add the workflow file
echo "📁 Adding .github/workflows/build.yml..."
git add .github/workflows/build.yml

# Check what's being committed
echo "📋 Changes to be committed:"
git status --porcelain

# Commit with descriptive message
echo "📝 Committing Build-Tools 37 license fixes..."
git commit -m "Fix: Build-Tools 37 license acceptance - targeted fixes

- Changed echo 'y' to yes command for multiple license prompts (line 201)
- Added Build-Tools 37 specific hash to license list (line 152)
- Added explicit license acceptance immediately before Build-Tools 37 installation (lines 228-230)

This addresses the 'Skipping following packages as the license is not accepted: Android SDK Build-Tools 37' error."

# Push to remote
echo "🚀 Pushing to remote repository..."
git push origin main

echo "✅ Build-Tools 37 license fixes committed and pushed!"