import MediaPlayer
import CarPlay

@available(iOS 14.0, *)
class NowPlayingManager {
    static let shared = NowPlayingManager()
    
    private init() {
        setupRemoteCommandCenter()
    }
    
    func updateNowPlayingInfo(title: String, artist: String?, albumTitle: String?, duration: Double?, elapsedTime: Double?, imageUrl: String?) {
        var nowPlayingInfo = [String: Any]()
        
        // Базові метадані
        nowPlayingInfo[MPMediaItemPropertyTitle] = title
        
        if let artist = artist {
            nowPlayingInfo[MPMediaItemPropertyArtist] = artist
        }
        
        if let albumTitle = albumTitle {
            nowPlayingInfo[MPMediaItemPropertyAlbumTitle] = albumTitle
        }
        
        // Тривалість аудіо
        if let duration = duration {
            nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = duration
        }
        
        // Поточна позиція відтворення
        if let elapsedTime = elapsedTime {
            nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = elapsedTime
        }
        
        // Швидкість відтворення
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = 1.0
        
        // Завантаження зображення, якщо URL доступний
        if let imageUrl = imageUrl, let url = URL(string: imageUrl) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                    let artwork = MPMediaItemArtwork(boundsSize: image.size) { _ in return image }
                    nowPlayingInfo[MPMediaItemPropertyArtwork] = artwork
                    
                    // Оновлюємо на головному потоці
                    DispatchQueue.main.async {
                        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
                    }
                }
            }
        } else {
            // Оновлюємо без зображення
            MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
        }
    }
    
    // Оновлення позиції відтворення
    func updatePlaybackPosition(position: Double) {
        guard var nowPlayingInfo = MPNowPlayingInfoCenter.default().nowPlayingInfo else { return }
        
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = position
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    
    // Налаштування Remote Command Center
    private func setupRemoteCommandCenter() {
        let commandCenter = MPRemoteCommandCenter.shared()
        
        // Очищаємо старі target-handler
        commandCenter.playCommand.removeTarget(nil)
        commandCenter.pauseCommand.removeTarget(nil)
        commandCenter.previousTrackCommand.removeTarget(nil)
        commandCenter.nextTrackCommand.removeTarget(nil)
        
        // Додаємо команди
        commandCenter.playCommand.addTarget { event in
            SwiftFlutterCarplayPlugin.sendEvent(type: "onPlayCommandTriggered", data: [:])
            return .success
        }
        
        commandCenter.pauseCommand.addTarget { event in
            SwiftFlutterCarplayPlugin.sendEvent(type: "onPauseCommandTriggered", data: [:])
            return .success
        }
        
        commandCenter.nextTrackCommand.addTarget { event in
            SwiftFlutterCarplayPlugin.sendEvent(type: "onNextTrackCommandTriggered", data: [:])
            return .success
        }
        
        commandCenter.previousTrackCommand.addTarget { event in
            SwiftFlutterCarplayPlugin.sendEvent(type: "onPreviousTrackCommandTriggered", data: [:])
            return .success
        }
    }
} 