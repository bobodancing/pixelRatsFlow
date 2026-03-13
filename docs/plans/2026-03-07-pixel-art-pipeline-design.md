# PixelRats 像素美術 Pipeline 設計文件

> 日期：2026-03-07
> 狀態：已核准
> 範圍：老鼠主體動畫 + 少量示範配件

---

## 1. 目標

在 `C:\Users\user\Documents\pixelRats` 資料夾中，利用 pixel-plugin（Aseprite MCP）建立 PixelRats 的像素美術 pipeline：

1. **老鼠主體 8 種動畫狀態**（輸出 .ase 原始檔）
2. **每部位 2-3 件示範配件**（從現有圖拆分，共約 6-9 件）
3. **驗證整體 pipeline 可行性**，為後續量產建立標準流程

---

## 2. 工作範圍

### 2.1 老鼠主體動畫（優先）

以 `items/pixelRats.png`（320x320）/ `items/pixelRats_64x64.png` 為基底。

| 動畫狀態 | 英文 ID | 預估幀數 | 使用場景 |
|---------|---------|---------|---------|
| 待機 | idle | 4-6 幀 | 啟動前、休息期 |
| 念書 | studying | 4-6 幀 | 專注期間主要動畫 |
| 吃飯 | eating | 6-8 幀 | 專注結束獎勵 |
| 困惑 | confused | 2-3 幀 | 離開 15-60 秒 |
| 難過 | sad | 3-4 幀 | 離開超過 60 秒 |
| 開心 | happy | 4-6 幀 | 升級、抽到好配件 |
| 睡覺 | sleeping | 2-3 幀 | 長時間休息 |
| 走路 | walking | 4-6 幀 | 場景間移動 |

**總計：** 約 29-43 幀

**已有素材：** `pixellabPxo/` 中有 eating、walking 的 .pxo 測試幀可參考。

### 2.2 示範配件（從現有圖拆分）

從 `items/` 中的 king.png、demon.png、angle.png 拆出獨立配件：

| 來源圖 | 拆出的 head 配件 | 拆出的 back 配件 |
|--------|----------------|-----------------|
| king.png | 皇冠 | 紅色斗篷 |
| demon.png | 惡魔角 | 黑色翅膀 |
| angle.png | 光環 | 白色翅膀 |

**每件配件：** 64x64 PNG，透明背景，獨立 sprite。
**背景配件（background slot）：** 本階段暫不處理。

### 2.3 錨點模板

每個動畫幀需定義 3 個錨點座標（MVP）：

```json
{
  "frame_id": "idle_01",
  "anchors": {
    "head": { "x": 38, "y": 12 },
    "back": { "x": 20, "y": 18 },
    "background": { "x": 0, "y": 0 }
  }
}
```

---

## 3. 技術方案：pixel-plugin 為主

### 3.1 工具鏈

```
素材來源
  ├── items/pixelRats.png（老鼠主體基底）
  ├── items/king.png, demon.png, angle.png（配件來源）
  └── pixellabPxo/*.pxo（已有動畫參考）
      │
      ↓
pixel-plugin MCP（mcp__aseprite__* 工具）
  ├── create_canvas — 建立 64x64 畫布
  ├── draw_pixels — 逐幀繪製像素
  ├── manage layers — 圖層管理
  ├── animation frames — 動畫幀建立
  └── palette management — 調色盤統一
      │
      ↓
Python PIL（配件拆分輔助）
  ├── 從合成圖中裁切配件區域
  ├── 縮放至 64x64
  └── 去背透明 PNG
      │
      ↓
Aseprite CLI（批次處理）
  ├── 格式轉換
  └── sprite sheet 匯出（未來需要時）
      │
      ↓
輸出：.ase 原始檔
  ├── rat_animations.ase（老鼠主體全動畫）
  └── items/*.ase（各配件獨立檔案）
```

### 3.2 Spec 規格

- **統一尺寸：** 64x64 pixel
- **色彩深度：** 32-bit RGBA
- **檔案格式：** .ase / .aseprite（本階段）
- **風格：** 溫暖像素風、黑色外框線、與現有 pixelRats 一致

### 3.3 Windows 環境注意事項

- Aseprite 路徑：`C:\Users\user\Documents\pixelRats\Aseprite-v1.3.17-x64\Aseprite.exe`
- pixel-plugin MCP 設定：`~/.config/pixel-mcp/config.json`
- **Controlled Folder Access 限制：** Documents 目錄下，bash/Node.js/Aseprite 子程序無法直接寫入。需使用 Python (py.exe) 或 Claude Code 的 Write 工具作為寫入中介。

---

## 4. 不在本次範圍

- 背景場景（圖書館、咖啡廳、公園）→ 之後用 algorithmic-art
- 配件背景（background slot）→ 之後用 algorithmic-art
- sprite sheet + JSON 匯出 → 之後需要時再做
- 大量配件量產（36-48 件）→ pipeline 驗證後再進行
- Flame 引擎整合測試 → Flutter 專案建立後

---

## 5. 後續擴展方向

| 階段 | 內容 | 建議工具 |
|------|------|---------|
| 階段 2 | 背景場景生成 | algorithmic-art (p5.js) |
| 階段 3 | 配件量產 (36-48 件) | pixel-plugin + PixelLab.ai |
| 階段 4 | sprite sheet + JSON 匯出 | pixel-plugin export |
| 階段 5 | Flame 引擎整合 | Flutter + Flame |
