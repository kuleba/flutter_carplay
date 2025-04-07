//
//  FCPNowPlayingTemplate.swift
//  flutter_carplay
//

import CarPlay

@available(iOS 14.0, *)
class FCPNowPlayingTemplate: FCPRootTemplate {
  private(set) var _super: CPNowPlayingTemplate?
  private(set) var elementId: String
  private var isRootTemplate: Bool
  
  init(obj: [String : Any]) {
    self.elementId = obj["_elementId"] as! String
    self.isRootTemplate = obj["isRootTemplate"] as! Bool
    
    // Create CPNowPlayingTemplate instance
    self._super = CPNowPlayingTemplate.shared
  }
  
  func toSuperObject() -> CPTemplate? {
    return self._super
  }
} 