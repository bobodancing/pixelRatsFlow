# PixelRats 指令書 — 第四章：執行計畫

> 版本：v0.2（2026/03 — Web 優先 PWA 方案）
> 狀態：待 Review 鎖定
> 核心改動：App Store → PWA Web 優先；等 Mac → Windows 立即開工；IAP → 免費 MVP 驗證留存

---

## 1. 發行策略

### 1.1 Web 優先（PWA）

| 項目 | 決策 |
|------|------|
| 發行平台 | PWA（Progressive Web App），Firebase Hosting |
| 開發環境 | Windows + VS Code + Chrome（不需要 Mac） |
| 部署方式 | `firebase deploy`，部署即上線，無審核 |
| 用戶入口 | URL 直接開啟 → 「加入主畫面」像原生 App 運作 |
| 帳號系統 | Firebase Auth（Google 登入為主，Apple 登入 MVP 略過） |
| 未來轉 App | Flutter 同一套程式碼，未來可直接編譯 iOS/Android |

### 1.2 MVP 變現策略：純免費驗證留存

| 項目 | MVP 決策 | 未來擴展 |
|------|---------|---------|
| 付費系統 | ❌ 不做 | 綠界/Stripe（Web 版）或 IAP（App 版） |
| Gold Cheese | ❌ MVP 移除 | 驗證留存後加入 |
| 廣告 | 申請 AdSense for Games，能過就放 | 轉 App 後改 AdMob |
| 月卡 | ❌ MVP 移除 | 驗證後加入 |
| 場景包 IAP | ❌ MVP 移除 | 驗證後加入 |

### 1.3 MVP 唯一目標

**驗證 Day 7 留存率 > 35%。** 如果免費版做到這個數字，再加入變現。如果做不到，先優化核心循環。

---

## 2. 時間線總覽（大幅前移）

```
Phase A：立即開始（第 1–2 週）
├── Flame Web 效能 POC + 環境設定
└── 美術素材批量產製

Phase B：核心開發（第 3–8 週）
├── Sprint 1: 專案骨架 + 計時器（2 週）
├── Sprint 2: Flame 老鼠動畫 + 場景（2 週）
└── Sprint 3: Mood + Trust + Gacha（2 週）

Phase C：打磨上線（第 9–12 週）
├── Sprint 4: 分享 + UI 打磨 + AdSense（1 週）
├── Sprint 5: 測試 + Bug 修復（1 週）
└── Sprint 6: PWA 部署 + 封測上線（1 週）

MVP Web 上線目標：開工後約 10–12 週（週末為主，每週 10–15 小時）
```

> 比原方案快 2–3 個月：不等 Mac、不做付費、不做 App Store 審核、不做 Apple 登入。

---

## 3. Phase A：立即開始（第 1–2 週）

### Week 1：環境 + POC + 學習

| 任務 | 工具 | 時間 | 完成標準 |
|------|------|------|---------|
| 安裝 Flutter SDK（Windows） | Windows Terminal | 1 小時 | `flutter doctor` 通過（忽略 iOS） |
| 啟用 Flutter Web | `flutter config --enable-web` | 10 分鐘 | `flutter create` 專案能在 Chrome 跑 |
| Flutter 基礎教學 | 官方 Codelabs ×2 | 4 小時 | 理解 Widget、State 概念 |
| Dart 語法速覽 | dart.dev（有 JS 基礎） | 30 分鐘 | 能讀懂 Dart 程式碼 |
| **🔴 Flame Web 效能 POC** | Flutter + Flame + Chrome | 3 小時 | 見下方 POC 規格 |
| 安裝 Aseprite | Steam / 官網 | 30 分鐘 | 開啟 64×64 畫布 |
| 設定 GitHub repo | GitHub | 30 分鐘 | `pixelrats` repo + README |
| 安裝 Claude Code | npm | 15 分鐘 | 終端機可執行 |
| Firebase 專案建立 | Firebase Console | 30 分鐘 | 啟用 Auth + Firestore + Hosting |

