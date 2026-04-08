/// Remote Config 預設值（Remote Config 取不到值時的 fallback）
class RCDefaults {
  RCDefaults._();

  // ── Gacha ──
  static const int gachaCostCheese = 120;

  // ── Cheese 獎勵 ──
  static const int cheeseRewardShort = 10;
  static const int cheeseRewardDeep = 25;
  static const int cheeseRewardFlow = 60;
  static const int cheeseRewardAd = 20;

  // ── Mood 獎勵 ──
  static const int moodRewardShort = 5;
  static const int moodRewardDeep = 10;
  static const int moodRewardFlow = 20;

  // ── Trust 獎勵 ──
  static const int trustRewardShort = 3;
  static const int trustRewardDeep = 5;
  static const int trustRewardFlow = 10;

  // ── Luck / Newbie ──
  static const double moodLuckCoefficient = 0.005;
  static const double trustNewbieMultiplier = 2.0;
  static const int trustNewbieDays = 7;

  // ── 稀有老鼠預覽 ──
  static const double rareRatBaseChance = 0.08;
  static const double rareRatMaxChance = 0.15;

  // ── Mood 離線衰減 ──
  static const int moodOfflineDecayHourly = 1;
  static const int moodOfflineDecayDaily = 5;
  static const int moodOfflineFloor = 30;

  // ── 廣告限制 ──
  static const int dailyAdGachaLimit = 3;
  static const int dailyAdMoodLimit = 2;

  // ── Checkpoint 策略 ──
  static const int localCheckpointSeconds = 30; // localStorage 本機存檔間隔
  static const int cloudSyncSeconds = 300; // Firestore 雲端同步間隔（5分鐘）

  // ── 每日互動 ──
  static const int dailyPetMoodLimit = 3;
  static const int petMoodReward = 3;
  static const int dailyLoginMoodReward = 5;
  static const int dailyLoginTrustReward = 2;
  static const int dailyLoginCheeseReward = 10; // MVP：僅免費 Cheese

  // ── 計時器模式（分鐘）──
  static const int shortMinutes = 25;
  static const int deepMinutes = 50;
  static const int flowMinutes = 100;

  // ── Grace Period ──
  static const int graceNoPenaltySeconds = 15;
  static const int graceWarningSeconds = 60;
  static const int gracePenaltyIntervalSeconds = 30;
  static const int gracePenaltyMoodPerInterval = 2;

  // ── 部分獎勵（取消防呆）──
  static const double partialRewardThreshold = 0.8;
  static const double partialRewardMultiplier = 0.8;
}
