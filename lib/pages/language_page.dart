import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:namer_app/constants/app_constants.dart';
import 'package:namer_app/l10n/app_localizations.dart';
import 'package:namer_app/providers/locale_provider.dart';

class LanguagePage extends StatefulWidget {
  const LanguagePage({super.key});

  @override
  State<LanguagePage> createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {

  // Variables
  bool _isPressing = false;
  String? _currentlyPressedId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      // Bar
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.languageSelection,
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary, fontSize: 24),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
      ),

      // Background
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).scaffoldBackgroundColor,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),

        // Language options
        child: Consumer(
          builder: (context, ref, _) {
            final currentLocale = ref.watch(localeProvider);
            
            return ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                
                // English
                _buildLanguageOption(
                  context: context,
                  ref: ref,
                  currentLocale: currentLocale,
                  languageCode: 'en',
                  flagAsset: AppConstants.usFlag,
                  languageName: AppLocalizations.of(context)!.languageEnglishUS,
                  languageSubtitle: AppConstants.languageEnglishUS,
                ),
                const SizedBox(height: 12),

                // Spanish (Mexico)
                _buildLanguageOption(
                  context: context,
                  ref: ref,
                  currentLocale: currentLocale,
                  languageCode: 'es',
                  flagAsset: AppConstants.mxFlag,
                  languageName: AppLocalizations.of(context)!.languageSpanishMX,
                  languageSubtitle: AppConstants.languageSpanishMX,
                ),
                const SizedBox(height: 12),

                // Franch
                _buildLanguageOption(
                  context: context,
                  ref: ref,
                  currentLocale: currentLocale,
                  languageCode: 'fr',
                  flagAsset: AppConstants.frFlag,
                  languageName: AppLocalizations.of(context)!.languageFrench,
                  languageSubtitle: AppConstants.languageFrench,
                ),
                const SizedBox(height: 12),

                // Japanese
                _buildLanguageOption(
                  context: context,
                  ref: ref,
                  currentLocale: currentLocale,
                  languageCode: 'ja',
                  flagAsset: AppConstants.jaFlag,
                  languageName: AppLocalizations.of(context)!.languageJapanese,
                  languageSubtitle: AppConstants.languageJapanese,
                ),
                const SizedBox(height: 12),

                // Korean
                _buildLanguageOption(
                  context: context,
                  ref: ref,
                  currentLocale: currentLocale,
                  languageCode: 'ko',
                  flagAsset: AppConstants.koFlag,
                  languageName: AppLocalizations.of(context)!.languageKorean,
                  languageSubtitle: AppConstants.languageKorean,
                ),
                const SizedBox(height: 12),

                // Chinese
                _buildLanguageOption(
                  context: context,
                  ref: ref,
                  currentLocale: currentLocale,
                  languageCode: 'zh',
                  flagAsset: AppConstants.zhFlag,
                  languageName: AppLocalizations.of(context)!.languageChinese,
                  languageSubtitle: AppConstants.languageChinese,
                ),
                const SizedBox(height: 12),

              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildLanguageOption({
    required BuildContext context,
    required WidgetRef ref,
    required Locale currentLocale,
    required String languageCode,
    required String flagAsset,
    required String languageName,
    required String languageSubtitle,
  }) {
    final isSelected = currentLocale.languageCode == languageCode;
    final isBeingPressed = _currentlyPressedId == languageCode && _isPressing;

    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          _isPressing = true;
          _currentlyPressedId = languageCode;
        });
      },
      onTapUp: (_) {
        setState(() {
          _isPressing = false;
          _currentlyPressedId = null;
        });
        ref.read(localeProvider.notifier).state = Locale(languageCode);
      },
      onTapCancel: () {
        setState(() {
          _isPressing = false;
          _currentlyPressedId = null;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected 
              ? Theme.of(context).colorScheme.secondary 
              : (isBeingPressed 
                  ? Theme.of(context).colorScheme.primaryContainer 
                  : Theme.of(context).colorScheme.primary),
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: SizedBox(
          height: 60,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Image.asset(
                  flagAsset,
                  width: 30,
                  height: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 200),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontSize: isBeingPressed ? 18 : 20,
                      fontWeight: FontWeight.normal,
                    ),
                    child: Text(languageName),
                  ),
                ),
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: isBeingPressed ? 10 : 12,
                    fontWeight: FontWeight.normal,
                  ),
                  child: Text(languageSubtitle),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}