//
//  LayoutProvider.swift
//  Layout
//
//  Created by Matthew Cheok on 30/7/16.
//  Copyright © 2016 Matthew Cheok. All rights reserved.
//

import UIKit

/// Manages and configures `UIView` subclasses for a layout
public protocol LayoutProviding {
  /// Called if there is no view available for this component.
  /// - Returns: An instance of a `UIView` subclass.
  static func createView() -> UIView
  
  /// Called to setup a view for display.
  /// This is the right hook to transfer relevant properties from the
  /// layout to the view.
  /// - Parameter view: An instance of `UIView` returned in `createView()`.
  /// - Parameter layout: The layout to be configured.
  static func setupView(view: UIView, layout: LayoutProtocol)
}

/// Makes the infrastructure instantiate an extra copy of the view
/// to calculate size information.
public protocol DefaultLayoutProviding: LayoutProviding {
  static func sizeThatFits(layout: LayoutProtocol) -> CGSize
}

private var cachedViews = [String: UIView]()

public extension DefaultLayoutProviding {
  /// Defaults to `false`
  static var usesSizeToFit: Bool {
    return false
  }
  
  static func sizeThatFits(layout: LayoutProtocol) -> CGSize {
    let view: UIView
    if let sample = cachedViews[String(self.dynamicType)] {
      view = sample
    } else {
      view = createView()
      cachedViews[String(self.dynamicType)] = view
    }
    
    setupView(view: view, layout: layout)
    let size = view.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
    return size
  }
}

