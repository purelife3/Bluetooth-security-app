#!/bin/bash

echo "🔍 Checking for unstaged changes..."
echo "=================================="

# Check git status for unstaged changes
git status --porcelain

echo ""
echo "📊 Summary of unstaged changes:"
echo "================================"

# Count unstaged changes
git status --porcelain | while read status file; do
  case "$status" in
    " M") echo "Modified: $file" ;;
    "??") echo "Untracked: $file" ;;
    " D") echo "Deleted: $file" ;;
    " A") echo "Added: $file" ;;
    " R") echo "Renamed: $file" ;;
    " C") echo "Copied: $file" ;;
    " U") echo "Unmerged: $file" ;;
    *) echo "Unknown ($status): $file" ;;
  esac
done

echo ""
echo "📋 Total unstaged files:"
git status --porcelain | wc -l

echo ""
echo "💡 Recommended actions:"
echo "======================"
echo "1. If these are temporary files, run: ./cleanup_untracked_files.sh"
echo "2. If these are important changes, commit them: git add . && git commit -m 'Temporary commit for rebase'"
echo "3. Or stash them: git stash"