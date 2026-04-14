#!/bin/bash

echo "🚀 Running Git Status Check"
echo "=========================="

# Make the check script executable
chmod +x check_git_simple.sh

# Run the check
bash check_git_simple.sh

echo ""
echo "📊 If you see files listed as modified/untracked,"
echo "   you need to push them to GitHub."
echo ""
echo "💡 Run this to push all changes:"
echo "   chmod +x push_now.sh && ./push_now.sh"
echo ""
echo "📋 Or check what files specifically need attention:"
echo "   ./execute_git_check.sh"