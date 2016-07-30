//
//  InsetLayout.swift
//  Layout
//
//  Created by Matthew Cheok on 30/7/16.
//  Copyright © 2016 Matthew Cheok. All rights reserved.
//

import UIKit

public struct InsetLayout: LayoutProtocol {
  let insets: UIEdgeInsets
  let content: LayoutProtocol
  
  public init(insets: UIEdgeInsets, content: LayoutProtocol) {
    self.insets = insets
    self.content = content
  }
  
  public var estimatedLayoutSize: LayoutSize {
    let contentSize = content.estimatedLayoutSize
    switch (contentSize.width, contentSize.height) {
    case let (.fixed(width), .fixed(height)):
      return LayoutSize(
        width: .fixed(width + insets.left + insets.right),
        height: .fixed(height + insets.top + insets.bottom)
      )
    case let (.flexible, .fixed(height)):
      return LayoutSize(
        height: height + insets.top + insets.bottom
      )
    case let (.fixed(width), .flexible):
      return LayoutSize(
        width: width + insets.left + insets.right
      )
    default:
      return .flexible
    }
  }
  
  func reducedLength(length: LayoutDimension, inset: CGFloat) -> LayoutDimension {
    switch length {
    case .flexible:
      return .flexible
    case .maximum(let value):
      return .maximum(value - inset)
    case .fixed(let value):
      return .fixed(value - inset)
    }
  }
  
  public func computeLayout(forSize size: LayoutSize) -> LayoutDescription {
    let contentSize = LayoutSize(
      width: reducedLength(length: size.width, inset: insets.left + insets.right),
      height: reducedLength(length: size.height, inset: insets.top + insets.bottom)
    )
    
    let info = content.computeLayout(forSize: contentSize)
    let result = CGSize(
      width: info.size.width + insets.left + insets.right,
      height: info.size.height + insets.top + insets.bottom
    )
    
    let debugItem = LayoutItem(
      path: "InsetLayout",
      frame: CGRect(origin: .zero, size: result),
      layout: self)
    return LayoutDescription(
      size: result,
      items: [debugItem] + info.items
        .map { $0.offsetOrigin(CGPoint(x: insets.left, y: insets.top)) }
        .map { $0.extendPath("InsetLayout") }
    )
  }

}


