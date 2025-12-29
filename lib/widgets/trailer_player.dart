import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../app/app_colors.dart';

class TrailerPlayer extends StatefulWidget {
  final String trailerKey;
  final String? title;

  const TrailerPlayer({
    super.key,
    required this.trailerKey,
    this.title,
  });

  @override
  State<TrailerPlayer> createState() => _TrailerPlayerState();
}

class _TrailerPlayerState extends State<TrailerPlayer> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.trailerKey,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        loop: false,
        enableCaption: true,
        controlsVisibleAtStart: true,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.play_circle_outline,
              color: AppColors.primary,
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              widget.title ?? 'trailer'.tr,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.1),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: YoutubePlayer(
                  controller: _controller,
                  showVideoProgressIndicator: true,
                  progressIndicatorColor: AppColors.primary,
                  progressColors: ProgressBarColors(
                    playedColor: AppColors.primary,
                    handleColor: AppColors.primary,
                    bufferedColor: AppColors.primary.withValues(alpha: 0.3),
                    backgroundColor: AppColors.surface.withValues(alpha: 0.5),
                  ),
                  bottomActions: [
                    CurrentPosition(),
                    const SizedBox(width: 10),
                    ProgressBar(
                      isExpanded: true,
                      colors: ProgressBarColors(
                        playedColor: AppColors.primary,
                        handleColor: AppColors.primary,
                        bufferedColor: AppColors.primary.withValues(alpha: 0.3),
                        backgroundColor: AppColors.surface.withValues(alpha: 0.5),
                      ),
                    ),
                    const SizedBox(width: 10),
                    RemainingDuration(),
                    const PlaybackSpeedButton(),
                    FullScreenButton(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
