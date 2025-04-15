#!/bin/zsh

# Use the .githooks directory
git config core.hooksPath .githooks

# Install brew packages
packages=("rename")

for package in "${packages[@]}"; do
    echo "Checking $package..."

    if brew list --formula | grep -q "^${package}\$"; then
        echo "Package '${package}' is already installed."
    else
        brew install "$package"
    fi
done

echo "All packages installed."

# Check if the new name is provided
if [ -z "$1" ]; then
    echo "Error: No new project name provided."
    echo "Usage: $0 ProjectName"
    exit 1
fi

TEMPLATE="projectName"
NEW_NAME="$1"

# Rename directories if necessary
if [ -d "$TEMPLATE" ]; then
    mv "$TEMPLATE" "$NEW_NAME"
fi

# Find and replace the template name with the new name.
find . -type d -name "$TEMPLATE*" -exec rename -i "s|$TEMPLATE|$NEW_NAME|g" {} +
find . -type f -name "*.swift" -exec rename -i "s|$TEMPLATE|$NEW_NAME|g" {} +
find . -type f -name "*.swift" -exec sed -i '' "s/$TEMPLATE/$NEW_NAME/g" {} +
find . -type f -name "README.md" -exec sed -i '' "s/$TEMPLATE/$NEW_NAME/g" {} +
find . -type f -name "sonar-project.properties" -exec sed -i '' "s/$TEMPLATE/$NEW_NAME/g" {} +

echo "Project renamed from $TEMPLATE to $NEW_NAME"