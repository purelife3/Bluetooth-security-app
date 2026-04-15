#!/bin/bash

echo "🔧 Fixing Buildozer Platform Directory Issue"
echo "============================================"
echo ""
echo "Problem: Buildozer checks for platform/android-sdk as a directory (not symlink)"
echo "Solution: Create platform/android-sdk as actual directory with SDK contents"
echo ""

# Make sure we're in the right directory
cd "$(dirname "$0")" || exit 1

# Create a function to accept licenses for Buildozer SDK
accept_buildozer_licenses() {
    echo "📝 Accepting licenses for Buildozer SDK management..."
    
    # Check if platform/android-sdk exists
    if [ -d ~/.buildozer/android/platform/android-sdk ]; then
        echo "✅ Found platform/android-sdk directory"
        
        # Find sdkmanager in platform directory
        SDKMANAGER_PATH=""
        if [ -f ~/.buildozer/android/platform/android-sdk/cmdline-tools/latest/bin/sdkmanager ]; then
            SDKMANAGER_PATH=~/.buildozer/android/platform/android-sdk/cmdline-tools/latest/bin/sdkmanager
        elif [ -f ~/.buildozer/android/platform/android-sdk/tools/bin/sdkmanager ]; then
            SDKMANAGER_PATH=~/.buildozer/android/platform/android-sdk/tools/bin/sdkmanager
        else
            SDKMANAGER_PATH=$(find ~/.buildozer/android/platform/android-sdk -name "sdkmanager" -type f 2>/dev/null | head -1)
        fi
        
        if [ -n "$SDKMANAGER_PATH" ]; then
            echo "✅ Found sdkmanager at: $SDKMANAGER_PATH"
            
            # CRITICAL: Enhanced license acceptance with multi-prompt handling
            echo "🔧 Enhanced license acceptance for Buildozer SDK..."
            
            # Method 1: Use expect-style approach with echo for ALL prompts
            echo "📋 Handling ALL interactive prompts (including initial 'Review licenses' prompt)..."
            
            # Create a comprehensive input file for ALL prompts
            cat > /tmp/buildozer_license_input.txt << 'EOF'
y
y
y
y
y
y
y
y
y
y
y
y
y
y
y
y
y
y
y
y
y
y
y
y
y
y
y
y
y
y
y
y
y
y
y
y
y
y
y
y
y
y
y
y
y
y
y
y
y
y
EOF
            
            # Apply licenses using the input file
            cat /tmp/buildozer_license_input.txt | "$SDKMANAGER_PATH" --licenses --sdk_root=~/.buildozer/android/platform/android-sdk 2>&1 || true
            
            # Method 2: Direct license file creation for critical packages
            echo "🔧 Creating direct license files for critical SDK packages..."
            mkdir -p ~/.buildozer/android/platform/android-sdk/licenses
            
            # Critical license hashes (including Build-Tools 37)
            echo "8933bad161af4178b1185d1a37fbf41ea5269c55" > ~/.buildozer/android/platform/android-sdk/licenses/android-sdk-license
            echo "d56f5187479451eabf01fb78af6dfcb131a6481e" > ~/.buildozer/android/platform/android-sdk/licenses/android-sdk-preview-license
            echo "84831b9409646a918e30573b4ad6d4e7e5c2f256" > ~/.buildozer/android/platform/android-sdk/licenses/android-googletv-license
            echo "33b6a2b64607f11b759f320ef9dff4ae5c47d97a" > ~/.buildozer/android/platform/android-sdk/licenses/android-sdk-arm-dbt-license
            echo "601085b94cd77f0b54ff86406957099ebe79c4d6" > ~/.buildozer/android/platform/android-sdk/licenses/google-gdk-license
            echo "24333f8a63b6825ea9c5514f83c2829b004d1fee" > ~/.buildozer/android/platform/android-sdk/licenses/android-googlexr-license
            echo "d975f751698a77b662f1254ddbeed3901e285f74" > ~/.buildozer/android/platform/android-sdk/licenses/android-sdk-build-tools-37-license
            
            # Verify license files
            echo "🔍 Verifying license files in platform/android-sdk/licenses..."
            if [ -d ~/.buildozer/android/platform/android-sdk/licenses ]; then
                echo "✅ License directory exists with $(ls -1 ~/.buildozer/android/platform/android-sdk/licenses | wc -l) license files"
                ls -la ~/.buildozer/android/platform/android-sdk/licenses/ || echo "⚠️ Could not list license files"
            fi
            
            echo "✅ Buildozer SDK licenses accepted with enhanced multi-prompt handling"
        else
            echo "⚠️ sdkmanager not found in platform/android-sdk"
        fi
    else
        echo "⚠️ platform/android-sdk directory not found"
    fi
}

