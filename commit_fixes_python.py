#!/usr/bin/env python3
"""
Python script to commit Build-Tools 37 license fixes to git.
This script performs the same actions as commit_build_tools_fix.sh
but uses Python's subprocess module for better compatibility.
"""

import subprocess
import os
import sys

def run_command(cmd, description):
    """Run a shell command and print output."""
    print(f"📝 {description}")
    print(f"   Command: {cmd}")
    
    try:
        result = subprocess.run(cmd, shell=True, capture_output=True, text=True)
        if result.stdout:
            print(f"   Output: {result.stdout.strip()}")
        if result.stderr:
            print(f"   Error: {result.stderr.strip()}")
        if result.returncode != 0:
            print(f"   ❌ Command failed with return code: {result.returncode}")
            return False
        return True
    except Exception as e:
        print(f"   ❌ Exception: {e}")
        return False

def main():
    print("=== Build-Tools 37 License Fix Commit Script ===")
    print()
    
    # Check if we're in a git repository
    if not os.path.exists(".git"):
        print("❌ Not a git repository")
        sys.exit(1)
    
    # Add the workflow file
    if not run_command("git add .github/workflows/build.yml", "Adding .github/workflows/build.yml..."):
        print("❌ Failed to add workflow file")
        sys.exit(1)
    
    # Check what's being committed
    print("📋 Changes to be committed:")
    run_command("git status --porcelain", "Checking git status")
    
    # Create commit message
    commit_msg = """Fix: Build-Tools 37 license acceptance - targeted fixes

- Changed echo 'y' to yes command for multiple license prompts (line 201)
- Added Build-Tools 37 specific hash to license list (line 152)
- Added explicit license acceptance immediately before Build-Tools 37 installation (lines 228-230)

This addresses the 'Skipping following packages as the license is not accepted: Android SDK Build-Tools 37' error."""
    
    # Write commit message to file
    with open("commit_msg.txt", "w") as f:
        f.write(commit_msg)
    
    # Commit with descriptive message
    if not run_command("git commit -F commit_msg.txt", "Committing Build-Tools 37 license fixes..."):
        print("❌ Failed to commit changes")
        sys.exit(1)
    
    # Clean up commit message file
    os.remove("commit_msg.txt")
    
    # Push to remote
    if not run_command("git push origin main", "Pushing to remote repository..."):
        print("❌ Failed to push to remote")
        sys.exit(1)
    
    print("✅ Build-Tools 37 license fixes committed and pushed!")
    print()
    print("=== Next Steps ===")
    print("1. The GitHub Actions workflow will automatically trigger")
    print("2. Monitor the build at: https://github.com/[your-repo]/actions")
    print("3. Verify Build-Tools 37 installation in the build logs")
    print("4. Check that AIDL is now available for APK compilation")

if __name__ == "__main__":
    main()