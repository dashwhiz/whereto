import 'package:get/get.dart';
import 'translations/en_us.dart';

/// GetX translations for internationalization
class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': enUS,
  };
}
