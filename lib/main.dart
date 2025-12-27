import 'app/environments.dart';

/// Application entry point
///
/// By default, runs in development mode.
/// For production builds, use lib/run/prod.dart instead.
///
/// Examples:
/// ```bash
/// # Run in development mode (default)
/// flutter run
///
/// # Run in development mode explicitly
/// flutter run -t lib/run/dev.dart --flavor dev
///
/// # Run in production mode
/// flutter run -t lib/run/prod.dart --flavor prod
/// ```
void main() => dev();
