// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'ViveChat';

  @override
  String get enterPassKey => 'パスキーを入力してください';

  @override
  String get passKey => 'パスキー';

  @override
  String get invalidPassKey => 'パスキーが無効です';

  @override
  String get pleaseEnterPassKey => 'パスキーを入力してください';

  @override
  String get continueButton => '続ける';

  @override
  String get selectCharacter => 'キャラクターを選択';

  @override
  String get selectFromDevice => 'デバイスから選択';

  @override
  String get clearChatHistoryTitle => 'チャット履歴を消去しますか？';

  @override
  String get clearChatHistoryBody => 'これにより、会話が完全に削除されます。';

  @override
  String get cancel => 'キャンセル';

  @override
  String get clear => '消去';

  @override
  String get selectCharacterFirst => '最初にキャラクター画像を選択してください。';

  @override
  String get failedToUpdateImage => '画像の更新に失敗しました。';

  @override
  String errorOccurred(Object error) {
    return 'エラーが発生しました: $error';
  }

  @override
  String get characterDidNotRespond => 'キャラクターが応答しませんでした。';

  @override
  String get viveChat => 'ViveChat';

  @override
  String get clearChatHistoryTooltip => 'チャット履歴を消去';

  @override
  String get emotionGalleryTooltip => '感情ギャラリー';

  @override
  String get justUpdateImage => '画像のみ更新';

  @override
  String get chatWithCharacter => 'キャラクターとチャット...';

  @override
  String get characterEmotionGallery => 'キャラクター感情ギャラリー';

  @override
  String get noEmotionalImages => '感情画像はまだ生成されていません。';

  @override
  String get original => 'オリジナル';

  @override
  String get imageSavedToGallery => '画像がギャラリーに保存されました';

  @override
  String get failedToSaveImage => '画像の保存に失敗しました';

  @override
  String get imageNotAvailable => '画像を利用できません';
}
