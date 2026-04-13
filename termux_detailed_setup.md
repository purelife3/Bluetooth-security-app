# Termux Detailed Setup Guide for Building APK on Android

## 📱 Prerequisites for Motorola Android 15

### 1. Device Requirements
- **Android Version**: Android 15 (SDK 35) - Compatible
- **Storage**: Minimum 10GB free space (SDK/NDK are large)
- **RAM**: 3.39GB available - Sufficient for compilation
- **Battery**: >50% recommended (builds take 30-60 minutes)

### 2. Termux Installation (CRITICAL)
**DO NOT install from Google Play Store** - Those versions are outdated and broken.

**Correct Installation Method:**
1. **Install F-Droid** (app store for open-source apps):
   - Visit https://f-droid.org/ in your browser
   - Download and install F-Droid APK
   - Open F-Droid and update repositories

2. **Install Termux from F-Droid**:
   - Search for "Termux" in F-Droid
   - Install "Termux" (by Fredrik Fornwall)
   - Version should be ≥ 0.118.0

3. **Install Termux:API** (optional but recommended):
   - Also install "Termux:API" from F-Droid
   - This provides access to Android APIs

### 3. Initial Termux Setup

**First Launch Configuration:**
```bash
# Update package lists
pkg update

# Upgrade existing packages
pkg upgrade

# Install essential tools
pkg install -y python python-pip git wget curl nano

# Install build essentials
pkg install -y clang make cmake pkg-config

# Install Java (required for Android SDK)
pkg install -y openjdk-17

# Verify installations
python --version  # Should show Python 3.11+
java --version    # Should show OpenJDK 17
git --version     # Should show git version
```

### 4. Storage Permissions Setup

**Android 15 requires explicit storage access:**

```bash
# Grant storage permission
termux-setup-storage

# This will show a popup - ALLOW access
# Creates ~/storage directory with symlinks:
# ~/storage/shared/ = /sdcard/
# ~/storage/downloads/ = /sdcard/Download/
# ~/storage/dcim/ = /sdcard/DCIM/
# ~/storage/pictures/ = /sdcard/Pictures/
# ~/storage/music/ = /sdcard/Music/
# ~/storage/movies/ = /sdcard/Movies/
```

**Verify storage access:**
```bash
ls ~/storage/shared/
# Should show your /sdcard contents
```

### 5. Project Setup in Termux

**Copy your project to Termux home:**
```bash
# Navigate to home
cd ~

# Create project directory
mkdir -p projects/bluetooth_manager
cd projects/bluetooth_manager

# Copy from /sdcard to Termux
cp -r /sdcard/Documents/BluetoothManager/* .
# OR if your files are elsewhere:
# cp -r ~/storage/shared/Documents/BluetoothManager/* .

# Verify files
ls -la
# Should show: main.py, bluetooth.kv, requirements.txt, etc.
```

### 6. Python Virtual Environment Setup

**Create isolated Python environment:**
```bash
# Install virtualenv
pip install virtualenv

# Create virtual environment
python -m venv venv

# Activate virtual environment
source venv/bin/activate

# Your prompt should change to (venv)
```

### 7. Install Python Dependencies

**Install required packages:**
```bash
# Upgrade pip
pip install --upgrade pip

# Install Kivy and dependencies
pip install kivy[base] kivy_examples

# Install Bleak for Bluetooth
pip install bleak

# Install other dependencies from requirements.txt
pip install -r requirements.txt

# Test Kivy installation
python -c "import kivy; print(f'Kivy version: {kivy.__version__}')"
python -c "import bleak; print('Bleak imported successfully')"
```

### 8. Android SDK/NDK Installation (ARM64)

**This is the most critical and complex part:**

