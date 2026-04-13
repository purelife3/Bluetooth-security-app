[app]

# Title of your application
title = Bluetooth Security Manager

# Package name
package.name = bluetoothsecurity

# Package domain
package.domain = org.security

# Source directory
source.dir = .

# Source files to include
source.include_exts = py,png,jpg,kv,atlas

# Application version
version = 1.0

# Application requirements
requirements = python3,kivy==2.3.0,plyer,pyjnius,android

# Supported orientation
orientation = portrait

# Android architecture (optimized for GitHub Actions - ARM64)
android.arch = arm64-v8a

# Android permissions (Bluetooth permissions for Android 12+)
android.permissions = BLUETOOTH,BLUETOOTH_ADMIN,BLUETOOTH_SCAN,BLUETOOTH_CONNECT,ACCESS_FINE_LOCATION,ACCESS_COARSE_LOCATION

# Minimum SDK version (Android 6.0 - required for GitHub Actions)
android.minapi = 23

# Target SDK version (Android 13)
android.targetapi = 33

# Enable debugging
android.enable_debuggable = True

# Logcat filters
android.logcat_filters = *:S python:D

# Hardware acceleration
android.hardware_acceleration = True

# Build settings for GitHub Actions
android.sdk = 33
android.ndk = 25.1.8937393
android.ndk_api = 23

# Presplash (optional)
# presplash.filename = %(source.dir)s/data/presplash.png

# Icon (optional)
# icon.filename = %(source.dir)s/data/icon.png

# Fullscreen mode
fullscreen = 0

# Window size
size = 360x640

# Log level
log_level = 2

# Build mode
build_mode = debug

# Python version
python.version = 3.11

# Android entry point
android.entrypoint = org.security.bluetoothsecurity

# Android activity class name
android.activity_class_name = PythonActivity

# Android manifest additions (for Bluetooth on Android 12+)
android.manifest_merger = True
android.manifest_merger_extra = |
    <uses-permission android:name="android.permission.BLUETOOTH_SCAN"
                     android:usesPermissionFlags="neverForLocation" />
    <uses-permission android:name="android.permission.BLUETOOTH_CONNECT" />
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"
                     android:maxSdkVersion="30" />
    <uses-feature android:name="android.hardware.bluetooth" android:required="true" />
    <uses-feature android:name="android.hardware.bluetooth_le" android:required="true" />

# Buildozer will use paths from ~/.buildozer/default.cfg
# No need to duplicate SDK/NDK paths here