#### Flame Web 效能 POC（最關鍵的 3 小時）

**目的：** 在你的手機瀏覽器上確認 Flame Web 的渲染效能可接受。

**POC 內容：**
```
1. 建立 Flutter Web + Flame 專案
2. 載入你現有的像素老鼠 sprite sheet
3. 同時渲染：背景（1 層）+ 老鼠本體（1 層）+ 2 個配件圖層
4. 播放 idle 動畫（4–6 幀循環）
5. 加一個倒數計時器 UI overlay
6. flutter build web --release
7. 部署到 Firebase Hosting
8. 用你的手機 Chrome/Safari 開啟，觀察：
   - fps 是否穩定 50+？
   - 動畫是否流暢？
   - 手機是否明顯發燙？
```

**判斷標準：**
- ✅ 50fps+ 且不明顯發燙 → 繼續 Web 方案
- ⚠️ 40–50fps → 可接受但需優化（降低動畫幀率到 8fps）
- ❌ 低於 40fps → 需要重新評估（考慮用 CanvasKit 替代、或簡化渲染層數）

### Week 2：美術素材批量產製

| 任務 | 工具 | 時間 | 完成標準 |
|------|------|------|---------|
| Aseprite 基礎教學 | YouTube | 3 小時 | 能做圖層、動畫、匯出 |
| 老鼠本體 8 動畫狀態 | PixelLab.ai → Aseprite | 5 小時 | ~36 幀 64×64 sprite sheet |
| 錨點模板定義 | Aseprite + JSON | 1 小時 | 每幀 3 個錨點 |
| 頭飾配件（12–16 件） | PixelLab.ai → Aseprite | 3 小時 | 4 級 × 3–4 款，去背 PNG |
| 背部配件（12–16 件） | PixelLab.ai → Aseprite | 3 小時 | 同上 |
| 背景配件（12–16 件） | PixelLab.ai → Aseprite | 2 小時 | 同上 |
| 場景背景（3 張） | PixelLab.ai → Aseprite | 1 小時 | 圖書館、咖啡廳、公園 |
| 匯出 sprite sheet + JSON | Aseprite | 30 分鐘 | Flame 可載入格式 |

---

## 4. Phase B：核心開發（第 3–8 週）

### Sprint 1：專案骨架 + 計時器（第 3–4 週）

**Claude Code 指令：**
```
根據 spec.md 建立 Flutter Web 專案：
- 設定 pubspec.yaml（flame、flutter_riverpod、firebase_core、
  firebase_auth、cloud_firestore、firebase_remote_config、audioplayers）
- 注意：不需要 RevenueCat（MVP 無付費）、不需要 google_mobile_ads（用 AdSense）
- 建立資料夾結構（lib/game、lib/models、lib/services、lib/screens）
- 實作 i18n 架構（flutter_localizations + ARB）
- Firebase Auth（僅 Google 登入）
- 專注計時器（25/50/100 三種模式）
- Timestamp Diffing + 三層式 Grace Period
- Web 專用：visibilitychange 事件監聽（取代 App lifecycle）
```

**Web 專用技術注意事項：**
```dart
// Web 版的「切出 App」監聽方式不同於原生 App
// 使用 document.onVisibilityChange 而非 WidgetsBindingObserver

import 'dart:html' as html;

html.document.onVisibilityChange.listen((event) {
  if (html.document.hidden!) {
    onAppPaused();  // 切換分頁 / 最小化
  } else {
    onAppResumed(); // 回到頁面
  }
});

// 額外：每 30 秒自動 checkpoint 到 Firestore
// 防止瀏覽器被強制關閉時遺失狀態
Timer.periodic(Duration(seconds: 30), (_) {
  saveCheckpointToFirestore();
});
```

| 交付物 | 完成標準 |
|--------|---------|
| Flutter Web 專案 | Chrome 上 `flutter run -d chrome` 正常啟動 |
| 計時器 | 三種模式可選、倒數正確 |
| Grace Period | 切換分頁測試三層懲罰正確 |
| Firebase Auth | Google 登入可用 |
| i18n | 中英文切換正常 |
| 自動 Checkpoint | 每 30 秒寫入 Firestore |

