import 'package:flutter/material.dart';
import '../../app/app_colors.dart';
import '../../models/streaming_provider.dart';

class ProviderItemWidget extends StatelessWidget {
  final StreamingProvider provider;
  final String type;
  final bool showPrice;

  const ProviderItemWidget({
    super.key,
    required this.provider,
    required this.type,
    required this.showPrice,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                provider.getLogoUrl(),
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.live_tv,
                    color: AppColors.textTertiary,
                    size: 24,
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 6),

          Text(
            provider.providerName,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),

          Text(
            showPrice && provider.price != null
                ? '$type • ${provider.price}'
                : type,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 10,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
