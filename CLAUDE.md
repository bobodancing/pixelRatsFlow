# Claude_Code_Execution_Master.md — PixelRats 唯一入口檔

> ⚠️ **Claude Code 必讀：這是最高優先級文件。所有指令以本檔為準。**
> 當本檔內容與 Ch1–Ch4 衝突時，以本檔為準。
> 版本：v1.3（2026/03/15 — 美術 pipeline 改為 pre-positioned 圖層疊加，移除 anchors.json）

---

## Current Sprint Status

| Sprint | Step | 狀態 | 說明 |
|--------|------|------|------|
| **Sprint 0** | 0-1: Git 初始化 | ✅ Done | .gitignore + initial commit |
| | 0-2: 資產重命名 | ✅ Done | rat_base_{state} format |
| | 0-3: 補完剩餘動畫 | ✅ Done | 8 states 全部到位 |
| | 0-4: 配件製作 | 🔶 In Progress | Devil horns/wings 4/6 states done, idle+confused pending |
| | 0-5: CLAUDE.md 同步更新 | ✅ Done | v1.2 美術 pipeline 對齊 |
| | 0-6: Sprite sheet + 驗證 | ⬜ Pending | blocked on 0-4 |
| **Sprint 1** | 1-1 ~ 1-3 | ⬜ Pending | Flutter 骨架 + 計時器 |
| **Sprint 2** | 2-1 ~ 2-3 | ⬜ Pending | Flame 動畫 + 場景 |
| **Sprint 3** | 3-1 ~ 3-3 | ⬜ Pending | Mood + Trust + Gacha |

---

## 0. 執行順序鐵律

```
1. 先完整閱讀本檔（Claude_Code_Execution_Master.md）
2. 依序讀 Ch1.md → Ch2.md → Ch3.md（僅取經濟數值與 Remote Config）→ Ch4.md
3. 開發時以本檔的「MVP 強制邊界」與「架構鐵律」為最高準則
4. 任何功能實作前，先確認是 Must-Have 還是 Nice-to-Have
```

---

## 1. MVP 強制邊界（任何功能不得違反）

```
✅ 純免費 Web PWA（Firebase Hosting）
✅ Flutter Web + Flame 引擎（WebGL）
✅ 帳號僅 Google 登入（Apple 登入 MVP 略過）
✅ 所有經濟數值 100% 走 Firebase Remote Config（絕不 hardcode）
✅ 目標：Day 7 留存 > 35%（唯一 KPI）

❌ 無 Gold Cheese、無 IAP、無月卡、無場景包（Ch3 相關內容為 Phase 2 預留）
❌ 無 AdMob（用 AdSense for Games，申請不過則完全無廣告）
❌ 無 RevenueCat
❌ 無 Apple 登入
❌ 無 NFT / Solana（Phase 2）
❌ 無 Personality 人格系統（Phase 2）
```

---

## 2. 優先級鐵則

### Must-Have（Sprint 1–3 必須 100% 完成，否則不進 Sprint 4）

1. 專注計時器 + Timestamp Diffing + 三層 Grace Period（Web visibilitychange）
2. Flame 老鼠 8 狀態動畫 + 3 部位配件圖層疊加系統
3. Mood（0–100，離線底線 30）+ Trust（0–1000，永不衰減）完整計算
4. Cheese 免費經濟 + Gacha（Trust 分池 + Mood luck 線性公式）
5. 離線衰減、streak、每 30 秒 Firestore checkpoint、Firestore 安全規則
6. i18n 雙語（繁體中文 + 英文）
7. Firebase Auth（Google 登入）+ Remote Config

8. 白噪音 + 互動音效（audioplayers，備選 Howler.js）

### Nice-to-Have（Sprint 4–6 再做）

- 稀有老鼠預覽（8% 機率）
- 截圖分享（Web Share API）
- AdSense for Games 整合
- PWA manifest.json + service worker + 離線 fallback
- 回歸彈窗（「老鼠想你了」）
- Dark Mode 色盤統一打磨

---

## 3. 開發方法論：Mock-First 三段式

**每個 Sprint 內的每個功能都必須遵循此順序：**

