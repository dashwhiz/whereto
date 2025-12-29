import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/app_colors.dart';
import '../../models/region.dart';

class NotAvailableWidget extends StatelessWidget {
  final Region region;
  final VoidCallback onChangeRegion;

  const NotAvailableWidget({
    super.key,
    required this.region,
    required this.onChangeRegion,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          children: [
            const Icon(
              Icons.tv_off_rounded,
              color: AppColors.textTertiary,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              '${'notAvailableIn'.tr} ${region.name}',
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'tryDifferentRegion'.tr,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: onChangeRegion,
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
              ),
              child: Text('changeRegion'.tr),
            ),
          ],
        ),
      ),
    );
  }
}
