//
//  FCPNowPlayingHandler.swift
//  flutter_carplay
//

import CarPlay
import MediaPlayer

@available(iOS 14.0, *)
class FCPNowPlayingHandler {
  
  public static func activateNowPlaying(args: [String: Any]) -> Bool {
    let title = args["title"] as! String
    let artist = args["artist"] as! String
    let isLiveStream = args["isLiveStream"] as! Bool
    let artworkUrl = args["artworkUrl"] as? String
    let switchToNowPlaying = args["switchToNowPlaying"] as! Bool
    
    // Налаштування аудіо сесії
    do {
      try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
      try AVAudioSession.sharedInstance().setActive(true)
    } catch {
      print("Failed to set audio session category: \(error)")
      return false
    }
    
    // Налаштування Now Playing Info
    updateNowPlayingInfo(title: title, artist: artist, isLiveStream: isLiveStream, artworkUrl: artworkUrl)
    
    // Активація дистанційного керування
    UIApplication.shared.beginReceivingRemoteControlEvents()
    
    // Перемикання на Now Playing, якщо потрібно
    if switchToNowPlaying && FlutterCarPlaySceneDelegate.interfaceController != nil {
      FlutterCarPlaySceneDelegate.push(template: CPNowPlayingTemplate.shared, animated: true)
    }
    
    return true
  }
  
  public static func updateNowPlayingInfo(title: String, artist: String, isLiveStream: Bool, artworkUrl: String?) -> Bool {
    // Налаштування Now Playing Info
    var nowPlayingInfo: [String: Any] = [
      MPMediaItemPropertyTitle: title,
      MPMediaItemPropertyArtist: artist,
      MPNowPlayingInfoPropertyIsLiveStream: isLiveStream
    ]
    
    // Додання артворку, якщо є
    if let artworkUrl = artworkUrl, let url = URL(string: artworkUrl) {
      DispatchQueue.global().async {
        if let data = try? Data(contentsOf: url),
           let image = UIImage(data: data) {
          let artwork = MPMediaItemArtwork(boundsSize: image.size) { _ in image }
          nowPlayingInfo[MPMediaItemPropertyArtwork] = artwork
          MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
        }
      }
    }
    
    MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    return true
  }
} 