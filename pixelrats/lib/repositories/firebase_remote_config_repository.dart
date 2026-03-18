import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'remote_config_repository.dart';
import '../utils/constants.dart';

class FirebaseRemoteConfigRepository implements RemoteConfigRepository {
  final FirebaseRemoteConfig _rc = FirebaseRemoteConfig.instance;

  @override
  Future<void> initialize() async {
    await _rc.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: const Duration(hours: 1),
      ),
    );
    await _rc.setDefaults(<String, dynamic>{
      'gacha_cost_cheese': RCDefaults.gachaCostCheese,
      'local_checkpoint_seconds': RCDefaults.localCheckpointSeconds,
      'cloud_sync_seconds': RCDefaults.cloudSyncSeconds,
      'grace_nopenalty_seconds': RCDefaults.graceNoPenaltySeconds,
      'grace_warning_seconds': RCDefaults.graceWarningSeconds,
      'grace_penalty_interval_seconds': RCDefaults.gracePenaltyIntervalSeconds,
      'grace_penalty_mood_per_interval': RCDefaults.gracePenaltyMoodPerInterval,
      'short_minutes': RCDefaults.shortMinutes,
      'deep_minutes': RCDefaults.deepMinutes,
      'flow_minutes': RCDefaults.flowMinutes,
      'mood_luck_coefficient': RCDefaults.moodLuckCoefficient,
      'trust_newbie_multiplier': RCDefaults.trustNewbieMultiplier,
      'partial_reward_threshold': RCDefaults.partialRewardThreshold,
      'partial_reward_multiplier': RCDefaults.partialRewardMultiplier,
    });
    await _rc.fetchAndActivate();
  }

  @override
  int getInt(String key) => _rc.getInt(key);

  @override
  double getDouble(String key) => _rc.getDouble(key);

  @override
  String getString(String key) => _rc.getString(key);

  @override
  bool getBool(String key) => _rc.getBool(key);
}
