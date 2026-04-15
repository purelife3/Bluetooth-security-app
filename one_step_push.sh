#!/bin/bash

echo "🚀 ONE-STEP PUSH: Deploy NDK Workflow Timing Fix"
echo "================================================"
echo ""
echo "This script will handle everything in one go:"
echo "1. Pull latest changes from GitHub"
echo "2. Apply your NDK fix"
echo "3. Commit and push"
echo ""

# Make sure we're in the right state
echo "📊 Checking current git status..."
git status

echo ""
echo "⚠️  IMPORTANT: This will overwrite any remote changes with your NDK fix."
echo "   Press Enter to continue or Ctrl+C to cancel..."
read

echo ""
echo "🚀 Executing push with force (since remote is ahead)..."
echo "-------------------------------------------------------"

# Pull with rebase to incorporate remote changes
echo "📥 Pulling latest changes..."
git pull --rebase origin main

# Stage the critical files
echo "📝 Staging NDK fix files..."
git add .github/workflows/build.yml
git add buildozer.spec
git add fix_buildozer_platform_directories.sh
git add verify_ndk_config.sh

# Commit
echo "💾 Committing fix..."
git commit -m "FIX: Workflow timing for NDK bridge

Critical fix to ensure NDK bridge executes AFTER SDK Manager download.
SDK Manager downloads '25b', Buildozer expects '25.1.8937393'.
Bridge creates naming bridge but was executing too early.
Workflow timing ensures proper sequence."

# Push with force (since we rebased)
echo "🚀 Pushing to GitHub..."
git push --force-with-lease origin main

echo ""
echo "✅ SUCCESS! NDK workflow timing fix deployed."
echo ""
echo "📋 Next Steps:"
echo "1. Go to: https://github.com/purelife3/Bluetooth-security-app/actions"
echo "2. Click 'Run workflow' → 'Run workflow'"
echo "3. Look for 'Download Android NDK via SDK Manager (CRITICAL FIX)' step"
echo "4. Verify no 'ValueError: read of closed file' errors"
echo ""
echo "The NDK bridge is in fix_buildozer_platform_directories.sh lines 130-174"
echo "It downloads android-ndk-r25b-linux.zip and creates 25.1.8937393/ directory"
echo "================================================"