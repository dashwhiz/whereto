import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import '../app/app_colors.dart';
import '../models/movie.dart';

class CastList extends StatelessWidget {
  final List<CastMember> cast;
  final String? title;

  const CastList({
    super.key,
    required this.cast,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    if (cast.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.people_outline,
              color: AppColors.primary,
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              title ?? 'cast'.tr,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: cast.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(
                  right: index < cast.length - 1 ? 12 : 0,
                ),
                child: _buildCastMember(cast[index]),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCastMember(CastMember member) {
    return SizedBox(
      width: 110,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Container(
                width: 110,
                height: 130,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.1),
                    width: 1.5,
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withValues(alpha: 0.08),
                      Colors.white.withValues(alpha: 0.02),
                    ],
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: member.getProfileUrl() != null
                      ? CachedNetworkImage(
                          imageUrl: member.getProfileUrl()!,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => _buildShimmerPlaceholder(),
                          errorWidget: (context, url, error) =>
                              _buildProfilePlaceholder(),
                        )
                      : _buildProfilePlaceholder(),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Flexible(
            child: Text(
              member.name,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 2),
          Flexible(
            child: Text(
              member.character,
              style: TextStyle(
                color: AppColors.textSecondary.withValues(alpha: 0.8),
                fontSize: 11,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerPlaceholder() {
    return Shimmer.fromColors(
      baseColor: AppColors.surface.withValues(alpha: 0.3),
      highlightColor: AppColors.surface.withValues(alpha: 0.5),
      child: Container(
        color: AppColors.surface.withValues(alpha: 0.3),
      ),
    );
  }

  Widget _buildProfilePlaceholder() {
    return Container(
      color: AppColors.surface.withValues(alpha: 0.3),
      child: const Center(
        child: Icon(
          Icons.person,
          color: AppColors.textTertiary,
          size: 48,
        ),
      ),
    );
  }
}
