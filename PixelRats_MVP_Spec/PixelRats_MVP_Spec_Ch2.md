# PixelRats 指令書 — 第二章：技術架構

> 版本：v0.2（2026/03 — 配合第一章 Mood+Trust 改版同步更新）
> 狀態：待 Review 鎖定

---

## 1. 技術棧總覽

| 層級 | 技術選型 | 版本/備註 |
|------|----------|-----------|
| 主框架 | Flutter | 3.24+（2026 穩定版） |
| 遊戲引擎 | Flame | 1.18+（pixel art 專用） |
| 語言 | Dart | 跨平台單一程式碼庫 |
| 狀態管理 | Riverpod | 待評估是否改用 flutter_bloc |
| 後端 | Firebase | Auth / Firestore / Analytics / AdMob / Crashlytics |
| 音效 | audioplayers | 白噪音播放 |
| IAP | RevenueCat | App 內購管理 |
| 分享 | share_plus | 截圖分享至 IG/LINE/X |
| 國際化 | flutter_localizations + ARB | 中英雙語 |
| CI/CD | GitHub Actions + Fastlane | 自動建構與上架 |
| 像素美術 | PixelLab.ai + Aseprite | 生成＋精修＋動畫＋匯出 |
| 區塊鏈（Phase 2） | Solana | Flutter 專用 solana package |

---

## 2. 遊戲引擎與渲染架構

### 2.1 引擎選型：Flutter + Flame

Flame 引擎專為 2D pixel art 設計，原生支援 sprite sheet 載入、60fps 動畫、碰撞檢測。搭配 Flutter 的 widget 系統處理 UI 層（計時器、按鈕、商店介面），遊戲畫面和 UI 可以無縫整合。

### 2.2 Sprite 規格

- **統一尺寸：** 老鼠本體與所有配件均使用 **64×64 pixel** 格式
- **色彩深度：** 32-bit RGBA（支援透明背景）
- **檔案格式：** PNG（單幀）→ Aseprite 組裝 → sprite sheet PNG + JSON（Flame 載入格式）
- **縮放策略：** 在不同螢幕解析度下以整數倍縮放（2x, 3x, 4x），保持像素銳利不模糊

### 2.3 渲染圖層架構

渲染分為兩種模式，根據使用場景切換：

**模式 A：專注模式（正常遊玩）**
```
Layer 0: 場景背景（圖書館/咖啡廳/公園）
Layer 1: 老鼠本體（64×64 base sprite）
Layer 2: 配件-背部裝飾（翅膀/披風/背包）
Layer 3: 配件-頭飾（最上層）
── 配件-背景（隱藏/透明）──
── 配件-嘴飾（Phase 1.5）──
── 配件-毛色（Phase 1.5）──
```
MVP 最大同場景渲染量：場景背景 + 主角鼠 3 層 + UI = 約 5 個 sprite
Phase 2 加入 Gen1/Gen2 鼠後：場景背景 + 3 隻鼠 × 3 層 + UI = 約 12 個 sprite
使用 Flame 的 SpriteBatch 優化批次渲染，降低 draw call。

**模式 B：預覽/截圖模式（狀態欄、分享）**
```
Layer 0: 配件-背景（老鼠專屬背景，此時顯示）
Layer 1: 老鼠本體
Layer 2: 配件-背部裝飾
Layer 3: 配件-頭飾
```

### 2.4 配件部位定義（最終版 — MVP 3 部位）

| 部位 | slot 值 | 渲染層級 | 說明 | 階段 |
|------|---------|----------|------|------|
| 頭飾 | head | Layer 3（最上） | 帽子、髮飾、頭巾 | ✅ MVP |
| 背部裝飾 | back | Layer 2 | 翅膀、披風、背包 | ✅ MVP |
| 背景 | background | 模式 B Layer 0 | 僅預覽/截圖時顯示 | ✅ MVP |
| 嘴飾 | mouth | — | 口罩、鬍子、食物 | ❌ Phase 1.5 |
| 毛色 | pattern | — | 基底色系替換 | ❌ Phase 1.5 |

