#!/bin/bash

# Push workflow fixes to GitHub
echo "🚀 Pushing workflow fixes to GitHub..."

# Check git status
echo "📊 Checking git status..."
git status

# Add the fixed workflow files
echo "📁 Adding fixed workflow files..."
git add .github/workflows/build.yml
git add .github/workflows/build-node24.yml

# Commit the changes
echo "💾 Committing fixes..."
git commit -m "Fix Android NDK download with sdkmanager-based approach

- Replaced problematic direct NDK download URL with sdkmanager-based download
- Direct Google NDK URL (https://dl.google.com/android/repository/android-ndk-r25.1.8937393-linux.zip) returns 0 MB files despite showing 100% download
- New approach uses 'sdkmanager ndk;25.1.8937393' to download NDK through official Android SDK tools
- NDK downloaded to ~/.buildozer/android/sdk/ndk/25.1.8937393 and symlinked to Buildozer's expected location
- Added fallback to NDK r25b direct download if sdkmanager fails
- Both workflow files updated with identical sdkmanager-based NDK download logic
- This prevents the 'read of closed file' error by avoiding Buildozer's problematic urllib downloads entirely"

# Push to GitHub
echo "📤 Pushing to GitHub..."
git push origin main

echo "✅ Fixes pushed successfully!"
echo ""
echo "📋 Next steps:"
echo "1. Go to your GitHub repository"
echo "2. Navigate to Actions tab"
echo "3. Run the workflow manually or wait for automatic trigger"
echo "4. Check the detailed build logs to see if NDK download now works"
echo ""
echo "🔍 If NDK download still fails, check:"
echo "   - sdkmanager output logs for NDK download errors"
echo "   - Network connectivity to Google's Android repositories"
echo "   - Available disk space (NDK is ~1.5GB)"