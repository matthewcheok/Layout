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
    return LayoutSize(
      width: contentSize.width.adjustedLength(insets.left + insets.right),
      height: contentSize.height.adjustedLength(insets.top + insets.bottom)
    )
  }
  
  public func computeLayout(forSize containingSize: LayoutSize) -> LayoutDescription {
    let contentSize = LayoutSize(
      width: containingSize.width.adjustedLength(-insets.left - insets.right),
      height: containingSize.height.adjustedLength(-insets.top - insets.bottom)
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

private extension LayoutDimension {
  func adjustedLength(_ amount: CGFloat) -> LayoutDimension {
    switch self {
    case .flexible:
      return .flexible
    case .maximum(let value):
      return .maximum(value + amount)
    case .fixed(let value):
      return .fixed(value + amount)
    }
  }
}
