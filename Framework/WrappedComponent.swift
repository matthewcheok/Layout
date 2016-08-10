//
//  ViewComponent.swift
//  Layout
//
//  Created by Matthew Cheok on 2/8/16.
//  Copyright © 2016 Matthew Cheok. All rights reserved.
//

import UIKit

public struct WrappedComponent<View: UIView>: LayoutProtocol {
  public typealias SetupClosure = (View) -> Void
  public let size: LayoutSize
  public let setup: SetupClosure
  
  public static func layoutProvider() -> LayoutProviding? {
    return LayoutProvider<View, WrappedComponent<View>>(setup: {
      (view, layout) in
      layout.setup(view)
    })
  }
  
  public init(size: LayoutSize = .flexible, setup: SetupClosure) {
    self.size = size
    self.setup = setup
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
}

private extension LayoutDimension {
  func restrictedLength(_ length: LayoutDimension) -> LayoutDimension {
    switch (self, length) {
    case let (.fixed(length), _):
      return .fixed(length)
    case let (.maximum(length), _):
      return .maximum(length)
    case let (_, .fixed(length)):
      return .fixed(length)
    case let (_, .maximum(length)):
      return .maximum(length)
    default:
      return self
    }
  }
}

