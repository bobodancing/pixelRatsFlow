// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

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
