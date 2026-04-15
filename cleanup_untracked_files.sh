#!/bin/bash

echo "🧹 Cleaning Up Untracked Files for Git Rebase"
echo "=============================================="
echo ""

# Create backup directory
echo "📁 Creating backup directory..."
mkdir -p backup_ndk_fix_files
echo "✅ Created: backup_ndk_fix_files/"
echo ""

# List of untracked files that conflict
UNTRACKED_FILES=(
    "FINAL_NDK_FIX_SUMMARY.md"
    "NDK_VERSION_CONSISTENCY_SUMMARY.md"
    "NDK_VERSION_CONSISTENCY_SUMMARY.md.local_backup"
    "check_current_state.sh"
    "check_git_status_detailed.sh"
    "continue_ndk_fix_push.sh"
    "diagnose_git_issue.sh"
    "final_complete_push.sh"
    "final_push_ndk_fix.sh"
    "push_ndk_fix.sh"
    "push_ndk_fix_with_pull.sh"
    "resolve_merge_conflict.sh"
    "resolve_non_fast_forward.sh"
    "resolve_stale_push.sh"
    "resolve_untracked_file_conflict.sh"
)

echo "📋 Files to move to backup:"
echo "---------------------------"
for file in "${UNTRACKED_FILES[@]}"; do
    if [ -f "$file" ]; then
        echo "  📄 $file"
    fi
done
echo ""

# Move files
echo "🚚 Moving files to backup..."
for file in "${UNTRACKED_FILES[@]}"; do
    if [ -f "$file" ]; then
        mv "$file" "backup_ndk_fix_files/"
        echo "  ✅ Moved: $file"
    else
        echo "  ⚠️  Not found: $file"
    fi
done
echo ""

# Verify critical files remain
echo "🔍 Verifying critical files remain:"
echo "----------------------------------"
CRITICAL_FILES=(
    "buildozer.spec"
    "fix_buildozer_platform_directories.sh"
    "verify_ndk_config.sh"
    "deploy_corrected_fix.sh"
)

for file in "${CRITICAL_FILES[@]}"; do
    if [ -f "$file" ]; then
        echo "  ✅ Critical file exists: $file"
    else
        echo "  ❌ MISSING: $file"
    fi
done
echo ""

# Check Git status
echo "📊 Git Status After Cleanup:"
echo "---------------------------"
git status
echo ""

# Show what's in backup
echo "📦 Backup Contents:"
echo "------------------"
ls -la backup_ndk_fix_files/
echo ""

echo "🎯 Next Steps:"
echo "-------------"
echo "1. Run: git pull origin main --rebase"
echo "2. If successful, continue with: git push origin main"
echo "3. After push, you can restore backup files if needed:"
echo "   cp backup_ndk_fix_files/* ."
echo ""
echo "📝 Note: These backup files are local troubleshooting artifacts."
echo "   The only critical files for the NDK fix are:"
echo "   - buildozer.spec (with android.ndk = 25b)"
echo "   - fix_buildozer_platform_directories.sh (bridge script)"
echo "   - verify_ndk_config.sh (verification)"
echo "   - deploy_corrected_fix.sh (deployment)"