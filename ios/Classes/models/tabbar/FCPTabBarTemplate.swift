//
//  FCPTabBarTemplate.swift
//  flutter_carplay
//
//  Created by Oğuzhan Atalay on 21.08.2021.
//

import CarPlay

@available(iOS 14.0, *)
class FCPTabBarTemplate: NSObject, FCPRootTemplate, CPTabBarTemplateDelegate {
  private(set) var _super: CPTabBarTemplate?
  private(set) var elementId: String
  private var title: String?
  private var templates: [CPTemplate]
  private var objcTemplates: [FCPListTemplate]
  
  init(obj: [String : Any]) {
    self.elementId = obj["_elementId"] as! String
    self.title = obj["title"] as? String
    self.objcTemplates = (obj["templates"] as! Array<[String: Any]>).map {
      FCPListTemplate(obj: $0, templateType: FCPListTemplateTypes.PART_OF_GRID_TEMPLATE)
    }
    self.templates = self.objcTemplates.map {
      $0.get
    }
    
    super.init()
  }
  
  var get: CPTabBarTemplate {
    let tabBarTemplate = CPTabBarTemplate.init(templates: templates)
    tabBarTemplate.tabTitle = title
    tabBarTemplate.delegate = self
    self._super = tabBarTemplate
    return tabBarTemplate
  }
  
  func toSuperObject() -> CPTemplate? {
    return self._super
  }
  
  public func getTemplates() -> [FCPListTemplate] {
    return objcTemplates
  }
  
  // MARK: - CPTabBarTemplateDelegate
  
  func tabBarTemplate(_ tabBarTemplate: CPTabBarTemplate, didSelect selectedTemplate: CPTemplate) {
    // Find selected index
    if let index = templates.firstIndex(where: { $0 === selectedTemplate }) {
      DispatchQueue.main.async {
        FCPStreamHandlerPlugin.sendEvent(
          type: FCPChannelTypes.onTabBarTemplateSelected, 
          data: [
            "templateId": self.elementId,
            "selectedIndex": index
          ]
        )
      }
    }
  }
}
