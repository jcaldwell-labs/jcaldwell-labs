#!/bin/bash
# Apply fintrack PR #4 fixes from working directory
# Run this after cloning fresh fintrack repo

set -e

SOURCE_DIR="$HOME/projects/fintrack"
TARGET_DIR="$HOME/projects/jcaldwell-labs/repos/fintrack"
BRANCH="claude/transaction-management-phase-1-018jGbVyGFV6u6AyHt4s2g2R"

echo "========================================="
echo "Apply fintrack PR #4 Fixes"
echo "========================================="
echo ""

# Verify source exists
if [ ! -d "$SOURCE_DIR" ]; then
    echo "❌ Source directory not found: $SOURCE_DIR"
    exit 1
fi

# Verify target exists
if [ ! -d "$TARGET_DIR" ]; then
    echo "❌ Target directory not found: $TARGET_DIR"
    echo "Run setup-workspace.sh first to clone repositories"
    exit 1
fi

echo "📁 Source: $SOURCE_DIR"
echo "📁 Target: $TARGET_DIR"
echo "🌿 Branch: $BRANCH"
echo ""

# Go to target directory
cd "$TARGET_DIR"

# Create and checkout branch
echo "🔄 Creating branch..."
git checkout main
git checkout -b "$BRANCH" || git checkout "$BRANCH"

echo ""
echo "📋 Copying fixed files from source..."

# Copy all modified files
cp "$SOURCE_DIR/internal/models/models.go" "$TARGET_DIR/internal/models/"
cp "$SOURCE_DIR/internal/commands/account.go" "$TARGET_DIR/internal/commands/"
cp "$SOURCE_DIR/tests/unit/account_repository_test.go" "$TARGET_DIR/tests/unit/"

# Copy new files from PR
cp "$SOURCE_DIR/internal/commands/category.go" "$TARGET_DIR/internal/commands/"
cp "$SOURCE_DIR/internal/commands/transaction.go" "$TARGET_DIR/internal/commands/"
cp "$SOURCE_DIR/internal/db/repositories/category_repository.go" "$TARGET_DIR/internal/db/repositories/"
cp "$SOURCE_DIR/internal/db/repositories/transaction_repository.go" "$TARGET_DIR/internal/db/repositories/"
cp "$SOURCE_DIR/tests/unit/category_repository_test.go" "$TARGET_DIR/tests/unit/"
cp "$SOURCE_DIR/tests/unit/transaction_repository_test.go" "$TARGET_DIR/tests/unit/"
cp "$SOURCE_DIR/README.md" "$TARGET_DIR/"
cp "$SOURCE_DIR/cmd/fintrack/main.go" "$TARGET_DIR/cmd/fintrack/"
cp "$SOURCE_DIR/internal/commands/stubs.go" "$TARGET_DIR/internal/commands/"
cp "$SOURCE_DIR/internal/output/output.go" "$TARGET_DIR/internal/output/"

echo "✅ Files copied"
echo ""

# Run checks
echo "🧪 Running local checks..."
echo ""

echo "1️⃣ go fmt..."
go fmt ./...

echo "2️⃣ go vet..."
go vet ./...

echo "3️⃣ go test..."
go test -v ./...

echo "4️⃣ gosec..."
if command -v gosec &> /dev/null; then
    gosec ./...
else
    echo "⚠️  gosec not installed, skipping"
fi

echo "5️⃣ go build..."
go build -v ./cmd/fintrack/

echo ""
echo "========================================="
echo "✅ All checks passed!"
echo "========================================="
echo ""
echo "Next steps:"
echo "1. Review the changes: git status"
echo "2. Commit: git add -A && git commit -m 'fix: resolve CI failures'"
echo "3. Push: git push -u origin $BRANCH"
echo "4. Verify CI: gh pr checks 4"
echo ""
