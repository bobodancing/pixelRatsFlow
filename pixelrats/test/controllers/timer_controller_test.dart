import 'package:flutter_test/flutter_test.dart';
import 'package:pixelrats/controllers/timer_controller.dart';
import 'package:pixelrats/models/enums.dart';
import 'package:pixelrats/utils/constants.dart';

void main() {
  late TimerLogic logic;

  setUp(() {
    logic = TimerLogic();
  });

  group('Timer basics', () {
    test('starts with correct duration for Short mode', () {
      logic.start(FocusMode.short);
      expect(logic.state.remainingSeconds, RCDefaults.shortMinutes * 60);
      expect(logic.state.isRunning, true);
    });

    test('starts with correct duration for Deep mode', () {
      logic.start(FocusMode.deep);
      expect(logic.state.remainingSeconds, RCDefaults.deepMinutes * 60);
    });

    test('starts with correct duration for Flow mode', () {
      logic.start(FocusMode.flow);
      expect(logic.state.remainingSeconds, RCDefaults.flowMinutes * 60);
    });
  });

  group('Grace Period — visibility change', () {
    test('15s return → no penalty, no event', () {
      logic.start(FocusMode.short);
      logic.handleLeave();
      logic.handleReturn(awaySeconds: 15);
      expect(logic.state.leaveEvents, isEmpty);
    });

    test('5s return → no penalty, no event (within grace)', () {
      logic.start(FocusMode.short);
      logic.handleLeave();
      logic.handleReturn(awaySeconds: 5);
      expect(logic.state.leaveEvents, isEmpty);
    });

    test('45s return → warning event, no mood loss', () {
      logic.start(FocusMode.short);
      logic.handleLeave();
      logic.handleReturn(awaySeconds: 45);
      expect(logic.state.leaveEvents.length, 1);
      expect(logic.state.leaveEvents.first.tier, 'warning');
      expect(logic.state.leaveEvents.first.moodLoss, 0);
    });

    test('90s return → penalty event, mood -2', () {
      logic.start(FocusMode.short);
      logic.handleLeave();
      logic.handleReturn(awaySeconds: 90);
      expect(logic.state.leaveEvents.length, 1);
      expect(logic.state.leaveEvents.first.tier, 'penalty');
      expect(logic.state.leaveEvents.first.moodLoss, 2);
    });

    test('180s return → penalty event, mood -8', () {
      logic.start(FocusMode.short);
      logic.handleLeave();
      logic.handleReturn(awaySeconds: 180);
      expect(logic.state.leaveEvents.length, 1);
      expect(logic.state.leaveEvents.first.tier, 'penalty');
      expect(logic.state.leaveEvents.first.moodLoss, 8);
    });

    test('multiple leaves accumulate correctly', () {
      logic.start(FocusMode.deep);
      logic.handleLeave();
      logic.handleReturn(awaySeconds: 45);
      logic.handleLeave();
      logic.handleReturn(awaySeconds: 90);
      expect(logic.state.leaveEvents.length, 2);
      expect(logic.state.leaveEvents[0].tier, 'warning');
      expect(logic.state.leaveEvents[1].tier, 'penalty');
      expect(logic.state.totalMoodLoss, 2);
    });
  });

  group('Browser kill → localStorage recovery', () {
    test('recovers leaveTime from stored string', () {
      logic.start(FocusMode.short);
      logic.handleReturnFromStoredLeaveTime(awaySeconds: 90);
      expect(logic.state.leaveEvents.length, 1);
      expect(logic.state.leaveEvents.first.tier, 'penalty');
      expect(logic.state.leaveEvents.first.moodLoss, 2);
    });

    test('no stored leave time → no penalty', () {
      logic.start(FocusMode.short);
      logic.handleReturnFromStoredLeaveTime(awaySeconds: null);
      expect(logic.state.leaveEvents, isEmpty);
    });
  });

  group('Session completion', () {
    test('session marks complete when time reaches zero', () {
      logic.start(FocusMode.short);
      logic.tick(RCDefaults.shortMinutes * 60);
      expect(logic.state.isComplete, true);
      expect(logic.state.isRunning, false);
    });
  });

  group('Partial rewards', () {
    test('cancelled session >80% complete gets partial flag', () {
      logic.start(FocusMode.short);
      final total = RCDefaults.shortMinutes * 60;
      logic.tick((total * 0.85).round());
      final result = logic.cancel();
      expect(result.qualifiesForPartialReward, true);
    });

    test('cancelled session <80% does not get partial flag', () {
      logic.start(FocusMode.short);
      final total = RCDefaults.shortMinutes * 60;
      logic.tick((total * 0.5).round());
      final result = logic.cancel();
      expect(result.qualifiesForPartialReward, false);
    });
  });

  group('Leave penalty multiplier', () {
    test('no leaves → leavePenalty = 1.0', () {
      logic.start(FocusMode.short);
      expect(logic.state.leavePenaltyMultiplier, 1.0);
    });

    test('1 penalty → leavePenalty = 0.8', () {
      logic.start(FocusMode.short);
      logic.handleLeave();
      logic.handleReturn(awaySeconds: 90);
      expect(logic.state.leavePenaltyMultiplier, 0.8);
    });

    test('1 warning → leavePenalty = 0.95', () {
      logic.start(FocusMode.short);
      logic.handleLeave();
      logic.handleReturn(awaySeconds: 45);
      expect(logic.state.leavePenaltyMultiplier, 0.95);
    });

    test('extreme leaves → clamped at 0.3', () {
      logic.start(FocusMode.flow);
      for (var i = 0; i < 5; i++) {
        logic.handleLeave();
        logic.handleReturn(awaySeconds: 90);
      }
      expect(logic.state.leavePenaltyMultiplier, 0.3);
    });
  });
}
