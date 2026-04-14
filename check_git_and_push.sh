#!/bin/bash

echo "🔍 Git Status & Push Assistant"
echo "=============================="
echo ""

# Check if git is installed
if ! command -v git &> /dev/null; then
    echo "❌ Git is not installed on this system!"
    echo ""
    echo "Please install git first:"
    echo "• Android/Termux: pkg install git"
    echo "• Windows: https://git-scm.com/download/win"
    echo "• macOS: brew install git"
    echo "• Linux: sudo apt-get install git"
    exit 1
fi

echo "✅ Git is installed: $(git --version)"
echo ""

# Check if we're in a git repository
if [ ! -d ".git" ]; then
    echo "❌ Not in a git repository!"
    echo ""
    echo "📋 You have two options:"
    echo ""
    echo "OPTION 1: Initialize new git repository here"
    echo "--------------------------------------------"
    echo "1. git init"
    echo "2. git add ."
    echo "3. git commit -m 'Initial commit'"
    echo "4. git remote add origin YOUR_GITHUB_REPO_URL"
    echo "5. git push -u origin main"
    echo ""
    echo "OPTION 2: Clone your existing repository"
    echo "----------------------------------------"
    echo "1. Find your GitHub repository URL"
    echo "2. Run: git clone YOUR_REPO_URL"
    echo "3. Copy all files from this workspace to the cloned directory"
    echo "4. Then run: git add . && git commit -m 'Update' && git push"
    echo ""
    echo "💡 Based on your workflow logs, you already have a GitHub repository."
    echo "   You should use OPTION 2 - clone your existing repo."
    echo ""
    echo "🔗 To find your GitHub repository URL:"
    echo "1. Go to https://github.com"
    echo "2. Navigate to your repository"
    echo "3. Click 'Code' button"
    echo "4. Copy the HTTPS URL"
    exit 1
fi

echo "✅ In a git repository"
echo ""

# Check git status
echo "📊 Git Status:"
git status
echo ""

# Check remote
echo "🌐 Remote Configuration:"
git remote -v
echo ""

# Check for uncommitted changes
echo "📝 Checking for uncommitted changes..."
if git diff --quiet && git diff --cached --quiet; then
    echo "✅ No uncommitted changes"
    echo ""
    echo "💡 All changes are already committed. You can push with:"
    echo "   git push origin main"
else
    echo "⚠️ You have uncommitted changes!"
    echo ""
    echo "📋 Files with changes:"
    git status --short
    echo ""
    echo "💡 To commit and push:"
    echo "1. git add ."
    echo "2. git commit -m 'Fix: Symlink solution for Buildozer platform directory creation'"
    echo "3. git push origin main"
fi

echo ""
echo "🚀 Quick Push Command (if ready):"
echo "---------------------------------"
echo "git add . && git commit -m 'Fix: Symlink solution for Buildozer platform directory creation' && git push origin main"
echo ""
echo "📋 Commit message includes:"
echo "• CRITICAL BREAKTHROUGH: Buildozer creates platform directories at runtime"
echo "• Symlink solution: platform/android-sdk → sdk, platform/android-ndk → sdk/ndk/25.1.8937393"
echo "• Prevents NDK downloads and 'ValueError: read of closed file' error"