### Sprint 2：Flame 老鼠動畫 + 場景（第 5–6 週）

**Claude Code 指令：**
```
實作 Flame 遊戲畫面（Web 版）：
- 載入老鼠 sprite sheet，8 個動畫狀態切換
- 配件圖層疊加系統（錨點定位，3 部位）
- 場景背景切換（3 種 + 白噪音綁定）
- 專注模式 vs 預覽模式渲染切換
- Web 優化：idle 動畫降至 8fps 省電，互動時 30fps
```

| 交付物 | 完成標準 |
|--------|---------|
| 老鼠動畫 | 8 狀態正確播放 |
| 配件系統 | 頭飾/背部/背景正確顯示在錨點 |
| 場景系統 | 3 場景可切換 |
| 白噪音 | 場景切換音效跟著換（Web Audio API） |
| 效能 | 手機 Chrome 穩定 40fps+ |

### Sprint 3：Mood + Trust + Gacha（第 7–8 週）

**Claude Code 指令：**
```
實作核心系統：
- Mood（0–100）：專注獎勵、Grace Period 懲罰、離線衰減（底線30）
- Trust（0–1000）：專注獎勵、Mood 加成、新手 7 天 ×2、等級判定
- Cheese 貨幣（僅免費版，無 Gold Cheese）
- Gacha 抽取：Trust 門檻分池、Mood×Luck 線性曲線
- 配件庫存管理 + 裝備系統
- Streak 系統（每日登入 + 連續天數 + 斷連處理）
- Remote Config 整合
- 所有經濟數值走 Remote Config
```

**MVP 免費版經濟調整：**
```
因為沒有 Gold Cheese 和廣告 Cheese：
- 每日 Cheese 收入預估：約 55–80（純專注 + 登入 + streak）
- 單抽成本：維持 120 Cheese（約 1.5–2 天一抽）
- 這個節奏讓免費玩家每兩天一抽，足夠維持新鮮感
- 如果 AdSense 通過，加入「看廣告 +20 Cheese」提速到每天一抽
- 所有數值 Remote Config 可即時調整
```

| 交付物 | 完成標準 |
|--------|---------|
| Mood 系統 | 所有規則正確，離線底線 30 |
| Trust 系統 | 新手加速、永不衰減、等級判定 |
| Cheese | 獲取/消耗/餘額正確 |
| Gacha | 機率正確、Mood luck 正確、Trust Pool 門檻正確 |
| Streak | 登入/加成/斷連處理正確 |
| Remote Config | 所有經濟參數可遠端調整 |

---

## 5. Phase C：打磨上線（第 9–12 週）

### Sprint 4：分享 + UI 打磨 + AdSense（第 9 週）

| 交付物 | 完成標準 |
|--------|---------|
| 截圖分享 | Web Share API 分享到 IG/LINE/X |
| 分享卡片 | 老鼠 + 配件背景 + Mood/Trust 數據 |
| 稀有老鼠預覽 | 8% 機率觸發 |
| Dark Mode UI | 色盤統一、動畫過渡 |
| 回歸彈窗 | 「老鼠想你了」+ Mood 補償 |
| AdSense for Games | 申請 + 整合（如果通過） |
| PWA manifest.json | App icon、名稱、主題色、離線提示 |

### Sprint 5：測試 + Bug 修復（第 10 週）

| 任務 | 說明 |
|------|------|
| 單元測試 | Mood/Trust/Cheese/Gacha/Timer 核心計算 |
| 瀏覽器測試 | Chrome（Android）、Safari（iOS）、桌面 Chrome |
| 手機效能 | 低階 Android Chrome、iPhone Safari 的 fps 和電池 |
| 邊界情況 | 瀏覽器殺進程、網路斷線、長時間離線回歸 |
| Crashlytics | Firebase Crashlytics Web 版整合 |

