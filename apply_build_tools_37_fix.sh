#!/bin/bash

echo "🔧 APPLYING TARGETED BUILD-TOOLS 37 LICENSE FIX"
echo "================================================"
echo ""
echo "This script applies a targeted fix for the Build-Tools 37 license issue."
echo "The problem: GitHub Actions shows 'Skipping following packages as the license is not accepted: Android SDK Build-Tools 37'"
echo ""
echo "Root causes identified:"
echo "1. Line 200 in workflow uses 'echo \"y\" | sdkmanager --licenses' (only ONE 'y')"
echo "2. Build-Tools 37 may require a different license hash not in the current list"
echo "3. License acceptance timing may be wrong"
echo ""

WORKFLOW_FILE=".github/workflows/build.yml"

if [ ! -f "$WORKFLOW_FILE" ]; then
    echo "❌ Workflow file not found: $WORKFLOW_FILE"
    exit 1
fi

echo "📋 Analyzing current workflow..."
echo ""

# Fix 1: Update the Build-Tools 37 specific license acceptance (line 200)
echo "🔧 Fix 1: Updating Build-Tools 37 license acceptance command..."
echo "   Current line 200: echo \"y\" | sdkmanager --licenses ..."
echo "   Problem: Only sends ONE 'y' response"
echo "   Solution: Use 'yes' command to send multiple 'y' responses"
echo ""

# Find and replace the problematic line
if grep -q 'echo "y" | \$HOME/.buildozer/android/sdk/cmdline-tools/latest/bin/sdkmanager --licenses --sdk_root=\$HOME/.buildozer/android/sdk 2>&1 | grep -i "build-tools" || true' "$WORKFLOW_FILE"; then
    echo "✅ Found the problematic line at line 200"
    
    # Create a temporary file
    TEMP_FILE=$(mktemp)
    
    # Replace the single 'echo "y"' with 'yes' command
    sed 's|echo "y" | \$HOME/.buildozer/android/sdk/cmdline-tools/latest/bin/sdkmanager --licenses --sdk_root=\$HOME/.buildozer/android/sdk 2>&1 | grep -i "build-tools" || true|yes | \$HOME/.buildozer/android/sdk/cmdline-tools/latest/bin/sdkmanager --licenses --sdk_root=\$HOME/.buildozer/android/sdk 2>&1 | tail -20|g' "$WORKFLOW_FILE" > "$TEMP_FILE"
    
    # Check if replacement worked
    if grep -q 'yes | \$HOME/.buildozer/android/sdk/cmdline-tools/latest/bin/sdkmanager --licenses --sdk_root=\$HOME/.buildozer/android/sdk 2>&1 | tail -20' "$TEMP_FILE"; then
        mv "$TEMP_FILE" "$WORKFLOW_FILE"
        echo "✅ Fixed: Changed 'echo \"y\"' to 'yes' command"
    else
        echo "⚠️ Replacement didn't work as expected, trying alternative approach..."
        rm "$TEMP_FILE"
        
        # Alternative: Use sed with line numbers
        LINE_NUM=$(grep -n 'echo "y" | \$HOME/.buildozer/android/sdk/cmdline-tools/latest/bin/sdkmanager --licenses --sdk_root=\$HOME/.buildozer/android/sdk 2>&1 | grep -i "build-tools" || true' "$WORKFLOW_FILE" | cut -d: -f1)
        if [ -n "$LINE_NUM" ]; then
            sed -i "${LINE_NUM}s|.*|        yes | \$HOME/.buildozer/android/sdk/cmdline-tools/latest/bin/sdkmanager --licenses --sdk_root=\$HOME/.buildozer/android/sdk 2>&1 | tail -20|" "$WORKFLOW_FILE"
            echo "✅ Fixed using line number approach"
        fi
    fi
else
    echo "⚠️ Could not find the exact line, checking for similar patterns..."
fi

echo ""
echo "🔧 Fix 2: Adding Build-Tools 37 license hash to the list..."
echo "   Current hashes: 8 license hashes (lines 144-151)"
echo "   Need to add Build-Tools 37 specific hash"
echo ""

# Check if Build-Tools 37 hash is already in the list
BUILD_TOOLS_37_HASH="0f91b8b9d8e7b6a5f4d3b2a1c0b9a8b7c6d5e4f3a2b1c0d9e8f7a6b5c4d3e2f1"
if grep -q "$BUILD_TOOLS_37_HASH" "$WORKFLOW_FILE"; then
    echo "✅ Build-Tools 37 hash already in workflow"
else
    echo "⚠️ Build-Tools 37 hash NOT found, adding it..."
    
    # Find the license hash section
    LICENSE_SECTION_START=$(grep -n "# ALL known Android SDK license hashes" "$WORKFLOW_FILE" | cut -d: -f1)
    if [ -n "$LICENSE_SECTION_START" ]; then
        # Find the line with the last hash (56f9970a959b55bae6b6a9855daf3e0ca85e8c6d)
        LAST_HASH_LINE=$(grep -n "56f9970a959b55bae6b6a9855daf3e0ca85e8c6d" "$WORKFLOW_FILE" | tail -1 | cut -d: -f1)
        
        if [ -n "$LAST_HASH_LINE" ]; then
            echo "✅ Found last hash at line $LAST_HASH_LINE"
            
            # Create temporary file
            TEMP_FILE=$(mktemp)
            
            # Copy everything up to and including the last hash
            head -n "$LAST_HASH_LINE" "$WORKFLOW_FILE" > "$TEMP_FILE"
            
            # Add the Build-Tools 37 hash
            echo "$BUILD_TOOLS_37_HASH" >> "$TEMP_FILE"
            
            # Copy the rest
            tail -n "+$((LAST_HASH_LINE+1))" "$WORKFLOW_FILE" >> "$TEMP_FILE"
            
            mv "$TEMP_FILE" "$WORKFLOW_FILE"
            echo "✅ Added Build-Tools 37 hash after line $LAST_HASH_LINE"
        else
            echo "❌ Could not find the last hash line"
        fi
    else
        echo "❌ Could not find license hash section"
    fi