```
Step 1: UI & Mock
  → 用 hardcode 假資料刻出 UI
  → 確認畫面、互動、i18n 都正確
  → commit: "feat: [功能名] UI with mock data"

Step 2: State & Logic
  → 引入 Riverpod，將邏輯寫成獨立 Provider
  → 寫 Unit Test 驗證所有邏輯（含邊界情況）
  → Mock Repository 替代真實 Firebase
  → commit: "feat: [功能名] state management + tests"

Step 3: Integration
  → 實作真實 FirebaseRepository 替換 MockRepository
  → 整合 Remote Config
  → 端對端驗證
  → commit: "feat: [功能名] Firebase integration"
```

**禁止：** 一個 commit 裡同時做 UI + 邏輯 + Firebase 整合。

---

## 4. 架構鐵律

### 4.1 狀態管理：Riverpod 2.x（嚴格規範）

```
✅ 統一使用 Riverpod 2.x（Notifier / AsyncNotifier）
✅ 必須使用 riverpod_annotation + build_runner 生成程式碼
✅ 所有 Provider 都要 @riverpod 註解

❌ 嚴禁使用舊版 StateNotifier / StateNotifierProvider
❌ 嚴禁使用 ChangeNotifier
❌ 嚴禁在 UI Widget 內直接操作 Firestore
```

### 4.2 三層架構（必須嚴格遵守）

```
lib/
├── repositories/        ← Layer 1: 資料層
│   ├── auth_repository.dart         # Firebase Auth
│   ├── firestore_repository.dart    # Firestore CRUD
│   ├── remote_config_repository.dart # Remote Config
│   └── mock/
│       ├── mock_firestore_repository.dart  # 測試用
│       └── mock_remote_config_repository.dart
│
├── controllers/         ← Layer 2: 業務邏輯層（Riverpod Providers）
│   ├── timer_controller.dart        # 專注計時 + Grace Period
│   ├── mood_trust_controller.dart   # Mood + Trust 計算
│   ├── cheese_controller.dart       # Cheese 經濟
│   ├── gacha_controller.dart        # 抽取邏輯 + luck
│   ├── streak_controller.dart       # 連續天數
│   └── rat_animation_controller.dart # 老鼠動畫狀態機
│
├── models/              ← 資料模型（freezed + json_serializable）
│   ├── rat_model.dart
│   ├── item_model.dart
│   ├── session_model.dart
│   ├── gacha_result_model.dart
│   └── enums.dart                   # MoodState, TrustLevel, Rarity, FocusMode
│
├── game/                ← Flame 遊戲邏輯
│   ├── pixel_rats_game.dart
│   ├── components/
│   │   ├── rat_component.dart       # 老鼠本體
│   │   ├── accessory_component.dart # 配件圖層（同座標疊加）
│   │   └── scene_component.dart     # 場景背景
│
├── screens/             ← Layer 3: UI 層
│   ├── home_screen.dart
│   ├── focus_screen.dart
│   ├── gacha_screen.dart
│   ├── profile_screen.dart
│   └── settings_screen.dart
│
├── widgets/             ← 可重用 UI 元件
│   ├── mood_indicator.dart
│   ├── trust_badge.dart
│   ├── cheese_counter.dart
│   └── focus_mode_selector.dart
│
├── l10n/                ← i18n
│   ├── app_en.arb
│   └── app_zh_TW.arb
│
├── utils/               ← 工具類
│   ├── constants.dart               # 常數（僅 Remote Config fallback）
│   └── timestamp_utils.dart         # 時間計算工具
│
├── app.dart
└── main.dart

web/
├── index.html
├── manifest.json
└── icons/
```

**規則：**
- `repositories/` 只負責與外部服務溝通（Firestore、Remote Config、Auth）
- `controllers/` 只負責業務邏輯與狀態計算，透過 Repository 介面操作資料
- `screens/` 和 `widgets/` 只負責讀取狀態與繪製 UI，**嚴禁在 UI 層寫業務邏輯**
- `game/` 是 Flame 引擎專屬，透過 `flame_riverpod` 套件橋接 Controller 狀態來驅動動畫

### 4.3 Repository 介面模式

