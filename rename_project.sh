#!/bin/bash

# Flutter Template Renaming Script
# Usage: ./rename_project.sh <new_project_name>
# Example: ./rename_project.sh countdown_app

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if project name is provided
if [ -z "$1" ]; then
    echo -e "${RED}Error: Project name is required${NC}"
    echo "Usage: ./rename_project.sh <new_project_name>"
    echo "Example: ./rename_project.sh countdown_app"
    exit 1
fi

NEW_PROJECT_NAME=$1
OLD_PROJECT_NAME="my_flutter_template"

# Validate project name (only lowercase letters, numbers, and underscores)
if ! [[ "$NEW_PROJECT_NAME" =~ ^[a-z][a-z0-9_]*$ ]]; then
    echo -e "${RED}Error: Invalid project name${NC}"
    echo "Project name must:"
    echo "  - Start with a lowercase letter"
    echo "  - Contain only lowercase letters, numbers, and underscores"
    echo "  - Not contain spaces or special characters"
    exit 1
fi

# Check if we're in the right directory
if [ ! -f "pubspec.yaml" ]; then
    echo -e "${RED}Error: pubspec.yaml not found${NC}"
    echo "Please run this script from the project root directory"
    exit 1
fi

echo -e "${GREEN}Starting project rename...${NC}"
echo "Old name: $OLD_PROJECT_NAME"
echo "New name: $NEW_PROJECT_NAME"
echo ""

# Backup important files
echo -e "${YELLOW}Creating backups...${NC}"
cp pubspec.yaml pubspec.yaml.backup
cp android/app/build.gradle android/app/build.gradle.backup 2>/dev/null || true
echo ""

# Update pubspec.yaml
echo -e "${YELLOW}Updating pubspec.yaml...${NC}"
sed -i.tmp "s/name: $OLD_PROJECT_NAME/name: $NEW_PROJECT_NAME/" pubspec.yaml
sed -i.tmp "s/description: \"A Flutter template project/description: \"$NEW_PROJECT_NAME/" pubspec.yaml
rm -f pubspec.yaml.tmp
echo "  ✓ pubspec.yaml updated"

# Update Android files
echo -e "${YELLOW}Updating Android configuration...${NC}"

# Update android/app/build.gradle or build.gradle.kts (applicationId)
if [ -f "android/app/build.gradle.kts" ]; then
    sed -i.tmp "s/applicationId = \"com.example.$OLD_PROJECT_NAME\"/applicationId = \"com.example.$NEW_PROJECT_NAME\"/" android/app/build.gradle.kts
    sed -i.tmp "s/applicationIdSuffix = \".dev\"/applicationIdSuffix = \".dev\"/" android/app/build.gradle.kts
    rm -f android/app/build.gradle.kts.tmp
    echo "  ✓ android/app/build.gradle.kts updated"
elif [ -f "android/app/build.gradle" ]; then
    sed -i.tmp "s/applicationId \"com.example.$OLD_PROJECT_NAME\"/applicationId \"com.example.$NEW_PROJECT_NAME\"/" android/app/build.gradle
    rm -f android/app/build.gradle.tmp
    echo "  ✓ android/app/build.gradle updated"
fi

# Update AndroidManifest.xml files
find android/app/src -name "AndroidManifest.xml" -type f | while read file; do
    sed -i.tmp "s/com.example.$OLD_PROJECT_NAME/com.example.$NEW_PROJECT_NAME/g" "$file"
    rm -f "$file.tmp"
done
echo "  ✓ AndroidManifest.xml files updated"

# Update iOS files
echo -e "${YELLOW}Updating iOS configuration...${NC}"

# Update Bundle Identifier in project.pbxproj
if [ -f "ios/Runner.xcodeproj/project.pbxproj" ]; then
    sed -i.tmp "s/com.example.$OLD_PROJECT_NAME/com.example.$NEW_PROJECT_NAME/g" ios/Runner.xcodeproj/project.pbxproj
    rm -f ios/Runner.xcodeproj/project.pbxproj.tmp
    echo "  ✓ iOS Bundle Identifier updated"
fi

# Update iOS Info.plist
if [ -f "ios/Runner/Info.plist" ]; then
    sed -i.tmp "s/<string>$OLD_PROJECT_NAME<\/string>/<string>$NEW_PROJECT_NAME<\/string>/" ios/Runner/Info.plist
    rm -f ios/Runner/Info.plist.tmp
    echo "  ✓ iOS Info.plist updated"
fi

