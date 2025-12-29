import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../app/app_colors.dart';
import '../models/region.dart';

class RegionSelectorSheet extends StatefulWidget {
  final Region selectedRegion;
  final Function(Region) onRegionSelected;

  const RegionSelectorSheet({
    super.key,
    required this.selectedRegion,
    required this.onRegionSelected,
  });

  @override
  State<RegionSelectorSheet> createState() => _RegionSelectorSheetState();
}

class _RegionSelectorSheetState extends State<RegionSelectorSheet> {
  late Region _selectedRegion;

  @override
  void initState() {
    super.initState();
    _selectedRegion = widget.selectedRegion;
  }

  void _onRegionTap(Region region) {
    setState(() => _selectedRegion = region);
    widget.onRegionSelected(region);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surface.withValues(alpha: 0.9),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              border: const Border(
                top: BorderSide(
                  color: Color.fromRGBO(255, 255, 255, 0.1),
                  width: 1.5,
                ),
              ),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withValues(alpha: 0.08),
                  Colors.white.withValues(alpha: 0.02),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 30,
                  offset: const Offset(0, -10),
                ),
              ],
            ),
            child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'selectRegion'.tr,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'selectRegionSubtitle'.tr,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          Flexible(
            child: ListView(
              shrinkWrap: true,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 8,
                  ),
                  child: Text(
                    'popular'.tr,
                    style: const TextStyle(
                      color: AppColors.textTertiary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                ...Region.popular.map((region) => _buildRegionItem(region)),

                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  child: Divider(
                    color: AppColors.border,
                    height: 1,
                    thickness: 1,
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 8,
                  ),
                  child: Text(
                    'allRegions'.tr,
                    style: const TextStyle(
                      color: AppColors.textTertiary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                ...Region.all
                    .where((region) => !Region.popular.contains(region))
                    .map((region) => _buildRegionItem(region)),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRegionItem(Region region) {
    final isSelected = region.code == _selectedRegion.code;

    return InkWell(
      onTap: () => _onRegionTap(region),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Text(region.flag, style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 16),

            Expanded(
              child: Text(
                region.name,
                style: TextStyle(
                  color: isSelected
                      ? AppColors.textPrimary
                      : AppColors.textSecondary,
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),

            if (isSelected)
              const Icon(Icons.check, color: AppColors.primary, size: 24),
          ],
        ),
      ),
    );
  }
}
