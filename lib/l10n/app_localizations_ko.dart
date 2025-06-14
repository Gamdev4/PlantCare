// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => '나의 정원';

  @override
  String get wateringButtonText => '식물에 물 주기';

  @override
  String get wateringPlants => '식물에 물 주는 중...';

  @override
  String get humidityLevel => '습도 수준';

  @override
  String get batteryLevel => '배터리 수준';

  @override
  String get notificationsTitle => '알림';

  @override
  String get noNotifications => '아직 알림이 없습니다!';

  @override
  String get settingsTitle => '설정';

  @override
  String get lightDarkMode => '밝은/어두운 모드';

  @override
  String get language => '언어';

  @override
  String get languageSelection => '언어';

  @override
  String get languageEnglishUS => '영어';

  @override
  String get languageSpanishMX => '스페인어';

  @override
  String get languageJapanese => '일본어';

  @override
  String get languageFrench => '프랑스어';

  @override
  String get languageChinese => '중국어';

  @override
  String get languageKorean => '한국어';
}
