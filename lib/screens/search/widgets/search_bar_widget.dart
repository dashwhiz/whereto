import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/app_colors.dart';

class SearchBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onClear;
  final bool hasFocus;
  final bool hasText;

  const SearchBarWidget({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onClear,
    required this.hasFocus,
    required this.hasText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: hasFocus
                ? AppColors.primary.withValues(alpha: 0.3)
                : Colors.black.withValues(alpha: 0.1),
            blurRadius: hasFocus ? 20 : 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surface.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: hasFocus
                    ? AppColors.primary.withValues(alpha: 0.6)
                    : Colors.white.withValues(alpha: 0.1),
                width: 1.5,
              ),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withValues(alpha: 0.15),
                  Colors.white.withValues(alpha: 0.05),
                ],
              ),
            ),
            child: Row(
        children: [
          const SizedBox(width: 16),
          Icon(Icons.search, color: AppColors.textSecondary, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
              ),
              cursorColor: AppColors.primary,
              decoration: InputDecoration(
                hintText: 'searchPlaceholder'.tr,
                hintStyle: TextStyle(
                  color: AppColors.textSecondary.withValues(alpha: 0.7),
                  fontSize: 16,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                filled: false,
                fillColor: Colors.transparent,
              ),
            ),
          ),
          if (hasText)
            IconButton(
              icon: const Icon(Icons.clear),
              color: AppColors.textSecondary,
              onPressed: onClear,
            ),
          const SizedBox(width: 8),
        ],
            ),
          ),
        ),
      ),
    );
  }
}
