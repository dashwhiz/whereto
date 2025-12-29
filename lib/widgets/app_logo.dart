import 'package:flutter/material.dart';
import '../app/app_colors.dart';

/// WhereTo app logo with Netflix-style arc effect
class AppLogo extends StatelessWidget {
  final double fontSize;
  final Color? color;

  const AppLogo({super.key, this.fontSize = 48, this.color});

  @override
  Widget build(BuildContext context) {
    final textColor = color ?? AppColors.primary;
    const letters = ['W', 'H', 'E', 'R', 'E', 'T', 'O'];

    // Arc heights - middle letters higher, edges lower (very dramatic)
    final arcOffsets = [
      14.0, // W
      8.0, // H
      0.0, // E (center-left)
      -5.0, // R (peak)
      3.0, // E (center-right)
      8.0, // T
      14.0, // O
    ];

    return SizedBox(
      height: fontSize * 1.4,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(letters.length, (index) {
          return Transform.translate(
            offset: Offset(0, arcOffsets[index]),
            child: Text(
              letters[index],
              style: TextStyle(
                color: textColor,
                fontSize: fontSize,
                fontWeight: FontWeight.w900,
                letterSpacing: 3,
                height: 1.0,
                shadows: [
                  Shadow(
                    color: textColor.withValues(alpha: 0.3),
                    offset: const Offset(0, 3),
                    blurRadius: 8,
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