# Update translation files (app name translation)
echo -e "${YELLOW}Updating translation files...${NC}"

# Update English translation
if [ -f "lib/app/translations/en_us.dart" ]; then
    sed -i.tmp "s/'appName': 'My Flutter Template'/'appName': '$NEW_PROJECT_NAME'/" lib/app/translations/en_us.dart
    rm -f lib/app/translations/en_us.dart.tmp
    echo "  ✓ en_us.dart updated"
fi

# Update German translation
if [ -f "lib/app/translations/de_de.dart" ]; then
    sed -i.tmp "s/'appName': 'Meine Flutter-Vorlage'/'appName': '$NEW_PROJECT_NAME'/" lib/app/translations/de_de.dart
    rm -f lib/app/translations/de_de.dart.tmp
    echo "  ✓ de_de.dart updated"
fi

# Update Spanish translation
if [ -f "lib/app/translations/es_es.dart" ]; then
    sed -i.tmp "s/'appName': 'Mi Plantilla Flutter'/'appName': '$NEW_PROJECT_NAME'/" lib/app/translations/es_es.dart
    rm -f lib/app/translations/es_es.dart.tmp
    echo "  ✓ es_es.dart updated"
fi

# Update French translation
if [ -f "lib/app/translations/fr_fr.dart" ]; then
    sed -i.tmp "s/'appName': 'Mon Modèle Flutter'/'appName': '$NEW_PROJECT_NAME'/" lib/app/translations/fr_fr.dart
    rm -f lib/app/translations/fr_fr.dart.tmp
    echo "  ✓ fr_fr.dart updated"
fi

# Update Italian translation
if [ -f "lib/app/translations/it_it.dart" ]; then
    sed -i.tmp "s/'appName': 'Il Mio Modello Flutter'/'appName': '$NEW_PROJECT_NAME'/" lib/app/translations/it_it.dart
    rm -f lib/app/translations/it_it.dart.tmp
    echo "  ✓ it_it.dart updated"
fi

# Update Portuguese translation
if [ -f "lib/app/translations/pt_pt.dart" ]; then
    sed -i.tmp "s/'appName': 'Meu Modelo Flutter'/'appName': '$NEW_PROJECT_NAME'/" lib/app/translations/pt_pt.dart
    rm -f lib/app/translations/pt_pt.dart.tmp
    echo "  ✓ pt_pt.dart updated"
fi

# Update environment configuration (Firebase project IDs)
echo -e "${YELLOW}Updating environment configuration...${NC}"
if [ -f "lib/app/environments.dart" ]; then
    # Update Firebase project IDs (dev and prod)
    sed -i.tmp "s/firebaseProjectId: '$OLD_PROJECT_NAME-dev'/firebaseProjectId: '$NEW_PROJECT_NAME-dev'/" lib/app/environments.dart
    sed -i.tmp "s/firebaseProjectId: '$OLD_PROJECT_NAME-prod'/firebaseProjectId: '$NEW_PROJECT_NAME-prod'/" lib/app/environments.dart
    rm -f lib/app/environments.dart.tmp
    echo "  ✓ environments.dart updated (Firebase project IDs)"
fi

# Find and replace all occurrences of old project name in Dart files
echo -e "${YELLOW}Updating Dart files...${NC}"
find lib -name "*.dart" -type f | while read file; do
    if grep -q "$OLD_PROJECT_NAME" "$file"; then
        sed -i.tmp "s/$OLD_PROJECT_NAME/$NEW_PROJECT_NAME/g" "$file"
        rm -f "$file.tmp"
        echo "  ✓ Updated: $file"
    fi
done

# Clean Flutter build
echo -e "${YELLOW}Cleaning Flutter project...${NC}"
flutter clean > /dev/null 2>&1
echo "  ✓ Flutter clean completed"

# Get dependencies
echo -e "${YELLOW}Getting dependencies...${NC}"
flutter pub get > /dev/null 2>&1
echo "  ✓ Dependencies installed"

# Remove backup files
echo -e "${YELLOW}Cleaning up backups...${NC}"
rm -f pubspec.yaml.backup
rm -f android/app/build.gradle.backup
echo "  ✓ Backups removed"

echo ""
echo -e "${GREEN}✓ Project successfully renamed to: $NEW_PROJECT_NAME${NC}"
echo ""
echo "Next steps:"
echo "  1. Review the changes"
echo "  2. Run 'flutter run' to test the app"
echo "  3. Update README.md with your project details"
echo ""
