#!/data/data/com.termux/files/usr/bin/bash

# Termux Quick Start Script for Bluetooth Manager APK Build
# Run this after installing Termux from F-Droid

echo "=========================================="
echo "Termux APK Build Quick Start"
echo "For Motorola Android 15 (SDK 35)"
echo "=========================================="

# Check if running in Termux
if [ ! -d "/data/data/com.termux" ]; then
    echo "ERROR: This script must be run in Termux!"
    echo "Install Termux from F-Droid first."
    exit 1
fi

echo "Step 1: Updating Termux packages..."
pkg update -y && pkg upgrade -y

echo "Step 2: Installing essential tools..."
pkg install -y python python-pip git wget curl nano clang make cmake pkg-config openjdk-17

echo "Step 3: Setting up storage permissions..."
echo "NOTE: A popup will appear - ALLOW storage access"
termux-setup-storage

echo "Step 4: Creating project directory..."
cd ~
mkdir -p projects/bluetooth_manager
cd projects/bluetooth_manager

echo "Step 5: Copying project files..."
echo "Looking for BluetoothManager in /sdcard/Documents/..."
if [ -d "/sdcard/Documents/BluetoothManager" ]; then
    cp -r /sdcard/Documents/BluetoothManager/* .
    echo "Files copied from /sdcard/Documents/BluetoothManager/"
elif [ -d "~/storage/shared/Documents/BluetoothManager" ]; then
    cp -r ~/storage/shared/Documents/BluetoothManager/* .
    echo "Files copied from ~/storage/shared/Documents/BluetoothManager/"
else
    echo "WARNING: BluetoothManager directory not found!"
    echo "Please copy your project files manually to:"
    echo "  ~/projects/bluetooth_manager/"
    echo "Files needed: main.py, bluetooth.kv, requirements.txt, etc."
    read -p "Press Enter after copying files..."
fi

echo "Step 6: Setting up Python virtual environment..."
python -m venv venv
source venv/bin/activate

echo "Step 7: Installing Python dependencies..."
pip install --upgrade pip
pip install kivy[base] bleak buildozer==1.5.0 cython==0.29.33

echo "Step 8: Testing Python setup..."
python -c "import kivy; print(f'✓ Kivy {kivy.__version__} installed')"
python -c "import bleak; print('✓ Bleak installed')"
python -c "import buildozer; print('✓ Buildozer installed')"

echo "Step 9: Initializing Buildozer..."
buildozer init

echo "Step 10: Creating build configuration..."
cat > build_config.sh << 'EOF'
#!/data/data/com.termux/files/usr/bin/bash

# Build configuration for Termux
export ANDROID_SDK_ROOT=~/android-sdk
export ANDROID_NDK_HOME=~/android-sdk/android-ndk-r25c
export PATH=$PATH:$ANDROID_SDK_ROOT/cmdline-tools/latest/bin
export PATH=$PATH:$ANDROID_SDK_ROOT/platform-tools

source ~/projects/bluetooth_manager/venv/bin/activate
cd ~/projects/bluetooth_manager

echo "Starting build process..."
buildozer -v android debug
EOF

chmod +x build_config.sh

echo "=========================================="
echo "QUICK SETUP COMPLETE!"
echo "=========================================="
echo ""
echo "Next steps:"
echo "1. Install Android SDK/NDK (Section 8 of detailed guide)"
echo "2. Configure buildozer.spec for your device"
echo "3. Run: ./build_config.sh"
echo ""
echo "Detailed guide: /sdcard/Documents/termux_detailed_setup.md"
echo "Compatibility test: bash /sdcard/Documents/termux_compatibility_test.sh"
echo ""
echo "Note: SDK/NDK download is ~3GB. Ensure you have enough space."
echo "Build time: 45-90 minutes for first build."

# Display system info
echo ""
echo "System Information:"
echo "Python: $(python --version 2>&1)"
echo "Java: $(java --version 2>&1 | head -1)"
echo "Storage: $(df -h /data | tail -1 | awk '{print $4}') free"
echo "RAM: $(free -m | awk 'NR==2{print $3"/"$2" MB used"}')"