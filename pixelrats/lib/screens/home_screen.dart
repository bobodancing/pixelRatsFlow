import 'package:flutter/material.dart';
import 'package:pixelrats/l10n/app_localizations.dart';
import '../models/enums.dart';
import '../utils/app_theme.dart';
import '../widgets/glass_panel.dart';
import '../widgets/cheese_counter.dart';
import '../widgets/mood_indicator.dart';
import '../widgets/trust_badge.dart';
import '../widgets/streak_badge.dart';
import '../widgets/timer_pill.dart';
import 'focus_screen.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FocusMode _selectedMode = FocusMode.short;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final screenSize = MediaQuery.sizeOf(context);

    return Scaffold(
      body: Center(
        child: AspectRatio(
          aspectRatio: 9 / 19.5,
          child: Container(
            constraints: BoxConstraints(maxWidth: screenSize.width),
            color: AppColors.bgPrimary,
            child: Stack(
              children: [
                // Background placeholder (Flame room in Sprint 2)
                Positioned.fill(child: Container(color: AppColors.bgPrimary)),

                // Vignette overlay
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        colors: [
                          Colors.transparent,
                          AppColors.bgDark.withValues(alpha: 0.6),
                        ],
                        radius: 1.2,
                      ),
                    ),
                  ),
                ),

                // Static rat image (centered)
                Center(
                  child: Image.asset(
                    'assets/sprites/previews/rat_idle.gif',
                    width: 192,
                    height: 192,
                    filterQuality: FilterQuality.none,
                    errorBuilder: (_, __, ___) => Container(
                      width: 192,
                      height: 192,
                      color: AppColors.bgCard,
                      child: const Icon(
                        Icons.pets,
                        color: AppColors.textCream,
                        size: 64,
                      ),
                    ),
                  ),
                ),

                // HUD Overlay
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        // Top row: Cheese (left), Mood (right)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GlassPanel(
                              child: const CheeseCounter(amount: 1240),
                            ),
                            GlassPanel(
                              child: MoodIndicator(
                                moodPercent: 72,
                                moodLabel: l10n.moodStateHappy,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Mid-top center: Streak + Trust
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GlassPanel(child: const StreakBadge(days: 7)),
                            const SizedBox(width: 8),
                            GlassPanel(
                              child: TrustBadge(label: l10n.trustLevelFriend),
                            ),
                          ],
                        ),
                        const Spacer(),

                        // Bottom: Timer pills + START
                        GlassPanel(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TimerPill(
                                    label: l10n.focusModeShort,
                                    mode: FocusMode.short,
                                    isSelected:
                                        _selectedMode == FocusMode.short,
                                    onTap: () => setState(
                                      () => _selectedMode = FocusMode.short,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  TimerPill(
                                    label: l10n.focusModeDeep,
                                    mode: FocusMode.deep,
                                    isSelected: _selectedMode == FocusMode.deep,
                                    onTap: () => setState(
                                      () => _selectedMode = FocusMode.deep,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  TimerPill(
                                    label: l10n.focusModeFlow,
                                    mode: FocusMode.flow,
                                    isSelected: _selectedMode == FocusMode.flow,
                                    onTap: () => setState(
                                      () => _selectedMode = FocusMode.flow,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: AppButtonStyles.primary,
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            FocusScreen(mode: _selectedMode),
                                      ),
                                    );
                                  },
                                  child: Text(l10n.startButton),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Bottom row: Profile (left), Settings (right)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GlassPanel(
                              padding: const EdgeInsets.all(8),
                              borderRadius: 24,
                              child: IconButton(
                                icon: const Text(
                                  '🐭',
                                  style: TextStyle(fontSize: 20),
                                ),
                                onPressed: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => const ProfileScreen(),
                                  ),
                                ),
                              ),
                            ),
                            GlassPanel(
                              padding: const EdgeInsets.all(8),
                              borderRadius: 24,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.settings,
                                  color: AppColors.textCream,
                                ),
                                onPressed: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => const SettingsScreen(),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
