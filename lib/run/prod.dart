import '../app/environments.dart';

/// Production environment entry point
///
/// Run this file to launch the app in production mode:
/// ```
/// flutter run -t lib/run/prod.dart --flavor prod
/// flutter build apk --release -t lib/run/prod.dart --flavor prod
/// flutter build appbundle --release -t lib/run/prod.dart --flavor prod
/// flutter build ios --release -t lib/run/prod.dart --flavor prod
/// ```
void main() => prod();
