#!/bin/bash

echo "🔍 Checking Git Repository Readiness"
echo "===================================="

# Check if git is installed
if ! command -v git &> /dev/null; then
    echo "❌ Git is not installed!"
    echo ""
    echo "Install git first:"
    echo "sudo apt-get update && sudo apt-get install -y git"
    exit 1
fi

echo "✅ Git is installed"

# Check if we're in a git repository
if [ ! -d ".git" ]; then
    echo "❌ Not a git repository!"
    echo ""
    echo "To initialize git repository:"
    echo "1. Run: git init"
    echo "2. Run: git add ."
    echo "3. Run: git commit -m 'Initial commit'"
    echo "4. Run: git remote add origin YOUR_GITHUB_REPO_URL"
    echo "5. Run: git push -u origin main"
    exit 1
fi

echo "✅ Git repository found"

# Check git status
echo ""
echo "📊 Git Status:"
git status --short

# Check remote configuration
echo ""
echo "🌐 Remote Configuration:"
git remote -v

if [ -z "$(git remote -v)" ]; then
    echo "❌ No remote repository configured!"
    echo ""
    echo "To add a remote repository:"
    echo "git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO.git"
    echo "git push -u origin main"
    exit 1
fi

echo "✅ Remote repository configured"

# Check if we have uncommitted changes
echo ""
echo "📝 Uncommitted Changes:"
if git diff --quiet; then
    echo "✅ No uncommitted changes"
else
    echo "⚠️ You have uncommitted changes!"
    echo ""
    echo "Files with changes:"
    git diff --name-only
    echo ""
    echo "To commit these changes:"
    echo "git add ."
    echo "git commit -m 'Your commit message'"
fi

# Check if we need to push
echo ""
echo "📤 Push Status:"
if git log --oneline origin/main..HEAD 2>/dev/null | grep -q .; then
    echo "⚠️ You have commits to push!"
    echo ""
    echo "Commits to push:"
    git log --oneline origin/main..HEAD
    echo ""
    echo "To push: git push origin main"
else
    echo "✅ No commits to push"
fi

echo ""
echo "📋 Critical Files That Need to Be Pushed:"
echo "========================================="
echo "1. .github/workflows/build.yml - Contains symlink fix (lines 242-257)"
echo "2. fix_buildozer_config.sh - Symlink implementation"
echo "3. test_buildozer_config.sh - Verification script"
echo "4. setup_environment.sh - Environment setup"
echo "5. verify_ndk_config.sh - Configuration verification"
echo "6. buildozer.spec - Clean configuration"

echo ""
echo "🚀 Ready to Push? Run:"
echo "======================"
echo "chmod +x push_symlink_fix.sh && ./push_symlink_fix.sh"
echo ""
echo "📝 Or manually:"
echo "git add .github/workflows/build.yml fix_buildozer_config.sh test_buildozer_config.sh setup_environment.sh verify_ndk_config.sh buildozer.spec"
echo "git commit -m 'Fix: Symlink solution for Buildozer platform directory creation'"
echo "git push origin main"