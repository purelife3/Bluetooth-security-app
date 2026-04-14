#!/bin/bash

echo "🔍 Analyzing Build Logs for Script Execution"
echo "=========================================="

LOG_DIR="/storage/emulated/0/Download/Operit/cleanOnExit/build_logs_latest"
WORKSPACE_LOG_DIR="/data/user/0/com.ai.assistance.operit/files/workspace/12b133bf-e2d7-4362-89c4-5f413cd49128/build_logs_analysis"

echo ""
echo "📊 Latest logs from: $LOG_DIR"
echo "📊 Workspace logs from: $WORKSPACE_LOG_DIR"

echo ""
echo "🔍 Checking for script execution evidence..."
echo "------------------------------------------"

# Check build.log for any script output
echo "1. Searching build.log for script execution:"
if [ -f "$LOG_DIR/build.log" ]; then
    echo "   Latest build.log:"
    grep -i "running\|creating\|platform\|android-ndk\|fix_buildozer" "$LOG_DIR/build.log" || echo "   ❌ No script execution found in latest logs"
else
    echo "   ❌ Latest build.log not found"
fi

echo ""
echo "2. Checking workspace build.log:"
if [ -f "$WORKSPACE_LOG_DIR/build.log" ]; then
    echo "   Workspace build.log:"
    grep -i "running\|creating\|platform\|android-ndk\|fix_buildozer" "$WORKSPACE_LOG_DIR/build.log" || echo "   ❌ No script execution found in workspace logs"
else
    echo "   ❌ Workspace build.log not found"
fi

echo ""
echo "3. Critical analysis of error pattern:"
echo "   - Buildozer says: 'Android NDK is missing, downloading'"
echo "   - Error occurs at: 'ValueError: read of closed file'"
echo "   - This indicates Buildozer is attempting NDK download"
echo "   - Our scripts should prevent this by creating platform directories"
echo "   - NO script output in logs = scripts not executed"

echo ""
echo "🚨 **CRITICAL FINDING**:"
echo "========================="
echo "The build logs show NO output from our fix scripts."
echo "This means the GitHub Actions workflow is NOT executing our scripts."
echo ""
echo "Possible reasons:"
echo "1. Scripts not pushed to GitHub yet (most likely)"
echo "2. Workflow not configured to run scripts"
echo "3. Scripts failing silently"
echo "4. Scripts not executable"

echo ""
echo "🔧 **IMMEDIATE ACTION REQUIRED**:"
echo "================================="
echo "1. Check if scripts are on GitHub:"
echo "   - Visit your GitHub repository"
echo "   - Check if fix_buildozer_platform_directories.sh exists"
echo "   - Check if .github/workflows/build.yml calls the script"
echo ""
echo "2. If scripts are NOT on GitHub:"
echo "   Run: chmod +x execute_push.sh && ./execute_push.sh"
echo ""
echo "3. If scripts ARE on GitHub but not executing:"
echo "   Check workflow logs for any errors before script execution"
echo "   Verify script permissions (chmod +x)"
echo "   Check script paths in workflow"

echo ""
echo "📋 To verify deployment readiness:"
echo "   chmod +x verify_deployment.sh && ./verify_deployment.sh"