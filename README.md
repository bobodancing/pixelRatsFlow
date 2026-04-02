# 🐀 PixelRats — Focus & Pet Simulation (Web PWA)

PixelRats 是一款以「專注計時」結合「老鼠養成」的 Web PWA 遊戲。本專案採用 Flutter Web + Flame 引擎開發，並以 Firebase 作為後端支撐。

---

## 🚀 MVP 開發邊界 (MVP Boundary)

為了確保開發效率與 Day 7 留存率（唯一 KPI > 35%），本階段嚴格禁止開發以下功能：

* **平台限制：** 僅支援 **Web PWA** (Firebase Hosting)，不處理原生 App 登入。
* **收費模式：** 純免費，**無 IAP**、無月卡、無 NFT / Solana 整合。
* **廣告：** 僅考慮 AdSense for Games，其餘廣告 SDK 略過。
* **系統：** 無人格系統 (Personality)，僅保留 Phase 2 擴充性。

---

## 🏗 技術架構與規範

### 1. 狀態管理 (Riverpod 2.x)
* **強制使用：** `Notifier` / `AsyncNotifier` 與 `@riverpod` 註解。
* **禁止使用：** 舊版 `StateNotifier`、`ChangeNotifier` 或在 UI 中直接操作 Firestore。

### 2. 三層架構 (3-Layer Architecture)
* **Layer 1: Data (Repositories)** — 負責外部通訊，必須定義抽象介面。
* **Layer 2: Domain (Controllers)** — 處理業務邏輯（如 Mood/Trust 計算），僅透過 Interface 操作資料。
* **Layer 3: Presentation (Screens/Widgets)** — 純 UI 繪製，嚴禁撰寫業務邏輯。

### 3. 測試驅動開發 (TDD)
所有核心邏輯（計時器、Mood、Gacha 機率）必須先通過單元測試才能進入 UI 實作。

---

## 📊 核心公式重點

### 離線衰減 (Offline Mood Decay)
$Mood$ 的離線衰減設有底線，確保玩家回歸時老鼠處於可挽回狀態：
$$Decay = HoursAway + (DaysAway \times 5)$$
* **離線底線：** 30 (Bored)
* **Sad 狀態：** 僅能由專注期間非法離開超過 60 秒觸發。

### 抽卡幸運值 (Gacha Luck)
機率根據 $Mood$ 線性修正後進行歸一化 (Normalize)：
$$LuckMod = (Mood - 50) \times 0.005$$

---

## 📂 專案結構簡述

```bash
lib/
├── repositories/   # Layer 1: 資料層 (Auth, Firestore, RemoteConfig)
├── controllers/    # Layer 2: 業務邏輯層 (Riverpod Providers)
├── models/         # 資料模型 (Freezed)
├── game/           # Flame 引擎邏輯 (Components, Systems)
├── screens/        # UI 頁面
├── widgets/        # 可重用組件
└── l10n/           # i18n (繁中, 英文)
```

---

## 🎨 美術資產規範 (Asset Naming)

* **格式：** 全部小寫、底線分隔。
* **老鼠：** `rat_base_{state}_{frame}`
* **配件：** `item_{slot}_{rarity}_{name}_{id}`
* **重要提示：** 老鼠臉頰上的紅點是**腮紅 (Blush)**，眼睛在頭部上方。配件錨點以頭頂為基準。

---

## 📝 Commit 規範

| 前綴 | 說明 | 範例 |
| :--- | :--- | :--- |
| `feat:` | 新功能 | `feat: timer UI with mock data (Sprint 1-1)` |
| `test:` | 測試代碼 | `test: mood decay logic (Sprint 3-1)` |
| `fix:` | Bug 修復 | `fix: gacha luck normalization logic` |
| `refactor:` | 重構 | `refactor: repository interface` |

---

## 📅 Sprint 路線圖

* **Sprint 1:** 專案骨架、三層 Grace Period 計時器、Firebase 整合。
* **Sprint 2:** Flame 老鼠動畫系統、配件錨點解析、場景與音效。
* **Sprint 3:** Mood/Trust 經濟平衡、Gacha 邏輯、Remote Config 整合。

---
**Happy coding, Ruei! 🐀**
