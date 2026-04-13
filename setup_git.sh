#!/bin/bash
# Git Setup Script for GitHub Actions
# Run this on your computer after creating GitHub repository

echo "=========================================="
echo "GitHub Actions Setup Script"
echo "=========================================="

# Check if git is installed
if ! command -v git &> /dev/null; then
    echo "❌ Git is not installed. Please install git first."
    echo "For Windows: https://git-scm.com/download/win"
    echo "For macOS: brew install git"
    echo "For Linux: sudo apt-get install git"
    exit 1
fi

echo "✅ Git is installed: $(git --version)"

# Initialize git repository
if [ ! -d ".git" ]; then
    echo "Initializing git repository..."
    git init
    echo "✅ Git repository initialized"
else
    echo "✅ Git repository already exists"
fi

# Add all files
echo "Adding files to git..."
git add .

# Check if there are any changes
if git diff --cached --quiet; then
    echo "⚠️  No changes to commit"
else
    # Commit changes
    echo "Committing changes..."
    git commit -m "Initial commit: Bluetooth Security App with GitHub Actions"
    echo "✅ Changes committed"
fi

echo ""
echo "=========================================="
echo "NEXT STEPS:"
echo "=========================================="
echo ""
echo "1. Create a GitHub repository at:"
echo "   https://github.com/new"
echo ""
echo "2. Name your repository (e.g., bluetooth-security-app)"
echo ""
echo "3. Choose public or private"
echo ""
echo "4. DO NOT initialize with README, .gitignore, or license"
echo ""
echo "5. After creating repository, run these commands:"
echo ""
echo "   git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO.git"
echo "   git branch -M main"
echo "   git push -u origin main"
echo ""
echo "6. Go to GitHub → Actions tab → Run workflow"
echo ""
echo "7. Wait 15-25 minutes for build to complete"
echo ""
echo "8. Download APK from Actions → Artifacts"
echo ""
echo "=========================================="
echo "Quick Command Reference:"
echo "=========================================="
echo "# Set remote (replace with your URL)"
echo "git remote add origin https://github.com/YOUR_USERNAME/bluetooth-security-app.git"
echo ""
echo "# Push to GitHub"
echo "git push -u origin main"
echo ""
echo "# Check status"
echo "git status"
echo ""
echo "# View remote URL"
echo "git remote -v"