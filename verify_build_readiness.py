#!/usr/bin/env python3
"""
Build Readiness Verification Script
Run this on any system to verify your Bluetooth app is ready for APK building.
"""

import os
import sys
import json

def check_file_exists(filepath, description):
    """Check if a file exists and return status."""
    if os.path.exists(filepath):
        size = os.path.getsize(filepath)
        return f"✅ {description}: {filepath} ({size:,} bytes)"
    else:
        return f"❌ {description}: {filepath} (MISSING)"

def check_buildozer_spec():
    """Check buildozer.spec configuration."""
    spec_path = "buildozer.spec"
    if not os.path.exists(spec_path):
        return "❌ buildozer.spec not found"
    
    try:
        with open(spec_path, 'r') as f:
            content = f.read()
        
        checks = []
        
        # Check essential configurations
        if 'title = Bluetooth Manager' in content:
            checks.append("✅ App title: Bluetooth Manager")
        else:
            checks.append("❌ App title not found")
            
        if 'package.name = bluetoothmanager' in content:
            checks.append("✅ Package name: bluetoothmanager")
        else:
            checks.append("❌ Package name not found")
            
        if 'android.permissions = BLUETOOTH,BLUETOOTH_ADMIN,BLUETOOTH_SCAN,BLUETOOTH_CONNECT,BLUETOOTH_ADVERTISE' in content:
            checks.append("✅ Bluetooth permissions configured")
        else:
            checks.append("❌ Bluetooth permissions missing")
            
        if 'android.api = 33' in content:
            checks.append("✅ Target SDK: 33 (Android 13)")
        else:
            checks.append("❌ Target SDK not set to 33")
            
        if 'android.minapi = 21' in content:
            checks.append("✅ Minimum API: 21 (Android 5.0)")
        else:
            checks.append("❌ Minimum API not set to 21")
            
        if 'requirements = python3,kivy==2.3.0,pyjnius,android,bleak' in content:
            checks.append("✅ Python dependencies configured")
        else:
            checks.append("❌ Python dependencies missing")
            
        return "\n".join(checks)
    except Exception as e:
        return f"❌ Error reading buildozer.spec: {str(e)}"

def check_main_app():
    """Check main application files."""
    checks = []
    
    # Check main.py
    if os.path.exists("main.py"):
        size = os.path.getsize("main.py")
        checks.append(f"✅ main.py: {size:,} bytes")
        
        # Check for key features
        with open("main.py", 'r') as f:
            content = f.read()
            
        feature_checks = []
        if 'class WindowsExploitSimulator' in content:
            feature_checks.append("✅ Windows exploit simulator")
        else:
            feature_checks.append("❌ Windows exploit simulator missing")
            
        if 'class MockDeviceCreator' in content:
            feature_checks.append("✅ Mock device creator")
        else:
            feature_checks.append("❌ Mock device creator missing")
            
        if 'class DebugLogger' in content:
            feature_checks.append("✅ Debug logger")
        else:
            feature_checks.append("❌ Debug logger missing")
            
        if 'BluetoothManagerApp' in content:
            feature_checks.append("✅ Main app class")
        else:
            feature_checks.append("❌ Main app class missing")
            
        checks.append("  Features: " + ", ".join(feature_checks))
    else:
        checks.append("❌ main.py not found")
    
    # Check KV file
    if os.path.exists("bluetooth.kv"):
        size = os.path.getsize("bluetooth.kv")
        checks.append(f"✅ bluetooth.kv: {size:,} bytes")
    else:
        checks.append("❌ bluetooth.kv not found")
    
    # Check requirements.txt
    if os.path.exists("requirements.txt"):
        with open("requirements.txt", 'r') as f:
            reqs = f.read()
        if 'buildozer==1.5.0' in reqs:
            checks.append("✅ requirements.txt includes buildozer")
        else:
            checks.append("❌ requirements.txt missing buildozer")
    else:
        checks.append("❌ requirements.txt not found")
    
    return "\n".join(checks)

def check_directory_structure():
    """Check if all required directories exist."""
    checks = []
    
    required_dirs = ['android', 'bluetooth', 'ui']
    for dir_name in required_dirs:
        if os.path.exists(dir_name) and os.path.isdir(dir_name):
            checks.append(f"✅ Directory: {dir_name}/")
        else:
            checks.append(f"❌ Directory missing: {dir_name}/")
    
    return "\n".join(checks)

def main():
    print("=" * 60)
    print("BLUETOOTH APP BUILD READINESS VERIFICATION")
    print("=" * 60)
    print()
    
    # Get current directory
    current_dir = os.getcwd()
    print(f"Current directory: {current_dir}")
    print()
    
    # Check essential files
    print("1. ESSENTIAL FILES:")
    print("-" * 40)
    print(check_file_exists("main.py", "Main application"))
    print(check_file_exists("bluetooth.kv", "UI layout file"))
    print(check_file_exists("buildozer.spec", "Build configuration"))
    print(check_file_exists("requirements.txt", "Python dependencies"))
    print()
    
    # Check buildozer.spec configuration
    print("2. BUILD CONFIGURATION:")
    print("-" * 40)
    print(check_buildozer_spec())
    print()
    
    # Check main app features
    print("3. APPLICATION FEATURES:")
    print("-" * 40)
    print(check_main_app())
    print()
    
    # Check directory structure
    print("4. DIRECTORY STRUCTURE:")
    print("-" * 40)
    print(check_directory_structure())
    print()
    
    # System information
    print("5. SYSTEM INFORMATION:")
    print("-" * 40)
    print(f"Python version: {sys.version}")
    print(f"Platform: {sys.platform}")
    print()
    
    # Summary
    print("=" * 60)
    print("SUMMARY:")
    print("-" * 40)
    
    # Count checks
    files_exist = all([
        os.path.exists("main.py"),
        os.path.exists("bluetooth.kv"),
        os.path.exists("buildozer.spec"),
        os.path.exists("requirements.txt")
    ])
    
    dirs_exist = all([
        os.path.exists("android") and os.path.isdir("android"),
        os.path.exists("bluetooth") and os.path.isdir("bluetooth"),
        os.path.exists("ui") and os.path.isdir("ui")
    ])
    
    if files_exist and dirs_exist:
        print("✅ Your app is READY for APK building!")
        print()
        print("NEXT STEPS:")
        print("1. Install Buildozer on your system (see installation guide)")
        print("2. Run: buildozer init (if not already done)")
        print("3. Run: buildozer -v android debug")
        print("4. Find APK in: bin/bluetoothmanager-0.1-debug.apk")
    else:
        print("❌ Some components are missing.")
        print("Please ensure all files and directories are present.")
    
    print("=" * 60)

if __name__ == "__main__":
    main()