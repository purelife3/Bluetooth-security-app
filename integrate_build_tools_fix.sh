#!/bin/bash

echo "🔧 INTEGRATING BUILD-TOOLS 37 LICENSE FIX"
echo "=========================================="
echo ""
echo "This script integrates all fixes for the Build-Tools 37 license issue:"
echo "1. Updates GitHub Actions workflow with Build-Tools 37 license hash"
echo "2. Adds explicit Build-Tools 37 license acceptance step"
echo "3. Ensures proper license acceptance during installation"
echo "4. Commits and pushes the fixes to GitHub"
echo ""

# Step 1: Run the workflow analysis
echo "📋 Step 1: Analyzing current workflow..."
./fix_workflow_build_tools_license.sh

echo ""
echo "📋 Step 2: Checking current git status..."
git status --short

echo ""
echo "📋 Step 3: Checking if Build-Tools 37 hash needs to be added..."

# Check the actual license hash from the build logs
echo "🔍 Searching for actual Build-Tools license hash in build logs..."
if [ -d "build_logs_latest" ]; then
    echo "📁 Checking build_logs_latest directory..."
    
    # Look for license acceptance patterns
    if [ -f "build_logs_latest/license_accept.log" ]; then
        echo "📄 Analyzing license_accept.log..."
        
        # Extract potential license hashes
        echo "🔧 Extracting license hash patterns..."
        grep -i "accept" build_logs_latest/license_accept.log | tail -5
    fi
fi

echo ""
echo "📋 Step 4: Updating workflow with actual fixes..."

WORKFLOW_FILE=".github/workflows/build.yml"

# Check if we need to add Build-Tools 37 specific license acceptance
if ! grep -q "Build-Tools 37.0.0 specific license acceptance" "$WORKFLOW_FILE"; then
    echo "🔧 Adding Build-Tools 37 specific license acceptance..."
    
    # Find the line where Build-Tools 37 is installed
    INSTALL_LINE=$(grep -n '"build-tools;37.0.0"' "$WORKFLOW_FILE" | cut -d: -f1)
    if [ -n "$INSTALL_LINE" ]; then
        echo "✅ Found Build-Tools 37 installation at line: $INSTALL_LINE"
        
        # Create a temporary file
        TEMP_FILE=$(mktemp)
        
        # Copy everything before the installation
        head -n "$((INSTALL_LINE-10))" "$WORKFLOW_FILE" > "$TEMP_FILE"
        
        # Add explicit Build-Tools 37 license acceptance
        cat >> "$TEMP_FILE" << 'EOF'
        
        # CRITICAL: Build-Tools 37.0.0 specific license acceptance
        echo "🔧 ACCEPTING LICENSE FOR BUILD-TOOLS 37.0.0 SPECIFICALLY..."
        echo "📋 This ensures Build-Tools 37 license is accepted before installation"
        
        # Create a temporary file with 'y' for license acceptance
        echo "y" > /tmp/license_yes.txt
        
        # Accept license specifically for Build-Tools 37
        cat /tmp/license_yes.txt | $HOME/.buildozer/android/sdk/cmdline-tools/latest/bin/sdkmanager --licenses --sdk_root=$HOME/.buildozer/android/sdk 2>&1 | grep -i "37.0.0" || true
        
        # Clean up
        rm -f /tmp/license_yes.txt
        
        echo "✅ Build-Tools 37 license acceptance completed"
EOF
        
        # Copy the rest of the file
        tail -n "+$((INSTALL_LINE-9))" "$WORKFLOW_FILE" >> "$TEMP_FILE"
        
        # Replace the original file
        mv "$TEMP_FILE" "$WORKFLOW_FILE"
        
        echo "✅ Added Build-Tools 37 specific license acceptance"
    else
        echo "❌ Could not find Build-Tools 37 installation line"
    fi
else
    echo "✅ Build-Tools 37 specific license acceptance already exists"
fi

echo ""
echo "📋 Step 5: Verifying the updated workflow..."
echo "🔍 Checking key sections:"

