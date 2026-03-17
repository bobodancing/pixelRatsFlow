// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'PixelRats';

  @override
  String get cheeseLabel => 'Cheese';

  @override
  String get moodLabel => 'Mood';

  @override
  String get trustLabel => 'Trust';

  @override
  String get streakLabel => 'Streak';

  @override
  String get profileButton => 'Profile';

  @override
  String get settingsButton => 'Settings';

  @override
  String get startButton => 'Start';

  @override
  String get okButton => 'OK';

  @override
  String get focusModeShort => '25 min';

  @override
  String get focusModeDeep => '50 min';

  @override
  String get focusModeFlow => '100 min';

  @override
  String get focusModeShortLabel => 'Short Focus';

  @override
  String get focusModeDeepLabel => 'Deep Focus';

  @override
  String get focusModeFlowLabel => 'Flow';

  @override
  String focusScreenTitle(String mode, String duration) {
    return '$mode — $duration';
  }

  @override
  String get cancelConfirmTitle => 'Abandon session?';

  @override
  String cancelConfirmMessage(int minutes) {
    return 'You\'ve been focused for $minutes minutes. Are you sure you want to quit?';
  }

  @override
  String get cancelConfirmKeep => 'Keep focusing';

  @override
  String get cancelConfirmQuit => 'Quit';

  @override
  String get cancelHoldToCancel => 'Hold to cancel';

  @override
  String get sessionComplete => 'Session complete!';

  @override
  String get signInWithGoogle => 'Sign in with Google';

  @override
  String get moodStateSad => 'Sad';

  @override
  String get moodStateBored => 'Bored';

  @override
  String get moodStateNeutral => 'Neutral';

  @override
  String get moodStateHappy => 'Happy';

  @override
  String get moodStateEcstatic => 'Ecstatic';

  @override
  String get trustLevelStranger => 'Stranger';

  @override
  String get trustLevelFriend => 'Friend';

  @override
  String get trustLevelPartner => 'Partner';

  @override
  String get trustLevelFamily => 'Family';

  @override
  String get trustLevelSoulBond => 'Soul Bond';

  @override
  String get placeholderScreen => 'Coming Soon';

  @override
  String get daysSuffix => 'days';
}

/// The translations for Chinese, as used in Taiwan (`zh_TW`).
class AppLocalizationsZhTw extends AppLocalizationsZh {
  AppLocalizationsZhTw() : super('zh_TW');

  @override
  String get appTitle => 'PixelRats';

  @override
  String get cheeseLabel => '起司';

  @override
  String get moodLabel => '心情';

  @override
  String get trustLabel => '信任';

  @override
  String get streakLabel => '連續';

  @override
  String get profileButton => '個人檔案';

  @override
  String get settingsButton => '設定';

  @override
  String get startButton => '開始';

  @override
  String get okButton => '確定';

  @override
  String get focusModeShort => '25 分鐘';

  @override
  String get focusModeDeep => '50 分鐘';

  @override
  String get focusModeFlow => '100 分鐘';

  @override
  String get focusModeShortLabel => '短專注';

  @override
  String get focusModeDeepLabel => '深度專注';

  @override
  String get focusModeFlowLabel => '心流';

  @override
  String focusScreenTitle(String mode, String duration) {
    return '$mode — $duration';
  }

  @override
  String get cancelConfirmTitle => '放棄本次專注？';

  @override
  String cancelConfirmMessage(int minutes) {
    return '你已經專注了 $minutes 分鐘，確定要放棄嗎？';
  }

  @override
  String get cancelConfirmKeep => '繼續專注';

  @override
  String get cancelConfirmQuit => '放棄';

  @override
  String get cancelHoldToCancel => '長按取消';

  @override
  String get sessionComplete => '專注完成！';

  @override
  String get signInWithGoogle => '以 Google 帳號登入';

  @override
  String get moodStateSad => '難過';

  @override
  String get moodStateBored => '無聊';

  @override
  String get moodStateNeutral => '普通';

  @override
  String get moodStateHappy => '開心';

  @override
  String get moodStateEcstatic => '超開心';

  @override
  String get trustLevelStranger => '陌生人';

  @override
  String get trustLevelFriend => '朋友';

  @override
  String get trustLevelPartner => '夥伴';

  @override
  String get trustLevelFamily => '家人';

  @override
  String get trustLevelSoulBond => '靈魂伴侶';

  @override
  String get placeholderScreen => '敬請期待';

  @override
  String get daysSuffix => '天';
}
