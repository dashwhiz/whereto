import 'package:flutter/material.dart';
import '../app/app_colors.dart';

/// FlickRadar app logo
class AppLogo extends StatelessWidget {
  final double fontSize;
  final Color? color;

  const AppLogo({super.key, this.fontSize = 48, this.color});

  @override
  Widget build(BuildContext context) {
    final textColor = color ?? AppColors.primary;

    return Text(
      'FlickRadar',
      style: TextStyle(
        color: textColor,
        fontSize: fontSize,
        fontWeight: FontWeight.w700,
        letterSpacing: 1,
      ),
    );
  }
}
