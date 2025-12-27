import 'package:flutter/material.dart';
import 'app_loading.dart';
import '../app/app_colors.dart';

typedef DataBuilder<T> = Widget Function(BuildContext context, T data);
typedef ErrorBuilder = Widget Function(BuildContext context, Object? error);
typedef ProgressBuilder = Widget Function(BuildContext context);

/// Simplified FutureBuilder with default loading and error states
class DataFutureBuilder<T> extends FutureBuilder<T> {
  /// Simplified constructor with sensible defaults
  factory DataFutureBuilder.simple({
    required Future<T> future,
    required DataBuilder<T> dataBuilder,
    ProgressBuilder? progressBuilder,
    ErrorBuilder? errorBuilder,
  }) {
    // Default progress builder
    progressBuilder ??= (_) => const Center(
          child: AppLoading(message: null),
        );

    // Default error builder
    errorBuilder ??= (context, error) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: AppColors.error,
              ),
              const SizedBox(height: 16),
              Text(
                'An error occurred',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );

    return DataFutureBuilder(
      future: future,
      progressBuilder: progressBuilder,
      dataBuilder: dataBuilder,
      errorBuilder: errorBuilder,
    );
  }

  DataFutureBuilder({
    required Future<T> future,
    required ProgressBuilder progressBuilder,
    required DataBuilder<T> dataBuilder,
    required ErrorBuilder errorBuilder,
    super.key,
  }) : super(
          future: future,
          builder: (BuildContext context, AsyncSnapshot<T> snapshot) {
            // Data is available
            if (snapshot.hasData) {
              return dataBuilder(context, snapshot.data as T);
            }

            // Loading state
            if (!snapshot.hasData && !snapshot.hasError ||
                snapshot.connectionState == ConnectionState.waiting) {
              return progressBuilder(context);
            }

            // Error state
            return errorBuilder(context, snapshot.error);
          },
        );
}
