/// PixelRats App Theme — 從 UIUX mockup 提取的設計規範
/// Sprint 1 開始 Flutter 開發時，將此檔移至 lib/utils/app_theme.dart
///
/// 參考來源：UIUX/ 資料夾中 5 個 Figma AI 生成的 React mockup
/// - Splash Screen UI Design (port 3001)
/// - Mobile Tamagotchi Timer UI (port 3002)
/// - Profile and Equipment Screen (port 3003)
/// - Gacha Pull Result Screen (port 3004)
/// - Reward Screen (port 3005)

import 'dart:ui';
import 'package:flutter/material.dart';

/// ═══════════════════════════════════════════════════════════
/// 1. 色盤系統 (Color Palette)
/// ═══════════════════════════════════════════════════════════

class AppColors {
  AppColors._();

  // ── 背景 ──
  static const Color bgDark = Color(0xFF1A0F1E);       // 最深底色
  static const Color bgPrimary = Color(0xFF2D1B2E);     // 主背景（所有畫面共用）
  static const Color bgCard = Color(0xFF3D2A3E);        // 卡片/道具格子底色

  // ── 主色（紫） ──
  static const Color purple = Color(0xFF8B4D8B);        // 按鈕、選中態
  static const Color purpleDark = Color(0xFF6A3A6A);    // 按鈕漸層暗端
  static const Color purpleDeep = Color(0xFF533483);    // EPIC 稀有度緞帶
  static const Color purpleGlow = Color(0x668B4D8B);    // 按鈕 glow shadow（40% opacity）

  // ── 金色 ──
  static const Color gold = Color(0xFFFFD700);          // 星星、光粒、Cheese icon
  static const Color goldWarm = Color(0xFFD4A844);      // Cheese 數字、燈光
  static const Color goldOrange = Color(0xFFFFA500);    // 光粒漸層暖端

  // ── 文字 ──
  static const Color textCream = Color(0xFFF0E6D3);     // 主文字（Home HUD）
  static const Color textCreamWarm = Color(0xFFFFF5E1);  // 主文字（Reward/Gacha）
  static const Color textCreamGold = Color(0xFFFFE4A0);  // 標題（Splash PixelRats）
  static const Color textLavender = Color(0xFFB8A0BA);   // 副文字（tagline）
  static const Color textPurpleLight = Color(0xFFC8B3CE);// 說明文字（Reward subtitle）

  // ── Mood 相關 ──
  static const Color moodPink = Color(0xFFE8758A);      // Mood 條亮端
  static const Color moodCoral = Color(0xFFE85A6A);     // Mood 條暗端
  static const Color moodHeart = Color(0xFFFF6B9D);     // Reward Mood icon

  // ── Trust 相關 ──
  static const Color trustBlue = Color(0xFF60A5FA);     // Trust 數值文字
  static const Color trustBadgeBg = Color(0x335B8DEF);  // Trust badge 底色（20%）

  // ── Streak ──
  static const Color streakOrange = Color(0xFFFF6B35);  // 🔥 streak icon

  // ── 稀有度邊框 ──
  static const Color rarityCommon = Color(0xFF808080);   // 灰
  static const Color rarityRare = Color(0xFF5B8DEF);     // 藍
  static const Color rarityEpic = Color(0xFF8B4D8B);     // 紫
  static const Color rarityLegend = Color(0xFFFFD700);   // 金（帶 glow）

  // ── 房間場景（Flame 用）──
  static const Color floorLight = Color(0xFFC49A6C);    // 木地板亮格
  static const Color floorDark = Color(0xFFA8844E);     // 木地板暗格
  static const Color wallColor = Color(0xFF3D2640);     // 牆壁
  static const Color wallTrim = Color(0xFF5A3A5E);      // 牆壁飾條
  static const Color rugColor = Color(0xFFB8727A);      // 地毯
  static const Color deskTop = Color(0xFF8B6843);       // 書桌面
  static const Color lampShade = Color(0xFFD4A844);     // 檯燈罩
}

/// ═══════════════════════════════════════════════════════════
/// 2. 磨砂玻璃樣式 (Glassmorphism)
/// ═══════════════════════════════════════════════════════════

class GlassStyle {
  GlassStyle._();

  /// 標準磨砂面板背景色
  static const Color panelBg = Color(0xA62D1B2E);       // rgba(45,27,46,0.65)

  /// 標準磨砂邊框色
  static const Color panelBorder = Color(0x4D8B4D8B);   // rgba(139,77,139,0.3)

  /// 模糊強度
  static const double blurSigma = 16.0;

  /// 圓角
  static const double borderRadius = 16.0;

  /// 建立標準磨砂裝飾
  static BoxDecoration panelDecoration({double? radius}) {
    return BoxDecoration(
      color: panelBg,
      borderRadius: BorderRadius.circular(radius ?? borderRadius),
      border: Border.all(color: panelBorder, width: 1),
    );
  }
}