```dart
// 必須定義抽象介面，方便 Mock 替換
abstract class FirestoreRepository {
  Future<RatModel> getRat(String userId);
  Future<void> updateMood(String userId, int mood);
  Future<void> updateTrust(String userId, int trust);
  Future<void> saveFocusSession(FocusSession session);
  Future<List<ItemModel>> getInventory(String userId);
  Future<void> addItem(String userId, ItemModel item);
  Future<void> saveCheckpoint(String userId, Map<String, dynamic> data);
}

// 真實實作
class FirebaseFirestoreRepository implements FirestoreRepository { ... }

// Mock 實作（開發與測試用）
class MockFirestoreRepository implements FirestoreRepository { ... }
```

---

## 5. 核心公式（精確程式碼，Claude 必須 copy-paste）

### 5.1 Grace Period（Web 版 visibilitychange）

```dart
// ⚠️ 使用 package:web，不使用已棄用的 dart:html
import 'package:web/web.dart' as web;
import 'dart:async';

class TimerController {
  DateTime? _leaveTime;
  Timer? _checkpointTimer;
  final FirestoreRepository _repo;

  void init() {
    web.document.addEventListener('visibilitychange', (web.Event _) {
      if (web.document.hidden) {
        _onPageHidden();
      } else {
        _onPageVisible();
      }
    }.toJS);
    // 每 30 秒自動 checkpoint 到 Firestore（防瀏覽器殺進程）
    _checkpointTimer = Timer.periodic(
      const Duration(seconds: 30),
      (_) => _saveCheckpoint(),
    );
  }

  void _onPageHidden() {
    _leaveTime = DateTime.now();
    // 立即寫入 localStorage 作為備份
    web.window.localStorage.setItem('leave_time', _leaveTime!.toIso8601String());
  }

  void _onPageVisible() {
    final leaveTime = _leaveTime ??
        DateTime.tryParse(web.window.localStorage.getItem('leave_time') ?? '');
    if (leaveTime == null) return;

    final awaySeconds = DateTime.now().difference(leaveTime).inSeconds;

    if (awaySeconds <= 15) {
      // Grace Period：完全不懲罰
      return;
    } else if (awaySeconds <= 60) {
      // Warning：標記品質降級，老鼠困惑
      _addLeaveEvent(leaveTime, 'warning');
      _setRatState(RatAnimationState.confused);
    } else {
      // Penalty：Mood 下降
      _addLeaveEvent(leaveTime, 'penalty');
      final penaltySeconds = awaySeconds - 60;
      final moodLoss = (penaltySeconds / 30).floor() * 2;
      _applyMoodPenalty(moodLoss);
      _setRatState(RatAnimationState.sad);
    }

    _leaveTime = null;
  }
}
```

### 5.2 Mood 離線衰減

```dart
void calculateOfflineMoodDecay(RatModel rat) {
  final now = DateTime.now();
  final hours = now.difference(rat.lastMoodUpdate).inHours;
  final days = now.difference(rat.lastMoodUpdate).inDays;

  // 每小時 -1，連續未開每天額外 -5
  final decay = hours + days * 5;

  // 離線衰減底線：30（Bored），絕不會掉到 Sad
  const OFFLINE_MOOD_FLOOR = 30;
  rat.mood = max(OFFLINE_MOOD_FLOOR, rat.mood - decay);
  rat.lastMoodUpdate = now;

  // ⚠️ Sad（0–20）只能由專注期間離開 App 超過 60 秒觸發
  // 離線衰減永遠不會把 Mood 推到 30 以下
}
```

### 5.3 Focus Session 結算

