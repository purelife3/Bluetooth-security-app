#!/bin/bash

echo "🔍 Checking heredoc formatting in workflow file..."
echo "=================================================="

# Check for heredoc sections and verify formatting
python3 -c "
import sys
import re

with open('.github/workflows/build.yml', 'r') as f:
    lines = f.readlines()

print('📊 File has {} lines'.format(len(lines)))

in_heredoc = False
heredoc_marker = ''
heredoc_start_line = 0
errors = []
heredoc_count = 0

for i, line in enumerate(lines, 1):
    # Check for heredoc start
    heredoc_match = re.search(r'<<\s*[\"\']?(EOF)[\"\']?', line)
    if heredoc_match and not in_heredoc:
        in_heredoc = True
        heredoc_marker = heredoc_match.group(1)
        heredoc_start_line = i
        heredoc_count += 1
        print(f'🔍 Found heredoc #{heredoc_count} start at line {i}: {line.strip()[:50]}...')
        continue
    
    # Check for heredoc end
    if in_heredoc and line.strip() == heredoc_marker:
        in_heredoc = False
        print(f'   Heredoc end at line {i}')
        continue
    
    # Check heredoc content for leading spaces
    if in_heredoc:
        # Heredoc content should not have leading spaces in YAML
        if line.startswith(' '):
            errors.append(f'Line {i}: Heredoc content has leading space: {repr(line[:30])}...')

print(f'\\n📋 Found {heredoc_count} heredoc sections in the file')

if errors:
    print('❌ HEREDOC FORMATTING ERRORS FOUND:')
    for error in errors:
        print(f'  {error}')
    print('\\n  CRITICAL: Heredoc content lines should start at column 0 (no leading spaces)')
    print('  This causes YAML parsing failures in GitHub Actions')
    sys.exit(1)
else:
    print('✅ All heredoc sections are correctly formatted!')
    print('   No leading spaces found in heredoc content lines.')

if in_heredoc:
    print(f'❌ ERROR: Unclosed heredoc starting at line {heredoc_start_line}')
    sys.exit(1)

print('\\n✅ Heredoc validation passed! Ready for GitHub Actions.')
"