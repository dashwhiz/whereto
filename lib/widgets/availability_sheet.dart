import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../app/app_colors.dart';
import '../models/movie.dart';
import '../models/region.dart';
import '../models/watch_availability.dart';
import '../models/streaming_provider.dart';
import '../services/tmdb_service.dart';
import 'availability_sheet/loading_state_widget.dart';
import 'availability_sheet/movie_header_widget.dart';
import 'availability_sheet/not_available_widget.dart';
import 'availability_sheet/provider_item_widget.dart';
import 'availability_sheet/region_selector_button.dart';
import 'availability_sheet/shimmer_sections.dart';
import 'region_selector_sheet.dart';
import 'trailer_player.dart';
import 'cast_list.dart';

class AvailabilitySheet extends StatefulWidget {
  final Movie movie;
  final Region region;

  const AvailabilitySheet({
    super.key,
    required this.movie,
    required this.region,
  });

  @override
  State<AvailabilitySheet> createState() => _AvailabilitySheetState();
}

class _AvailabilitySheetState extends State<AvailabilitySheet> {
  WatchAvailability? _availability;
  bool _isLoading = true;
  bool _isLoadingDetails = true;
  late Region _currentRegion;
  Movie? _detailedMovie;

  @override
  void initState() {
    super.initState();
    _currentRegion = widget.region;
    _loadAvailability();
  }

  Future<void> _loadAvailability() async {
    setState(() {
      _isLoading = true;
      _isLoadingDetails = true;
    });

    try {
      // Fetch both availability and details in parallel
      final results = await Future.wait([
        tmdbService.getWatchProviders(
          movieId: widget.movie.id,
          mediaType: widget.movie.mediaType,
          region: _currentRegion.code,
        ),
        tmdbService.getDetails(
          movieId: widget.movie.id,
          mediaType: widget.movie.mediaType,
        ),
      ]);

      if (mounted) {
        setState(() {
          _availability = results[0] as WatchAvailability?;
          _detailedMovie = results[1] as Movie?;
          _isLoading = false;
          _isLoadingDetails = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isLoadingDetails = false;
        });
      }
    }
  }

  void _onChangeRegion() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => RegionSelectorSheet(
        selectedRegion: _currentRegion,
        onRegionSelected: (region) {
          setState(() => _currentRegion = region);
          _loadAvailability();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.85,
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
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 16),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MovieHeaderWidget(movie: _detailedMovie ?? widget.movie),
                        const SizedBox(height: 20),
                        RegionSelectorButton(
                          region: _currentRegion,
                          onTap: _onChangeRegion,
                        ),
                        _buildAvailabilityContent(),

                        // Overview section with shimmer loading
                        const SizedBox(height: 20),
                        _isLoadingDetails
                            ? const OverviewShimmer()
                            : (_detailedMovie?.overview != null &&
                                    _detailedMovie!.overview!.isNotEmpty)
                                ? _buildOverviewSection()
                                : const SizedBox.shrink(),

                        // Trailer section with shimmer loading
                        const SizedBox(height: 20),
                        _isLoadingDetails
                            ? const TrailerShimmer()
                            : (_detailedMovie?.trailerKey != null)
                                ? TrailerPlayer(
                                    trailerKey: _detailedMovie!.trailerKey!,
                                    title: 'Watch Trailer',
                                  )
                                : const SizedBox.shrink(),

                        // Cast section with shimmer loading
                        const SizedBox(height: 20),
                        _isLoadingDetails
                            ? const CastShimmer()
                            : (_detailedMovie != null && _detailedMovie!.cast.isNotEmpty)
                                ? CastList(
                                    cast: _detailedMovie!.cast,
                                    title: 'Cast & Crew',
                                  )
                                : const SizedBox.shrink(),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOverviewSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Overview',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.1),
                  width: 1,
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
              child: Text(
                _detailedMovie?.overview ?? widget.movie.overview ?? '',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAvailabilityContent() {
    if (_isLoading) {
      return const LoadingStateWidget();
    }

    if (_availability == null || !_availability!.isAvailable) {
      return NotAvailableWidget(
        region: _currentRegion,
        onChangeRegion: _onChangeRegion,
      );
    }

    final allProvidersWithType = <Map<String, dynamic>>[];

    for (var provider in _availability!.flatrate) {
      allProvidersWithType.add({
        'provider': provider,
        'type': 'stream'.tr,
        'showPrice': false,
      });
    }

    for (var provider in _availability!.rent) {
      allProvidersWithType.add({
        'provider': provider,
        'type': 'rent'.tr,
        'showPrice': true,
      });
    }

    for (var provider in _availability!.buy) {
      allProvidersWithType.add({
        'provider': provider,
        'type': 'buy'.tr,
        'showPrice': true,
      });
    }

    return Wrap(
      spacing: 12,
      runSpacing: 16,
      children: allProvidersWithType.map((item) {
        return ProviderItemWidget(
          provider: item['provider'] as StreamingProvider,
          type: item['type'] as String,
          showPrice: item['showPrice'] as bool,
        );
      }).toList(),
    );
  }
}
