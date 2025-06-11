import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = false;
  Locale _locale = const Locale('en');

  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;
  Locale get locale => _locale;

  ThemeProvider() {
    _loadTheme();
    _loadLocale();
  }

  Future<void> _loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isDarkMode = prefs.getBool('darkMode') ?? false;
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading theme: $e');
    }
  }

  Future<void> _loadLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lang = prefs.getString('language') ?? 'English';
      _locale = switch (lang) {
        'Sinhala' => const Locale('si'),
        'Tamil' => const Locale('ta'),
        _ => const Locale('en'),
      };
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading locale: $e');
    }
  }

  void toggleTheme(bool isDark) {
    _isDarkMode = isDark;
    SharedPreferences.getInstance().then((prefs) {
      prefs.setBool('darkMode', isDark);
    }).catchError((e) {
      debugPrint('Error saving theme: $e');
    });
    notifyListeners();
  }

  void setLocale(Locale locale) {
    _locale = locale;
    SharedPreferences.getInstance().then((prefs) {
      final lang = switch (locale.languageCode) {
        'si' => 'Sinhala',
        'ta' => 'Tamil',
        _ => 'English',
      };
      prefs.setString('language', lang);
    }).catchError((e) {
      debugPrint('Error saving locale: $e');
    });
    notifyListeners();
  }
}