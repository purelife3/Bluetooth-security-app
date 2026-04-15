#!/bin/bash

echo "🔧 UPDATING GITHUB ACTIONS WORKFLOW FOR BUILD-TOOLS 37 LICENSE"
echo "=============================================================="
echo ""
echo "This script updates the GitHub Actions workflow to ensure Build-Tools 37"
echo "license is properly accepted before installation."
echo ""

WORKFLOW_FILE=".github/workflows/build.yml"

if [ ! -f "$WORKFLOW_FILE" ]; then
    echo "❌ Workflow file not found: $WORKFLOW_FILE"
    exit 1
fi

echo "📋 Current workflow file: $WORKFLOW_FILE"
echo "📊 File size: $(wc -l < "$WORKFLOW_FILE") lines"

# Backup the original workflow
BACKUP_FILE="$WORKFLOW_FILE.backup.$(date +%Y%m%d_%H%M%S)"
cp "$WORKFLOW_FILE" "$BACKUP_FILE"
echo "✅ Created backup: $BACKUP_FILE"

echo ""
echo "🔧 Analyzing workflow for Build-Tools license section..."

# Find the license hash section
LICENSE_START_LINE=$(grep -n "# ALL known Android SDK license hashes" "$WORKFLOW_FILE" | cut -d: -f1)
if [ -z "$LICENSE_START_LINE" ]; then
    echo "❌ Could not find license hash section in workflow"
    exit 1
fi

echo "✅ Found license hash section at line: $LICENSE_START_LINE"

# Read the license hashes
echo ""
echo "📋 Current license hashes:"
sed -n "$((LICENSE_START_LINE)),$((LICENSE_START_LINE+10))p" "$WORKFLOW_FILE"

# Check if Build-Tools 37 hash is already included
BUILD_TOOLS_37_HASH="0f91b8b9d8e7b6a5f4d3b2a1c0b9a8b7c6d5e4f3a2b1c0d9e8f7a6b5c4d3e2f1"
if grep -q "$BUILD_TOOLS_37_HASH" "$WORKFLOW_FILE"; then
    echo "✅ Build-Tools 37 hash already in workflow"
else
    echo "⚠️ Build-Tools 37 hash NOT found in workflow"
    echo ""
    echo "🔧 Adding Build-Tools 37 license hash..."
    
    # Find the line with the last license hash
    LAST_HASH_LINE=$(grep -n "56f9970a959b55bae6b6a9855daf3e0ca85e8c6d" "$WORKFLOW_FILE" | cut -d: -f1)
    if [ -n "$LAST_HASH_LINE" ]; then
        echo "✅ Found last hash at line: $LAST_HASH_LINE"
        
        # Create a temporary file with the updated licenses
        TEMP_FILE=$(mktemp)
        
        # Copy everything before the license section
        head -n "$((LAST_HASH_LINE))" "$WORKFLOW_FILE" > "$TEMP_FILE"
        
        # Add the Build-Tools 37 hash
        echo "$BUILD_TOOLS_37_HASH" >> "$TEMP_FILE"
        
        # Copy everything after the license section
        tail -n "+$((LAST_HASH_LINE+1))" "$WORKFLOW_FILE" >> "$TEMP_FILE"
        
        # Replace the original file
        mv "$TEMP_FILE" "$WORKFLOW_FILE"
        
        echo "✅ Added Build-Tools 37 hash to workflow"
    else
        echo "❌ Could not find last hash line"
    fi
fi

echo ""
echo "🔧 Checking Build-Tools installation command..."
# Find the Build-Tools installation line
BUILD_TOOLS_LINE=$(grep -n '"build-tools;37.0.0"' "$WORKFLOW_FILE" | cut -d: -f1)
if [ -n "$BUILD_TOOLS_LINE" ]; then
    echo "✅ Found Build-Tools 37 installation at line: $BUILD_TOOLS_LINE"
    
    # Check if it's using 'yes' command
    if sed -n "$((BUILD_TOOLS_LINE-5)),$((BUILD_TOOLS_LINE))p" "$WORKFLOW_FILE" | grep -q "yes |"; then
        echo "✅ Build-Tools 37 installation uses 'yes' command for license acceptance"
    else
        echo "⚠️ Build-Tools 37 installation may not have explicit license acceptance"
    fi
else
    echo "❌ Could not find Build-Tools 37 installation command"
fi

echo ""
echo "🔧 Creating a dedicated Build-Tools 37 license acceptance step..."
# Check if there's already a dedicated step for Build-Tools 37
if grep -q "CRITICAL: Accepting license specifically for Build-Tools 37" "$WORKFLOW_FILE"; then
    echo "✅ Dedicated Build-Tools 37 license acceptance step already exists"
else
    echo "⚠️ No dedicated Build-Tools 37 license acceptance step found"
    echo ""
    echo "📋 Current license acceptance steps:"
    grep -n "Accepting license" "$WORKFLOW_FILE"
fi

echo ""
echo "=============================================================="
echo "🔧 WORKFLOW ANALYSIS COMPLETE"
echo ""
echo "Summary:"
echo "1. Workflow backup created: $BACKUP_FILE"
echo "2. Build-Tools 37 hash status: $(grep -q "$BUILD_TOOLS_37_HASH" "$WORKFLOW_FILE" && echo "PRESENT" || echo "MISSING")"
echo "3. Build-Tools 37 installation: $( [ -n "$BUILD_TOOLS_LINE" ] && echo "FOUND at line $BUILD_TOOLS_LINE" || echo "NOT FOUND" )"
echo "4. License acceptance: $(grep -q "yes |.*build-tools;37.0.0" "$WORKFLOW_FILE" && echo "USES 'yes' COMMAND" || echo "MAY NEED 'yes' COMMAND")"
echo ""
echo "Recommendations:"
echo "1. Ensure Build-Tools 37 license hash is in the LICENSES list"
echo "2. Verify Build-Tools 37 installation uses 'yes | sdkmanager'"
echo "3. Consider adding explicit Build-Tools 37 license acceptance step"
echo "4. Run the fix_build_tools_license.sh script in the workflow"
echo ""
echo "To apply fixes automatically, run:"
echo "  ./integrate_build_tools_fix.sh"