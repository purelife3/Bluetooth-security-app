#!/bin/bash

echo "Checking git status..."
git status --porcelain

echo -e "\nChecking diff for .github/workflows/build.yml..."
git diff .github/workflows/build.yml

echo -e "\nCounting changes..."
git diff .github/workflows/build.yml | grep -E "^[+-]" | wc -l

echo -e "\nSummary of changes:"
echo "1. Line 201: Changed echo 'y' to yes command"
echo "2. Line 152: Added Build-Tools 37 specific hash"
echo "3. Lines 228-230: Added explicit license acceptance before Build-Tools 37 installation"