### 2.5 效能目標

- **目標幀率：** 穩定 60fps
- **目標機型下限：** iPhone SE 2 / Android 中階機（Snapdragon 600 系列）
- **電池影響：** 專注期間為低動畫頻率模式（idle 動畫 8fps 即可），降低 CPU 使用
- **記憶體上限：** sprite sheet 總載入量控制在 50MB 以內

---

## 3. 動畫系統與 Sprite 規劃

### 3.1 動畫狀態清單（MVP）

| 動畫狀態 | 英文 ID | 預估幀數 | 使用場景 | 製作狀態 |
|---------|---------|---------|---------|---------|
| 待機 | idle | 4–6 幀 | 啟動前、休息期 | ❌ 待製作 |
| 念書 | studying | 4–6 幀 | 專注期間主要動畫 | ❌ 待製作 |
| 吃飯 | eating | 6–8 幀 | 專注結束獎勵 | ✅ 已有測試幀 |
| 困惑 | confused | 2–3 幀 | 離開 15–60 秒（Grace 警示層） | ❌ 待製作 |
| 難過 | sad | 3–4 幀 | 離開超過 60 秒（懲罰層） | ❌ 待製作 |
| 開心 | happy | 4–6 幀 | 升級、抽到好配件 | ❌ 待製作 |
| 睡覺 | sleeping | 2–3 幀 | 長時間休息 | ❌ 待製作 |
| 走路 | walking | 4–6 幀 | 場景間移動 | ✅ 已有測試幀 |

**總計：** 約 29–43 幀（老鼠本體）

### 3.2 配件錨點模板系統

配件不需要每幀重畫，而是根據錨點座標自動定位：

```
每個動畫幀定義錨點座標（MVP 3 個，Phase 1.5 擴充至 5 個）：
{
  "frame_id": "studying_01",
  "anchors": {
    "head":       { "x": 38, "y": 12 },  // 頭飾掛載點
    "back":       { "x": 20, "y": 18 },  // 背部裝飾掛載點
    "background": { "x": 0,  "y": 0  }   // 背景固定原點
    // Phase 1.5 擴充：
    // "mouth":   { "x": 28, "y": 30 },
    // "pattern": { "x": 0,  "y": 0  }
  }
}
```

**工作流程：**
1. 在 Aseprite 中為每個動畫幀標記錨點（使用 tag 或 metadata）
2. 匯出時同時輸出 sprite sheet PNG + 錨點 JSON
3. Flame 引擎載入時，根據當前幀自動將配件 sprite 定位到對應錨點
4. 配件 sprite 本身只需要一組靜態幀（或少量變化幀），大幅降低美術工作量

### 3.3 美術工作量估算

| 項目 | 數量 | 說明 |
|------|------|------|
| 老鼠本體動畫幀 | ~36 幀 | 8 個動畫狀態（含 confused） |
| 錨點定義 | ~36 組 | 每幀 3 個錨點座標（MVP） |
| 配件素材（MVP） | 36–48 件 | 3 部位 × 4 級 × 3–4 款 |
| 配件靜態幀 | 36–48 張 | 每件 1 張（錨點定位） |
| 場景背景 | 3 張 | 圖書館、咖啡廳、公園 |
| 配件背景 | 10–12 張 | 預覽/截圖用 |
| 稀有老鼠預覽（Phase 1） | 3–5 隻 × ~36 幀 | 免費展示款 |
| Mood 狀態變化 | 5 組表情覆蓋 | sad/bored/normal/happy/excited |

> **vs v0.1：** 配件從 75–100 件降至 36–48 件，美術工作量減少 50%+

---

## 4. 美術 Pipeline

### 4.1 工具鏈

