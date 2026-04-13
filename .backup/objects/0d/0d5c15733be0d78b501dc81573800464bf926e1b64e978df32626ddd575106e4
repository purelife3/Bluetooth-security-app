#!/bin/bash
# Buildozer Installation Script for Android APK Building

echo "========================================="
echo "Buildozer & Android SDK/NDK Installation"
echo "========================================="

# Update package list
echo "[1/8] Updating package list..."
sudo apt-get update

# Install Python and pip
echo "[2/8] Installing Python and pip..."
sudo apt-get install -y python3 python3-pip python3-venv

# Install Buildozer dependencies
echo "[3/8] Installing Buildozer system dependencies..."
sudo apt-get install -y \
    git \
    zip \
    unzip \
    openjdk-17-jdk \
    python3-dev \
    python3-venv \
    python3-setuptools \
    cython \
    autoconf \
    automake \
    libtool \
    pkg-config \
    zlib1g-dev \
    libncurses5-dev \
    libncursesw5-dev \
    libtinfo5 \
    cmake \
    libffi-dev \
    libssl-dev

# Install Buildozer via pip
echo "[4/8] Installing Buildozer..."
pip3 install --user buildozer==1.5.0

# Add Buildozer to PATH
echo "[5/8] Adding Buildozer to PATH..."
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

# Initialize Buildozer
echo "[6/8] Initializing Buildozer..."
cd /path/to/your/project
buildozer init

# Download Android SDK/NDK
echo "[7/8] Downloading Android SDK/NDK (this may take a while)..."
buildozer android update

# Set Android SDK path
echo "[8/8] Setting up Android SDK environment..."
export ANDROID_SDK_ROOT="$HOME/.buildozer/android/platform/android-sdk"
export ANDROID_NDK_HOME="$HOME/.buildozer/android/platform/android-ndk"
echo "export ANDROID_SDK_ROOT=\"$ANDROID_SDK_ROOT\"" >> ~/.bashrc
echo "export ANDROID_NDK_HOME=\"$ANDROID_NDK_HOME\"" >> ~/.bashrc

echo "========================================="
echo "Installation Complete!"
echo "========================================="
echo ""
echo "Next steps:"
echo "1. Navigate to your project directory:"
echo "   cd /path/to/your/project"
echo "2. Build the APK:"
echo "   buildozer android debug"
echo "3. Find the APK at:"
echo "   bin/BluetoothManager-0.1-debug.apk"
echo ""
echo "Troubleshooting:"
echo "- If build fails, try: buildozer android clean"
echo "- For verbose output: buildozer -v android debug"
echo "- Check Android SDK: ls ~/.buildozer/android/platform/"