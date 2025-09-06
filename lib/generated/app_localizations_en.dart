// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Vivechat';

  @override
  String get enterPassKey => 'Enter Pass Key';

  @override
  String get passKey => 'Pass Key';

  @override
  String get invalidPassKey => 'Invalid pass key';

  @override
  String get pleaseEnterPassKey => 'Please enter a pass key';

  @override
  String get continueButton => 'Continue';

  @override
  String get selectCharacter => 'Select a Character';

  @override
  String get selectFromDevice => 'Select from Device';

  @override
  String get clearChatHistoryTitle => 'Clear Chat History?';

  @override
  String get clearChatHistoryBody =>
      'This will permanently delete the conversation.';

  @override
  String get cancel => 'Cancel';

  @override
  String get clear => 'Clear';

  @override
  String get selectCharacterFirst => 'Please select a character image first.';

  @override
  String get failedToUpdateImage => 'Failed to update image.';

  @override
  String errorOccurred(Object error) {
    return 'An error occurred: $error';
  }

  @override
  String get characterDidNotRespond => 'The character didn\'t respond.';

  @override
  String get viveChat => 'ViveChat';

  @override
  String get clearChatHistoryTooltip => 'Clear Chat History';

  @override
  String get emotionGalleryTooltip => 'Emotion Gallery';

  @override
  String get justUpdateImage => 'Just Update Image';

  @override
  String get chatWithCharacter => 'Chat with your character...';

  @override
  String get characterEmotionGallery => 'Character Emotion Gallery';

  @override
  String get noEmotionalImages =>
      'No emotional images have been generated yet.';

  @override
  String get original => 'ORIGINAL';

  @override
  String get imageSavedToGallery => 'Image saved to gallery';

  @override
  String get failedToSaveImage => 'Failed to save image';

  @override
  String get imageNotAvailable => 'Image not available';
}
