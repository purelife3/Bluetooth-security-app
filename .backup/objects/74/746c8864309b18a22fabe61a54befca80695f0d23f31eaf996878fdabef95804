#!/bin/bash

echo "🚀 NUCLEAR OPTION: Clean Start GitHub Actions Fix"
echo "================================================="
echo ""
echo "This script will:"
echo "1. Remove ALL old workflow files"
echo "2. Keep ONLY the new optimized workflows"
echo "3. Create a fresh commit"
echo "4. Push to GitHub"
echo ""
echo "⚠️  WARNING: This will delete your original workflow files!"
echo ""

read -p "Continue? (y/n): " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ Cancelled."
    exit 0
fi

echo "📁 Current workflow files:"
ls -la .github/workflows/
echo ""

# Backup old files (just in case)
echo "💾 Creating backup of old workflows..."
mkdir -p .backup/workflows
cp .github/workflows/* .backup/workflows/ 2>/dev/null || true
echo "Backup created in .backup/workflows/"
echo ""

# Remove old workflow files
echo "🗑️  Removing old workflow files..."
rm -f .github/workflows/build.yml .github/workflows/test-build.yml
echo "✅ Removed: build.yml, test-build.yml"
echo ""

# Rename new workflows to standard names
echo "🔄 Renaming optimized workflows to standard names..."
mv .github/workflows/build-node24.yml .github/workflows/build.yml
mv .github/workflows/test-node24.yml .github/workflows/test-build.yml
echo "✅ Renamed:"
echo "   build-node24.yml → build.yml"
echo "   test-node24.yml → test-build.yml"
echo ""

# Verify the new files
echo "🔍 Verifying new workflow files..."
echo ""
echo "📄 build.yml (formerly build-node24.yml):"
head -3 .github/workflows/build.yml
echo ""
echo "📄 test-build.yml (formerly test-node24.yml):"
head -3 .github/workflows/test-build.yml
echo ""

# Check git status
echo "📊 Git status before commit:"
git status .github/workflows/
echo ""

# Add and commit
echo "➕ Adding updated workflows..."
git add .github/workflows/
echo ""

echo "💾 Committing changes..."
git commit -m "COMPLETE FIX: Replace all workflows with Ubuntu 24.04 optimized versions

- Removed all old workflow files
- Replaced with Ubuntu 24.04 runner workflows
- Eliminates Node.js 20 deprecation warnings at source
- Uses native Node.js 24 support in Ubuntu 24.04"
echo ""

# Push
echo "📤 Pushing to GitHub..."
echo "Note: If this fails, you may need to set up your remote repository first."
echo "Run: git remote add origin YOUR_GITHUB_REPO_URL"
echo ""
read -p "Push to GitHub? (y/n): " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
    git push origin main
    echo ""
    echo "✅ Successfully pushed clean workflow fix!"
else
    echo "⚠️  Changes committed locally but not pushed."
    echo "To push manually: git push origin main"
fi

echo ""
echo "🎯 NEXT STEPS:"
echo "1. Go to GitHub → Actions"
echo "2. Run the 'Test Build Setup' workflow"
echo "3. Verify NO Node.js 20 deprecation warnings appear"
echo ""
echo "📝 Note: The new workflows use 'ubuntu-24.04' runner which has"
echo "       Node.js 24 by default - no compatibility layer needed!"