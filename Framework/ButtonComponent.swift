//
//  ButtonComponent.swift
//  Layout2
//
//  Created by Matthew Cheok on 30/7/16.
//  Copyright © 2016 Matthew Cheok. All rights reserved.
//

import UIKit

public struct ButtonComponent: LayoutProtocol {
  let title: String?
  let image: UIImage?
  let background: UIImage?
  let action: () -> Void
  
  static let provider = DefaultLayoutProvider<UIButton, ButtonComponent>(setup: {
    (view, layout) in
    view.setTitle(layout.title, for: .normal)
    view.setImage(layout.image, for: .normal)
    view.setBackgroundImage(layout.background, for: .normal)
    view.actionHandle(controlEvents: .touchUpInside, ForAction: layout.action)
  })
  
  public init(title: String? = nil, image: UIImage? = nil, background: UIImage? = nil, action: () -> Void) {
    self.title = title
    self.image = image
    self.background = background
    self.action = action
  }

  public var estimatedLayoutSize: LayoutSize {
    let size = self.dynamicType.provider.sizeThatFits(layout: self)
    return LayoutSize(cgSize: size)
  }

  public func computeLayout(forSize containingSize: LayoutSize) -> LayoutDescription {
    var size = self.dynamicType.provider.sizeThatFits(layout: self)
    if case .fixed(let length) = containingSize.width {
      size.width = length
    }
    if case .fixed(let length) = containingSize.height {
      size.height = length
    }

    return LayoutDescription(
      size: size,
      items: [
        LayoutItem(
          path: "ButtonComponent",
          frame: CGRect(origin: .zero, size: size),
          layout: self
        )
      ])
  }
  
  public static func layoutProvider() -> LayoutProviding? {
    return provider
  }
}

extension UIButton {
  private func actionHandleBlock(action:(() -> Void)? = nil) {
    struct __ {
      static var action :(() -> Void)?
    }
    if action != nil {
      __.action = action
    } else {
      __.action?()
    }
  }
  
  @objc private func triggerActionHandleBlock() {
    self.actionHandleBlock()
  }
  
  private func actionHandle(controlEvents events :UIControlEvents, ForAction action:() -> Void) {
    self.actionHandleBlock(action: action)
    self.addTarget(self, action: #selector(UIButton.triggerActionHandleBlock), for: events)
  }
}