### Sprint 6：PWA 部署 + 封測上線（第 11–12 週）

| 任務 | 說明 |
|------|------|
| 購買 Domain | pixelrats.app 或 pixelrats.io |
| Firebase Hosting 設定 | 自訂 domain + SSL |
| PWA 完整設定 | manifest.json + service worker + offline fallback |
| OG 標籤 | 社群分享時的預覽圖和描述 |
| 封測邀請 | 寵物鼠社群 + 朋友，目標 20–50 人 |
| 數據監控 | Firebase Analytics 事件追蹤設定 |
| 正式上線 | 公開 URL，開始社群推廣 |

---

## 6. CLAUDE.md 草稿（Web 版）

```markdown
# CLAUDE.md — PixelRats 開發規則

## 專案概述
PixelRats 是一款 Focus Tamagotchi PWA：像素老鼠陪你專注，
Mood 和 Trust 取決於你的專注習慣。
Web 優先（PWA），Flutter Web + Flame 引擎。

## 技術棧
- Flutter 3.24+ / Dart（Web 版）
- Flame 1.18+（遊戲引擎，WebGL 渲染）
- Riverpod（狀態管理）
- Firebase（Auth / Firestore / Analytics / Crashlytics / Remote Config / Hosting）
- audioplayers（白噪音，走 Web Audio API）
- Web Share API（截圖分享）

## ⚠️ 不需要的套件（MVP Web 版）
- RevenueCat（無 IAP）
- google_mobile_ads（無 AdMob，用 AdSense）
- share_plus（改用 Web Share API 直接呼叫）

## 平台特殊規則
- 這是 Web 版，不是原生 App
- 監聽切換分頁用 `document.onVisibilityChange`，不是 `WidgetsBindingObserver`
- 每 30 秒自動 checkpoint 到 Firestore（防瀏覽器殺進程遺失狀態）
- localStorage 作為本地快取，Firestore 作為持久化來源
- 帳號：僅 Google 登入（Apple 登入 MVP 略過）

## 架構規則
- 所有 UI 文字透過 i18n（AppLocalizations），禁止 hardcode
- 所有經濟數值透過 Remote Config，禁止 hardcode 數字
- 專注計時用 Timestamp Diffing，不用 setInterval/setTimeout 長計時
- Mood 離線衰減底線 = 30（OFFLINE_MOOD_FLOOR）

## 程式碼風格
- dart analyze 零警告
- 每個 Widget 獨立檔案
- 所有 async 操作必須 try-catch
- 有意義的變數命名

## 資料夾結構
lib/
├── main.dart
├── app.dart
├── l10n/                    # i18n ARB 檔案
├── game/                    # Flame 遊戲邏輯
│   ├── pixel_rats_game.dart
│   ├── components/          # 老鼠、配件、場景
│   ├── animations/          # 動畫狀態機
│   └── systems/             # Mood、Trust、Gacha
├── models/                  # 資料模型
├── services/                # Firebase、Remote Config
├── screens/                 # UI 頁面
└── widgets/                 # 可重用元件
web/
├── index.html               # PWA 入口
├── manifest.json             # PWA 設定
└── firebase-messaging-sw.js  # Service Worker

## 核心規格摘要
- Mood: 0–100, 離線底線 30
- Trust: 0–1000, 永不衰減, 新手 7 天 ×2
- Focus: 25/50/100 分鐘
- Grace Period: 15s 免罰 → 60s 警示 → 60s+ 懲罰
- Gacha: 僅 Cheese（免費），Trust 門檻分池
- 配件: 3 部位 head/back/background, 4 級 common/rare/epic/legend
- MVP 無付費、無 Gold Cheese

## Commit 規範
feat / fix / refactor / style / test / docs
```

---

## 7. spec.md 精簡版（Web 版）

