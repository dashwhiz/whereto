import 'package:get/get.dart';
import 'translations/en_us.dart';
import 'translations/de_de.dart';
import 'translations/es_es.dart';
import 'translations/fr_fr.dart';
import 'translations/it_it.dart';
import 'translations/pt_pt.dart';

/// GetX translations for internationalization
/// Supports multiple languages out of the box
/// Add more languages by creating a new file in translations/ folder
class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': enUS,
    'de_DE': deDE,
    'es_ES': esES,
    'fr_FR': frFR,
    'it_IT': itIT,
    'pt_PT': ptPT,
  };
}