```dart
void calculateSessionRewards(FocusMode mode, List<LeaveEvent> events, int currentMood) {
  // 基礎獎勵
  final baseMood = {FocusMode.short: 5, FocusMode.deep: 10, FocusMode.flow: 20}[mode]!;
  final baseTrust = {FocusMode.short: 3, FocusMode.deep: 5, FocusMode.flow: 10}[mode]!;
  final baseCheese = {FocusMode.short: 10, FocusMode.deep: 25, FocusMode.flow: 60}[mode]!;

  // Grace Period 離開懲罰
  final penalties = events.where((e) => e.tier == 'penalty').length;
  final warnings = events.where((e) => e.tier == 'warning').length;
  final leavePenalty = max(0.3, 1.0 - (penalties * 0.2) - (warnings * 0.05));

  // Mood 加成 Trust
  final trustMultiplier = currentMood >= 60 ? 1.25 : 1.0;

  // 最終計算
  final moodEarned = (baseMood * leavePenalty).round();
  final trustEarned = (baseTrust * leavePenalty * trustMultiplier).round();
  final cheeseEarned = (baseCheese * leavePenalty * (currentMood >= 80 ? 1.2 : 1.0)).round();

  // 新手 Trust 加速（前 7 天 ×2）
  final daysSinceCreation = DateTime.now().difference(user.createdAt).inDays;
  final newbieMultiplier = daysSinceCreation < remoteConfig.getInt('trust_newbie_days')
      ? remoteConfig.getDouble('trust_newbie_multiplier')
      : 1.0;
  final finalTrust = (trustEarned * newbieMultiplier).round();
}
```

### 5.4 Gacha Luck（精確 normalize 公式）

```dart
GachaResult pullGacha(int currentMood, String trustLevel, int cheeseBalance) {
  assert(cheeseBalance >= remoteConfig.getInt('gacha_cost_cheese'));

  // Mood luck modifier：線性 (mood - 50) * 0.005 = -0.25 ~ +0.25
  final luckMod = (currentMood - 50) * remoteConfig.getDouble('mood_luck_coefficient');

  // 基礎機率（依 Trust Pool 決定可抽到的最高稀有度）
  Map<Rarity, double> baseProbs = _getPoolProbs(trustLevel);

  // 套用 luck modifier 並 normalize
  final adjusted = baseProbs.map((rarity, prob) => MapEntry(rarity, prob * (1 + luckMod)));
  final total = adjusted.values.reduce((a, b) => a + b);
  final normalized = adjusted.map((rarity, prob) => MapEntry(rarity, prob / total));

  // 加權隨機抽取
  final roll = Random().nextDouble();
  double cumulative = 0;
  for (final entry in normalized.entries) {
    cumulative += entry.value;
    if (roll <= cumulative) {
      return _generateItem(entry.key);
    }
  }
  return _generateItem(Rarity.common); // fallback
}

Map<Rarity, double> _getPoolProbs(String trustLevel) {
  switch (trustLevel) {
    case 'stranger': return {Rarity.common: 1.0};
    case 'friend':   return {Rarity.common: 0.70, Rarity.rare: 0.30};
    case 'partner':  return {Rarity.common: 0.60, Rarity.rare: 0.25, Rarity.epic: 0.15};
    case 'family':   return {Rarity.common: 0.60, Rarity.rare: 0.25, Rarity.epic: 0.10, Rarity.legend: 0.05};
    default:         return {Rarity.common: 1.0};
  }
}
```

### 5.5 稀有老鼠預覽機率

```dart
bool shouldShowRareRatPreview(int currentMood) {
  final baseChance = remoteConfig.getDouble('rare_rat_base_chance'); // 0.08
  final maxChance = remoteConfig.getDouble('rare_rat_max_chance');   // 0.15
  final moodMod = 1.0 + (currentMood - 50) * 0.002;
  final finalChance = min(maxChance, baseChance * moodMod);
  return Random().nextDouble() < finalChance;
}
```

---

## 6. 測試驅動開發（TDD）要求

### 6.1 規則

```
核心邏輯（Timer、Mood、Trust、Cheese、Gacha）：
  → 必須先寫 Unit Test
  → 測試通過後才能串接 UI
  → 測試必須使用 MockRepository

UI 元件：
  → Widget Test 可選，但鼓勵
```

### 6.2 必寫測試案例（最低要求）

**TimerController Tests：**
```
✅ 15 秒內回歸 → 無懲罰、無事件記錄
✅ 45 秒回歸 → warning 事件、老鼠 confused、Mood 不扣
✅ 90 秒回歸 → penalty 事件、Mood -2（(90-60)/30 = 1 次扣分）
✅ 180 秒回歸 → penalty 事件、Mood -8（(180-60)/30 = 4 次扣分）
✅ 多次離開累計計算正確
✅ 瀏覽器殺進程後從 localStorage 恢復 leaveTime
```