```bash
# Create Android SDK directory
mkdir -p ~/android-sdk
cd ~/android-sdk

# Download command-line tools (ARM64 compatible)
wget https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip

# Extract tools
unzip commandlinetools-linux-9477386_latest.zip

# Create proper SDK directory structure
mkdir -p cmdline-tools/latest
mv cmdline-tools/* cmdline-tools/latest/
rmdir cmdline-tools/* 2>/dev/null || true

# Set environment variables
export ANDROID_SDK_ROOT=~/android-sdk
export PATH=$PATH:$ANDROID_SDK_ROOT/cmdline-tools/latest/bin

# Accept licenses
yes | sdkmanager --licenses

# Install required SDK packages
sdkmanager "platform-tools" "platforms;android-33" "build-tools;33.0.0"

# Install NDK (ARM64 version)
# Note: This is ~2GB download
wget https://dl.google.com/android/repository/android-ndk-r25c-linux.zip
unzip android-ndk-r25c-linux.zip
export ANDROID_NDK_HOME=~/android-sdk/android-ndk-r25c

# Verify installations
ls $ANDROID_SDK_ROOT/platform-tools/adb
ls $ANDROID_NDK_HOME/ndk-build
```

### 9. Buildozer Installation in Termux

**Install Buildozer in virtual environment:**
```bash
# Make sure virtual environment is active
source ~/projects/bluetooth_manager/venv/bin/activate

# Install Buildozer
pip install buildozer==1.5.0

# Install Cython (required for compilation)
pip install cython==0.29.33

# Initialize Buildozer
cd ~/projects/bluetooth_manager
buildozer init

# Edit buildozer.spec if needed
nano buildozer.spec
```

**Key buildozer.spec modifications for Termux:**
```
# Change these lines:
android.ndk = 25c
android.sdk = 33
android.ndk_path = /data/data/com.termux/files/home/android-sdk/android-ndk-r25c
android.sdk_path = /data/data/com.termux/files/home/android-sdk

# Set target API to match your device
android.api = 33
android.minapi = 21
```

### 10. Build Configuration for ARM64

**Create build configuration script:**
```bash
cat > build_config.sh << 'EOF'
#!/data/data/com.termux/files/usr/bin/bash

# Set environment variables
export ANDROID_SDK_ROOT=~/android-sdk
export ANDROID_NDK_HOME=~/android-sdk/android-ndk-r25c
export PATH=$PATH:$ANDROID_SDK_ROOT/cmdline-tools/latest/bin
export PATH=$PATH:$ANDROID_SDK_ROOT/platform-tools

# Activate virtual environment
source ~/projects/bluetooth_manager/venv/bin/activate

# Navigate to project
cd ~/projects/bluetooth_manager

# Clean previous builds
buildozer android clean

# Start debug build
buildozer -v android debug
EOF

chmod +x build_config.sh
```

### 11. First Build Attempt

**Run the build:**
```bash
# Execute build script
./build_config.sh

# OR run directly
buildozer -v android debug
```

**Expected output:**
- Downloading dependencies (takes 10-20 minutes)
- Compiling Python extensions
- Building APK (takes 15-30 minutes)
- APK generated at: `bin/YourApp-0.1-debug.apk`

### 12. Troubleshooting Common Issues

**Issue 1: "No space left on device"**
```bash
# Check available space
df -h /data

# Clean Termux cache
pkg clean

# Remove old downloads
rm -rf ~/android-sdk/*.zip
```

**Issue 2: "Permission denied" for SDK**
```bash
# Fix permissions
chmod -R 755 ~/android-sdk
chmod +x ~/android-sdk/cmdline-tools/latest/bin/*
```

**Issue 3: Buildozer fails with Cython error**
```bash
# Reinstall specific Cython version
pip uninstall cython -y
pip install cython==0.29.33
```

**Issue 4: "NDK not found"**
```bash
# Verify NDK path
ls $ANDROID_NDK_HOME

# Update buildozer.spec with correct path
# android.ndk_path = /data/data/com.termux/files/home/android-sdk/android-ndk-r25c
```

