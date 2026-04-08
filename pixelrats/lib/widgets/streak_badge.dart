import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class StreakBadge extends StatelessWidget {
  const StreakBadge({super.key, required this.days});

  final int days;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('🔥', style: TextStyle(fontSize: 14)),
        const SizedBox(width: 4),
        Text(
          '$days',
          style: AppTypography.hudValue.copyWith(color: AppColors.streakOrange),
        ),
      ],
    );
  }
}
