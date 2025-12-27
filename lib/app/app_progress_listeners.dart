import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/app_loading.dart';

/// Base class for progress listening during async operations
class ProgressListener {
  ProgressListener();

  final ValueNotifier<bool> _started = ValueNotifier(false);
  ValueListenable<bool> get started => _started;
  bool get isStarted => started.value;

  @mustCallSuper
  void show() {
    _started.value = true;
  }

  @mustCallSuper
  void hide() {
    _started.value = false;
  }
}

/// Shows progress after a delay to avoid flashing on fast operations
class DelayedProgressListener extends ProgressListener {
  DelayedProgressListener({this.delay = 300});

  final int delay;
  bool _isStarted = false;
  bool _isDelayFinished = false;

  final ValueNotifier<bool> _startedDelayed = ValueNotifier(false);
  ValueListenable<bool> get startedDelayed => _startedDelayed;
  bool get isStartedDelayed => _startedDelayed.value;

  @override
  void show() async {
    super.show();
    _isStarted = true;
    _isDelayFinished = false;
    if (delay != 0) {
      await Future.delayed(Duration(milliseconds: delay));
    }
    _isDelayFinished = true;
    if (_isStarted) {
      _startedDelayed.value = true;
      showDelayed();
    }
  }

  @override
  void hide() async {
    super.hide();
    _isStarted = false;
    if (_isDelayFinished) {
      _startedDelayed.value = false;
      hideDelayed();
    }
  }

  void showDelayed() {}
  void hideDelayed() {}
}

/// Default progress listener using AppLoading widget with 'loading'.tr message
class DefaultProgressListener extends DelayedProgressListener {
  DefaultProgressListener(this.context, {super.delay = 0});

  final BuildContext context;

  @override
  void showDelayed() {
    AppLoading.show(context, message: 'loading'.tr);
  }

  @override
  void hideDelayed() {
    AppLoading.hide(context);
  }
}