**MoodTrustController Tests：**
```
✅ Short Focus 完成 → Mood +5, Trust +3, Cheese +10
✅ Deep Focus + Mood 80 完成 → Cheese +25 × 1.2 = +30
✅ Flow Focus + 1 penalty 離開 → 獎勵 × 0.8
✅ Mood 65 時完成 → Trust ×1.25 加成
✅ 離線 3 小時 → Mood -3（不低於 30）
✅ 離線 3 天 → Mood -(72 + 15) = -87，但底線 30
✅ Trust 永不因任何原因下降
✅ 新手第 5 天 → Trust ×2 加速
✅ 第 8 天 → Trust 加速結束，回歸 ×1
✅ 摸老鼠 3 次 → Mood +9，第 4 次無效
```

**CheeseController Tests：**
```
✅ 抽取消耗 120 Cheese
✅ 餘額不足時無法抽取
✅ 重複配件分解回收 Cheese（數量正確）
```

**GachaController Tests：**
```
✅ Trust stranger → 只能抽到 Common
✅ Trust friend → Common + Rare
✅ Trust family → 全部稀有度可抽
✅ Mood 0 → luck -25%，Common 機率上升
✅ Mood 100 → luck +25%，高稀有度機率上升
✅ 所有機率 normalize 後總和 = 1.0
✅ 1000 次模擬抽取分佈在合理範圍（±3%）
```

**StreakController Tests：**
```
✅ 連續 7 天 → Trust 獎勵從 +2 升為 +5
✅ 斷連 1 天 → streak 歸 1、Trust 不扣、Mood 不扣
✅ 斷連 3 天 → 觸發回歸彈窗標記 + Mood +10 補償
```

---

## 7. Remote Config 預設值（hardcode 在程式碼作為 fallback）

```dart
// utils/constants.dart — Remote Config 取不到值時的 fallback
class RCDefaults {
  static const int gachaCostCheese = 120;
  static const int cheeseRewardShort = 10;
  static const int cheeseRewardDeep = 25;
  static const int cheeseRewardFlow = 60;
  static const int cheeseRewardAd = 20;
  static const int moodRewardShort = 5;
  static const int moodRewardDeep = 10;
  static const int moodRewardFlow = 20;
  static const int trustRewardShort = 3;
  static const int trustRewardDeep = 5;
  static const int trustRewardFlow = 10;
  static const double moodLuckCoefficient = 0.005;
  static const double trustNewbieMultiplier = 2.0;
  static const int trustNewbieDays = 7;
  static const double rareRatBaseChance = 0.08;
  static const double rareRatMaxChance = 0.15;
  static const int moodOfflineDecayHourly = 1;
  static const int moodOfflineDecayDaily = 5;
  static const int moodOfflineFloor = 30;
  static const int dailyAdGachaLimit = 3;
  static const int dailyAdMoodLimit = 2;
  static const int checkpointIntervalSeconds = 30;
  static const int dailyPetMoodLimit = 3;
  static const int petMoodReward = 3;
  static const int dailyLoginMoodReward = 5;
  static const int dailyLoginTrustReward = 2;
  static const int dailyLoginCheeseReward = 10;  // MVP：僅免費 Cheese
}
```

---

## 8. 美術資產命名規範

### 8.1 美術 Pipeline：Pre-positioned 圖層疊加

```
⚠️ 配件不使用錨點系統（anchors.json）。
每個配件的每個動畫狀態都是完整 64x64 canvas，
配件已在畫布上對齊老鼠位置，渲染時同座標疊加即可。

配件顯示規則：
- studying、sleeping 狀態不顯示任何配件
- 其餘 6 個狀態（idle, eating, confused, sad, happy, walking）顯示配件
```

### 8.2 目錄結構

