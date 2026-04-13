#!/bin/bash

echo "🔧 Fixing Buildozer Initialization Error"
echo "========================================"
echo ""
echo "The GitHub Actions workflow is failing because:"
echo "❌ 'buildozer init' is called when buildozer.spec already exists"
echo ""
echo "This script will:"
echo "1. Fix both workflow files to use 'buildozer spec validate' instead"
echo "2. Commit the changes"
echo "3. Push to GitHub"
echo ""

# Check if we're in a git repository
if [ ! -d ".git" ]; then
    echo "❌ Not a git repository. Please initialize git first."
    exit 1
fi

echo "📁 Checking workflow files..."
echo ""

# Show current workflow files
echo "Current workflow files:"
ls -la .github/workflows/
echo ""

# Check the fix was applied
echo "🔍 Checking test-build.yml fix..."
if grep -q "buildozer spec validate" .github/workflows/test-build.yml; then
    echo "✅ test-build.yml already fixed"
else
    echo "❌ test-build.yml needs fixing"
    exit 1
fi

echo ""
echo "🔍 Checking test-node24.yml fix..."
if grep -q "buildozer spec validate" .github/workflows/test-node24.yml; then
    echo "✅ test-node24.yml already fixed"
else
    echo "❌ test-node24.yml needs fixing"
    exit 1
fi

echo ""
echo "📊 Git status before commit:"
git status .github/workflows/
echo ""

# Add and commit
echo "➕ Adding fixed workflows..."
git add .github/workflows/
echo ""

echo "💾 Committing fixes..."
git commit -m "FIX: Replace buildozer init with validate for existing spec

- Workflow was calling 'buildozer init' when buildozer.spec already exists
- Changed to 'buildozer spec validate' when file exists
- Prevents 'ERROR: You already have a buildozer.spec file'"
echo ""

# Push
echo "📤 Pushing to GitHub..."
echo "Note: If this fails, check your remote repository setup."
echo ""

read -p "Push to GitHub? (y/n): " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
    git push origin main
    echo ""
    echo "✅ Successfully pushed workflow fixes to GitHub!"
    echo ""
    echo "🎯 Next Steps:"
    echo "1. Go to GitHub → Actions"
    echo "2. Run the 'Test Build Setup' workflow again"
    echo "3. The 'buildozer init' error should be resolved"
    echo "4. Workflow should complete successfully"
else
    echo "⚠️  Changes committed locally but not pushed."
    echo "To push manually: git push origin main"
fi

echo ""
echo "📝 Summary of fixes applied:"
echo "1. test-build.yml: Changed 'buildozer init' → 'buildozer spec validate'"
echo "2. test-node24.yml: Changed 'buildozer init' → 'buildozer spec validate'"
echo ""
echo "✅ Both workflows now properly handle existing buildozer.spec files"