```
PixelLab.ai（AI 生成）
    │  生成單幀素材：老鼠本體各姿勢、各配件、各場景
    │  每個素材生成 3–5 張備選
    ↓
Aseprite（精修＋組裝）— USD $19.99 買斷
    │  ① 精修至精確 64×64 pixel
    │  ② 去背透明 PNG
    │  ③ 分圖層管理（本體 / 各配件獨立圖層）
    │  ④ 建立動畫時間軸（逐幀排列）
    │  ⑤ 定義錨點座標（每幀標記 5 個掛載點）
    │  ⑥ 匯出 sprite sheet PNG + JSON
    ↓
驗證腳本（自動化）
    │  自動疊加所有圖層組合，生成預覽圖
    │  檢查錨點對位是否正確（配件有無飄移）
    │  輸出報告：哪些組合有問題需修正
    ↓
Flame 引擎載入
    │  讀取 sprite sheet + 錨點 JSON
    │  根據當前動畫狀態＋裝備配件，即時合成畫面
```

### 4.2 風格一致性控制

- **PixelLab.ai Prompt 模板：** 建立統一的 prompt 前綴，確保所有生成素材風格一致
  ```
  "64x64 pixel art, [item description], warm pixel art style, 
   black outline, transparent background, matching PixelRats style"
  ```
- **Aseprite 調色板：** 建立固定的 PixelRats 色盤（.pal 檔），所有素材只能使用色盤內的顏色
- **品質 Checklist：** 每件素材完成後檢查——尺寸正確？透明背景？黑色外框線？色盤內顏色？

### 4.3 Aseprite 學習路徑（等 Mac 期間可先準備）

1. 基礎操作：圖層、選取、繪圖工具（2 小時）
2. 動畫時間軸：建立幀、onion skinning、播放預覽（2 小時）
3. Sprite sheet 匯出：JSON data + PNG atlas（1 小時）
4. 進階：Tag 管理、調色板、批次匯出（2 小時）

推薦教學：Aseprite 官方文件 + YouTube "Aseprite animation tutorial for beginners"

---

## 5. Firestore 資料模型

### 5.1 Collection 結構

