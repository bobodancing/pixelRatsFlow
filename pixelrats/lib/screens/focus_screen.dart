import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pixelrats/l10n/app_localizations.dart';
import '../controllers/timer_controller.dart';
import '../models/enums.dart';
import '../utils/app_theme.dart';
import '../utils/constants.dart';
import '../utils/web_visibility.dart' as web_vis;
import '../widgets/long_press_cancel_button.dart';

class FocusScreen extends ConsumerStatefulWidget {
  const FocusScreen({super.key, required this.mode});

  final FocusMode mode;

  @override
  ConsumerState<FocusScreen> createState() => _FocusScreenState();
}

class _FocusScreenState extends ConsumerState<FocusScreen> {
  Timer? _tickTimer;
  Timer? _localCheckpointTimer;
  DateTime? _leaveTime;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(timerControllerProvider.notifier).start(widget.mode);
      _tickTimer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (!mounted) return;
        ref.read(timerControllerProvider.notifier).tick();
      });

      // localStorage checkpoint every 30 seconds
      _localCheckpointTimer = Timer.periodic(
        const Duration(seconds: RCDefaults.localCheckpointSeconds),
        (_) => _saveLocalCheckpoint(),
      );

      // Recover from any stored leave time (browser kill recovery)
      _recoverFromLocalStorage();

      // Wire up visibilitychange listener
      web_vis.addVisibilityListener(_onVisibilityChange);
    });
  }

  void _onVisibilityChange(bool isHidden) {
    if (!mounted) return;
    if (isHidden) {
      _leaveTime = DateTime.now();
      web_vis.saveToLocalStorage('leave_time', _leaveTime!.toIso8601String());
      ref.read(timerControllerProvider.notifier).handleLeave();
    } else {
      final leaveTime = _leaveTime ?? _parseStoredLeaveTime();
      if (leaveTime == null) return;

      final awaySeconds = DateTime.now().difference(leaveTime).inSeconds;
      ref
          .read(timerControllerProvider.notifier)
          .handleReturn(awaySeconds: awaySeconds);
      _leaveTime = null;
      web_vis.removeFromLocalStorage('leave_time');
    }
  }

  DateTime? _parseStoredLeaveTime() {
    final stored = web_vis.readFromLocalStorage('leave_time');
    if (stored == null) return null;
    return DateTime.tryParse(stored);
  }

  void _recoverFromLocalStorage() {
    final storedLeaveTime = _parseStoredLeaveTime();
    if (storedLeaveTime == null) return;

    final awaySeconds = DateTime.now().difference(storedLeaveTime).inSeconds;
    ref
        .read(timerControllerProvider.notifier)
        .handleReturnFromStoredLeaveTime(awaySeconds: awaySeconds);
    web_vis.removeFromLocalStorage('leave_time');
  }

  void _saveLocalCheckpoint() {
    if (!mounted) return;
    final timerState = ref.read(timerControllerProvider);
    web_vis.saveToLocalStorage('session_mode', widget.mode.name);
    web_vis.saveToLocalStorage(
      'elapsed_seconds',
      timerState.elapsedSeconds.toString(),
    );
  }

  @override
  void dispose() {
    _tickTimer?.cancel();
    _localCheckpointTimer?.cancel();
    web_vis.removeVisibilityListener();
    // Clean up localStorage session data on normal exit
    web_vis.removeFromLocalStorage('leave_time');
    web_vis.removeFromLocalStorage('session_mode');
    web_vis.removeFromLocalStorage('elapsed_seconds');
    super.dispose();
  }

  void _handleShortCancel() {
    final l10n = AppLocalizations.of(context)!;
    final timerState = ref.read(timerControllerProvider);
    final elapsedMinutes = timerState.elapsedSeconds ~/ 60;

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
              ref.read(timerControllerProvider.notifier).cancel();
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
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final timerState = ref.watch(timerControllerProvider);

    if (timerState.isComplete) {
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
                      onPressed: _handleShortCancel,
                    )
                  : LongPressCancelButton(
                      holdDuration: const Duration(seconds: 3),
                      label: l10n.cancelHoldToCancel,
                      onCancelled: () {
                        ref.read(timerControllerProvider.notifier).cancel();
                        Navigator.pop(context);
                      },
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
                    _formatTime(timerState.remainingSeconds),
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
