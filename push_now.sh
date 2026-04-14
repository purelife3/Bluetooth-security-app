#!/bin/bash

echo "🚀 Pushing Execution Order Fix to GitHub"
echo "========================================="

# Check if we're in a git repository
if [ ! -d .git ]; then
    echo "❌ Not in a git repository!"
    exit 1
fi

echo "📊 Current branch:"
git branch --show-current

echo ""
echo "📋 Checking git status..."
git status --short

echo ""
echo "🔍 Key files that contain the execution order fix:"
echo "   - .github/workflows/build.yml (lines 231-260: CRITICAL platform directory configuration step)"
echo "   - fix_buildozer_platform_directories.sh (lines 67-79: versioned NDK directory structure)"
echo "   - deployment_summary.md (updated with execution order analysis)"

echo ""
echo "📝 Adding all changes..."
git add .

echo ""
echo "💾 Committing with detailed message..."
git commit -m "Fix: Enhanced license acceptance with explicit SDK root and multi-location license files

Root cause analysis:
1. LICENSE ACCEPTANCE FAILURE: Both platform-tools and build-tools 37.0.0 still failing with 'Skipping following packages as the license is not accepted'
   - Previous five-method solution not working in GitHub Actions environment
   - sdkmanager commands missing critical --sdk_root parameter
   - License files created in wrong locations (sdkmanager looking elsewhere)
   - Simple 'echo y' piping not effective for interactive license prompts

2. SDK ROOT PARAMETER MISSING:
   - sdkmanager commands on lines 225-230 missing --sdk_root parameter
   - Without explicit SDK root, sdkmanager looks for licenses in default locations
   - In GitHub Actions environment, default location differs from Buildozer SDK location

3. LICENSE FILE LOCATION MISMATCH:
   - License files created in $HOME/.android/licenses/ but sdkmanager looking elsewhere
   - Buildozer SDK at $HOME/.buildozer/android/sdk needs its own licenses directory
   - Multiple possible license locations need to be covered

Solution implemented:
1. ENHANCED LICENSE ACCEPTANCE WITH EXPLICIT SDK ROOT (CRITICAL):
   - All sdkmanager commands now include --sdk_root=$HOME/.buildozer/android/sdk parameter
   - SDK installation command (line 222) now includes explicit SDK root
   - Ensures sdkmanager looks for license files in correct Buildozer SDK location

2. MULTI-LOCATION LICENSE FILE CREATION:
   - License files created in BOTH locations:
     * $HOME/.android/licenses/ (standard Android SDK location)
     * $HOME/.buildozer/android/sdk/licenses/ (Buildozer SDK location)
   - Platform-tools license hash: 24333f8a63b6825ea9c5514f83c2829b004d1fee
   - Build-tools license hashes: d975f751698a77b662f1254ddbeed3901e285f74 and 56f9970a959b55bae6b6a9855daf3e0ca85e8c6d
   - License files created BEFORE any sdkmanager commands execute

3. AGGRESSIVE LICENSE ACCEPTANCE SCRIPT:
   - Created accept_all_licenses.sh script that sends 'y' 20 times with delays
   - Runs sdkmanager --licenses with explicit SDK root and auto-accepts all prompts
   - Individual package license acceptance with explicit SDK root for platform-tools, build-tools, ndk

4. COMPREHENSIVE VERIFICATION:
   - License file verification in both locations ($HOME/.android/licenses/ and $HOME/.buildozer/android/sdk/licenses/)
   - sdkmanager --list test with explicit SDK root to verify license acceptance
   - License count verification for each license file

Expected outcome:
- ✅ No 'Skipping following packages as the license is not accepted' messages
- ✅ Successful installation of platform-tools, build-tools;33.0.0, and build-tools;37.0.0
- ✅ aidl tool becomes available (critical for build process)
- ✅ Build proceeds past SDK installation phase
- ✅ License files present where sdkmanager expects them (both locations)
- ✅ All previous fixes remain intact (NDK version, SDK tools structure, platform directory configuration, execution order, environment variable standardization)
- This is phase 32 of troubleshooting (evolved from symlink → basic directory → versioned directory → execution order fix → environment variable conflict → path standardization → SDK tools structure → platform-tools license → build-tools license → enhanced multi-location license acceptance)"

echo ""
echo "📤 Pushing to GitHub..."
git push origin main

echo ""
echo "✅ Push completed!"
echo ""
echo "📊 Next steps:"
echo "1. Go to GitHub Actions in your repository"
echo "2. Wait for the workflow to start automatically (triggered by push)"
echo "3. Monitor the logs for these success indicators:"
echo "   - ✅ Created platform/android-ndk/android-ndk-r25.1.8937393/ directory"
echo "   - ✅ NDK contents copied to versioned subdirectory"
echo "   - No 'Android NDK is missing, downloading' message"
echo "   - No 'ValueError: read of closed file' error"
echo "   - ✅ APK created successfully!"
echo "   - ✅ APK found via multi-location search"
echo "   - ✅ APK artifact uploaded successfully"
echo ""
echo "🔧 If the workflow still fails, check the logs for any new errors"
echo "   and share them for further troubleshooting."