```
firestore-root/
│
├── users/{user_id}
│   ├── profile
│   │   ├── display_name: string
│   │   ├── language: "zh_TW" | "en"
│   │   ├── theme_mode: "dark" | "light"
│   │   └── created_at: timestamp
│   │
│   ├── rat
│   │   ├── name: string（用戶命名）
│   │   ├── mood: number (0–100)
│   │   ├── trust: number (0–1000)
│   │   ├── trust_level: "stranger" | "friend" | "partner" | "family" | "soul_bond"
│   │   ├── streak_days: number
│   │   ├── last_login: timestamp
│   │   ├── last_mood_update: timestamp（用於計算離線 mood 衰減）
│   │   ├── cheese: number（免費貨幣餘額）
│   │   └── equipped_items
│   │       ├── head: item_id | null
│   │       ├── back: item_id | null
│   │       └── background: item_id | null
│   │       // Phase 1.5 擴充：
│   │       // mouth: item_id | null
│   │       // pattern: item_id | null
│   │
│   ├── stats
│   │   ├── total_focus_min: number
│   │   ├── total_sessions: number
│   │   └── best_streak: number
│   │
│   ├── settings
│   │   ├── timer_default: 25 | 50 | 100
│   │   ├── sound_enabled: boolean
│   │   └── notifications: boolean
│   │
│   └── inventory/（子集合）
│       └── {item_id}
│           ├── slot: "head" | "back" | "background" | "mouth" | "pattern"
│           ├── rarity: "legend" | "epic" | "rare" | "common"
│           ├── name_zh: string
│           ├── name_en: string
│           ├── sprite_ref: string（sprite sheet 路徑）
│           ├── obtained_at: timestamp
│           ├── source: "gacha" | "event" | "reward" | "streak"
│           ├── is_equipped: boolean
│           └── gene_data
│               ├── inheritable: boolean (true)
│               └── gene_weight: number (0.0–1.0)
│
├── focus_sessions/{session_id}
│   ├── user_id: string
│   ├── mode: "short" | "deep" | "flow"
│   ├── duration_min: 25 | 50 | 100
│   ├── leave_events: array
│   │   └── [{ left_at: timestamp, returned_at: timestamp, duration_sec: number, tier: "grace"|"warning"|"penalty" }]
│   ├── mood_before: number（session 開始時的 mood）
│   ├── mood_earned: number（本次獲得的 mood）
│   ├── trust_earned: number（本次獲得的 trust）
│   ├── cheese_earned: number（本次獲得的 cheese）
│   ├── rare_rat_appeared: boolean
│   ├── started_at: timestamp（server timestamp）
│   └── completed_at: timestamp（server timestamp）
│
├── gacha_log/{log_id}
│   ├── user_id: string
│   ├── item_id: string
│   ├── rarity: string
│   ├── pool: "basic" | "rare" | "epic" | "legend"
│   ├── is_duplicate: boolean
│   ├── cheese_spent: number
│   ├── cheese_returned: number（分解所得）
│   ├── mood_at_pull: number（抽卡時的 mood，用於驗證 luck 加成）
│   └── timestamp: timestamp
│
└── nft_rats/{nft_id}（Phase 2）
    ├── generation: "gen1" | "gen2"
    ├── parent_ids: array [nft_id | user_rat_id]
    ├── owner_id: string (user_id)
    ├── base_appearance
    │   ├── fur_color: string
    │   ├── body_type: string
    │   ├── tail_style: string
    │   └── eye_color: string
    ├── inherited_items: array
    │   └── [{ item_id, slot, rarity, from_parent: "gen1" | "player_rat" }]
    ├── mutated_items: array
    │   └── [{ item_id, slot, rarity, is_mutation: true }]
    ├── breed_count: number (gen1 上限 1, gen2 固定 0)
    ├── breed_available: boolean
    ├── solana_token_id: string | null
    └── minted_at: timestamp
```

### 5.2 查詢效率考量

- **inventory 用子集合而非 array：** 配件數量可達 100+，用 array 會導致每次更新都寫入整個文檔。子集合可以獨立查詢和更新。
- **focus_sessions 用獨立集合：** 方便做全域排行榜查詢和數據分析。加 `user_id` 索引做個人歷史查詢。
- **gacha_log 獨立紀錄：** 用於保底機制計算（查詢最近 N 次抽取結果）和經濟數據分析。
- **Server Timestamp：** `focus_sessions` 的 `started_at` 和 `completed_at` 使用 Firebase Server Timestamp，防止客戶端改時間作弊。

### 5.3 Firestore 安全規則要點

```
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
    // 專注記錄只能由自己建立，不可修改
    match /focus_sessions/{sessionId} {
      allow create: if request.auth != null && request.resource.data.user_id == request.auth.uid;
      allow read: if request.auth != null && resource.data.user_id == request.auth.uid;
      allow update, delete: if false; // 不可修改或刪除
    }
    // 抽取記錄同理
    match /gacha_log/{logId} {
      allow create: if request.auth != null;
      allow read: if request.auth != null && resource.data.user_id == request.auth.uid;
      allow update, delete: if false;
    }
  }
}
```

---

## 6. 核心邏輯與防作弊

### 6.1 Timestamp Diffing（專注計時 + 三層式 Grace Period）

不使用背景計時器，改用時間戳差值判斷：

