# App Icon

Place your app icon here to generate launcher icons for iOS and Android.

## Requirements

- **Size**: 1024x1024 pixels (PNG format)
- **Name**: `app_icon.png`
- **Location**: This folder (`assets/icon/`)

## How to Generate Icons

1. Add your 1024x1024 PNG icon to this folder as `app_icon.png`
2. Run the following command:

```bash
flutter pub run flutter_launcher_icons
```

This will automatically generate:
- iOS app icons (all required sizes)
- Android app icons (all required sizes)
- Android adaptive icons

## Customization

Edit the `flutter_launcher_icons` section in `pubspec.yaml` to customize:

- Change icon names
- Add adaptive icon backgrounds/foregrounds
- Configure platform-specific settings

## Resources

- [Flutter Launcher Icons Package](https://pub.dev/packages/flutter_launcher_icons)
- [iOS Icon Guidelines](https://developer.apple.com/design/human-interface-guidelines/app-icons)
- [Android Icon Guidelines](https://developer.android.com/distribute/google-play/resources/icon-design-specifications)

## Icon Design Tips

- Use a simple, recognizable design
- Avoid text in the icon
- Test on both light and dark backgrounds
- Ensure the icon looks good at small sizes
- Consider using an adaptive icon for Android with a transparent foreground
