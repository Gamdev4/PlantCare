// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'My Garden';

  @override
  String get wateringButtonText => 'Watering Plants';

  @override
  String get wateringPlants => 'Watering the Plants...';

  @override
  String get humidityLevel => 'Humidity Level';

  @override
  String get batteryLevel => 'Battery Level';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get noNotifications => 'No notifications yet!';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get lightDarkMode => 'Light/Dark Mode';

  @override
  String get language => 'Language';

  @override
  String get languageSelection => 'Language';

  @override
  String get languageEnglishUS => 'English';

  @override
  String get languageSpanishMX => 'Spanish';

  @override
  String get languageJapanese => 'Japanese';

  @override
  String get languageFrench => 'French';
}