```dart
// App 進入背景
void onAppPaused() {
  final leaveTime = DateTime.now();
  saveToLocal('leave_time', leaveTime);
  // 不立即改變老鼠狀態（Grace Period 15 秒）
}

// App 回到前景
void onAppResumed() {
  final leaveTime = loadFromLocal('leave_time');
  final returnTime = DateTime.now();
  final awaySeconds = returnTime.difference(leaveTime).inSeconds;
  
  if (awaySeconds <= 15) {
    // Grace Period：完全不懲罰，不記錄
    ratState = RatState.studying; // 繼續念書
    return;
  }
  
  // 記錄離開事件
  leaveEvents.add({
    'left_at': leaveTime,
    'returned_at': returnTime,
    'duration_sec': awaySeconds,
    'tier': awaySeconds <= 60 ? 'warning' : 'penalty',
  });
  
  if (awaySeconds <= 60) {
    // 警示層：Mood 不扣，但標記品質降級
    sessionQualityDegraded = true;
    ratState = RatState.confused;
  } else {
    // 懲罰層：Mood 下降
    final penaltySeconds = awaySeconds - 60;
    final moodLoss = (penaltySeconds / 30).floor() * 2;
    currentMood = max(0, currentMood - moodLoss); // Sad 可由此觸發
    ratState = RatState.sad;
  }
  
  // 恢復動畫（3–5 秒後回到念書）
  Future.delayed(Duration(seconds: awaySeconds <= 60 ? 3 : 5), () {
    ratState = RatState.studying;
  });
}
```

### 6.2 Server Timestamp 交叉驗證

```
客戶端記錄：leave_time / return_time（本地時鐘）
伺服端記錄：session_start / session_end（Firebase Server Timestamp）

驗證邏輯：
if |客戶端總時長 - 伺服端總時長| > 60 秒:
    標記為可疑 session
    quality_score = 0
    不發放積分
```

### 6.3 Mood/Trust 計算框架

```
完成 Focus Session 時：

// 基礎獎勵（依模式）
base_mood  = { short: 5, deep: 10, flow: 20 }
base_trust = { short: 3, deep: 5,  flow: 10 }
base_cheese = { short: 10, deep: 25, flow: 60 }

// 離開懲罰（三層式 Grace Period）
// Grace（0–15秒）：不計入
// Warning（15–60秒）：品質降級但不扣 Mood
// Penalty（60秒+）：扣 Mood + 獎勵打折
penalty_events = leaveEvents.where(tier == 'penalty')
warning_events = leaveEvents.where(tier == 'warning')

leave_penalty = max(0.3, 1.0 
  - (penalty_events.length × 0.2)      // 每次正式離開扣 20%
  - (warning_events.length × 0.05))     // 每次警示層扣 5%

// Mood 加成 Trust
trust_multiplier = mood >= 60 ? 1.25 : 1.0

// 最終計算
mood_earned  = base_mood × leave_penalty
trust_earned = base_trust × leave_penalty × trust_multiplier
cheese_earned = base_cheese × leave_penalty × (mood >= 80 ? 1.2 : 1.0)
```

### 6.4 Mood 離線衰減計算

```dart
// App 啟動時計算離線期間的 Mood 衰減
void calculateOfflineMoodDecay() {
  final lastUpdate = rat.lastMoodUpdate;
  final now = DateTime.now();
  final hoursAway = now.difference(lastUpdate).inHours;
  final daysAway = now.difference(lastUpdate).inDays;
  
  // 每小時 -1
  int hourlyDecay = hoursAway;
  
  // 連續未開 App 每天額外 -5
  int dailyDecay = daysAway > 0 ? daysAway * 5 : 0;
  
  int totalDecay = hourlyDecay + dailyDecay;
  
  // 離線衰減底線：30（Bored）
  // Sad（0–20）只能由專注期間離開 App 觸發，離線絕不會掉到 Sad
  final OFFLINE_MOOD_FLOOR = 30;
  rat.mood = max(OFFLINE_MOOD_FLOOR, rat.mood - totalDecay);
  
  // Trust 不衰減（永不倒扣）
  rat.lastMoodUpdate = now;
}
```

**關鍵設計原則：**
- 離線 Mood 底線 = 30（Bored），離線永遠不會觸發 Sad 狀態
- Sad（0–20）只能在專注期間離開 App 超過 60 秒時觸發
- 這確保回歸用戶看到的是「無聊等你的老鼠」而非「被拋棄的老鼠」