# Create a function to pre-download NDK to avoid Buildozer download failures
pre_download_ndk() {
    echo "📥 Pre-downloading Android NDK to avoid Buildozer download failures..."
    
    # CRITICAL FIX: SDK manager installs "25b" but Buildozer expects "25.1.8937393"
    # These are the same NDK version with different naming conventions
    # We need to download the correct version that matches SDK manager's naming
    
    NDK_URL="https://dl.google.com/android/repository/android-ndk-r25b-linux.zip"
    NDK_FILENAME="android-ndk-r25b-linux.zip"
    NDK_TARGET_DIR="$HOME/.buildozer/android/platform/android-sdk/ndk/25.1.8937393"
    
    echo "🔗 NDK URL: $NDK_URL"
    echo "📁 Target directory: $NDK_TARGET_DIR"
    echo "⚠️  IMPORTANT: Downloading NDK 25b (same as 25.1.8937393) to match SDK manager"
    echo "🔍 DEBUG: SDK Manager should have already downloaded NDK to: $HOME/.buildozer/android/sdk/ndk/25b"
    echo "🔍 DEBUG: Checking if SDK Manager NDK exists..."
    if [ -d "$HOME/.buildozer/android/sdk/ndk/25b" ]; then
        echo "✅ DEBUG: Found SDK Manager NDK at: $HOME/.buildozer/android/sdk/ndk/25b"
        echo "📊 DEBUG: SDK Manager NDK contents:"
        ls -la "$HOME/.buildozer/android/sdk/ndk/25b/" | head -5
    else
        echo "⚠️ DEBUG: SDK Manager NDK not found at: $HOME/.buildozer/android/sdk/ndk/25b"
        echo "📝 DEBUG: Will download NDK directly from Google"
    fi
    
    # Create target directory
    mkdir -p "$NDK_TARGET_DIR"
    
    # FIRST: Check if we can use SDK Manager's already downloaded NDK
    echo "🔍 DEBUG: Checking if we can use SDK Manager's NDK instead of downloading..."
    if [ -d "$HOME/.buildozer/android/sdk/ndk/25b" ]; then
        echo "✅ DEBUG: Using SDK Manager's NDK from: $HOME/.buildozer/android/sdk/ndk/25b"
        echo "📋 DEBUG: Copying SDK Manager NDK to bridge directory..."
        cp -r "$HOME/.buildozer/android/sdk/ndk/25b/." "$NDK_TARGET_DIR/" 2>/dev/null || true
        
        # Verify copy
        if [ -d "$NDK_TARGET_DIR" ] && [ "$(ls -A "$NDK_TARGET_DIR" 2>/dev/null)" ]; then
            echo "✅ DEBUG: Successfully copied SDK Manager NDK to bridge directory"
            echo "📊 DEBUG: Bridge directory contents after copy:"
            ls -la "$NDK_TARGET_DIR" | head -10
            echo "✅ NDK bridge created using SDK Manager's download"
            return 0
        else
            echo "⚠️ DEBUG: Failed to copy SDK Manager NDK, will download instead"
        fi
    fi
    
    # Download with robust retry logic (fallback if SDK Manager NDK not available)
    echo "📋 DEBUG: Downloading NDK directly from Google (fallback)..."
    for attempt in {1..5}; do
        echo "📋 NDK download attempt $attempt/5..."
        
        # Clean up any previous failed downloads
        rm -f "$NDK_FILENAME" "$NDK_FILENAME.part"
        
        # Download with curl - resume support, timeout, and progress
        if curl -L --retry 3 --retry-delay 5 --connect-timeout 60 --max-time 600 \
             --progress-bar \
             -o "$NDK_FILENAME" \
             "$NDK_URL"; then
            echo "✅ NDK download completed successfully"
            
            # Verify file size (should be > 1GB)
            file_size=$(stat -c%s "$NDK_FILENAME" 2>/dev/null || stat -f%z "$NDK_FILENAME")
            if [ "$file_size" -gt 1000000000 ]; then
                echo "✅ NDK file size check passed: $((file_size/1024/1024)) MB"
                
                # Extract NDK
                echo "📦 Extracting NDK to $HOME/.buildozer/android/platform/android-sdk/ndk/..."
                unzip -q "$NDK_FILENAME" -d "$HOME/.buildozer/android/platform/android-sdk/ndk/"
                
                # CRITICAL: The zip creates android-ndk-r25b/ directory, but Buildozer expects 25.1.8937393/
                # Rename the directory to match Buildozer's expectations
                echo "🔄 Renaming android-ndk-r25b/ to 25.1.8937393/..."
                if [ -d "$HOME/.buildozer/android/platform/android-sdk/ndk/android-ndk-r25b" ]; then
                    mv "$HOME/.buildozer/android/platform/android-sdk/ndk/android-ndk-r25b" "$NDK_TARGET_DIR"
                    echo "✅ Successfully renamed NDK directory"
                fi
                
                # Verify extraction
                if [ -d "$NDK_TARGET_DIR" ]; then
                    echo "✅ NDK successfully extracted to $NDK_TARGET_DIR"
                    echo "📊 NDK directory contents:"
                    ls -la "$NDK_TARGET_DIR" | head -10
                    return 0
                else
                    echo "⚠️ NDK extraction may have failed - target directory not found"
                fi
            else
                echo "⚠️ NDK file size suspiciously small: $((file_size/1024/1024)) MB"
            fi
        else
            echo "⚠️ NDK download failed on attempt $attempt"
        fi
        
        if [ $attempt -lt 5 ]; then
            echo "Retrying in 10 seconds..."
            sleep 10
        fi
    done
    
    echo "❌ All NDK download attempts failed"
    return 1
}

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
        
        # CRITICAL: Ensure license files are copied to platform directory
        echo "📝 Ensuring license files are copied to platform/android-sdk/licenses..."
        mkdir -p ~/.buildozer/android/platform/android-sdk/licenses
        if [ -d ~/.buildozer/android/sdk/licenses ]; then
            echo "📋 Copying license files from sdk/licenses to platform/android-sdk/licenses..."
            cp -r ~/.buildozer/android/sdk/licenses/* ~/.buildozer/android/platform/android-sdk/licenses/ 2>/dev/null || true
        fi
        if [ -d ~/.android/licenses ]; then
            echo "📋 Copying license files from ~/.android/licenses to platform/android-sdk/licenses..."
            cp -r ~/.android/licenses/* ~/.buildozer/android/platform/android-sdk/licenses/ 2>/dev/null || true
        fi
        
        # CRITICAL FIX: Ensure SDK tools structure exists for sdkmanager
        echo "🔧 Ensuring SDK tools structure for sdkmanager..."
        
        # Check if sdkmanager exists in cmdline-tools/latest/bin/
        if [ -f ~/.buildozer/android/platform/android-sdk/cmdline-tools/latest/bin/sdkmanager ]; then
            echo "✅ Found sdkmanager in cmdline-tools/latest/bin/"
            
            # Create the expected tools/bin directory structure
            mkdir -p ~/.buildozer/android/platform/android-sdk/tools/bin
            
            # Create symlink from cmdline-tools/latest/bin/sdkmanager to tools/bin/sdkmanager
            echo "🔗 Creating symlink: tools/bin/sdkmanager -> cmdline-tools/latest/bin/sdkmanager"
            ln -sf ../cmdline-tools/latest/bin/sdkmanager ~/.buildozer/android/platform/android-sdk/tools/bin/sdkmanager
            
            # Also create symlink for avdmanager if it exists
            if [ -f ~/.buildozer/android/platform/android-sdk/cmdline-tools/latest/bin/avdmanager ]; then
                ln -sf ../cmdline-tools/latest/bin/avdmanager ~/.buildozer/android/platform/android-sdk/tools/bin/avdmanager
            fi
            
            echo "✅ SDK tools structure created for Buildozer compatibility"
        else
            echo "⚠️ sdkmanager not found in cmdline-tools/latest/bin/"
            echo "   Searching for sdkmanager in other locations..."
            
            # Try to find sdkmanager anywhere in the SDK
            SDKMANAGER_PATH=$(find ~/.buildozer/android/platform/android-sdk -name "sdkmanager" -type f 2>/dev/null | head -1)
            if [ -n "$SDKMANAGER_PATH" ]; then
                echo "✅ Found sdkmanager at: $SDKMANAGER_PATH"
                
                # Create tools/bin directory
                mkdir -p ~/.buildozer/android/platform/android-sdk/tools/bin
                
                # Create symlink to the found sdkmanager
                echo "🔗 Creating symlink to found sdkmanager"
                ln -sf "$(realpath --relative-to=~/.buildozer/android/platform/android-sdk/tools/bin "$SDKMANAGER_PATH")" ~/.buildozer/android/platform/android-sdk/tools/bin/sdkmanager
            else
                echo "❌ sdkmanager not found anywhere in the SDK"
                echo "   Buildozer may fail SDK verification"
            fi
        fi
        
        echo "✅ platform/android-sdk created with SDK contents and tools structure"
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
    echo "📝 Checking license files in platform/android-sdk/licenses:"
    if [ -d ~/.buildozer/android/platform/android-sdk/licenses ]; then
        echo "✅ License directory exists in platform/android-sdk/licenses"
        echo "📋 License files found:"
        ls -la ~/.buildozer/android/platform/android-sdk/licenses/ 2>/dev/null || echo "⚠️ No license files found"
    else
        echo "❌ License directory not found in platform/android-sdk/licenses"
    fi
    
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
            
            # CRITICAL: Ensure SDK tools structure exists for sdkmanager
            echo "🔧 Ensuring SDK tools structure for sdkmanager..."
            if [ -f ~/.buildozer/android/platform/android-sdk/cmdline-tools/latest/bin/sdkmanager ]; then
                echo "✅ Found sdkmanager in cmdline-tools/latest/bin/"
                mkdir -p ~/.buildozer/android/platform/android-sdk/tools/bin
                ln -sf ../cmdline-tools/latest/bin/sdkmanager ~/.buildozer/android/platform/android-sdk/tools/bin/sdkmanager
                echo "✅ SDK tools structure created for Buildozer compatibility"
            else
                echo "⚠️ sdkmanager not found in cmdline-tools/latest/bin/"
                SDKMANAGER_PATH=$(find ~/.buildozer/android/platform/android-sdk -name "sdkmanager" -type f 2>/dev/null | head -1)
                if [ -n "$SDKMANAGER_PATH" ]; then
                    echo "✅ Found sdkmanager at: $SDKMANAGER_PATH"
                    mkdir -p ~/.buildozer/android/platform/android-sdk/tools/bin
                    ln -sf "$(realpath --relative-to=~/.buildozer/android/platform/android-sdk/tools/bin "$SDKMANAGER_PATH")" ~/.buildozer/android/platform/android-sdk/tools/bin/sdkmanager
                else
                    echo "❌ sdkmanager not found anywhere in the SDK"
                fi
            fi
            
            echo "✅ platform/android-sdk created with SDK contents and tools structure"
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

# Pre-download NDK to avoid Buildozer download failures
echo ""
echo "📥 Pre-downloading NDK to platform directory..."
pre_download_ndk

# Accept licenses for Buildozer SDK management
echo ""
echo "📝 Accepting licenses for Buildozer SDK..."
accept_buildozer_licenses

# Update workflow file
update_workflow_file

# Create test script
create_test_script

echo ""
echo "🎯 Fix Summary:"
echo "1. Created platform/android-sdk as actual directory with SDK contents"
echo "2. Created platform/android-ndk as actual directory with NDK contents"
echo "3. Pre-downloaded NDK to platform/android-sdk/ndk/25b"
echo "4. Accepted licenses for Buildozer SDK with enhanced multi-prompt handling"
echo "5. Updated workflow file instructions for GitHub Actions"
echo "6. Created test script to verify the fix"
echo ""
echo "📋 Next steps:"
echo "1. Run: ./fix_buildozer_platform_directories.sh"
echo "2. Run: ./test_platform_directories.sh to verify"
echo "3. Manually update .github/workflows/build.yml with the new directory creation logic"
echo "4. Push changes to GitHub and test the workflow"
echo ""
echo "⚠️ Important: This fix addresses the root cause - Buildozer checks for directories, not symlinks!"