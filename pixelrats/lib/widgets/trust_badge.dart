import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class TrustBadge extends StatelessWidget {
  const TrustBadge({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.trustBadgeBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('⭐', style: TextStyle(fontSize: 12)),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTypography.hudLabel.copyWith(color: AppColors.trustBlue),
          ),
        ],
      ),
    );
  }
}
