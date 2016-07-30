//
//  ViewComponent.swift
//  Layout
//
//  Created by Matthew Cheok on 2/8/16.
//  Copyright © 2016 Matthew Cheok. All rights reserved.
//

import UIKit

public struct WrappedComponent<View: UIView>: LayoutProtocol, LayoutProviding {
  public let size: LayoutSize
  public let configuration: (View)->Void
  
  public static func layoutProvider() -> LayoutProviding.Type? {
    return self
  }
  
  public init(configuration: (View)->Void) {
    self.init(size: .flexible, configuration: configuration)
  }
  
  public init(size: LayoutSize, configuration: (View)->Void) {
    self.size = size
    self.configuration = configuration
  }
  
  public var estimatedLayoutSize: LayoutSize {
    return size
  }
  
  public func computeLayout(forSize containingSize: LayoutSize) -> LayoutDescription {
    let result: CGSize
    switch (size.width, size.height, containingSize.width, containingSize.height) {
    case let (.fixed(width), .fixed(height), _, _):
      result = CGSize(width: width, height: height)
    case let (_, .fixed(height), .fixed(width), _):
      result = CGSize(width: width, height: height)
    case let (.fixed(width), _, _, .fixed(height)):
      result = CGSize(width: width, height: height)
    case let (_, _, .fixed(width), .fixed(height)):
      result = CGSize(width: width, height: height)
    default:
      preconditionFailure("Could not layout without specific size")
    }
    
    return LayoutDescription(size: result,
                      items: [
                        LayoutItem(
                          path: "\(self.dynamicType)",
                          frame: CGRect(origin: .zero, size: result),
                          layout: self
                        )])
  }
  
  public static func createView() -> UIView {
    return View()
  }
  
  public static func setupView(view: UIView, layout: LayoutProtocol) {
    guard let view = view as? View else {
      fatalError()
    }
    
    guard let layout = layout as? WrappedComponent else {
      fatalError()
    }
    
    layout.configuration(view)
  }
}
