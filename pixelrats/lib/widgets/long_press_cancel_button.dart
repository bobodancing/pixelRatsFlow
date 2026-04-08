import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class LongPressCancelButton extends StatefulWidget {
  const LongPressCancelButton({
    super.key,
    required this.onCancelled,
    required this.holdDuration,
    required this.label,
  });

  final VoidCallback onCancelled;
  final Duration holdDuration;
  final String label;

  @override
  State<LongPressCancelButton> createState() => _LongPressCancelButtonState();
}

class _LongPressCancelButtonState extends State<LongPressCancelButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.holdDuration,
    );
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onCancelled();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: (_) => _controller.forward(),
      onLongPressEnd: (_) {
        if (_controller.status != AnimationStatus.completed) {
          _controller.reverse();
        }
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 48,
                    height: 48,
                    child: CircularProgressIndicator(
                      value: _controller.value,
                      strokeWidth: 3,
                      valueColor: const AlwaysStoppedAnimation(
                        AppColors.moodCoral,
                      ),
                      backgroundColor: AppColors.bgCard,
                    ),
                  ),
                  const Icon(Icons.close, color: AppColors.textCream, size: 20),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                widget.label,
                style: const TextStyle(
                  color: AppColors.textLavender,
                  fontSize: 10,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
