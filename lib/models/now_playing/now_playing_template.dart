import 'package:flutter_carplay/controllers/carplay_controller.dart';
import 'package:flutter_carplay/helpers/enum_utils.dart';
import 'package:uuid/uuid.dart';

/// A template that displays the playback controls and information about the currently playing audio item.
class CPNowPlayingTemplate {
  /// Unique id of the template.
  final String _elementId = const Uuid().v4();

  /// A Boolean value that indicates whether this template is the root template.
  bool isRootTemplate = false;

  /// Creates [CPNowPlayingTemplate] that displays the playback controls and information
  /// about the currently playing audio item.
  ///
  /// The template automatically updates its UI when the playback state of the now playing app changes.
  /// CarPlay manages the layout of this template.
  CPNowPlayingTemplate({
    this.isRootTemplate = false,
  });

  Map<String, dynamic> toJson() => {
        "_elementId": _elementId,
        "isRootTemplate": isRootTemplate,
      };
}
