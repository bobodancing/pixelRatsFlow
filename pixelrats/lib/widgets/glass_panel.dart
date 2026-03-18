import 'dart:ui';
import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class GlassPanel extends StatelessWidget {
  const GlassPanel({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? GlassStyle.borderRadius;
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: GlassStyle.blurSigma,
          sigmaY: GlassStyle.blurSigma,
        ),
        child: Container(
          padding:
              padding ??
              const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: GlassStyle.panelDecoration(radius: radius),
          child: child,
        ),
      ),
    );
  }
}
