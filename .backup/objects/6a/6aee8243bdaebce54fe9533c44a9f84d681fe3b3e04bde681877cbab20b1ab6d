#!/bin/bash

echo "🔧 GitHub Actions Issue Diagnostic"
echo "=================================="
echo ""

# Check current directory
echo "📂 Current directory: $(pwd)"
echo ""

# List all workflow files
echo "📄 Available workflow files:"
echo "---------------------------"
if [ -d ".github/workflows" ]; then
    for file in .github/workflows/*.yml .github/workflows/*.yaml; do
        if [ -f "$file" ]; then
            echo "• $file"
            # Show first few lines
            echo "  Content preview:"
            head -5 "$file" | sed 's/^/    /'
            echo ""
        fi
    done
else
    echo "❌ No .github/workflows directory found!"
fi

echo ""
echo "🔍 Checking for Node.js 20 deprecation issues..."
echo "-----------------------------------------------"

# Check each workflow file for potential issues
for file in .github/workflows/*.yml .github/workflows/*.yaml; do
    if [ -f "$file" ]; then
        echo ""
        echo "📋 Analyzing: $file"
        echo "-----------------"
        
        # Check runner
        if grep -q "runs-on:" "$file"; then
            echo "Runner: $(grep "runs-on:" "$file" | head -1)"
        fi
        
        # Check Node.js version
        if grep -q "node-version:" "$file"; then
            echo "Node.js version: $(grep "node-version:" "$file" | head -1)"
        fi
        
        # Check action versions
        echo "Action versions:"
        grep -E "uses:.*@" "$file" | sed 's/^/  /'
        
        # Check for FORCE_JAVASCRIPT_ACTIONS_TO_NODE24
        if grep -q "FORCE_JAVASCRIPT_ACTIONS_TO_NODE24" "$file"; then
            echo "✅ FORCE_JAVASCRIPT_ACTIONS_TO_NODE24 found"
        else
            echo "❌ FORCE_JAVASCRIPT_ACTIONS_TO_NODE24 NOT found"
        fi
        
        # Check for ubuntu-24.04
        if grep -q "ubuntu-24.04" "$file"; then
            echo "✅ Ubuntu 24.04 runner detected"
        else
            echo "⚠️  Not using Ubuntu 24.04 runner"
        fi
    fi
done

echo ""
echo "📋 Summary of Solutions Available:"
echo "---------------------------------"
echo "1. Original workflows (may have Node.js 20 warnings):"
echo "   - build.yml"
echo "   - test-build.yml"
echo ""
echo "2. New optimized workflows (should NOT have warnings):"
echo "   - build-node24.yml (uses ubuntu-24.04)"
echo "   - test-node24.yml (uses ubuntu-24.04)"
echo ""
echo "💡 Recommendation:"
echo "If you're still getting Node.js 20 warnings, make sure:"
echo "1. You've pushed ALL workflow files to GitHub"
echo "2. You're running the NEW workflows (build-node24.yml/test-node24.yml)"
echo "3. GitHub isn't caching old workflow runs"
echo ""
echo "🚀 Quick fix: Delete old workflows and only keep the new ones!"
echo "Run: rm .github/workflows/build.yml .github/workflows/test-build.yml"
echo "Then push: bash push_updates.sh"