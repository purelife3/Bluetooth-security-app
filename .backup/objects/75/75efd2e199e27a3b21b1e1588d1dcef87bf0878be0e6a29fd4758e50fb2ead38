#!/usr/bin/env python3
"""
GitHub Actions Version Compatibility Checker
Verifies that all GitHub Actions are using Node.js 24 compatible versions.
"""

import os
import re
import sys

def check_workflow_file(filepath):
    """Check a workflow file for Node.js 24 compatibility."""
    print(f"\n🔍 Checking: {filepath}")
    
    if not os.path.exists(filepath):
        print(f"❌ File not found: {filepath}")
        return False
    
    try:
        with open(filepath, 'r') as f:
            content = f.read()
        
        # Check for FORCE_JAVASCRIPT_ACTIONS_TO_NODE24
        if "FORCE_JAVASCRIPT_ACTIONS_TO_NODE24: true" in content:
            print("✅ FORCE_JAVASCRIPT_ACTIONS_TO_NODE24: true found")
        else:
            print("❌ FORCE_JAVASCRIPT_ACTIONS_TO_NODE24: true NOT found")
        
        # Check action versions
        actions_to_check = [
            ("actions/checkout", ["v4.3.0", "v4.2.0"]),
            ("actions/setup-python", ["v5.3.0", "v5.2.0"]),
            ("actions/upload-artifact", ["v4.5.0", "v4.4.0"])
        ]
        
        all_correct = True
        for action_name, correct_versions in actions_to_check:
            # Find all uses of this action
            pattern = rf'{re.escape(action_name)}@([\w\.\-]+)'
            matches = re.findall(pattern, content)
            
            if matches:
                for version in matches:
                    if version in correct_versions:
                        print(f"✅ {action_name}@{version} (Node.js 24 compatible)")
                    else:
                        print(f"❌ {action_name}@{version} (NOT Node.js 24 compatible)")
                        print(f"   Expected: {', '.join(correct_versions)}")
                        all_correct = False
            else:
                # Action not found in this file (might not be used)
                pass
        
        return all_correct
        
    except Exception as e:
        print(f"❌ Error reading file: {e}")
        return False

def main():
    print("=" * 70)
    print("GitHub Actions Node.js 24 Compatibility Check")
    print("=" * 70)
    
    workflow_dir = ".github/workflows"
    
    if not os.path.exists(workflow_dir):
        print(f"❌ Workflow directory not found: {workflow_dir}")
        return 1
    
    workflow_files = []
    for filename in os.listdir(workflow_dir):
        if filename.endswith(('.yml', '.yaml')):
            workflow_files.append(os.path.join(workflow_dir, filename))
    
    if not workflow_files:
        print("❌ No workflow files found")
        return 1
    
    print(f"\nFound {len(workflow_files)} workflow file(s):")
    
    all_passed = True
    for workflow_file in workflow_files:
        if not check_workflow_file(workflow_file):
            all_passed = False
    
    print("\n" + "=" * 70)
    print("SUMMARY:")
    print("=" * 70)
    
    if all_passed:
        print("✅ ALL WORKFLOWS ARE NODE.JS 24 COMPATIBLE!")
        print("\nIf you're still seeing deprecation warnings:")
        print("1. Make sure you've pushed the updated files to GitHub:")
        print("   git add .github/workflows/")
        print("   git commit -m 'Update to Node.js 24 compatible actions'")
        print("   git push origin main")
        print("\n2. GitHub Actions may be caching old runs:")
        print("   - Go to GitHub → Actions")
        print("   - Click on the failing workflow")
        print("   - Click 'Re-run all jobs' to force a fresh run")
        print("\n3. Wait 1-2 minutes for GitHub to process the update")
    else:
        print("❌ SOME WORKFLOWS NEED UPDATES")
        print("\nRequired updates:")
        print("- actions/checkout@v4.3.0 (or v4.2.0)")
        print("- actions/setup-python@v5.3.0 (or v5.2.0)")
        print("- actions/upload-artifact@v4.5.0 (or v4.4.0)")
        print("\nAlso ensure each workflow has:")
        print("env:")
        print("  FORCE_JAVASCRIPT_ACTIONS_TO_NODE24: true")
    
    return 0 if all_passed else 1

if __name__ == "__main__":
    sys.exit(main())