```markdown
# spec.md — PixelRats MVP（Web PWA 版）

## 產品
Focus Tamagotchi PWA — 像素老鼠陪你專注。

## 核心循環
Focus → Mood↑ → Trust↑ → 解鎖 Gacha Pool → 抽配件 → 繼續 Focus

## 專注模式
| 模式 | 時長 | Mood | Trust | Cheese |
|------|------|------|-------|--------|
| Short | 25min | +5 | +3 | +10 |
| Deep | 50min | +10 | +5 | +25 |
| Flow | 100min | +20 | +10 | +60 |

## Mood（0–100）
離線底線 30。Sad 只由專注中離開觸發。
Luck = (mood - 50) × 0.5%

## Trust（0–1000）
0=Stranger, 100=Friend, 300=Partner, 600=Family, 1000=SoulBond
永不衰減。新手 7 天 ×2。

## Grace Period
0–15s: 無懲罰 / 15–60s: 警示 / 60s+: Mood -2/30s

## Gacha
Cheese 免費抽 120/次。4 級: Common60% Rare25% Epic10% Legend5%
Trust 門檻分池。Mood 影響 luck。
MVP 無 Gold Cheese。

## 配件（MVP）
head / back / background（3 部位）
mouth / pattern → Phase 1.5

## 動畫（8 狀態）
idle / studying / eating / confused / sad / happy / sleeping / walking

## 技術
Flutter Web + Flame + Firebase Hosting（PWA）
visibilitychange 監聽切出 / 每 30 秒 Firestore checkpoint
Google 登入 / AdSense for Games（可選）
所有經濟數值走 Remote Config
```

---

## 8. 上線準備清單（PWA 版 — 比 App Store 簡化 80%）

| 項目 | 時間 | 備註 |
|------|------|------|
| 購買 Domain | Sprint 6 | pixelrats.app 或 .io |
| Firebase Hosting 設定 | Sprint 6 | 自訂 domain + SSL（免費） |
| manifest.json | Sprint 4 | App 名稱、Icon、主題色 |
| Service Worker | Sprint 4 | 離線 fallback 頁面 |
| OG Meta Tags | Sprint 6 | 社群分享預覽圖 |
| 隱私政策頁面 | Sprint 6 | Firebase Auth 資料收集說明 |
| Google AdSense 申請 | Sprint 4 | 需要有內容的網站才能申請 |
| App Icon（各尺寸） | Phase A | 192×192 + 512×512 PNG |

> 不需要：Apple Developer 帳號、App Store 截圖、Google Play Console、code signing、審核等待

---

## 9. 上線後數據追蹤計畫

### 核心驗證指標（MVP 唯一目標：留存）

| 指標 | 目標 | 行動觸發點 |
|------|------|-----------|
| **Day 7 留存率** | **> 35%** | **低於 25% → 核心循環有問題，優先修** |
| Day 1 留存率 | > 60% | 低於 50% → 新手引導有問題 |
| 每日 Session 完成率 | > 70% | 低於 60% → 計時器 UX 或 Mood 懲罰太重 |
| 平均 Session 數/日 | > 1.5 | 低於 1 → 回訪動力不足 |

### 每週檢視

| 指標 | 觀察重點 |
|------|---------|
| Mood 分佈 | 多數用戶是否維持 40–80？太多 <30 = 衰減太快 |
| Trust 成長 | 第 7 天多數 > 80？太低 = 獎勵不夠 |
| Gacha 抽取頻率 | 每人每天 0.5–1 次？太低 = Cheese 太難賺 |
| 瀏覽器分佈 | Chrome vs Safari 比例，針對性優化 |
| 跳出率 | 首次訪問多少人完成第一次專注？ |

### 留存達標後的下一步

```
Day 7 留存 > 35% 確認後：
├── 加入 Gold Cheese 付費（串接金流）
├── 加入更多廣告位置
├── 開始 Phase 1.5（嘴飾 / 毛色部位）
└── 評估是否轉 App Store 上架

Day 7 留存 < 25%：
├── 檢查 Mood 衰減是否太快
├── 檢查 Gacha 是否太慢（Cheese 不夠）
├── 檢查新手引導是否清楚
├── 訪談封測用戶找痛點
└── Remote Config 調整數值後再測
```

