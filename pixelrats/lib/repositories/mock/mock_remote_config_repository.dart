import '../remote_config_repository.dart';
import '../../utils/constants.dart';

class MockRemoteConfigRepository implements RemoteConfigRepository {
  final Map<String, dynamic> _overrides = {};

  @override
  Future<void> initialize() async {}

  void setOverride(String key, dynamic value) => _overrides[key] = value;

  @override
  int getInt(String key) => _overrides[key] as int? ?? _defaultInt(key);

  @override
  double getDouble(String key) =>
      _overrides[key] as double? ?? _defaultDouble(key);

  @override
  String getString(String key) => _overrides[key] as String? ?? '';

  @override
  bool getBool(String key) => _overrides[key] as bool? ?? false;

  int _defaultInt(String key) => switch (key) {
    'gacha_cost_cheese' => RCDefaults.gachaCostCheese,
    'local_checkpoint_seconds' => RCDefaults.localCheckpointSeconds,
    'cloud_sync_seconds' => RCDefaults.cloudSyncSeconds,
    'grace_nopenalty_seconds' => RCDefaults.graceNoPenaltySeconds,
    'grace_warning_seconds' => RCDefaults.graceWarningSeconds,
    'grace_penalty_interval_seconds' => RCDefaults.gracePenaltyIntervalSeconds,
    'grace_penalty_mood_per_interval' => RCDefaults.gracePenaltyMoodPerInterval,
    'short_minutes' => RCDefaults.shortMinutes,
    'deep_minutes' => RCDefaults.deepMinutes,
    'flow_minutes' => RCDefaults.flowMinutes,
    _ => 0,
  };

  double _defaultDouble(String key) => switch (key) {
    'mood_luck_coefficient' => RCDefaults.moodLuckCoefficient,
    'trust_newbie_multiplier' => RCDefaults.trustNewbieMultiplier,
    'partial_reward_threshold' => RCDefaults.partialRewardThreshold,
    'partial_reward_multiplier' => RCDefaults.partialRewardMultiplier,
    _ => 0.0,
  };
}