---

## 7. 國際化架構（i18n）

### 7.1 技術方案

使用 Flutter 原生 `flutter_localizations` + ARB（Application Resource Bundle）檔案。

### 7.2 檔案結構

```
lib/
  l10n/
    app_en.arb          ← 英文字串（同時作為 key 定義檔）
    app_zh_TW.arb       ← 繁體中文字串
  generated/
    app_localizations.dart  ← 自動生成的存取類別
```

### 7.3 ARB 檔案範例

```json
// app_zh_TW.arb
{
  "appTitle": "PixelRats",
  "startFocus": "開始專注",
  "focusShort": "Short Focus · 25 分鐘",
  "focusDeep": "Deep Focus · 50 分鐘",
  "focusFlow": "Flow Focus · 100 分鐘",
  "focusComplete": "專注完成！",
  "ratDialogWelcome": "主人回來了！我好想你～",
  "ratDialogSad": "嗚嗚...你去哪了...",
  "ratDialogBored": "好無聊喔...陪我念書嘛～",
  "ratDialogHappy": "今天好開心！繼續加油！",
  "ratDialogExcited": "哇啊啊啊！！超棒的！！！",
  "moodLabel": "心情",
  "trustLabel": "信任",
  "trustStranger": "陌生人",
  "trustFriend": "朋友",
  "trustPartner": "夥伴",
  "trustFamily": "家人",
  "trustSoulBond": "靈魂羈絆",
  "cheeseEarned": "獲得 {cheese} 🧀",
  "@cheeseEarned": { "placeholders": { "cheese": { "type": "int" } } },
  "streakDays": "連續 {days} 天",
  "@streakDays": { "placeholders": { "days": { "type": "int" } } },
  "gachaResultNew": "獲得新配件！",
  "gachaResultDuplicate": "已擁有，分解為 {cheese} 🧀",
  "@gachaResultDuplicate": { "placeholders": { "cheese": { "type": "int" } } },
  "gachaPoolLocked": "需要 Trust {level} 才能解鎖此池",
  "@gachaPoolLocked": { "placeholders": { "level": { "type": "String" } } }
}
```

### 7.4 重要原則

- **Day 1 就實作：** 所有 UI 字串一律透過 `AppLocalizations.of(context)` 存取，絕不在程式碼中 hardcode 文字
- **老鼠對話泡泡也走 i18n：** 這些文案是產品的靈魂，中英文的語氣差異需要分別設計
- **配件名稱雙語：** Firestore 中每件配件都存 `name_zh` 和 `name_en`，根據用戶語言設定顯示

---

## 8. CI/CD Pipeline

### 8.1 工具鏈

- **版本控制：** GitHub（個人帳號管理）
- **CI：** GitHub Actions
- **CD：** Fastlane（iOS + Android 自動上架）

### 8.2 Repository 結構

```
pixelrats/
├── .github/
│   └── workflows/
│       ├── ci.yml          ← 每次 push 觸發
│       └── release.yml     ← push tag 觸發
├── android/
├── ios/
├── lib/
│   ├── l10n/              ← i18n 檔案
│   ├── game/              ← Flame 遊戲邏輯
│   ├── models/            ← 資料模型
│   ├── services/          ← Firebase、IAP 服務
│   ├── screens/           ← UI 頁面
│   └── main.dart
├── assets/
│   ├── sprites/           ← sprite sheet + JSON
│   ├── audio/             ← 白噪音檔案
│   └── backgrounds/       ← 場景背景圖
├── test/                  ← 單元測試
├── fastlane/
│   └── Fastfile
├── pubspec.yaml
├── CLAUDE.md              ← Claude Code 規則檔
└── spec.md                ← 產品規格（本指令書的精簡版）
```

### 8.3 CI 流程（ci.yml）

