#!/bin/bash

echo "🚀 APPLYING CORRECTED NDK FIX"
echo "=============================="

# Check current buildozer.spec
echo ""
echo "📊 Current buildozer.spec NDK version:"
grep "android.ndk" buildozer.spec

# Apply the corrected fix
echo ""
echo "🔧 Applying corrected NDK fix..."
echo "Changing: android.ndk = 25.1.8937393 → android.ndk = 25b"

# Create a temporary file with the fix
cat > /tmp/buildozer_fix.sed << 'EOF'
/android.sdk = 33/,/android.ndk_api = 23/ {
    s/android.ndk = 25\.1\.8937393/android.ndk = 25b/
}
EOF

# Apply the sed script
sed -i.bak -f /tmp/buildozer_fix.sed buildozer.spec

# Verify the fix
echo ""
echo "✅ Applied fix. New buildozer.spec NDK version:"
grep "android.ndk" buildozer.spec

# Check bridge script has debug output
echo ""
echo "🔍 Checking bridge script debug output..."
if grep -q "DEBUG: Found SDK Manager NDK at:" fix_buildozer_platform_directories.sh; then
    echo "✅ Bridge script has debug output"
else
    echo "❌ Bridge script missing debug output - restoring..."
    # Add debug output if missing
    cat >> fix_buildozer_platform_directories.sh << 'EOF'

# DEBUG: Check if SDK Manager NDK exists
echo "DEBUG: Looking for SDK Manager NDK..."
if [ -d "$SDK_MANAGER_NDK_PATH" ]; then
    echo "DEBUG: Found SDK Manager NDK at: $SDK_MANAGER_NDK_PATH"
else
    echo "DEBUG: SDK Manager NDK not found at: $SDK_MANAGER_NDK_PATH"
fi
EOF
fi

# Show git status
echo ""
echo "📋 Git status:"
git status --porcelain buildozer.spec fix_buildozer_platform_directories.sh

echo ""
echo "🎯 NEXT STEPS:"
echo "=============="
echo "1. Commit the corrected fix:"
echo "   git add buildozer.spec fix_buildozer_platform_directories.sh"
echo "   git commit -m 'FIX: Correct NDK version to 25b in buildozer.spec'"
echo ""
echo "2. Push to GitHub:"
echo "   git push origin main"
echo ""
echo "3. Trigger GitHub Actions:"
echo "   Go to GitHub → Actions → 'Build Android APK' → Run workflow"
echo ""
echo "4. Monitor build logs for:"
echo "   'DEBUG: Found SDK Manager NDK at:'"
echo "   No 'ValueError: read of closed file' errors"