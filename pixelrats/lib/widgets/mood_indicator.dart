import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class MoodIndicator extends StatelessWidget {
  const MoodIndicator({
    super.key,
    required this.moodPercent,
    required this.moodLabel,
  });

  final int moodPercent;
  final String moodLabel;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('❤', style: TextStyle(fontSize: 16)),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 60,
              height: 6,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(3),
                child: LinearProgressIndicator(
                  value: moodPercent / 100,
                  backgroundColor: AppColors.bgCard,
                  valueColor: const AlwaysStoppedAnimation(AppColors.moodPink),
                ),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              '$moodPercent% $moodLabel',
              style: AppTypography.hudLabel.copyWith(fontSize: 10),
            ),
          ],
        ),
      ],
    );
  }
}
