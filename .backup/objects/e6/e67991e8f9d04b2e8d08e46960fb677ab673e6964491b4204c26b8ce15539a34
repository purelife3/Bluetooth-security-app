#!/bin/bash

echo "🔍 Executing Git Status Check"
echo "============================="

# First, verify we're in the right directory
echo "Current directory: $(pwd)"
echo ""

# Check if we're in a git repository
if [ ! -d .git ]; then
    echo "❌ Not in a git repository!"
    echo "Please navigate to your Bluetooth-security-app directory."
    exit 1
fi

echo "✅ In a git repository"
echo ""

# Show current branch
echo "📊 Current branch:"
git branch --show-current
echo ""

# Show git status in detail
echo "📋 Git status (detailed):"
git status
echo ""

# Show what files would be committed
echo "📦 Files that would be committed with 'git add .':"
git status --porcelain
echo ""

# Count files
total_files=$(git status --porcelain | wc -l)
modified_files=$(git status --porcelain | grep -E '^M' | wc -l)
added_files=$(git status --porcelain | grep -E '^A' | wc -l)
untracked_files=$(git status --porcelain | grep -E '^\?' | wc -l)

echo "📊 Summary:"
echo "  Total files: $total_files"
echo "  Modified: $modified_files"
echo "  Added: $added_files"
echo "  Untracked: $untracked_files"
echo ""

# Check if the workflow file has the symlink fix
echo "🔍 Checking for symlink fix in workflow:"
if [ -f ".github/workflows/build.yml" ]; then
    if grep -q "CRITICAL: Create symlinks" .github/workflows/build.yml; then
        echo "✅ Symlink fix FOUND in workflow file"
        echo "   Lines 242-257 contain symlink creation logic"
    else
        echo "❌ Symlink fix NOT FOUND in workflow file"
        echo "   The workflow file needs to be updated"
    fi
else
    echo "❌ Workflow file not found at .github/workflows/build.yml"
fi
echo ""

# Provide next steps
echo "🚀 Next Steps:"
echo "=============="
echo ""
echo "If you see files listed above (especially .github/workflows/build.yml),"
echo "you need to push them to GitHub to test the symlink solution."
echo ""
echo "To push ALL changes:"
echo "   chmod +x push_now.sh && ./push_now.sh"
echo ""
echo "Or manually:"
echo "   1. git add ."
echo "   2. git commit -m 'Fix: Symlink solution for Buildozer platform directory issue'"
echo "   3. git push origin main"
echo ""
echo "After pushing, the GitHub Actions workflow will automatically run"
echo "and we can see if the symlink fix resolves the 'ValueError: read of closed file' error."