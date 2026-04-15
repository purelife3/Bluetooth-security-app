#!/bin/bash

echo "🔍 Validating YAML syntax for GitHub Actions workflow..."
echo "========================================================"

# Check if yamllint is available
if ! command -v yamllint &> /dev/null; then
    echo "⚠️ yamllint not found, installing..."
    pip install yamllint || {
        echo "❌ Failed to install yamllint"
        echo "Using basic YAML validation instead..."
        
        # Basic validation: check for common YAML syntax errors
        echo ""
        echo "📋 Basic YAML validation..."
        
         # Check for tabs (should use spaces)
        if grep -n $'\t' .github/workflows/build_fixed.yml; then
            echo "❌ ERROR: Found tabs in YAML file (line numbers above)"
            echo "   YAML should use spaces, not tabs"
            exit 1
        fi
        
        # Check for unterminated quotes
        echo "Checking for unterminated quotes..."
        python3 -c "
import sys
with open('.github/workflows/build_fixed.yml', 'r') as f:
    content = f.read()
    
# Simple quote balance check
single_quotes = content.count(\"'\") % 2
double_quotes = content.count('\"') % 2

if single_quotes != 0:
    print('❌ ERROR: Unbalanced single quotes in YAML')
    sys.exit(1)
if double_quotes != 0:
    print('❌ ERROR: Unbalanced double quotes in YAML')
    sys.exit(1)
print('✅ Quote balance check passed')
        " || exit 1
        
        # Check heredoc formatting
        echo ""
        echo "🔍 Checking heredoc formatting..."
        
        # Read the file and check heredoc sections
        python3 -c "
import sys
import re

with open('.github/workflows/build_fixed.yml', 'r') as f:
    lines = f.readlines()

in_heredoc = False
heredoc_marker = ''
line_num = 0
errors = []

for i, line in enumerate(lines, 1):
    line_num = i
    
    # Check for heredoc start
    heredoc_match = re.search(r'<<\s*[\"\']?(EOF)[\"\']?', line)
    if heredoc_match and not in_heredoc:
        in_heredoc = True
        heredoc_marker = heredoc_match.group(1)
        print(f'Found heredoc start at line {i}: {line.strip()}')
        continue
    
    # Check for heredoc end
    if in_heredoc and line.strip() == heredoc_marker:
        in_heredoc = False
        heredoc_marker = ''
        print(f'Found heredoc end at line {i}')
        continue
    
    # Check heredoc content for leading spaces
    if in_heredoc:
        # Heredoc content should not have leading spaces in YAML
        if line.startswith(' '):
            errors.append(f'Line {i}: Heredoc content has leading space: {repr(line[:20])}...')

if errors:
    print('❌ HEREDOC FORMATTING ERRORS:')
    for error in errors:
        print(f'  {error}')
    print('  Heredoc content lines should start at column 0 (no leading spaces)')
    sys.exit(1)
else:
    print('✅ Heredoc formatting check passed')

if in_heredoc:
    print(f'❌ ERROR: Unclosed heredoc starting at line {line_num}')
    sys.exit(1)
        " || exit 1
        
        echo ""
        echo "✅ Basic YAML validation completed"
    fi
else
    # Use yamllint for comprehensive validation
    echo "Using yamllint for comprehensive validation..."
    yamllint .github/workflows/build_fixed.yml
    
    if [ $? -eq 0 ]; then
        echo "✅ YAML syntax is valid!"
    else
        echo "❌ YAML syntax errors found"
        exit 1
    fi
fi

echo ""
echo "📋 Checking workflow structure..."
echo "File size: $(wc -l < .github/workflows/build_fixed.yml) lines"
echo "File exists: $(ls -la .github/workflows/build_fixed.yml | awk '{print $5}') bytes"

echo ""
echo "🔍 Checking for critical sections..."
grep -n "Ensure Build-Tools 37 License Acceptance" .github/workflows/build_fixed.yml
grep -n "CRITICAL NDK version bridging" .github/workflows/build_fixed.yml
grep -n "android-actions/setup-android" .github/workflows/build_fixed.yml

echo ""
echo "✅ YAML validation complete! The workflow file appears to be syntactically correct."
echo ""
echo "🚀 Ready to push with: ./push_now.sh"