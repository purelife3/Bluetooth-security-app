#!/data/data/com.termux/files/usr/bin/bash
# Termux Compatibility Test Script
# Run this in Termux to check if your device can build APKs

echo "=========================================="
echo "TERMUX BUILD COMPATIBILITY TEST"
echo "=========================================="
echo "Device: $(getprop ro.product.model)"
echo "Android: $(getprop ro.build.version.release)"
echo "Architecture: $(uname -m)"
echo "=========================================="
echo

# Test 1: Basic commands
echo "1. BASIC COMMANDS:"
echo "------------------"
which python3 && python3 --version || echo "❌ Python3 not found"
which pip && pip --version || echo "❌ pip not found"
which git && git --version || echo "❌ git not found"
which wget && wget --version | head -1 || echo "❌ wget not found"
which curl && curl --version | head -1 || echo "❌ curl not found"
echo

# Test 2: Storage space
echo "2. STORAGE SPACE:"
echo "------------------"
df -h /data | awk 'NR==2 {print "Internal: " $4 " free of " $2}'
if [ -d /storage/emulated/0 ]; then
    df -h /storage/emulated/0 | awk 'NR==2 {print "SD Card: " $4 " free of " $2}'
else
    echo "SD Card: Not accessible"
fi
echo

# Test 3: Memory
echo "3. MEMORY:"
echo "----------"
free -h | awk 'NR==2 {print "RAM: " $4 " free of " $2}'
echo

# Test 4: CPU
echo "4. CPU INFORMATION:"
echo "-------------------"
echo "Cores: $(nproc)"
echo "Architecture: $(uname -m)"
cat /proc/cpuinfo | grep "model name" | head -1 | cut -d: -f2
echo

# Test 5: Java
echo "5. JAVA:"
echo "--------"
which java && java --version 2>/dev/null | head -1 || echo "❌ Java not installed"
echo

# Test 6: Build tools
echo "6. BUILD TOOLS:"
echo "---------------"
which make && make --version | head -1 || echo "❌ make not found"
which cmake && cmake --version | head -1 || echo "❌ cmake not found"
which clang && clang --version | head -1 || echo "❌ clang not found"
echo

# Test 7: Python packages
echo "7. PYTHON PACKAGES:"
echo "-------------------"
python3 -c "import sys; print(f'Python: {sys.version}')"
python3 -c "try: import kivy; print('✅ Kivy installed'); except: print('❌ Kivy missing')"
python3 -c "try: import bleak; print('✅ Bleak installed'); except: print('❌ Bleak missing')"
echo

# Test 8: Permissions
echo "8. PERMISSIONS:"
echo "---------------"
if [ -d /storage/emulated/0 ]; then
    echo "✅ Storage access: OK"
else
    echo "❌ Storage access: Failed (run: termux-setup-storage)"
fi

# Check if running as root
if [ "$(whoami)" = "root" ]; then
    echo "⚠️  Running as root (may cause issues)"
else
    echo "✅ Normal user mode"
fi
echo

# Summary
echo "=========================================="
echo "BUILD COMPATIBILITY SUMMARY"
echo "=========================================="

# Calculate score
SCORE=0
TOTAL=8

# Check each requirement
[ -x "$(which python3)" ] && SCORE=$((SCORE+1))
[ -x "$(which pip)" ] && SCORE=$((SCORE+1))
[ -x "$(which git)" ] && SCORE=$((SCORE+1))
[ -x "$(which java)" ] && SCORE=$((SCORE+1))
[ -x "$(which make)" ] && SCORE=$((SCORE+1))
[ -d "/storage/emulated/0" ] && SCORE=$((SCORE+1))
python3 -c "import kivy" 2>/dev/null && SCORE=$((SCORE+1))
python3 -c "import bleak" 2>/dev/null && SCORE=$((SCORE+1))

PERCENTAGE=$((SCORE * 100 / TOTAL))

echo "Compatibility Score: $SCORE/$TOTAL ($PERCENTAGE%)"
echo

if [ $PERCENTAGE -ge 75 ]; then
    echo "✅ GOOD: Your device is likely capable of building APKs"
    echo "Recommended: Try the Termux + P4A approach"
elif [ $PERCENTAGE -ge 50 ]; then
    echo "⚠️  MODERATE: Building will be challenging"
    echo "Recommended: Install missing dependencies first"
else
    echo "❌ DIFFICULT: Significant setup required"
    echo "Recommended: Consider cloud build or computer"
fi

echo "=========================================="
echo "NEXT STEPS:"
echo "1. Install Termux from F-Droid"
echo "2. Run: termux-setup-storage"
echo "3. Run: pkg update && pkg upgrade"
echo "4. Install missing tools from test above"
echo "5. Try building with P4A first"
echo "=========================================="