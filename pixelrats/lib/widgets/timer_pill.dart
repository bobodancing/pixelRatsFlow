import 'package:flutter/material.dart';
import '../models/enums.dart';
import '../utils/app_theme.dart';

class TimerPill extends StatelessWidget {
  const TimerPill({
    super.key,
    required this.label,
    required this.mode,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final FocusMode mode;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: AppButtonStyles.timerPill(isActive: isSelected),
      onPressed: onTap,
      child: Text(label),
    );
  }
}
