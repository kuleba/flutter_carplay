import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:flutter_carplay/controllers/carplay_controller.dart';
import 'package:flutter_carplay/flutter_carplay.dart';

class NowPlayingManager {
  static final NowPlayingManager _instance = NowPlayingManager._internal();

  factory NowPlayingManager() {
    return _instance;
  }

  NowPlayingManager._internal();

  final FlutterCarPlayController _controller = FlutterCarPlayController();

  // Оновлення інформації Now Playing
  Future<bool> updateNowPlayingInfo({
    required String title,
    String? artist,
    String? albumTitle,
    double? duration,
    double? elapsedTime,
    String? imageUrl,
  }) async {
    final result =
        await _controller.methodChannel.invokeMethod('updateNowPlayingInfo', {
      'title': title,
      'artist': artist,
      'albumTitle': albumTitle,
      'duration': duration,
      'elapsedTime': elapsedTime,
      'imageUrl': imageUrl,
    });

    return result ?? false;
  }

  // Оновлення позиції відтворення
  Future<bool> updatePlaybackPosition(double position) async {
    final result = await _controller.methodChannel
        .invokeMethod('updatePlaybackPosition', {'position': position});

    return result ?? false;
  }

  // Реєстрація обробників для медіа кнопок
  void registerCommandHandlers({
    VoidCallback? onPlay,
    VoidCallback? onPause,
    VoidCallback? onNextTrack,
    VoidCallback? onPreviousTrack,
  }) {
    final FlutterCarplay carplay = FlutterCarplay();

    // Створення EventChannel для прослуховування подій
    _controller.eventChannel.receiveBroadcastStream().listen((event) {
      if (event is Map<String, dynamic>) {
        final String? type = event['type'] as String?;

        switch (type) {
          case 'onPlayCommandTriggered':
            if (onPlay != null) onPlay();
            break;
          case 'onPauseCommandTriggered':
            if (onPause != null) onPause();
            break;
          case 'onNextTrackCommandTriggered':
            if (onNextTrack != null) onNextTrack();
            break;
          case 'onPreviousTrackCommandTriggered':
            if (onPreviousTrack != null) onPreviousTrack();
            break;
        }
      }
    });
  }
}