```
sprites/
├── rat/                            # 老鼠本體（.ase 原檔）
│   ├── rat_base_idle.ase
│   ├── rat_base_studying.ase
│   ├── rat_base_eating.ase
│   ├── rat_base_confused.ase
│   ├── rat_base_sad.ase
│   ├── rat_base_happy.ase
│   ├── rat_base_sleeping.ase
│   └── rat_base_walking.ase
│
├── items/                          # 配件（pre-positioned 64x64）
│   ├── head/
│   │   └── devil_horns/            # 資料夾名 = 配件 ID（snake_case）
│   │       ├── idle.ase
│   │       ├── eating.ase
│   │       ├── confused.ase
│   │       ├── sad.ase
│   │       ├── happy.ase
│   │       └── walking.ase
│   ├── back/
│   │   └── devil_wings/
│   │       ├── idle.ase
│   │       ├── eating.ase
│   │       ├── confused.ase
│   │       ├── sad.ase
│   │       ├── happy.ase
│   │       └── walking.ase
│   └── bg/                         # 背景配件（未來）
│
assets/                             # Flutter build 用（export 產出）
├── sprites/
│   ├── rat_spritesheet.png         # 合併後的 sprite sheet
│   └── items/
│       ├── head/devil_horns/       # 配件 sprite sheets（per state）
│       └── back/devil_wings/
├── backgrounds/
│   ├── bg_library.png
│   ├── bg_cafe.png
│   └── bg_park.png
├── audio/
│   ├── bgm_library_01.mp3
│   ├── bgm_cafe_01.mp3
│   └── bgm_park_01.mp3
└── ui/
    ├── icon_cheese.png
    ├── icon_mood_sad.png
    ├── icon_mood_happy.png
    └── icon_trust_friend.png
```

### 8.3 命名規則

```
- 全部小寫、底線分隔
- 老鼠本體 .ase：rat_base_{state}.ase
- 配件資料夾：items/{slot}/{accessory_name}/（snake_case）
- 配件動畫 .ase：{state}.ase（與老鼠 state 名稱對應）
- slot: head / back / bg
- rarity 不放檔名，由程式端 items_catalog.json 定義
- 背景場景：bg_{name}
- 音效：bgm_{scene}_{id}
```

---

## 9. 老鼠美術注意事項

```
⚠️ 重要：老鼠臉頰上的紅色小圓點是「腮紅（blush）」，不是眼睛。
老鼠的眼睛是黑色的、在頭部上方。
在擴充美術時，「head」配件的定位基準是頭頂（兩耳之間），不是腮紅位置。
```

---

## 10. Firestore 安全規則（完整版）

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // 用戶只能讀寫自己的資料
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
      match /inventory/{itemId} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }
    }
    // 專注記錄只能由自己建立，不可修改或刪除
    match /focus_sessions/{sessionId} {
      allow create: if request.auth != null
        && request.resource.data.user_id == request.auth.uid;
      allow read: if request.auth != null
        && resource.data.user_id == request.auth.uid;
      allow update, delete: if false;
    }
    // 抽取記錄只能建立和讀取
    match /gacha_log/{logId} {
      allow create: if request.auth != null;
      allow read: if request.auth != null
        && resource.data.user_id == request.auth.uid;
      allow update, delete: if false;
    }
  }
}
```

---

## 11. Analytics 事件清單

| 事件名稱 | 觸發時機 | 參數 |
|---------|---------|------|
| `focus_start` | 開始專注 | mode, mood_before, trust_level |
| `focus_complete` | 專注完成 | mode, mood_earned, trust_earned, cheese_earned, leave_count |
| `focus_abandon` | 中途放棄 | mode, elapsed_seconds, mood_before |
| `gacha_pull` | 抽取配件 | pool, rarity_result, mood_at_pull, is_duplicate |
| `item_equip` | 裝備配件 | slot, rarity, item_id |
| `mood_decay` | 離線衰減觸發 | mood_before, mood_after, hours_away |
| `streak_break` | streak 斷連 | previous_streak, days_absent |
| `streak_milestone` | streak 里程碑 | streak_days (3/7/14/30) |
| `trust_levelup` | Trust 等級提升 | new_level (friend/partner/family/soul_bond) |
| `share_screenshot` | 截圖分享 | platform (ig/line/x) |
| `daily_login` | 每日登入 | streak_days, mood_before |
| `pet_rat` | 摸老鼠 | mood_before, mood_after, daily_count |
| `rare_rat_preview` | 稀有老鼠出現 | mood_at_trigger |
| `ad_watched` | 觀看廣告 | ad_type (gacha/cheese/mood), reward |
| `pwa_install` | 加入主畫面 | browser, platform |

---

## 12. Sprint 詳細指令（Claude Code 逐步執行）

### Sprint 0: 美術完成 + 專案準備（Flutter 開發前置）

```
⚠️ Sprint 0 必須全部完成才能進入 Sprint 1
```

**Step 0-1: Git 初始化** ✅
```
git init + .gitignore（排除 Aseprite 二進制、*.7z、build artifacts）
初始 commit：現有 spec、sprites、scripts、docs
```

**Step 0-2: 資產重命名** ✅
```
全部 sprites/rat/ 檔案重命名為 rat_base_{state} 格式
修正 typo（eatting→eating、idel→idle）
```

**Step 0-3: 補完剩餘動畫** ✅
```
8 個動畫狀態全部到位：
  idle(4), studying(4), eating(4), confused(3),
  sad(8), happy(4), sleeping(2), walking(3)
