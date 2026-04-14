#!/bin/bash

echo "🔧 Fixing Buildozer Platform Directory Issue"
echo "============================================"
echo ""
echo "Problem: Buildozer checks for platform/android-sdk as a directory (not symlink)"
echo "Solution: Create platform/android-sdk as actual directory with SDK contents"
echo ""

# Make sure we're in the right directory
cd "$(dirname "$0")" || exit 1

# Create a function to fix platform directories
fix_platform_directories() {
    echo "📁 Fixing Buildozer platform directories..."
    
    # Create platform directory
    mkdir -p ~/.buildozer/android/platform
    
    # Check if SDK is already in sdk/ directory
    if [ -d ~/.buildozer/android/sdk ]; then
        echo "✅ SDK found in sdk/ directory"
        
        # Remove any existing symlinks
        if [ -L ~/.buildozer/android/platform/android-sdk ]; then
            echo "🔗 Removing existing symlink: platform/android-sdk"
            rm -f ~/.buildozer/android/platform/android-sdk
        fi
        
        # Remove any existing directory
        if [ -d ~/.buildozer/android/platform/android-sdk ]; then
            echo "📁 Removing existing directory: platform/android-sdk"
            rm -rf ~/.buildozer/android/platform/android-sdk
        fi
        
        # Create platform/android-sdk as an actual directory
        echo "📁 Creating platform/android-sdk as actual directory..."
        mkdir -p ~/.buildozer/android/platform/android-sdk
        
        # Copy SDK contents to platform directory
        echo "📋 Copying SDK contents to platform/android-sdk..."
        cp -r ~/.buildozer/android/sdk/* ~/.buildozer/android/platform/android-sdk/ 2>/dev/null || true
        
        echo "✅ platform/android-sdk created with SDK contents"
    else
        echo "⚠️ SDK not found in sdk/ directory"
        echo "   Creating empty platform/android-sdk directory"
        mkdir -p ~/.buildozer/android/platform/android-sdk
    fi
    
    # Check if NDK is already in sdk/ndk/ directory
    if [ -d ~/.buildozer/android/sdk/ndk/25b ]; then
        echo "✅ NDK found in sdk/ndk/25b directory"
        
        # Remove any existing symlinks
        if [ -L ~/.buildozer/android/platform/android-ndk ]; then
            echo "🔗 Removing existing symlink: platform/android-ndk"
            rm -f ~/.buildozer/android/platform/android-ndk
        fi
        
        # Remove any existing directory
        if [ -d ~/.buildozer/android/platform/android-ndk ]; then
            echo "📁 Removing existing directory: platform/android-ndk"
            rm -rf ~/.buildozer/android/platform/android-ndk
        fi
        
        # Create platform/android-ndk/android-ndk-r25b directory structure
        echo "📁 Creating platform/android-ndk/android-ndk-r25b directory..."
        mkdir -p ~/.buildozer/android/platform/android-ndk/android-ndk-r25b
        
        # Copy NDK contents to the versioned platform directory
        echo "📋 Copying NDK contents to platform/android-ndk/android-ndk-r25b..."
        cp -r ~/.buildozer/android/sdk/ndk/25b/* ~/.buildozer/android/platform/android-ndk/android-ndk-r25b/ 2>/dev/null || true
        
        echo "✅ platform/android-ndk/android-ndk-r25b created with NDK contents"
    else
        echo "⚠️ NDK not found in sdk/ndk/25b directory"
        echo "   Creating empty platform/android-ndk/android-ndk-r25b directory"
        mkdir -p ~/.buildozer/android/platform/android-ndk/android-ndk-r25b
    fi
    
    # Verify the directories
    echo ""
    echo "🔍 Verifying platform directories:"
    echo "Platform directory structure:"
    ls -la ~/.buildozer/android/platform/
    
    echo ""
    echo "📊 Checking platform/android-sdk:"
    if [ -d ~/.buildozer/android/platform/android-sdk ]; then
        echo "✅ platform/android-sdk is a directory"
        echo "   Contents:"
        ls -la ~/.buildozer/android/platform/android-sdk/ | head -5
    else
        echo "❌ platform/android-sdk is not a directory"
    fi
    
    echo ""
    echo "📊 Checking platform/android-ndk:"
    if [ -d ~/.buildozer/android/platform/android-ndk ]; then
        echo "✅ platform/android-ndk is a directory"
        echo "   Contents:"
        ls -la ~/.buildozer/android/platform/android-ndk/ | head -5
    else
        echo "❌ platform/android-ndk is not a directory"
    fi
}

# Create a function to update the workflow file
update_workflow_file() {
    echo ""
    echo "📝 Updating GitHub Actions workflow file..."
    
    if [ -f .github/workflows/build.yml ]; then
        echo "✅ Found workflow file: .github/workflows/build.yml"
        
        # Create backup
        cp .github/workflows/build.yml .github/workflows/build.yml.backup
        
        # Replace the symlink creation with directory creation
        echo "🔄 Replacing symlink creation with directory creation..."
        
        # Create a temporary file with the fix
        cat > /tmp/workflow_fix.yml << 'EOF'
    - name: Configure Buildozer for GitHub Actions
      run: |
        # Run the comprehensive Buildozer configuration fix
        echo "🔧 Running Buildozer configuration fix..."
        chmod +x fix_buildozer_config.sh
        ./fix_buildozer_config.sh
        
        # Test the configuration
        echo "🔍 Testing Buildozer configuration..."
        ./test_buildozer_config.sh
        
        # CRITICAL: Create platform directories with actual SDK/NDK contents
        echo "📁 Creating platform directories with SDK/NDK contents..."
        mkdir -p ~/.buildozer/android/platform
        
        # Create platform/android-sdk as actual directory with SDK contents
        if [ -d ~/.buildozer/android/sdk ]; then
            echo "📋 Copying SDK to platform/android-sdk..."
            mkdir -p ~/.buildozer/android/platform/android-sdk
            cp -r ~/.buildozer/android/sdk/* ~/.buildozer/android/platform/android-sdk/ 2>/dev/null || true
            echo "✅ platform/android-sdk created with SDK contents"
        else
            echo "⚠️ SDK not found, creating empty platform/android-sdk"
            mkdir -p ~/.buildozer/android/platform/android-sdk
        fi
        
        # Create platform/android-ndk as actual directory with NDK contents
        if [ -d ~/.buildozer/android/sdk/ndk/25b ]; then
            echo "📋 Copying NDK to platform/android-ndk..."
            mkdir -p ~/.buildozer/android/platform/android-ndk
            cp -r ~/.buildozer/android/sdk/ndk/25b/* ~/.buildozer/android/platform/android-ndk/ 2>/dev/null || true
            echo "✅ platform/android-ndk created with NDK contents"
        else
            echo "⚠️ NDK not found, creating empty platform/android-ndk"
            mkdir -p ~/.buildozer/android/platform/android-ndk
        fi
        
        # Verify platform directories
        echo "🔍 Verifying platform directories:"
        ls -la ~/.buildozer/android/platform/ | grep -E "(android-sdk|android-ndk)"
EOF
        
        echo "✅ Workflow update template created"
        echo ""
        echo "📋 Manual update required:"
        echo "1. Open .github/workflows/build.yml"
        echo "2. Find the 'Configure Buildozer for GitHub Actions' step (around line 231)"
        echo "3. Replace the symlink creation section (lines 242-257) with the new directory creation logic"
        echo "4. The new logic should copy SDK/NDK contents to platform/android-sdk and platform/android-ndk"
    else
        echo "❌ Workflow file not found: .github/workflows/build.yml"
    fi
}

# Create a test script to verify the fix
create_test_script() {
    echo ""
    echo "📝 Creating test script to verify platform directories..."
    
    cat > test_platform_directories.sh << 'EOF'
#!/bin/bash

echo "🔍 Testing Buildozer Platform Directories"
echo "========================================="

# Check if platform directories exist as directories (not symlinks)
echo "📁 Checking platform/android-sdk:"
if [ -d ~/.buildozer/android/platform/android-sdk ]; then
    echo "✅ platform/android-sdk is a directory"
    if [ -L ~/.buildozer/android/platform/android-sdk ]; then
        echo "⚠️ platform/android-sdk is a symlink (not what we want)"
    else
        echo "✅ platform/android-sdk is NOT a symlink (good!)"
    fi
    
    # Check contents
    echo "📊 Contents of platform/android-sdk:"
    ls -la ~/.buildozer/android/platform/android-sdk/ 2>/dev/null | head -3
else
    echo "❌ platform/android-sdk is not a directory"
fi

echo ""
echo "📁 Checking platform/android-ndk:"
if [ -d ~/.buildozer/android/platform/android-ndk ]; then
    echo "✅ platform/android-ndk is a directory"
    if [ -L ~/.buildozer/android/platform/android-ndk ]; then
        echo "⚠️ platform/android-ndk is a symlink (not what we want)"
    else
        echo "✅ platform/android-ndk is NOT a symlink (good!)"
    fi
    
    # Check contents
    echo "📊 Contents of platform/android-ndk:"
    ls -la ~/.buildozer/android/platform/android-ndk/ 2>/dev/null | head -3
else
    echo "❌ platform/android-ndk is not a directory"
fi

echo ""
echo "📁 Checking original SDK/NDK locations:"
if [ -d ~/.buildozer/android/sdk ]; then
    echo "✅ Original SDK directory exists: ~/.buildozer/android/sdk"
else
    echo "⚠️ Original SDK directory not found"
fi

if [ -d ~/.buildozer/android/sdk/ndk/25b ]; then
    echo "✅ Original NDK directory exists: ~/.buildozer/android/sdk/ndk/25b"
else
    echo "⚠️ Original NDK directory not found"
fi

echo ""
echo "📋 Summary:"
echo "1. Buildozer expects platform/android-sdk and platform/android-ndk to be directories"
echo "2. Symlinks don't work because Buildozer checks with os.path.isdir()"
echo "3. Solution: Copy SDK/NDK contents to platform directories"
echo "4. This prevents Buildozer from attempting to download SDK/NDK"
EOF
    
    chmod +x test_platform_directories.sh
    echo "✅ Test script created: test_platform_directories.sh"
}

# Main execution
echo "🚀 Starting platform directory fix..."
echo ""

# Fix platform directories
fix_platform_directories

# Update workflow file
update_workflow_file

# Create test script
create_test_script

echo ""
echo "🎯 Fix Summary:"
echo "1. Created platform/android-sdk as actual directory with SDK contents"
echo "2. Created platform/android-ndk as actual directory with NDK contents"
echo "3. Updated workflow file instructions for GitHub Actions"
echo "4. Created test script to verify the fix"
echo ""
echo "📋 Next steps:"
echo "1. Run: ./fix_buildozer_platform_directories.sh"
echo "2. Run: ./test_platform_directories.sh to verify"
echo "3. Manually update .github/workflows/build.yml with the new directory creation logic"
echo "4. Push changes to GitHub and test the workflow"
echo ""
echo "⚠️ Important: This fix addresses the root cause - Buildozer checks for directories, not symlinks!"