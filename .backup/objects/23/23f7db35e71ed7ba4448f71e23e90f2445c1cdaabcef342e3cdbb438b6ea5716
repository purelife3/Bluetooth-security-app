#!/usr/bin/env python3
"""
Script to install buildozer and Android SDK/NDK tools
This script attempts to install buildozer via pip and check for Android SDK
"""

import subprocess
import sys
import os

def run_command(cmd, description):
    """Run a command and return output"""
    print(f"\n{'='*60}")
    print(f"Running: {description}")
    print(f"Command: {cmd}")
    print('='*60)
    
    try:
        result = subprocess.run(
            cmd,
            shell=True,
            capture_output=True,
            text=True,
            timeout=30
        )
        print(f"Exit code: {result.returncode}")
        if result.stdout:
            print(f"Output:\n{result.stdout}")
        if result.stderr:
            print(f"Errors:\n{result.stderr}")
        return result.returncode == 0
    except subprocess.TimeoutExpired:
        print("Command timed out after 30 seconds")
        return False
    except Exception as e:
        print(f"Error executing command: {e}")
        return False

def main():
    print("Attempting to install buildozer and Android SDK/NDK tools")
    
    # Check Python version
    run_command("python3 --version", "Check Python version")
    
    # Check pip version
    run_command("pip3 --version", "Check pip version")
    
    # Try to install buildozer
    success = run_command("pip3 install buildozer==1.5.0", "Install buildozer")
    
    if success:
        print("\n✓ Buildozer installation successful!")
        
        # Check if buildozer is installed
        run_command("buildozer --version", "Check buildozer version")
        
        # Initialize buildozer for current directory
        run_command("buildozer init", "Initialize buildozer")
        
        print("\nBuildozer setup complete!")
        print("\nNext steps:")
        print("1. Install Android SDK/NDK manually (see install_buildozer.sh)")
        print("2. Run: buildozer android debug")
        print("3. Find APK in bin/ directory")
    else:
        print("\n✗ Buildozer installation failed")
        print("\nAlternative installation methods:")
        print("1. Use the install_buildozer.sh script on a Linux system")
        print("2. Install via system package manager:")
        print("   Ubuntu/Debian: sudo apt-get install buildozer")
        print("   Arch: sudo pacman -S buildozer")
        print("3. Use virtual environment:")
        print("   python3 -m venv venv")
        print("   source venv/bin/activate")
        print("   pip install buildozer")

if __name__ == "__main__":
    main()