```

**Step 0-4: 配件製作**
```
每個配件 = 資料夾，內含 6 個 state 的 .ase（pre-positioned 64x64 canvas）
⚠️ studying / sleeping 不顯示配件，不需製作
需要的 states：idle, eating, confused, sad, happy, walking

目前進度：
  ✅ devil_wings: eating(4f), happy(4f), sad(8f), walking(3f)
  ✅ devil_horns: eating(4f), happy(4f), sad(8f), walking(4f)
  ⬜ devil_wings + devil_horns: idle, confused 待補
  ✅ 資料夾重命名為 snake_case
```

**Step 0-5: CLAUDE.md 同步更新** ✅
```
7 處差異對齊修正（package:web、30秒 checkpoint、freezed、flame_riverpod 等）
```

**Step 0-6: Sprite sheet 合併 + 驗證 commit**
```
所有 .ase 輸出為 sprite sheet PNG（assets/sprites/rat_spritesheet.png）
GIF 預覽確認每個動畫正常
commit: "feat: complete pixel art pipeline (Sprint 0)"
```

---

### Sprint 1: 專案骨架 + 計時器

**Step 1-1: 專案建立（UI & Mock）**
```
建立 Flutter Web 專案 pixelrats。
設定 pubspec.yaml：
  dependencies: flame, flutter_riverpod, riverpod_annotation
  dev_dependencies: riverpod_generator, build_runner, flutter_test
