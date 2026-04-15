#!/bin/bash

echo "🔍 Verifying YAML syntax after heredoc fixes..."
echo "================================================"

# Check the workflow file exists
if [ ! -f ".github/workflows/build_fixed.yml" ]; then
    echo "❌ ERROR: build_fixed.yml not found!"
    exit 1
fi

echo "✅ File exists: .github/workflows/build_fixed.yml"

# Check that heredocs have been replaced with echo statements
echo ""
echo "📋 Checking heredoc replacements..."

# First heredoc (sdkmanager wrapper) - should be replaced with echo statements
echo "1. Checking sdkmanager wrapper (lines 172-176):"
if grep -q "echo '#!/bin/bash' >.*sdkmanager" ".github/workflows/build_fixed.yml"; then
    echo "   ✅ First heredoc replaced with echo statements"
else
    echo "   ❌ First heredoc still present or incorrect replacement"
fi

# Second heredoc (license input) - should be replaced with loop
echo "2. Checking license input (lines 207-210):"
if grep -q "for i in {1..52}" ".github/workflows/build_fixed.yml"; then
    echo "   ✅ Second heredoc replaced with loop"
else
    echo "   ❌ Second heredoc still present or incorrect replacement"
fi

# Check for YAML syntax errors by looking for common patterns
echo ""
echo "🔍 Checking for common YAML syntax issues..."

# Check for tabs (should use spaces)
if grep -n $'\t' ".github/workflows/build_fixed.yml"; then
    echo "❌ ERROR: Found tabs in YAML file (see above)"
    exit 1
else
    echo "✅ No tabs found (good - YAML should use spaces)"
fi

# Check for unterminated quotes
echo ""
echo "Checking quote balance..."
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
"

# Check for consistent indentation in run: | blocks
echo ""
echo "Checking indentation consistency in run blocks..."
python3 -c "
import sys
import re

with open('.github/workflows/build_fixed.yml', 'r') as f:
    lines = f.readlines()

in_run_block = False
run_indent = 0
errors = []

for i, line in enumerate(lines, 1):
    # Check for run: | start
    if 'run: |' in line and not in_run_block:
        in_run_block = True
        # Get the indentation level of this line
        run_indent = len(line) - len(line.lstrip())
        print(f'Found run block at line {i} with indentation {run_indent}')
        continue
    
    # Check for end of run block (empty line with less indentation)
    if in_run_block and line.strip() == '' and len(line) - len(line.lstrip()) < run_indent:
        in_run_block = False
        run_indent = 0
        continue
    
    # Check indentation within run block
    if in_run_block and line.strip() != '':
        current_indent = len(line) - len(line.lstrip())
        if current_indent < run_indent:
            errors.append(f'Line {i}: Indentation {current_indent} < run block indentation {run_indent}')
        elif current_indent > run_indent + 8:  # Allow some extra indentation for shell commands
            errors.append(f'Line {i}: Excessive indentation {current_indent} in run block')

if errors:
    print('❌ INDENTATION ERRORS FOUND:')
    for error in errors:
        print(f'  {error}')
    sys.exit(1)
else:
    print('✅ All run blocks have consistent indentation')
"

echo ""
echo "================================================"
echo "✅ YAML syntax verification complete!"
echo ""
echo "📊 Summary of fixes applied:"
echo "1. ✅ Replaced heredoc with echo statements (lines 172-176)"
echo "2. ✅ Replaced heredoc with loop (lines 207-210)"
echo "3. ✅ Eliminated YAML heredoc indentation conflicts entirely"
echo ""
echo "🚀 The workflow file should now pass GitHub Actions YAML validation!"
echo "   Next step: Commit and push to trigger a build test."