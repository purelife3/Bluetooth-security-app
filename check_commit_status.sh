#!/bin/bash

echo "🔍 Checking Git commit status..."
echo "================================"

echo ""
echo "📊 Local commits (last 10):"
echo "---------------------------"
git log --oneline -10

echo ""
echo "📊 Remote commits (last 10):"
echo "----------------------------"
git log origin/main --oneline -10

echo ""
echo "📊 Commits not pushed to remote:"
echo "--------------------------------"
git log origin/main..HEAD --oneline

echo ""
echo "📊 Commits in remote not in local:"
echo "----------------------------------"
git log HEAD..origin/main --oneline

echo ""
echo "📋 Current branch status:"
echo "-------------------------"
git status -sb

echo ""
echo "💡 Critical check - NDK fix commit:"
echo "-----------------------------------"
if git log --oneline | grep -q "d3e84ad"; then
  echo "✅ NDK fix commit (d3e84ad) found locally"
else
  echo "❌ NDK fix commit (d3e84ad) NOT found locally"
fi

echo ""
echo "🔍 Checking buildozer.spec NDK version:"
echo "---------------------------------------"
if [ -f "buildozer.spec" ]; then
  echo "Local buildozer.spec NDK version:"
  grep "android.ndk" buildozer.spec
else
  echo "buildozer.spec not found"
fi