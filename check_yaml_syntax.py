#!/usr/bin/env python3
"""
Simple YAML syntax checker for GitHub Actions workflow file.
Validates basic YAML syntax without external dependencies.
"""

import sys
import re

def check_yaml_syntax(filepath):
    """Check basic YAML syntax in the workflow file."""
    print(f"🔍 Checking YAML syntax for: {filepath}")
    print("=" * 60)
    
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            lines = f.readlines()
    except FileNotFoundError:
        print(f"❌ ERROR: File not found: {filepath}")
        return False
    
    print(f"✅ File loaded: {len(lines)} lines")
    
    errors = []
    warnings = []
    
    # Check for tabs (YAML should use spaces)
    for i, line in enumerate(lines, 1):
        if '\t' in line:
            errors.append(f"Line {i}: Contains tab character (YAML should use spaces)")
    
    # Check quote balance
    content = ''.join(lines)
    single_quotes = content.count("'") % 2
    double_quotes = content.count('"') % 2
    
    if single_quotes != 0:
        errors.append(f"Unbalanced single quotes (count: {content.count(\"'\")})")
    if double_quotes != 0:
        errors.append(f"Unbalanced double quotes (count: {content.count('\"')})")
    
    # Check for common YAML syntax patterns
    in_run_block = False
    run_indent = 0
    run_block_start = 0
    
    for i, line in enumerate(lines, 1):
        # Check for run: | blocks
        if 'run: |' in line and not in_run_block:
            in_run_block = True
            run_indent = len(line) - len(line.lstrip())
            run_block_start = i
            print(f"Found run block at line {i} (indent: {run_indent})")
            continue
        
        # Check for end of run block
        if in_run_block and line.strip() == '' and len(line) - len(line.lstrip()) < run_indent:
            in_run_block = False
            print(f"  Run block ends at line {i-1} (length: {i - run_block_start} lines)")
            continue
        
        # Check indentation within run blocks
        if in_run_block and line.strip() != '':
            current_indent = len(line) - len(line.lstrip())
            if current_indent < run_indent:
                errors.append(f"Line {i}: Indentation {current_indent} < run block indentation {run_indent}")
            elif current_indent > run_indent + 12:  # Allow some extra for shell commands
                warnings.append(f"Line {i}: Excessive indentation {current_indent} in run block")
    
    # Check for heredoc syntax (should be replaced)
    heredoc_pattern = re.compile(r'<<\s*[\"\']?(EOF)[\"\']?')
    in_heredoc = False
    heredoc_marker = ''
    
    for i, line in enumerate(lines, 1):
        # Check for heredoc start
        heredoc_match = heredoc_pattern.search(line)
        if heredoc_match and not in_heredoc:
            in_heredoc = True
            heredoc_marker = heredoc_match.group(1)
            warnings.append(f"Line {i}: Found heredoc syntax (should be replaced with echo/loop)")
            continue
        
        # Check for heredoc end
        if in_heredoc and line.strip() == heredoc_marker:
            in_heredoc = False
            heredoc_marker = ''
            continue
    
    if in_heredoc:
        errors.append(f"Unclosed heredoc starting at line {i}")
    
    # Check for the specific fixes we made
    echo_sdkmanager_found = any('echo \'#!/bin/bash\' >' in line for line in lines)
    loop_license_found = any('for i in {1..52}' in line for line in lines)
    
    print("\n📋 Fix verification:")
    if echo_sdkmanager_found:
        print("✅ First heredoc replaced with echo statements")
    else:
        warnings.append("First heredoc replacement not found (should have echo statements)")
    
    if loop_license_found:
        print("✅ Second heredoc replaced with loop")
    else:
        warnings.append("Second heredoc replacement not found (should have for loop)")
    
    # Report results
    print("\n" + "=" * 60)
    if errors:
        print("❌ YAML SYNTAX ERRORS FOUND:")
        for error in errors:
            print(f"  - {error}")
        return False
    else:
        print("✅ No critical YAML syntax errors found")
    
    if warnings:
        print("\n⚠️  WARNINGS:")
        for warning in warnings:
            print(f"  - {warning}")
    
    print("\n" + "=" * 60)
    print("✅ YAML syntax validation completed successfully!")
    print("The workflow file should pass GitHub Actions YAML validation.")
    return True

if __name__ == "__main__":
    if len(sys.argv) > 1:
        filepath = sys.argv[1]
    else:
        filepath = ".github/workflows/build_fixed.yml"
    
    success = check_yaml_syntax(filepath)
    sys.exit(0 if success else 1)