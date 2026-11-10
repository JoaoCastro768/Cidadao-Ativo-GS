import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const _skipOnboarding = 'skip_onboarding_v1';
  final SharedPreferencesAsync _prefs;

  PreferencesService({SharedPreferencesAsync? preferences})
      : _prefs = preferences ?? SharedPreferencesAsync();

  Future<bool> shouldSkipOnboarding() async =>
      await _prefs.getBool(_skipOnboarding) ?? false;

  Future<void> setSkipOnboarding(bool value) =>
      _prefs.setBool(_skipOnboarding, value);
}
