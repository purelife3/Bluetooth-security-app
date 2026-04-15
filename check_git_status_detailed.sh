#!/bin/bash

echo "🔍 Detailed Git Status Check"
echo "============================"

echo ""
echo "1. Current branch:"
git branch -a

echo ""
echo "2. Remote tracking:"
git remote -v

echo ""
echo "3. Local commit:"
git log --oneline -5

echo ""
echo "4. Remote commit (origin/main):"
git fetch origin
git log origin/main --oneline -5

echo ""
echo "5. Difference between local and remote:"
git log HEAD..origin/main --oneline

echo ""
echo "6. Git status:"
git status

echo ""
echo "7. Staged changes:"
git diff --cached --name-only

echo ""
echo "8. Unstaged changes:"
git diff --name-only

echo ""
echo "9. Git configuration:"
git config --list | grep -E "(user\.|remote\.|branch\.)"