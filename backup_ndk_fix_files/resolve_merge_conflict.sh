#!/bin/bash

echo "🔧 Resolving Merge Conflict in fix_buildozer_platform_directories.sh"
echo "===================================================================="
echo ""

# Step 1: Check current git status
echo "📊 Step 1: Checking git status..."
echo "--------------------------------"
git status
echo ""

# Step 2: Check for conflict markers
echo "🔍 Step 2: Checking for conflict markers..."
echo "------------------------------------------"
if grep -n "<<<<<<<" fix_buildozer_platform_directories.sh; then
    echo "❌ Conflict markers found!"
    echo ""
    echo "Conflict lines:"
    grep -n -B2 -A2 "<<<<<<<" fix_buildozer_platform_directories.sh
else
    echo "✅ No conflict markers found"
fi
echo ""

# Step 3: Show the conflicted file content around the conflict area
echo "📄 Step 3: Showing file content around potential conflict area..."
echo "---------------------------------------------------------------"
echo "Checking lines 125-180 (NDK bridge section):"
sed -n '125,180p' fix_buildozer_platform_directories.sh
echo ""

# Step 4: Show git diff for the conflicted file
echo "📋 Step 4: Showing git diff for conflicted file..."
echo "-------------------------------------------------"
git diff fix_buildozer_platform_directories.sh
echo ""

# Step 5: Manual resolution instructions
echo "🛠️ Step 5: Manual Resolution Instructions"
echo "----------------------------------------"
echo "Since the script detected a merge conflict, here's how to resolve it:"
echo ""
echo "1. Open the file in a text editor:"
echo "   nano fix_buildozer_platform_directories.sh"
echo ""
echo "2. Look for conflict markers:"
echo "   <<<<<<< HEAD"
echo "   ... your changes ..."
echo "   ======="
echo "   ... remote changes ..."
echo "   >>>>>>> [commit hash]"
echo ""
echo "3. Decide which changes to keep:"
echo "   - Keep your NDK bridge fix (lines 130-174)"
echo "   - Remove conflict markers"
echo "   - Keep both sets of changes if they don't conflict"
echo ""
echo "4. Mark as resolved:"
echo "   git add fix_buildozer_platform_directories.sh"
echo ""
echo "5. Continue with stash:"
echo "   git stash drop"
echo ""
echo "6. Run the final push script again:"
echo "   ./final_push_ndk_fix.sh"
echo ""

# Step 6: Quick fix - keep our NDK bridge and remove conflicts
echo "⚡ Step 6: Quick Fix Option"
echo "--------------------------"
echo "If you want to keep our NDK bridge fix and discard remote changes:"
echo ""
echo "1. Backup the current file:"
echo "   cp fix_buildozer_platform_directories.sh fix_buildozer_platform_directories.sh.backup"
echo ""
echo "2. Remove conflict markers and keep our version:"
echo "   sed -i '/<<<<<<< HEAD/,/>>>>>>>/d' fix_buildozer_platform_directories.sh"
echo ""
echo "3. Verify the fix:"
echo "   grep -n 'CRITICAL FIX: SDK manager' fix_buildozer_platform_directories.sh"
echo ""
echo "4. Mark as resolved:"
echo "   git add fix_buildozer_platform_directories.sh"
echo ""
echo "5. Continue:"
echo "   git stash drop"
echo "   ./final_push_ndk_fix.sh"
echo ""

echo "🚀 Ready to resolve the merge conflict!"