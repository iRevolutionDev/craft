import 'package:logging/logging.dart';
import 'package:craft/i18n/translations.g.dart';
import 'package:craft/utils/settings_key.dart';
import 'package:shared_preferences/shared_preferences.dart';

final _logger = Logger('LanguageSettings');

Future<void> setupLanguageSettings() async {
  final sharedPrefs = await SharedPreferences.getInstance();

  final language = sharedPrefs.getString(SettingKey.appLanguage.toString());

  if (language != null) {
    _logger.info('Setting language to $language');
    LocaleSettings.setLocaleRaw(language);
  } else {
    _logger.info('Setting language to device locale');
    LocaleSettings.useDeviceLocale();
  }
}
