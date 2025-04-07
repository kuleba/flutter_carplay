import 'package:flutter/services.dart';
import 'package:flutter_carplay/constants/private_constants.dart';
import 'package:flutter_carplay/controllers/carplay_controller.dart';

class NowPlayingHelper {
  static final FlutterCarPlayController _controller =
      FlutterCarPlayController();

  /// Активує системний екран Now Playing та налаштовує аудіо сесію
  static Future<bool> activateNowPlaying({
    required String title,
    required String artist,
    bool isLiveStream = true,
    String? artworkUrl,
    bool switchToNowPlaying = true,
  }) async {
    return await _controller.reactToNativeModule(
      FCPChannelTypes.activateNowPlaying,
      <String, dynamic>{
        "title": title,
        "artist": artist,
        "isLiveStream": isLiveStream,
        "artworkUrl": artworkUrl,
        "switchToNowPlaying": switchToNowPlaying,
      },
    );
  }

  /// Оновлює інформацію Now Playing без переключення на екран
  static Future<bool> updateNowPlayingInfo({
    required String title,
    required String artist,
    bool isLiveStream = true,
    String? artworkUrl,
  }) async {
    return await _controller.reactToNativeModule(
      FCPChannelTypes.updateNowPlayingInfo,
      <String, dynamic>{
        "title": title,
        "artist": artist,
        "isLiveStream": isLiveStream,
        "artworkUrl": artworkUrl,
      },
    );
  }
}