```
觸發條件：push to any branch / pull request

Steps:
1. flutter pub get
2. flutter analyze（靜態分析）
3. flutter test（單元測試）
4. flutter build apk --debug（Android 建構驗證）
5. flutter build ios --no-codesign（iOS 建構驗證）
```

### 8.4 Release 流程（release.yml）

```
觸發條件：push tag v*.*.*（例如 v1.0.0）

Steps:
1. flutter build appbundle --release（Android）
2. flutter build ipa --release（iOS）
3. Fastlane → 上傳至 Google Play Internal Testing
4. Fastlane → 上傳至 TestFlight
```

### 8.5 必寫測試項目

| 測試範圍 | 測試重點 | 優先級 |
|---------|---------|--------|
| 番茄鐘計時 | 25/50/100 三種模式、暫停恢復 | 🔴 最高 |
| Mood 計算 | 專注獎勵、離開懲罰、離線衰減、上下限 | 🔴 最高 |
| Trust 計算 | 專注獎勵、Mood 加成、Trust 等級判定 | 🔴 最高 |
| Cheese 計算 | 獎勵發放、Mood 加成、streak 加成 | 🔴 最高 |
| Gacha 抽取 | 機率分佈、Mood luck 影響、Trust pool 門檻、重複判定 | 🔴 最高 |
| Firestore CRUD | 用戶資料讀寫、配件存取 | 🟡 高 |
| i18n | 所有 key 在兩種語言都有對應值 | 🟡 高 |
| 動畫狀態機 | Mood 狀態對應正確動畫 + Grace Period 層級轉換（studying→confused→sad→studying） | 🟢 中 |

---

## 9. 截圖分享技術方案

### 9.1 技術實作

使用 Flutter `RepaintBoundary` 截取組合畫面，搭配 `share_plus` 分享。

```dart
// 截圖區域包裹 RepaintBoundary
final boundaryKey = GlobalKey();

RepaintBoundary(
  key: boundaryKey,
  child: ShareCardWidget(
    rat: currentRat,
    equippedItems: equippedItems,
    background: equippedBackground, // 此時顯示配件背景
    todayStats: todayFocusStats,
  ),
);

// 觸發截圖
Future<void> captureAndShare() async {
  final boundary = boundaryKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
  final image = await boundary.toImage(pixelRatio: 3.0);
  final byteData = await image.toByteData(format: ImageByteFormat.png);
  // 存為暫存檔後透過 share_plus 分享
}
```

### 9.2 分享卡片排版

```
┌─────────────────────────────┐
│     配件背景（專屬背景）       │
│                             │
│     ┌─────────────────┐     │
│     │  老鼠＋全配件     │     │
│     │ （完整渲染合成）   │     │
│     └─────────────────┘     │
│                             │
│  🔥 今日專注：3 小時 15 分   │
│  😊 Mood: Happy ｜ 🤝 Trust: Partner │
│  ─────────────────────────  │
│  PixelRats 🧀  下載連結      │
└─────────────────────────────┘
```

### 9.3 分享管道

- **IG Story：** 直接開啟 IG Story 編輯器，圖片自動填入
- **LINE：** 透過 share_plus 分享圖片 + 文字
- **X（Twitter）：** 透過 share_plus 分享圖片 + hashtag

---

## 10. UI 色調設計

### 10.1 模式規劃

- **Dark Mode（預設）：** 深藍 + 柔光色調，適合夜間讀書場景
- **Light Mode：** 先留架構預留位，後續版本補上

### 10.2 Dark Mode 色盤（初步定義）