建立完整資料夾結構（見 Section 4.2）。
建立 enums.dart（FocusMode、MoodState、TrustLevel、Rarity、RatAnimationState）。
用 hardcode 資料建立計時器 UI（25/50/100 三個按鈕 + 倒數顯示）。
實作 i18n 架構（flutter_localizations + ARB），中英文切換可用。
確認 flutter run -d chrome 正常顯示。
```

**Step 1-2: 計時器邏輯（State & Test）**
```
建立 TimerController（Riverpod Notifier）。
實作三種模式計時（25/50/100 分鐘）。
實作 Web visibilitychange 監聽（package:web，非 dart:html）。
實作三層 Grace Period（15s/60s/60s+）。
建立 MockFirestoreRepository。
寫 TimerController 的 Unit Tests（見 Section 6.2）。
所有測試通過後 commit。
```

**Step 1-3: Firebase 整合（Integration）**
```
設定 Firebase Web 專案（firebase_core + firebase_auth + cloud_firestore + firebase_remote_config）。
實作 FirebaseFirestoreRepository。
實作 Google 登入。
實作每 30 秒 Firestore checkpoint（見 Section 7 checkpointIntervalSeconds）。
用真實 Firebase 取代 Mock，端對端驗證。
```

### Sprint 2: Flame 老鼠動畫 + 場景

> 前置條件：Sprint 0 已完成，8 動畫 .ase + spritesheet + 配件 .ase 全部就緒

**Step 2-1: Flame 基礎（UI & Mock）**
```
建立 PixelRatsGame extends FlameGame（使用 flame_riverpod 套件橋接）。
載入老鼠 sprite sheet（rat_spritesheet.png）。
實作 RatComponent，播放 idle 動畫。
用 hardcode 切換 8 個動畫狀態驗證播放正確。
```

**Step 2-2: 配件圖層疊加系統（State）**
```
建立 AccessoryComponent，載入配件 sprite sheet。
配件與老鼠使用相同 64x64 canvas，同座標疊加渲染（無需錨點）。
實作裝備/卸除配件的邏輯。
實作 state 切換時自動切換對應配件動畫。
⚠️ studying / sleeping 狀態隱藏所有配件。
用 Mock 配件資料驗證 head + back 同時渲染正確。
```

**Step 2-3: 場景 + 音效（Integration）**
```
實作 SceneComponent，載入 3 張場景背景。
場景切換時自動更換白噪音（audioplayers Web Audio API）。
專注模式（配件背景隱藏）vs 預覽模式（配件背景顯示）切換。
Flame Game 與 Riverpod Controller 連接。
```

### Sprint 3: Mood + Trust + Gacha

**Step 3-1: Mood/Trust 邏輯（State & Test）**
```
建立 MoodTrustController（Riverpod Notifier）。
實作 Mood 0–100 完整計算（專注獎勵、離開懲罰、離線衰減底線 30、摸老鼠加成）。
實作 Trust 0–1000 完整計算（專注獎勵、Mood 加成、新手加速、等級判定）。
實作 StreakController（每日登入、連續天數、斷連處理）。
寫 MoodTrustController + StreakController 的 Unit Tests（見 Section 6.2）。
所有測試通過後 commit。
```

**Step 3-2: Gacha 邏輯（State & Test）**
```
建立 GachaController（Riverpod Notifier）。
實作 Cheese 貨幣管理（獲取、消耗、餘額）。
實作 Trust 門檻分池（4 個 Pool）。
實作 Mood × Luck 線性公式（含 normalize，見 Section 5.4）。
實作重複配件判定 + 分解回收。
寫 GachaController + CheeseController 的 Unit Tests（見 Section 6.2）。
所有測試通過後 commit。
```

**Step 3-3: 完整串接（Integration）**
```
Mood/Trust/Cheese 資料寫入 Firestore。
Gacha 記錄寫入 gacha_log。
Remote Config 整合所有經濟參數（見 Section 7）。
老鼠動畫根據 Mood 狀態自動切換。
Gacha UI（抽取動畫 + 結果展示 + 配件裝備）。
端對端：完成一次 Focus → 結算 → Mood/Trust 更新 → 抽 Gacha → 裝備配件。
```

---

## 13. 風險與應對

| 風險 | 應對 |
|------|------|
| Flame Web fps < 40 | 立即降 idle 動畫至 4fps + 啟用 SpriteBatch |
| 瀏覽器殺進程遺失狀態 | 每 30 秒 Firestore checkpoint + localStorage 雙備份 |
| PWA 「加入主畫面」轉換率低 | 新手引導強調加入主畫面；首次專注完成後彈出提示 |
| AdSense 申請不過 | 完全不影響 MVP（純免費驗證） |
| 白噪音 Web Audio 相容性差 | 備選：Howler.js |
| Riverpod 2.x code generation 問題 | 確保 build_runner 版本一致，每次 build 前跑 `dart run build_runner build` |

---

## 14. Commit 規範

```
feat: 新功能          fix: Bug 修復
refactor: 重構        style: 格式
test: 測試            docs: 文件
chore: 雜項           perf: 效能優化

範例：
feat: timer UI with mock data (Sprint 1-1)
feat: timer controller + grace period tests (Sprint 1-2)
feat: firebase auth + firestore integration (Sprint 1-3)
```

---

## 15. 程式碼品質檢查清單

每次 commit 前必須通過：
```bash
flutter analyze        # 零警告
flutter test           # 所有測試通過
dart format .          # 格式統一
```

---

## 附錄：指令書章節索引

| 文件 | 內容 | 優先讀取 |
|------|------|---------|
| **本檔（Master.md）** | 最高準則、所有精確公式、架構鐵律 | 🔴 必讀 |
| Ch1.md | 產品核心定義（Mood+Trust、Gacha、NFT 預留） | 🟡 參考 |
| Ch2.md | 技術架構（渲染、Sprite、Firestore Schema） | 🟡 參考 |
| Ch3.md | 經濟平衡（⚠️ IAP 相關內容為 Phase 2，MVP 忽略） | 🟢 僅取 Remote Config 數值 |
| Ch4.md | 執行計畫（Sprint 時間線、學習路徑） | 🟡 參考 |
