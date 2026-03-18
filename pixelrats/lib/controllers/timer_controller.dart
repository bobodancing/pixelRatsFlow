import 'dart:math';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/enums.dart';
import '../utils/constants.dart';

part 'timer_controller.g.dart';

/// A leave event recorded during a focus session.
class LeaveEvent {
  const LeaveEvent({
    required this.tier,
    required this.moodLoss,
    required this.awaySeconds,
    required this.timestamp,
  });

  final String tier; // 'warning' or 'penalty'
  final int moodLoss;
  final int awaySeconds;
  final DateTime timestamp;
}

/// Result of cancelling a session.
class CancelResult {
  const CancelResult({
    required this.elapsedSeconds,
    required this.totalSeconds,
    required this.qualifiesForPartialReward,
  });

  final int elapsedSeconds;
  final int totalSeconds;
  final bool qualifiesForPartialReward;
}

/// Immutable timer state.
class TimerState {
  const TimerState({
    this.mode,
    this.remainingSeconds = 0,
    this.totalSeconds = 0,
    this.isRunning = false,
    this.isComplete = false,
    this.leaveEvents = const [],
  });

  final FocusMode? mode;
  final int remainingSeconds;
  final int totalSeconds;
  final bool isRunning;
  final bool isComplete;
  final List<LeaveEvent> leaveEvents;

  int get elapsedSeconds => totalSeconds - remainingSeconds;

  int get totalMoodLoss => leaveEvents.fold(0, (sum, e) => sum + e.moodLoss);

  double get leavePenaltyMultiplier {
    final penalties = leaveEvents.where((e) => e.tier == 'penalty').length;
    final warnings = leaveEvents.where((e) => e.tier == 'warning').length;
    return max(0.3, 1.0 - (penalties * 0.2) - (warnings * 0.05));
  }

  TimerState copyWith({
    FocusMode? mode,
    int? remainingSeconds,
    int? totalSeconds,
    bool? isRunning,
    bool? isComplete,
    List<LeaveEvent>? leaveEvents,
  }) {
    return TimerState(
      mode: mode ?? this.mode,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      totalSeconds: totalSeconds ?? this.totalSeconds,
      isRunning: isRunning ?? this.isRunning,
      isComplete: isComplete ?? this.isComplete,
      leaveEvents: leaveEvents ?? this.leaveEvents,
    );
  }
}

/// Pure business logic for the focus timer — testable without Flutter.
class TimerLogic {
  TimerState _state = const TimerState();
  bool _hasLeft = false;

  TimerState get state => _state;

  void start(FocusMode mode) {
    final totalSeconds = _getDurationMinutes(mode) * 60;
    _state = TimerState(
      mode: mode,
      remainingSeconds: totalSeconds,
      totalSeconds: totalSeconds,
      isRunning: true,
    );
    _hasLeft = false;
  }

  int _getDurationMinutes(FocusMode mode) => switch (mode) {
    FocusMode.short => RCDefaults.shortMinutes,
    FocusMode.deep => RCDefaults.deepMinutes,
    FocusMode.flow => RCDefaults.flowMinutes,
  };

  void handleLeave() {
    _hasLeft = true;
  }

  void handleReturn({required int awaySeconds}) {
    if (!_hasLeft) return;
    _processReturn(awaySeconds);
    _hasLeft = false;
  }

  void handleReturnFromStoredLeaveTime({required int? awaySeconds}) {
    if (awaySeconds == null) return;
    _processReturn(awaySeconds);
  }

  void _processReturn(int awaySeconds) {
    if (awaySeconds <= RCDefaults.graceNoPenaltySeconds) return;

    if (awaySeconds <= RCDefaults.graceWarningSeconds) {
      _state = _state.copyWith(
        leaveEvents: [
          ..._state.leaveEvents,
          LeaveEvent(
            tier: 'warning',
            moodLoss: 0,
            awaySeconds: awaySeconds,
            timestamp: DateTime.now(),
          ),
        ],
      );
    } else {
      final penaltySeconds = awaySeconds - RCDefaults.graceWarningSeconds;
      final intervals =
          penaltySeconds ~/ RCDefaults.gracePenaltyIntervalSeconds;
      final moodLoss = intervals * RCDefaults.gracePenaltyMoodPerInterval;
      _state = _state.copyWith(
        leaveEvents: [
          ..._state.leaveEvents,
          LeaveEvent(
            tier: 'penalty',
            moodLoss: moodLoss,
            awaySeconds: awaySeconds,
            timestamp: DateTime.now(),
          ),
        ],
      );
    }
  }

  void tick(int seconds) {
    final newRemaining = max(0, _state.remainingSeconds - seconds);
    _state = _state.copyWith(
      remainingSeconds: newRemaining,
      isComplete: newRemaining == 0,
      isRunning: newRemaining > 0,
    );
  }

  CancelResult cancel() {
    final elapsed = _state.elapsedSeconds;
    final total = _state.totalSeconds;
    final ratio = total > 0 ? elapsed / total : 0.0;
    _state = _state.copyWith(isRunning: false);
    return CancelResult(
      elapsedSeconds: elapsed,
      totalSeconds: total,
      qualifiesForPartialReward: ratio >= RCDefaults.partialRewardThreshold,
    );
  }
}

/// Riverpod Notifier wrapping TimerLogic.
@riverpod
class TimerController extends _$TimerController {
  final TimerLogic _logic = TimerLogic();

  @override
  TimerState build() => const TimerState();

  TimerLogic get logic => _logic;

  void start(FocusMode mode) {
    _logic.start(mode);
    state = _logic.state;
  }

  void tick() {
    _logic.tick(1);
    state = _logic.state;
  }

  void handleLeave() {
    _logic.handleLeave();
  }

  void handleReturn({required int awaySeconds}) {
    _logic.handleReturn(awaySeconds: awaySeconds);
    state = _logic.state;
  }

  void handleReturnFromStoredLeaveTime({required int? awaySeconds}) {
    _logic.handleReturnFromStoredLeaveTime(awaySeconds: awaySeconds);
    state = _logic.state;
  }

  CancelResult cancel() {
    final result = _logic.cancel();
    state = _logic.state;
    return result;
  }
}