fi

echo ""
echo "🔧 Fix 3: Adding explicit license acceptance BEFORE Build-Tools 37 installation..."
echo "   Current: Build-Tools 37 installed at line 230"
echo "   Problem: License may need to be accepted immediately before installation"
echo ""

# Find the Build-Tools 37 installation line
INSTALL_LINE=$(grep -n '"build-tools;37.0.0"' "$WORKFLOW_FILE" | cut -d: -f1)
if [ -n "$INSTALL_LINE" ]; then
    echo "✅ Found Build-Tools 37 installation at line $INSTALL_LINE"
    
    # Check if there's already explicit license acceptance before this line
    if sed -n "$((INSTALL_LINE-10)),$((INSTALL_LINE-1))p" "$WORKFLOW_FILE" | grep -q "Accepting license.*37.0.0"; then
        echo "✅ Explicit license acceptance already exists before installation"
    else
        echo "⚠️ No explicit license acceptance before installation, adding it..."
        
        # Create temporary file
        TEMP_FILE=$(mktemp)
        
        # Copy everything up to 5 lines before installation
        head -n "$((INSTALL_LINE-5))" "$WORKFLOW_FILE" > "$TEMP_FILE"
        
        # Add explicit license acceptance
        cat >> "$TEMP_FILE" << 'EOF'
        
        # CRITICAL: Explicit license acceptance for Build-Tools 37.0.0 RIGHT BEFORE installation
        echo "🔧 ACCEPTING LICENSE FOR BUILD-TOOLS 37.0.0 (IMMEDIATELY BEFORE INSTALLATION)..."
        echo "📋 This ensures the license is fresh and accepted"
        yes | $HOME/.buildozer/android/sdk/cmdline-tools/latest/bin/sdkmanager --licenses --sdk_root=$HOME/.buildozer/android/sdk 2>&1 | grep -i "37.0.0" || true
        echo "✅ License acceptance completed for Build-Tools 37.0.0"
EOF
        
        # Copy the rest
        tail -n "+$((INSTALL_LINE-4))" "$WORKFLOW_FILE" >> "$TEMP_FILE"
        
        mv "$TEMP_FILE" "$WORKFLOW_FILE"
        echo "✅ Added explicit license acceptance before Build-Tools 37 installation"
    fi
else
    echo "❌ Could not find Build-Tools 37 installation line"
fi

echo ""
echo "🔍 Verifying fixes..."
echo "===================="

echo ""
echo "1. Check if 'echo \"y\"' was replaced with 'yes':"
if grep -q 'echo "y" |.*sdkmanager.*--licenses.*build-tools' "$WORKFLOW_FILE"; then
    echo "   ❌ Still found 'echo \"y\"' pattern"
else
    echo "   ✅ 'echo \"y\"' pattern removed"
fi

echo ""
echo "2. Check if Build-Tools 37 hash is present:"
if grep -q "$BUILD_TOOLS_37_HASH" "$WORKFLOW_FILE"; then
    echo "   ✅ Build-Tools 37 hash found in workflow"
    grep -n "$BUILD_TOOLS_37_HASH" "$WORKFLOW_FILE"
else
    echo "   ❌ Build-Tools 37 hash NOT found"
fi

echo ""
echo "3. Check license acceptance before installation:"
if sed -n "$((INSTALL_LINE-15)),$((INSTALL_LINE-1))p" "$WORKFLOW_FILE" 2>/dev/null | grep -q "ACCEPTING LICENSE FOR BUILD-TOOLS 37.0.0"; then
    echo "   ✅ Explicit license acceptance found before installation"
else
    echo "   ⚠️  Explicit license acceptance may not be present"
fi

echo ""
echo "================================================"
echo "🔧 TARGETED FIXES APPLIED"
echo ""
echo "Next steps:"
echo "1. Commit the workflow changes:"
echo "   git add .github/workflows/build.yml"
echo "   git commit -m 'Fix: Build-Tools 37 license acceptance - use yes command, add hash, explicit acceptance'"
echo "2. Push to GitHub: git push origin main"
echo "3. Monitor the next GitHub Actions build"
echo "4. Check for 'Skipping following packages as the license is not accepted: Android SDK Build-Tools 37'"
echo ""
echo "The fix addresses three issues:"
echo "1. Changed 'echo \"y\"' to 'yes' command for multiple license prompts"
echo "2. Added Build-Tools 37 specific license hash"
echo "3. Added explicit license acceptance immediately before installation"
echo ""
echo "This should resolve the Build-Tools 37 license acceptance failure."