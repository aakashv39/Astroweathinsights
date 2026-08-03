import 'package:shared_preferences/shared_preferences.dart';

// This class will prevent unnecessary reloading if the language is already translated,
// whether you are visiting the scene once or for multiple times...

class TranslationCache {
  static final TranslationCache _instance = TranslationCache._internal();

  factory TranslationCache() {
    return _instance;
  }

  TranslationCache._internal();

  Future<void> saveTranslation(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  Future<String?> getTranslation(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }
}