### 13. Optimizing Build Process

**Reduce build time:**
```bash
# Skip downloading each time (after first successful build)
# Edit buildozer.spec:
# android.skip_update = True

# Use parallel compilation
# Add to buildozer.spec:
# android.num_cores = 4
```

**Monitor build progress:**
```bash
# Watch build logs
tail -f .buildozer/android/platform/build-*/build.output

# Check specific errors
grep -i "error\|fail\|warning" .buildozer/android/platform/build-*/build.output
```

### 14. Testing the APK

**Transfer APK to device:**
```bash
# Copy APK to /sdcard
cp bin/*.apk ~/storage/shared/Download/

# Install via ADB (if USB debugging enabled)
adb install bin/*.apk

# OR install directly on device
# Navigate to /sdcard/Download/ and tap the APK
```

### 15. Maintenance Commands

**Update Termux packages:**
```bash
pkg update && pkg upgrade
```

**Update Python packages:**
```bash
source venv/bin/activate
pip list --outdated
pip install --upgrade kivy buildozer
```

**Clean build artifacts:**
```bash
buildozer android clean
rm -rf .buildozer/bin
rm -rf .buildozer/android/platform/build-*
```

### 16. Alternative: Python-for-Android (P4A) Direct Build

**If Buildozer fails, try P4A directly:**
```bash
# Install p4a
pip install python-for-android

# Build with p4a
p4a apk --requirements=python3,kivy,bleak \
        --private . \
        --package=com.yourcompany.bluetoothmanager \
        --name="Bluetooth Manager" \
        --version=0.1 \
        --bootstrap=sdl2 \
        --orientation=portrait
```

### 17. Important Notes for Android 15

1. **Storage Access**: Android 15 restricts access to /sdcard. Use `~/storage/shared/` instead.
2. **Background Limits**: Long builds might be paused. Keep screen on during build.
3. **Battery Optimization**: Disable battery optimization for Termux.
4. **Thermal Throttling**: Device may throttle CPU during long builds.

### 18. Success Verification

**After successful build, verify:**
```bash
# Check APK size (should be 20-50MB)
ls -lh bin/*.apk

# Check APK contents
unzip -l bin/*.apk | head -20

# Test on device
adb install -r bin/*.apk
adb shell am start -n com.yourcompany.bluetoothmanager/.MainActivity
```

### 19. Backup Your Work

**Backup Termux installation:**
```bash
# Backup project
tar -czf ~/storage/shared/termux_backup.tar.gz ~/projects

# Backup SDK/NDK (optional, large)
# tar -czf ~/storage/shared/android_sdk_backup.tar.gz ~/android-sdk
```

### 20. Getting Help

**Useful resources:**
- Termux Wiki: https://wiki.termux.com
- Buildozer Documentation: https://buildozer.readthedocs.io
- Python-for-Android: https://python-for-android.readthedocs.io

**Common build issues forum:**
- GitHub Issues: https://github.com/kivy/buildozer/issues
- Stack Overflow: Tag [termux] [kivy] [buildozer]

---

## ⚡ Quick Start Summary

1. **Install Termux from F-Droid**
2. **Run**: `termux-setup-storage` (ALLOW permission)
3. **Copy project**: `cp -r /sdcard/Documents/BluetoothManager ~/projects/`
4. **Setup**: `pkg update && pkg upgrade && pkg install python git openjdk-17`
5. **Create venv**: `python -m venv venv && source venv/bin/activate`
6. **Install deps**: `pip install kivy bleak buildozer`
7. **Download SDK/NDK** (follow section 8)
8. **Build**: `buildozer -v android debug`

**Expected time**: 45-90 minutes for first build
**Success rate**: ~60% on Android 15 with proper setup

---

**Next Steps**: Run the compatibility test first to identify potential issues:
```bash
bash /sdcard/Documents/termux_compatibility_test.sh
```

Then proceed with the setup sections that pass the test.