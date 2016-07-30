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
  let action: () -> Void
  
  public init(title: String? = nil, image: UIImage? = nil, action: () -> Void) {
    self.title = title
    self.image = image
    self.action = action
  }
  
  public static func layoutProvider() -> LayoutProviding.Type? {
    return ButtonComponentProvider.self
  }
  
  public var estimatedLayoutSize: LayoutSize {
    let size = ButtonComponentProvider.sizeThatFits(layout: self)
    return LayoutSize(cgSize: size)
  }
  
  public func computeLayout(forSize containingSize: LayoutSize) -> LayoutDescription {
    let size = ButtonComponentProvider.sizeThatFits(layout: self)
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
  
  func actionHandle(controlEvents events :UIControlEvents, ForAction action:() -> Void) {
    self.actionHandleBlock(action: action)
    self.addTarget(self, action: #selector(UIButton.triggerActionHandleBlock), for: events)
  }
}

class ButtonComponentProvider: LayoutProviding {
  typealias Layout = ButtonComponent
  typealias View = UIButton
  
  static let sample = UIButton()
  static func sizeThatFits(layout: LayoutProtocol) -> CGSize {
    setupView(view: sample, layout: layout)
    let size = sample.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
    return size
  }
  
  static func createView() -> UIView {
    return View()
  }
  
  static func setupView(view: UIView, layout: LayoutProtocol) {
    guard let view = view as? View else {
      fatalError()
    }
    
    guard let layout = layout as? Layout else {
      fatalError()
    }
    
    view.setTitle(layout.title, for: .normal)
    view.setImage(layout.image, for: .normal)
    view.actionHandle(controlEvents: .touchUpInside, ForAction: layout.action)
  }
}