/// ═══════════════════════════════════════════════════════════
/// 3. 按鈕樣式 (Button Styles)
/// ═══════════════════════════════════════════════════════════

class AppButtonStyles {
  AppButtonStyles._();

  /// 主要按鈕（紫色漸層 + glow）
  /// 用於：Start、Collect & Return、Equip Now
  static ButtonStyle primary = ElevatedButton.styleFrom(
    foregroundColor: AppColors.textCreamGold,
    backgroundColor: AppColors.purple,
    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(24),
    ),
    elevation: 0,
    textStyle: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      letterSpacing: 1.0,
    ),
  );

  /// 次要按鈕（透明 + 邊框）
  /// 用於：Share Screenshot、Back to Room
  static ButtonStyle secondary = OutlinedButton.styleFrom(
    foregroundColor: AppColors.textCreamWarm,
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(24),
    ),
    side: BorderSide(
      color: AppColors.textCreamWarm.withOpacity(0.3),
      width: 1.5,
    ),
    textStyle: const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
    ),
  );

  /// 計時器模式選擇膠囊按鈕（磨砂底）
  /// 用於：25 min / 50 min / 100 min
  static ButtonStyle timerPill({bool isActive = false}) {
    return ElevatedButton.styleFrom(
      foregroundColor: isActive
          ? const Color(0xFFE8D0F0)
          : AppColors.textCream,
      backgroundColor: isActive
          ? AppColors.purple.withOpacity(0.45)
          : GlassStyle.panelBg,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(
          color: isActive
              ? AppColors.purple.withOpacity(0.8)
              : GlassStyle.panelBorder,
          width: isActive ? 1.5 : 1.0,
        ),
      ),
      elevation: 0,
      textStyle: const TextStyle(
        fontSize: 14,
        letterSpacing: 0.3,
      ),
    );
  }
}

/// ═══════════════════════════════════════════════════════════
/// 4. 字體 (Typography)
/// ═══════════════════════════════════════════════════════════

class AppTypography {
  AppTypography._();

  /// 像素字體（Splash 標題、Reward 標題）
  /// pubspec.yaml 需加入 google_fonts 或手動載入 'Press Start 2P'
  static const String pixelFontFamily = 'Press Start 2P';

  /// 一般 UI 字體
  static const String uiFontFamily = 'system-ui';

  // ── 標題 ──
  static const TextStyle splashTitle = TextStyle(
    fontFamily: pixelFontFamily,
    fontSize: 32,
    color: AppColors.textCreamGold,
    shadows: [Shadow(color: Color(0x80FFD700), blurRadius: 20)],
  );

  static const TextStyle rewardTitle = TextStyle(
    fontFamily: pixelFontFamily,
    fontSize: 24,
    color: AppColors.textCreamWarm,
    shadows: [Shadow(color: Color(0x80FFD700), blurRadius: 20)],
  );

  // ── 副標題 ──
  static const TextStyle subtitle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w300,
    color: AppColors.textLavender,
    letterSpacing: 0.5,
  );

  // ── HUD 數值 ──
  static const TextStyle hudValue = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w700,
    color: AppColors.goldWarm,
    letterSpacing: 0.5,
  );

  static const TextStyle hudLabel = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: AppColors.textCream,
  );

  // ── Stat 卡片 ──
  static const TextStyle statValue = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColors.textCreamWarm,
  );

  static const TextStyle statLabel = TextStyle(
    fontSize: 10,
    color: AppColors.textLavender,
  );

  // ── 稀有度標籤 ──
  static const TextStyle rarityBanner = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColors.gold,
    letterSpacing: 2.0,
  );
}

/// ═══════════════════════════════════════════════════════════
/// 5. 動畫時長參考 (Animation Durations)
/// ═══════════════════════════════════════════════════════════

class AppAnimations {
  AppAnimations._();

  /// 老鼠彈跳（Reward 畫面）
  static const Duration ratBounce = Duration(milliseconds: 1000);

  /// Shimmer 光澤掃過（Reward 獎勵行）
  static const Duration shimmer = Duration(milliseconds: 2000);

  /// 數字跑動計數器（Reward +cheese/mood/trust）
  static const Duration counterRollUp = Duration(milliseconds: 1500);

  /// 星星閃爍（Splash 背景）
  static const Duration starTwinkle = Duration(milliseconds: 2000);

  /// 按鈕彈出（Splash Start 按鈕）
  static const Duration buttonSpring = Duration(milliseconds: 400);

  /// Gacha 物品浮動上下
  static const Duration itemFloat = Duration(milliseconds: 2000);

  /// Gacha 光環脈動
  static const Duration glowPulse = Duration(milliseconds: 2000);

  /// 老鼠走動步態（Home 房間）
  static const Duration walkingStep = Duration(milliseconds: 400);

  /// 場景中走路位移過渡
  static const Duration roomWander = Duration(milliseconds: 2000);
}
