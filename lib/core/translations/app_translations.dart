import 'languages/en_us.dart';
import 'languages/ru_ru.dart';
import 'languages/uz_uz.dart';

abstract class AppTranslations {
  static Map<String, Map<String, String>> translations = {
    'en_US': enUs,
    'ru_RU': ruRu,
    'uz_UZ': uzUz,
  };
}