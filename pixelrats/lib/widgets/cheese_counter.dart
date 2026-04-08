import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class CheeseCounter extends StatelessWidget {
  const CheeseCounter({super.key, required this.amount});

  final int amount;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('🧀', style: TextStyle(fontSize: 16)),
        const SizedBox(width: 6),
        Text(amount.toString(), style: AppTypography.hudValue),
      ],
    );
  }
}
