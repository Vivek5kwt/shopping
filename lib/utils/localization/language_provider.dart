import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageOption {
  const LanguageOption({required this.locale, required this.labelKey});

  final Locale locale;
  final String labelKey;
}

class LanguageProvider extends ChangeNotifier {
  LanguageProvider() {
    _loadSavedLocale();
  }

  static const String _prefKey = 'selected_locale';

  static const List<LanguageOption> _languages = [
    LanguageOption(locale: Locale('en'), labelKey: 'language.english'),
    LanguageOption(locale: Locale('hi'), labelKey: 'language.hindi'),
  ];

  Locale _locale = _languages.first.locale;
  bool _initialized = false;

  Locale get locale => _locale;
  bool get isInitialized => _initialized;

  List<LanguageOption> get languages => List.unmodifiable(_languages);

  List<Locale> get supportedLocales =>
      _languages.map((language) => language.locale).toList(growable: false);

  LanguageOption get selectedLanguage => _languages.firstWhere(
        (option) => option.locale.languageCode == _locale.languageCode,
        orElse: () => _languages.first,
      );

  Future<void> _loadSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_prefKey);
    if (code != null) {
      final matchedLocale = _languages.firstWhere(
        (option) => option.locale.languageCode == code,
        orElse: () => _languages.first,
      );
      _locale = matchedLocale.locale;
    }
    _initialized = true;
    notifyListeners();
  }

  Future<void> updateLocale(Locale locale) async {
    if (locale.languageCode == _locale.languageCode) return;
    _locale = locale;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefKey, locale.languageCode);
  }
}
