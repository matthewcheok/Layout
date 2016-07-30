//
//  LayoutProvider.swift
//  Layout
//
//  Created by Matthew Cheok on 30/7/16.
//  Copyright © 2016 Matthew Cheok. All rights reserved.
//

import UIKit

public protocol LayoutProviding {
  // Makes the infrastructure instantiate an extra copy of the view
  // to calculate size information.
  // Custom layouts should return false.
  static var usesSizeToFit: Bool { get }
  
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

public extension LayoutProviding {
  /// Defaults to `false`
  static var usesSizeToFit: Bool {
    return false
  }
}
