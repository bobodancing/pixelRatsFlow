import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pixelrats/l10n/app_localizations.dart';
import '../models/enums.dart';
import '../utils/app_theme.dart';
import '../utils/constants.dart';
import '../widgets/long_press_cancel_button.dart';

class FocusScreen extends StatefulWidget {
  const FocusScreen({super.key, required this.mode});

  final FocusMode mode;

  @override
  State<FocusScreen> createState() => _FocusScreenState();
}

class _FocusScreenState extends State<FocusScreen> {
  late int _remainingSeconds;
  late int _totalSeconds;
  Timer? _timer;
  bool _isComplete = false;

  @override
  void initState() {
    super.initState();
    _totalSeconds = _getDurationMinutes(widget.mode) * 60;
    _remainingSeconds = _totalSeconds;
    _startTimer();
  }

  int _getDurationMinutes(FocusMode mode) => switch (mode) {
    FocusMode.short => RCDefaults.shortMinutes,
    FocusMode.deep => RCDefaults.deepMinutes,
    FocusMode.flow => RCDefaults.flowMinutes,
  };

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _timer?.cancel();
          _isComplete = true;
        }
      });
    });
  }

  void _handleCancel() {
    final l10n = AppLocalizations.of(context)!;
    final elapsedMinutes = (_totalSeconds - _remainingSeconds) ~/ 60;

    if (widget.mode == FocusMode.short) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: AppColors.bgCard,
          title: Text(
            l10n.cancelConfirmTitle,
            style: const TextStyle(color: AppColors.textCream),
          ),
          content: Text(
            l10n.cancelConfirmMessage(elapsedMinutes),
            style: const TextStyle(color: AppColors.textLavender),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                l10n.cancelConfirmKeep,
                style: const TextStyle(color: AppColors.purple),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.pop(context);
              },
              child: Text(
                l10n.cancelConfirmQuit,
                style: const TextStyle(color: AppColors.moodCoral),
              ),
            ),
          ],
        ),
      );
    }
  }

  String _formatTime(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  String _getModeLabel(AppLocalizations l10n) => switch (widget.mode) {
    FocusMode.short => l10n.focusModeShortLabel,
    FocusMode.deep => l10n.focusModeDeepLabel,
    FocusMode.flow => l10n.focusModeFlowLabel,
  };

  String _getModeDuration(AppLocalizations l10n) => switch (widget.mode) {
    FocusMode.short => l10n.focusModeShort,
    FocusMode.deep => l10n.focusModeDeep,
    FocusMode.flow => l10n.focusModeFlow,
  };

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (_isComplete) {
      return Scaffold(
        backgroundColor: AppColors.bgDark,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(l10n.sessionComplete, style: AppTypography.rewardTitle),
              const SizedBox(height: 24),
              ElevatedButton(
                style: AppButtonStyles.primary,
                onPressed: () => Navigator.pop(context),
                child: Text(l10n.okButton),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.bgDark,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 16,
              left: 16,
              child: widget.mode == FocusMode.short
                  ? IconButton(
                      icon: const Icon(Icons.close, color: AppColors.textCream),
                      onPressed: _handleCancel,
                    )
                  : LongPressCancelButton(
                      holdDuration: const Duration(seconds: 3),
                      label: l10n.cancelHoldToCancel,
                      onCancelled: () => Navigator.pop(context),
                    ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    l10n.focusScreenTitle(
                      _getModeLabel(l10n),
                      _getModeDuration(l10n),
                    ),
                    style: AppTypography.subtitle,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    _formatTime(_remainingSeconds),
                    style: AppTypography.splashTitle.copyWith(fontSize: 48),
                  ),
                  const SizedBox(height: 48),
                  Container(
                    width: 128,
                    height: 128,
                    decoration: BoxDecoration(
                      color: AppColors.bgCard.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Center(
                      child: Text('🐭', style: TextStyle(fontSize: 48)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
