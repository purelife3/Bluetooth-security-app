#!/usr/bin/env python3
"""
GitHub Actions Readiness Checker
Verifies that your project is ready for GitHub Actions build.
"""

import os
import sys
import yaml

def check_file_exists(filepath, description):
    """Check if a file exists and return status."""
    exists = os.path.exists(filepath)
    status = "✅" if exists else "❌"
    print(f"{status} {description}: {filepath}")
    return exists

def check_github_workflow():
    """Check GitHub Actions workflow file."""
    workflow_path = ".github/workflows/build.yml"
    if not os.path.exists(workflow_path):
        print("❌ GitHub Actions workflow not found")
        return False
    
    try:
        with open(workflow_path, 'r') as f:
            content = f.read()
        
        # Basic validation
        if "name: Build Android APK" in content:
            print("✅ GitHub Actions workflow configured correctly")
            return True
        else:
            print("❌ GitHub Actions workflow missing expected content")
            return False
    except Exception as e:
        print(f"❌ Error reading workflow file: {e}")
        return False

def check_buildozer_spec():
    """Check buildozer.spec configuration."""
    spec_path = "buildozer.spec"
    if not os.path.exists(spec_path):
        print("❌ buildozer.spec not found")
        return False
    
    try:
        with open(spec_path, 'r') as f:
            content = f.read()
        
        checks = [
            ("android.arch = arm64-v8a", "ARM64 architecture"),
            ("android.minapi = 23", "Minimum API 23"),
            ("android.targetapi = 33", "Target API 33"),
            ("BLUETOOTH_SCAN", "Bluetooth permissions"),
            ("requirements = python3,kivy", "Python requirements"),
        ]
        
        all_good = True
        for check_str, description in checks:
            if check_str in content:
                print(f"✅ {description} configured")
            else:
                print(f"❌ {description} missing")
                all_good = False
        
        return all_good
    except Exception as e:
        print(f"❌ Error reading buildozer.spec: {e}")
        return False

def check_essential_files():
    """Check essential app files."""
    essential_files = [
        ("main.py", "Main application file"),
        ("bluetooth.kv", "UI layout file"),
        ("requirements.txt", "Python dependencies"),
        ("ble_module_part1.py", "Bluetooth module part 1"),
        ("ble_module_part2.py", "Bluetooth module part 2"),
        ("ble_module_part3.py", "Bluetooth module part 3"),
    ]
    
    all_exist = True
    for filename, description in essential_files:
        exists = os.path.exists(filename)
        status = "✅" if exists else "❌"
        print(f"{status} {description}: {filename}")
        if not exists:
            all_exist = False
    
    return all_exist

def check_gitignore():
    """Check .gitignore file."""
    gitignore_path = ".gitignore"
    if not os.path.exists(gitignore_path):
        print("❌ .gitignore file missing")
        return False
    
    try:
        with open(gitignore_path, 'r') as f:
            content = f.read()
        
        # Check for common build artifacts
        if ".buildozer" in content or "bin/" in content:
            print("✅ .gitignore excludes build artifacts")
            return True
        else:
            print("⚠️  .gitignore may not exclude build artifacts")
            return True  # Not critical
    except:
        print("⚠️  Could not read .gitignore")
        return True  # Not critical

def main():
    print("=" * 60)
    print("GitHub Actions Readiness Check")
    print("=" * 60)
    
    results = []
    
    print("\n1. Checking GitHub Actions workflow:")
    results.append(("GitHub Actions Workflow", check_github_workflow()))
    
    print("\n2. Checking Buildozer configuration:")
    results.append(("Buildozer Configuration", check_buildozer_spec()))
    
    print("\n3. Checking essential app files:")
    results.append(("Essential Files", check_essential_files()))
    
    print("\n4. Checking .gitignore:")
    results.append((".gitignore", check_gitignore()))
    
    print("\n" + "=" * 60)
    print("SUMMARY:")
    print("=" * 60)
    
    all_passed = True
    for name, passed in results:
        status = "PASS" if passed else "FAIL"
        print(f"{name}: {status}")
        if not passed:
            all_passed = False
    
    print("\n" + "=" * 60)
    if all_passed:
        print("✅ READY FOR GITHUB ACTIONS!")
        print("\nNext steps:")
        print("1. Create GitHub repository at github.com")
        print("2. Run: git init")
        print("3. Run: git add .")
        print("4. Run: git commit -m 'Initial commit'")
        print("5. Run: git remote add origin YOUR_REPO_URL")
        print("6. Run: git push -u origin main")
        print("7. Go to GitHub → Actions → Run workflow")
    else:
        print("❌ Some checks failed. Please fix the issues above.")
        print("\nCommon fixes:")
        print("- Ensure .github/workflows/build.yml exists")
        print("- Verify buildozer.spec has correct settings")
        print("- Make sure all app files are present")
    
    return 0 if all_passed else 1

if __name__ == "__main__":
    sys.exit(main())