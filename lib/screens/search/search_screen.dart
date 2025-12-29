import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/app_colors.dart';
import '../../data/background_images.dart';
import '../../models/movie.dart';
import '../../models/region.dart';
import '../../services/mock_data_service.dart';
import '../../widgets/app_logo.dart';
import '../../widgets/availability_sheet.dart';
import 'widgets/loading_list_widget.dart';
import 'widgets/movie_list_widget.dart';
import 'widgets/search_bar_widget.dart';

class MovieSearchController extends GetxController
    with GetTickerProviderStateMixin {
  final searchResults = <Movie>[].obs;
  final isLoading = false.obs;
  final isSearching = false.obs;
  final selectedRegion = Region.defaultRegion.obs;
  final hasFocus = false.obs;
  final hasText = false.obs;
  final currentBackgroundIndex = 0.obs;

  String _lastSearchQuery = '';
  Timer? _debounceTimer;
  Timer? _backgroundTimer;

  final textController = TextEditingController();
  final searchFocusNode = FocusNode();

  late final AnimationController introController;
  late final Animation<double> logoAnimation;
  late final Animation<double> searchBarFadeAnimation;
  late final AnimationController animationController;
  late final Animation<double> searchBarAnimation;

  @override
  void onInit() {
    super.onInit();

    introController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    logoAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: introController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    searchBarFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: introController,
        curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
      ),
    );

    animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    searchBarAnimation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInOut,
    );

    textController.addListener(_onTextChanged);

    searchFocusNode.addListener(() {
      hasFocus.value = searchFocusNode.hasFocus;
    });

    introController.forward();

    _backgroundTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      currentBackgroundIndex.value =
          (currentBackgroundIndex.value + 1) % BackgroundImages.images.length;
    });
  }

  @override
  void onClose() {
    _debounceTimer?.cancel();
    _backgroundTimer?.cancel();
    introController.dispose();
    animationController.dispose();
    textController.dispose();
    searchFocusNode.dispose();
    super.onClose();
  }

  void _onTextChanged() {
    final query = textController.text;

    hasText.value = query.isNotEmpty;

    if (query.isNotEmpty && !isSearching.value) {
      animationController.forward();
    } else if (query.isEmpty && isSearching.value) {
      animationController.reverse();
    }

    onSearchChanged(query);
  }

  void onSearchChanged(String query) {
    _debounceTimer?.cancel();

    if (query.trim().isEmpty) {
      isSearching.value = false;
      searchResults.clear();
      _lastSearchQuery = '';
      return;
    }

    if (query.trim() == _lastSearchQuery) {
      return;
    }

    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      _performSearch(query.trim());
    });
  }

  Future<void> _performSearch(String query) async {
    if (isLoading.value || query.isEmpty || query == _lastSearchQuery) return;

    isSearching.value = true;
    _lastSearchQuery = query;
    isLoading.value = true;

    try {
      final results = await mockDataService.searchMovies(query);
      searchResults.value = results;
    } catch (e) {
      searchResults.clear();
    } finally {
      isLoading.value = false;
    }
  }

  void clearSearch() {
    textController.clear();
    searchResults.clear();
    isSearching.value = false;
    isLoading.value = false;
    hasText.value = false;
    _lastSearchQuery = '';
    _debounceTimer?.cancel();
    searchFocusNode.unfocus();
  }

  void changeRegion(Region region) {
    selectedRegion.value = region;
  }
}

