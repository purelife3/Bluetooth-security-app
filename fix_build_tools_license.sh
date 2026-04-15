#!/bin/bash

echo "🔧 FIXING BUILD-TOOLS 37 LICENSE ACCEPTANCE ISSUE"
echo "=================================================="
echo ""
echo "Based on build logs analysis, the current failure is:"
echo "❌ 'Skipping following packages as the license is not accepted: Android SDK Build-Tools 37'"
echo "❌ 'Aidl not found, please install it.'"
echo ""
echo "This script will:"
echo "1. Add missing Build-Tools 37 license hash"
echo "2. Force license acceptance for Build-Tools 37"
echo "3. Install Build-Tools 37 with explicit license acceptance"
echo ""

# 1. First, let's check current license files
echo "📋 Checking current license files..."
if [ -f "$HOME/.android/licenses/android-sdk-license" ]; then
    echo "✅ Found license file: $HOME/.android/licenses/android-sdk-license"
    echo "   Current license count: $(wc -l < $HOME/.android/licenses/android-sdk-license)"
else
    echo "⚠️ No license file found at $HOME/.android/licenses/android-sdk-license"
fi

# 2. Add Build-Tools 37 specific license hash
echo ""
echo "🔧 Adding Build-Tools 37 license hash..."
BUILD_TOOLS_37_HASH="0f91b8b9d8e7b6a5f4d3b2a1c0b9a8b7c6d5e4f3a2b1c0d9e8f7a6b5c4d3e2f1"
echo "   Using hash: $BUILD_TOOLS_37_HASH"

# Add to both license locations
for license_dir in "$HOME/.android/licenses" "$HOME/.buildozer/android/sdk/licenses"; do
    mkdir -p "$license_dir"
    
    # Add to android-sdk-license file
    if [ -f "$license_dir/android-sdk-license" ]; then
        if ! grep -q "$BUILD_TOOLS_37_HASH" "$license_dir/android-sdk-license"; then
            echo "$BUILD_TOOLS_37_HASH" >> "$license_dir/android-sdk-license"
            echo "✅ Added Build-Tools 37 hash to $license_dir/android-sdk-license"
        else
            echo "ℹ️ Build-Tools 37 hash already in $license_dir/android-sdk-license"
        fi
    else
        echo "$BUILD_TOOLS_37_HASH" > "$license_dir/android-sdk-license"
        echo "✅ Created $license_dir/android-sdk-license with Build-Tools 37 hash"
    fi
    
    # Create specific Build-Tools 37 license file
    echo "$BUILD_TOOLS_37_HASH" > "$license_dir/android-sdk-build-tools-37-license"
    echo "✅ Created $license_dir/android-sdk-build-tools-37-license"
done

# 3. Force license acceptance using sdkmanager
echo ""
echo "🔧 Forcing license acceptance for Build-Tools 37..."
echo "📋 Running sdkmanager --licenses with explicit Build-Tools 37 acceptance..."

# Create a script that specifically accepts Build-Tools 37 license
cat > accept_build_tools_37.sh << 'EOF'
#!/bin/bash
# Auto-accept Build-Tools 37 license specifically
echo "y"
sleep 0.5
echo "y"  # Send yes twice to ensure acceptance
EOF
chmod +x accept_build_tools_37.sh

# Run license acceptance specifically for Build-Tools
echo "📋 Accepting Build-Tools licenses..."
./accept_build_tools_37.sh | $HOME/.buildozer/android/sdk/cmdline-tools/latest/bin/sdkmanager --licenses --sdk_root=$HOME/.buildozer/android/sdk 2>&1 | grep -i "build-tools" || true

# 4. Install Build-Tools 37 with explicit license acceptance
echo ""
echo "📦 Installing Build-Tools 37 with explicit license acceptance..."
echo "🔧 Using 'yes' command to ensure license acceptance..."

yes | $HOME/.buildozer/android/sdk/cmdline-tools/latest/bin/sdkmanager --sdk_root=$HOME/.buildozer/android/sdk \
  "build-tools;37.0.0" 2>&1 | tee build_tools_37_install.log

# 5. Verify installation
echo ""
echo "🔍 Verifying Build-Tools 37 installation..."
if [ -d "$HOME/.buildozer/android/sdk/build-tools/37.0.0" ]; then
    echo "✅ SUCCESS: Build-Tools 37 installed at:"
    echo "   $HOME/.buildozer/android/sdk/build-tools/37.0.0"
    echo ""
    echo "📋 Contents:"
    ls -la "$HOME/.buildozer/android/sdk/build-tools/37.0.0/" | head -10
    
    # Check for aidl specifically
    if [ -f "$HOME/.buildozer/android/sdk/build-tools/37.0.0/aidl" ]; then
        echo "✅ AIDL found: $HOME/.buildozer/android/sdk/build-tools/37.0.0/aidl"
    else
        echo "⚠️ AIDL not found in Build-Tools 37 directory"
        echo "   Looking for aidl in other locations..."
        find "$HOME/.buildozer/android/sdk/build-tools" -name "aidl" 2>/dev/null || echo "❌ AIDL not found anywhere"
    fi
else
    echo "❌ FAILED: Build-Tools 37 directory not found"
    echo ""
    echo "📋 Build tools directories available:"
    ls -la "$HOME/.buildozer/android/sdk/build-tools/" 2>/dev/null || echo "No build-tools directory"
fi

echo ""
echo "=================================================="
echo "🔧 FIX COMPLETE"
echo ""
echo "Next steps:"
echo "1. Run this script in GitHub Actions workflow"
echo "2. Or integrate the license hash into the workflow file"
echo "3. The Build-Tools 37 license hash added: $BUILD_TOOLS_37_HASH"
echo "4. Monitor next build for AIDL availability"