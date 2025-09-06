import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ja'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Vivechat'**
  String get appTitle;

  /// No description provided for @enterPassKey.
  ///
  /// In en, this message translates to:
  /// **'Enter Pass Key'**
  String get enterPassKey;

  /// No description provided for @passKey.
  ///
  /// In en, this message translates to:
  /// **'Pass Key'**
  String get passKey;

  /// No description provided for @invalidPassKey.
  ///
  /// In en, this message translates to:
  /// **'Invalid pass key'**
  String get invalidPassKey;

  /// No description provided for @pleaseEnterPassKey.
  ///
  /// In en, this message translates to:
  /// **'Please enter a pass key'**
  String get pleaseEnterPassKey;

  /// No description provided for @continueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// No description provided for @selectCharacter.
  ///
  /// In en, this message translates to:
  /// **'Select a Character'**
  String get selectCharacter;

  /// No description provided for @selectFromDevice.
  ///
  /// In en, this message translates to:
  /// **'Select from Device'**
  String get selectFromDevice;

  /// No description provided for @clearChatHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear Chat History?'**
  String get clearChatHistoryTitle;

  /// No description provided for @clearChatHistoryBody.
  ///
  /// In en, this message translates to:
  /// **'This will permanently delete the conversation.'**
  String get clearChatHistoryBody;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @selectCharacterFirst.
  ///
  /// In en, this message translates to:
  /// **'Please select a character image first.'**
  String get selectCharacterFirst;

  /// No description provided for @failedToUpdateImage.
  ///
  /// In en, this message translates to:
  /// **'Failed to update image.'**
  String get failedToUpdateImage;

  /// No description provided for @errorOccurred.
  ///
  /// In en, this message translates to:
  /// **'An error occurred: {error}'**
  String errorOccurred(Object error);

  /// No description provided for @characterDidNotRespond.
  ///
  /// In en, this message translates to:
  /// **'The character didn\'t respond.'**
  String get characterDidNotRespond;

  /// No description provided for @viveChat.
  ///
  /// In en, this message translates to:
  /// **'ViveChat'**
  String get viveChat;

  /// No description provided for @clearChatHistoryTooltip.
  ///
  /// In en, this message translates to:
  /// **'Clear Chat History'**
  String get clearChatHistoryTooltip;

  /// No description provided for @emotionGalleryTooltip.
  ///
  /// In en, this message translates to:
  /// **'Emotion Gallery'**
  String get emotionGalleryTooltip;

  /// No description provided for @justUpdateImage.
  ///
  /// In en, this message translates to:
  /// **'Just Update Image'**
  String get justUpdateImage;

  /// No description provided for @chatWithCharacter.
  ///
  /// In en, this message translates to:
  /// **'Chat with your character...'**
  String get chatWithCharacter;

  /// No description provided for @characterEmotionGallery.
  ///
  /// In en, this message translates to:
  /// **'Character Emotion Gallery'**
  String get characterEmotionGallery;

  /// No description provided for @noEmotionalImages.
  ///
  /// In en, this message translates to:
  /// **'No emotional images have been generated yet.'**
  String get noEmotionalImages;

  /// No description provided for @original.
  ///
  /// In en, this message translates to:
  /// **'ORIGINAL'**
  String get original;

  /// No description provided for @imageSavedToGallery.
  ///
  /// In en, this message translates to:
  /// **'Image saved to gallery'**
  String get imageSavedToGallery;

  /// No description provided for @failedToSaveImage.
  ///
  /// In en, this message translates to:
  /// **'Failed to save image'**
  String get failedToSaveImage;

  /// No description provided for @imageNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Image not available'**
  String get imageNotAvailable;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ja'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ja':
      return AppLocalizationsJa();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
