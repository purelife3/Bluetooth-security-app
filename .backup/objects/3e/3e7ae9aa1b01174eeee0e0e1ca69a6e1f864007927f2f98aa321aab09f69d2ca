#!/bin/bash

echo "🔧 Fixing buildozer.spec GitHub Issue"
echo "======================================"
echo ""
echo "The GitHub Actions workflow is failing because buildozer.spec"
echo "is not in your GitHub repository, even though it exists locally."
echo ""

# Check if buildozer.spec exists
if [ ! -f "buildozer.spec" ]; then
    echo "❌ ERROR: buildozer.spec not found locally!"
    echo "Please create buildozer.spec first."
    exit 1
fi

echo "✅ buildozer.spec found locally."

# Check git status
echo ""
echo "📊 Checking git status..."
git status buildozer.spec

echo ""
echo "🔄 Adding buildozer.spec to git..."
git add buildozer.spec

echo ""
echo "💾 Committing buildozer.spec..."
git commit -m "Add buildozer.spec configuration file

- Required for Buildozer Android APK builds
- Contains Android app configuration and dependencies"

echo ""
echo "📤 Pushing to GitHub..."
echo "Note: If this fails, check your remote repository setup."
echo ""

read -p "Push to GitHub? (y/n): " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
    git push origin main
    echo ""
    echo "✅ Successfully pushed buildozer.spec to GitHub!"
    echo ""
    echo "🎯 Next Steps:"
    echo "1. Go to GitHub → Actions"
    echo "2. Run the workflow again"
    echo "3. The 'buildozer.spec missing' error should be resolved"
else
    echo "⚠️  Changes committed locally but not pushed."
    echo "To push manually: git push origin main"
fi

echo ""
echo "📝 Additional check:"
echo "Run 'bash check_git_status.sh' to verify all files are tracked."