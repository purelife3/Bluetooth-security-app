#!/bin/bash

echo "=== VERIFYING AND PUSHING CURRENT NDK FIX ==="
echo ""

# 1. Verify current buildozer.spec configuration
echo "1. Checking current buildozer.spec NDK configuration..."
if grep -q "android.ndk = 25b" buildozer.spec; then
    echo "   ✅ NDK configuration is CORRECT: android.ndk = 25b"
    NDK_LINE=$(grep -n "android.ndk = 25b" buildozer.spec)
    echo "   Found at line: $NDK_LINE"
else
    echo "   ❌ ERROR: NDK configuration NOT found as '25b'"
    echo "   Current NDK line:"
    grep "android.ndk" buildozer.spec
    exit 1
fi

echo ""

# 2. Check Git status
echo "2. Checking Git status..."
git status --short

echo ""

# 3. Show what would be committed
echo "3. Changes to be committed:"
git diff --cached

echo ""

# 4. Show unstaged changes
echo "4. Unstaged changes:"
git diff

echo ""

# 5. Check if we need to commit the NDK fix
echo "5. Checking if NDK fix needs to be committed..."
if git diff --quiet buildozer.spec; then
    echo "   ✅ buildozer.spec has no uncommitted changes"
    echo "   The NDK fix may already be committed"
else
    echo "   ⚠️  buildozer.spec has uncommitted changes"
    echo "   Showing diff:"
    git diff buildozer.spec
    echo ""
    echo "   Would you like to commit these changes? (y/n)"
    read -r response
    if [[ "$response" =~ ^[Yy]$ ]]; then
        git add buildozer.spec
        git commit -m "Fix: Correct NDK version to 25b (restored after Git sync issue)"
        echo "   ✅ Changes committed"
    fi
fi

echo ""

# 6. Show current branch and remote status
echo "6. Current Git branch and remote status:"
git branch -vv
echo ""
echo "Remote branches:"
git branch -r

echo ""

# 7. Check if we can push
echo "7. Checking if we can push to remote..."
if git status | grep -q "Your branch is ahead"; then
    echo "   ✅ Local branch is ahead of remote - ready to push"
    echo ""
    echo "   Would you like to push to GitHub? (y/n)"
    read -r response
    if [[ "$response" =~ ^[Yy]$ ]]; then
        echo "   Pushing to GitHub..."
        git push origin main
        echo "   ✅ Push completed"
    fi
else
    echo "   ℹ️  Local branch is up to date with remote"
    echo "   No push needed"
fi

echo ""
echo "=== VERIFICATION COMPLETE ==="
echo ""
echo "Next steps:"
echo "1. The NDK configuration is already correct (android.ndk = 25b)"
echo "2. If there are uncommitted changes, commit them with the script above"
echo "3. Push to GitHub if local branch is ahead"
echo "4. The new issue is Build-Tools license acceptance in GitHub Actions"
echo "5. Monitor the next GitHub Actions build for Build-Tools 37 license issue"