| 用途 | 色碼 | 說明 |
|------|------|------|
| 主背景 | #0D1B2A | 深海藍 |
| 次背景 | #1B2838 | 稍淺藍 |
| 強調色 | #FFB74D | 溫暖橘（按鈕、重要數據） |
| 文字主色 | #E0E0E0 | 柔和白 |
| 文字次色 | #90A4AE | 灰藍 |
| 成功色 | #81C784 | 柔綠（完成、升級） |
| 警告色 | #E57373 | 柔紅（老鼠難過、離開警示） |
| 稀有度 SS | 彩虹漸層 | holographic 效果 |
| 稀有度 S | #FFD700 | 金色 |
| 稀有度 A | #AB47BC | 紫色 |
| 稀有度 B | #42A5F5 | 藍色 |
| 稀有度 C | #9E9E9E | 灰色 |

---

## 11. Solana 區塊鏈整合（Phase 2 預評估）

> 以下為 Phase 2 實裝時的技術方向，Phase 1 期間僅需確保 Firestore schema 已預留相關欄位。

### 11.1 SDK 選型

- **Flutter 端：** 使用 `solana_web3` 或同等 Flutter Solana package（需在 Phase 1 開發期做 POC 驗證）
- **鏈上程式：** Solana Program（Rust），處理 NFT Mint、Breeding 邏輯

### 11.2 錢包方案（建議分階段）

| 階段 | 方案 | 用戶體驗 | 複雜度 |
|------|------|----------|--------|
| Phase 2 初期 | Phantom SDK deeplink | 用戶自己管鑰匙 | 低 |
| Phase 2 成熟期 | Account Abstraction (AA) | 社交帳號自動生成地址 | 高 |
| Phase 3 | 完整錢包互通 | 任意 Solana 錢包 | 中 |

### 11.3 Apple 合規雙軌支付

```
路徑 A：App 內（Web2 門票）
  用戶在 App 內透過 IAP 購買抽取 Gen1 NFT
  Apple 抽 30%，視為用戶獲取成本
  ⚠️ App 內不可引導用戶去官網購買

路徑 B：官網（Web3 專業版）
  官網提供 Direct Mint（連接 Phantom/Solflare）
  價格較低（避開 30% 抽成）
  用戶登入相同 Firebase 帳號 → 系統掃描 Solana 錢包 → NFT 權限同步至 App

同步機制：
  Firestore 的 nft_rats/{nft_id} 欄位 solana_token_id 對應鏈上 token
  App 啟動時查詢用戶綁定的 Solana 地址，比對鏈上持有狀態
  鏈上轉移 → Firestore webhook 更新 owner_id
```

### 11.4 Phase 1 期間的 POC 建議

在 Phase 1 開發的最後一個月，花 2–3 天做一個最小可行的 Solana POC：
1. Flutter App 透過 deeplink 連接 Phantom 錢包
2. 讀取錢包地址
3. 在 devnet 上 mint 一個測試 NFT
4. 確認 Flutter ↔ Solana 的基本通訊可行

---

## 12. 待第三輪討論確認事項

### 變現與經濟平衡
- [ ] Cheese 獲取速度 vs 抽取消耗的平衡
- [ ] Gold Cheese 的 IAP 定價（台灣市場）
- [ ] Mood 影響 luck 的具體數值曲線
- [ ] Trust 成長速度與 Pool 解鎖的時間預估（多少天到 Friend/Partner/Family?）
- [ ] 稀有老鼠預覽的出現機率
- [ ] streak 斷連的處理邏輯（Mood 額外懲罰？Trust 不動？）
- [ ] 配件保底機制設計（天井系統）
- [ ] 白噪音的音源取得與授權方案
- [ ] AdMob 廣告的放置位置與觸發時機
- [ ] IAP 場景包的定價策略
- [ ] NFT Gen1 稀有老鼠的抽取定價
- [ ] 社交育鼠的費用機制
- [ ] Gen2 繼承的稀有度權重公式
- [ ] 突變 items 的機率與設計規則

### 第四輪：執行計畫
- [ ] Sprint 拆分與每個 sprint 的交付物
- [ ] CLAUDE.md 規則檔內容
- [ ] spec.md 精簡版撰寫
- [ ] Figma 原型設計需求
- [ ] Beta 測試計畫
