#!/bin/bash

echo "🔍 Checking git diff for workflow file..."
echo "=========================================="

# Check current HEAD commit
echo "Current HEAD commit:"
git log --oneline -1

echo ""
echo "Checking git status for .github/workflows/build.yml:"
git status --porcelain .github/workflows/build.yml

echo ""
echo "Checking if file is staged:"
git diff --cached --name-only | grep -q "\.github/workflows/build.yml" && echo "✅ File is staged" || echo "❌ File is NOT staged"

echo ""
echo "Checking if file has unstaged changes:"
git diff --name-only | grep -q "\.github/workflows/build.yml" && echo "✅ File has unstaged changes" || echo "❌ File has NO unstaged changes"

echo ""
echo "Checking git diff between HEAD and working directory:"
git diff HEAD -- .github/workflows/build.yml | head -50

echo ""
echo "Checking git diff between HEAD and staged area:"
git diff --cached HEAD -- .github/workflows/build.yml | head -50

echo ""
echo "Checking last commit that modified this file:"
git log --oneline -5 -- .github/workflows/build.yml

echo ""
echo "=========================================="
echo "Analysis complete."