class SearchScreen extends GetView<MovieSearchController> {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<MovieSearchController>()) {
      Get.put(MovieSearchController(), permanent: true);
    }

    return GestureDetector(
      onTap: () => controller.searchFocusNode.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            AnimatedBuilder(
              animation: Listenable.merge([
                controller.logoAnimation,
                controller.searchBarAnimation,
              ]),
              builder: (context, child) {
                final introOpacity = controller.logoAnimation.value;

                final searchFadeOut = 1.0 - controller.searchBarAnimation.value;

                final combinedOpacity = introOpacity * searchFadeOut;

                final scale = 1.0 + (0.1 * (1.0 - introOpacity));

                return Transform.scale(
                  scale: scale,
                  child: Opacity(
                    opacity: combinedOpacity,
                    child: Obx(
                      () => AnimatedSwitcher(
                        duration: const Duration(milliseconds: 1000),
                        child: Container(
                          key: ValueKey(
                            controller.currentBackgroundIndex.value,
                          ),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(
                                BackgroundImages
                                    .images[controller
                                        .currentBackgroundIndex
                                        .value]
                                    .url,
                              ),
                              fit: BoxFit.cover,
                              opacity: 0.5,
                            ),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  AppColors.background.withValues(alpha: 0.4),
                                  AppColors.background.withValues(alpha: 0.7),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),

            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: AnimatedBuilder(
                animation: Listenable.merge([
                  controller.logoAnimation,
                  controller.searchBarAnimation,
                ]),
                builder: (context, child) {
                  final introOpacity = controller.logoAnimation.value;
                  final searchFadeOut =
                      1.0 - controller.searchBarAnimation.value;
                  final combinedOpacity = introOpacity * searchFadeOut;

                  return Opacity(
                    opacity: combinedOpacity,
                    child: Obx(
                      () => Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Photo by ${BackgroundImages.images[controller.currentBackgroundIndex.value].artist}',
                            style: TextStyle(
                              color: AppColors.textSecondary.withValues(
                                alpha: 0.7,
                              ),
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            SafeArea(
              bottom: false,
              child: SizedBox.expand(
                child: Stack(
                  children: [
                    Obx(() {
                      if (!controller.isSearching.value) {
                        return const SizedBox.shrink();
                      }

                      return Padding(
                        padding: const EdgeInsets.only(top: 80),
                        child: _buildResultsList(controller),
                      );
                    }),

                    _buildAnimatedLogo(context, controller),

                    _buildAnimatedSearchBar(controller),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedLogo(
    BuildContext context,
    MovieSearchController controller,
  ) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        controller.logoAnimation,
        controller.searchBarAnimation,
      ]),
      builder: (context, child) {
        final introOpacity = controller.logoAnimation.value;
        final movementOpacity = 1.0 - controller.searchBarAnimation.value;
        final combinedOpacity = introOpacity * movementOpacity;

        final screenHeight = MediaQuery.of(context).size.height;
        final logoHeight = 48.0 * 1.4;
        final searchBarHeight = 56.0;
        final spacing = 40.0;

        final totalHeight = logoHeight + spacing + searchBarHeight;
        final centerY = (screenHeight / 2) - (totalHeight / 2) - 100;
        final topY = -120.0;
        final titleTop =
            controller.searchBarAnimation.value * topY +
            (1 - controller.searchBarAnimation.value) * centerY;

        final scale = 1.0 - (controller.searchBarAnimation.value * 0.3);

        return Positioned(
          top: titleTop,
          left: 0,
          right: 0,
          child: Opacity(
            opacity: combinedOpacity,
            child: Transform.scale(scale: scale, child: child!),
          ),
        );
      },
      child: const Center(child: AppLogo(fontSize: 48)),
    );
  }

  Widget _buildAnimatedSearchBar(MovieSearchController controller) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        controller.searchBarFadeAnimation,
        controller.searchBarAnimation,
      ]),
      builder: (context, child) {
        final introOpacity = controller.searchBarFadeAnimation.value;

        final screenHeight = MediaQuery.of(context).size.height;
        final logoHeight = 48.0 * 1.4;
        final spacing = 40.0;
        final searchBarHeight = 56.0;

        final totalHeight = logoHeight + spacing + searchBarHeight;
        final centerY =
            (screenHeight / 2) - (totalHeight / 2) + logoHeight + spacing - 100;
        final topY = 20.0;
        final searchTop =
            controller.searchBarAnimation.value * topY +
            (1 - controller.searchBarAnimation.value) * centerY;

        return Positioned(
          top: searchTop,
          left: 16,
          right: 16,
          child: Opacity(opacity: introOpacity, child: child!),
        );
      },
      child: AnimatedBuilder(
        animation: controller.searchBarFadeAnimation,
        builder: (context, child) {
          return Obx(
            () => SearchBarWidget(
              controller: controller.textController,
              focusNode: controller.searchFocusNode,
              onClear: controller.clearSearch,
              hasFocus: controller.hasFocus.value,
              hasText: controller.hasText.value,
              fadeProgress: controller.searchBarFadeAnimation.value,
            ),
          );
        },
      ),
    );
  }

  Widget _buildResultsList(MovieSearchController controller) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const LoadingListWidget();
      }

      return MovieListWidget(
        movies: controller.searchResults,
        onMovieTap: (movie) => _onMovieSelected(movie, controller),
      );
    });
  }

  void _onMovieSelected(movie, MovieSearchController controller) {
    controller.searchFocusNode.unfocus();

    Get.bottomSheet(
      AvailabilitySheet(movie: movie, region: controller.selectedRegion.value),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }
}
