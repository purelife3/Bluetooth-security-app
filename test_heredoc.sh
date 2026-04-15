#!/bin/bash

echo "🔧 Creating sdkmanager symlink for Buildozer..."

# Test the first heredoc (sdkmanager wrapper)
echo "Testing sdkmanager wrapper heredoc..."
cat > /tmp/test_sdkmanager_wrapper.sh << 'EOF'
#!/bin/bash
echo "WARNING: Dummy sdkmanager script - real sdkmanager not found"
echo "This is a fallback for Buildozer's path expectations"
echo "Arguments: $@"
exit 1
EOF

echo "First heredoc created successfully"

# Test the second heredoc (license input)
echo "Testing license input heredoc..."
cat > /tmp/test_license_input.txt << 'EOF'
y
y
y
y
y
EOF

echo "Second heredoc created successfully"
echo "Both heredocs executed without syntax errors!"