---

## 10. Pre-Mac 期間的 Flutter Web 學習路徑

### Week 1 前半：Dart + Flutter 基礎（5 小時）

| 順序 | 內容 | 時間 |
|------|------|------|
| 1 | Dart 語法（有 JS 基礎跳著看） | 30 分 |
| 2 | Flutter 第一個 App（Codelab） | 2 小時 |
| 3 | StatelessWidget vs StatefulWidget | 1 小時 |
| 4 | Riverpod 入門 | 1.5 小時 |

### Week 1 後半：Flame + Web 特性（5 小時）

| 順序 | 內容 | 時間 |
|------|------|------|
| 1 | Flame 入門教學 | 2 小時 |
| 2 | Sprite 載入與動畫 | 1.5 小時 |
| 3 | **Flame Web POC**（載入你的老鼠） | 1.5 小時 |

**POC 完成時的 moment：** 在 Chrome 上看到你的像素老鼠動畫播放。這會非常有成就感，而且直接驗證了技術可行性。

---

## 11. 第一批配件追加時間表

| 時間點 | 追加內容 | 數量 |
|--------|---------|------|
| 上線後第 2 週 | 「上線慶祝」限定頭飾 + 背部 | 2 件 |
| 上線後第 1 個月 | 季節主題配件 | 6–8 件 |
| 上線後第 2 個月 | 台灣節慶配件 | 4–6 件 |
| 上線後第 3 個月 | 評估開放嘴飾/毛色（Phase 1.5） | 依數據 |

---

## 12. 風險與應對

| 風險 | 機率 | 影響 | 應對方案 |
|------|------|------|---------|
| Flame Web 效能不足 | 中 | 致命 | Week 1 POC 驗證；降幀率到 8fps；簡化渲染層 |
| 瀏覽器殺進程遺失狀態 | 高 | 中 | 每 30 秒 Firestore checkpoint |
| PWA「加入主畫面」轉換率低 | 高 | 高 | 新手引導強調「加入主畫面」；寄信/推播提醒回訪 |
| AdSense for Games 申請不過 | 中 | 低 | MVP 不依賴廣告收入，純免費驗證 |
| 台灣用戶偏好 App 不信任網頁 | 中 | 中 | Web 驗證留存後盡快轉 App Store |
| 白噪音 Web Audio API 相容性 | 低 | 中 | 備選：Howler.js 音效庫 |

---

## 附錄：完整指令書目錄

| 章節 | 內容 | 版本 |
|------|------|------|
| 第一章 | MVP 產品核心定義（Mood+Trust、核心循環、Gacha、NFT 預留） | v0.2 |
| 第二章 | 技術架構（渲染、Sprite、Firestore、防作弊、CI/CD） | v0.2 |
| 第三章 | 變現與經濟平衡（Cheese 經濟、定價、Luck 曲線、Remote Config） | v0.1 |
| 第四章 | 執行計畫（Web PWA 版、Windows 立即開工、免費 MVP 驗證） | v0.2 |

---

## 附錄：v0.1 → v0.2 第四章變更記錄

| 項目 | v0.1 | v0.2 | 變更原因 |
|------|------|------|---------|
| 發行平台 | App Store + Google Play | PWA（Firebase Hosting） | 跳過審核，快速驗證 |
| 開發起點 | 等 Mac 到貨 | Windows 立即開工 | Flutter Web 不需要 Mac |
| MVP 變現 | AdMob + IAP + 月卡 | 純免費（AdSense 可選） | 先驗證留存再變現 |
| 帳號系統 | Google + Apple 登入 | 僅 Google 登入 | Apple 登入 Web 設定繁瑣 |
| 上線時間 | Mac 到手後 4–6 個月 | 開工後 10–12 週 | 大幅加速 |
| Sprint 10 | 1–2 週上架準備 | 1 週 PWA 部署 | 無商店審核 |
| 金流 | RevenueCat（IAP） | 無（未來綠界/Stripe） | MVP 不做付費 |