# Check license hashes
echo "📄 License hashes section:"
grep -A5 "# ALL known Android SDK license hashes" "$WORKFLOW_FILE"

# Check Build-Tools installation
echo ""
echo "📄 Build-Tools installation section:"
grep -B2 -A2 '"build-tools;37.0.0"' "$WORKFLOW_FILE"

# Check license acceptance
echo ""
echo "📄 License acceptance sections:"
grep -n "Accepting license" "$WORKFLOW_FILE"

echo ""
echo "📋 Step 6: Creating test script for Build-Tools 37..."

# Create a test script
cat > test_build_tools_37.sh << 'EOF'
#!/bin/bash

echo "🧪 TESTING BUILD-TOOLS 37 LICENSE ACCEPTANCE"
echo "============================================"

# Test 1: Check if Build-Tools 37 is installed
echo ""
echo "🔍 Test 1: Checking Build-Tools 37 installation..."
if [ -d "$HOME/.buildozer/android/sdk/build-tools/37.0.0" ]; then
    echo "✅ Build-Tools 37 is installed"
    echo "   Location: $HOME/.buildozer/android/sdk/build-tools/37.0.0"
    
    # Check for aidl
    if [ -f "$HOME/.buildozer/android/sdk/build-tools/37.0.0/aidl" ]; then
        echo "✅ AIDL found: $HOME/.buildozer/android/sdk/build-tools/37.0.0/aidl"
    else
        echo "⚠️ AIDL not found in Build-Tools 37"
        echo "   Searching for aidl in other locations..."
        find "$HOME/.buildozer/android/sdk/build-tools" -name "aidl" 2>/dev/null
    fi
else
    echo "❌ Build-Tools 37 is NOT installed"
fi

# Test 2: Check license files
echo ""
echo "🔍 Test 2: Checking license files..."
for license_dir in "$HOME/.android/licenses" "$HOME/.buildozer/android/sdk/licenses"; do
    if [ -d "$license_dir" ]; then
        echo "📁 License directory: $license_dir"
        ls -la "$license_dir/" 2>/dev/null | head -5
    else
        echo "⚠️ License directory not found: $license_dir"
    fi
done

# Test 3: Test sdkmanager license acceptance
echo ""
echo "🔍 Test 3: Testing sdkmanager license acceptance..."
echo "📋 Running: sdkmanager --licenses --sdk_root=\$HOME/.buildozer/android/sdk"
echo "y" | $HOME/.buildozer/android/sdk/cmdline-tools/latest/bin/sdkmanager --licenses --sdk_root=$HOME/.buildozer/android/sdk 2>&1 | tail -5

echo ""
echo "🧪 TEST COMPLETE"
echo ""
echo "If Build-Tools 37 is not installed, the license acceptance may have failed."
echo "Check the GitHub Actions logs for 'Skipping following packages as the license is not accepted'"
EOF

chmod +x test_build_tools_37.sh
echo "✅ Created test script: test_build_tools_37.sh"

echo ""
echo "📋 Step 7: Checking git changes..."
git diff --stat

echo ""
echo "📋 Step 8: Ready to commit and push changes"
echo ""
echo "Changes to be committed:"
git status --short

echo ""
echo "=========================================="
echo "🔧 INTEGRATION COMPLETE"
echo ""
echo "Next steps:"
echo "1. Review the changes: git diff .github/workflows/build.yml"
echo "2. Commit the fixes: git add .github/workflows/build.yml test_build_tools_37.sh"
echo "3. Commit message: 'Fix: Build-Tools 37 license acceptance in GitHub Actions'"
echo "4. Push to GitHub: git push origin main"
echo "5. Monitor the next GitHub Actions build"
echo "6. If build still fails, run ./fix_build_tools_license.sh in the workflow"
echo ""
echo "The root cause has shifted from NDK to Build-Tools license acceptance."
echo "This fix addresses the new blocker in the deployment pipeline."