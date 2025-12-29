import 'package:flutter/material.dart';
import '../../app/app_colors.dart';
import '../../models/streaming_provider.dart';
import '../../utils/provider_logo_mapper.dart';

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
              child: _buildProviderLogo(),
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

  Widget _buildProviderLogo() {
    // Check if we have a local logo for this provider
    final localLogoPath = ProviderLogoMapper.getLocalLogoPath(provider.providerId);

    if (localLogoPath != null) {
      // Use local asset for crispy quality
      return Image.asset(
        localLogoPath,
        width: 60,
        height: 60,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          // Fallback to network if local asset fails
          return _buildNetworkLogo();
        },
      );
    }

    // Fallback to network image if no local logo
    return _buildNetworkLogo();
  }

  Widget _buildNetworkLogo() {
    return Image.network(
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
    );
  }
}
