//
//  FixedLayout.swift
//  Layout
//
//  Created by Matthew Cheok on 2/8/16.
//  Copyright © 2016 Matthew Cheok. All rights reserved.
//

import UIKit

public struct RestrictedLayout: LayoutProtocol {
  let size: LayoutSize
  let content: LayoutProtocol
  
  public init(width: CGFloat, content: LayoutProtocol) {
    self.size = LayoutSize(width: width)
    self.content = content
  }
  
  public init(maxWidth: CGFloat, content: LayoutProtocol) {
    self.size = LayoutSize(width: .maximum(maxWidth), height: .flexible)
    self.content = content
  }
  
  public init(height: CGFloat, content: LayoutProtocol) {
    self.size = LayoutSize(height: height)
    self.content = content
  }
  
  public init(maxHeight: CGFloat, content: LayoutProtocol) {
    self.size = LayoutSize(width: .flexible, height: .maximum(maxHeight))
    self.content = content
  }
  
  public init(size: CGSize, content: LayoutProtocol) {
    self.size = LayoutSize(cgSize: size)
    self.content = content
  }
  
  public var estimatedLayoutSize: LayoutSize {
    return size
  }
  
  public func computeLayout(forSize containingSize: LayoutSize) -> LayoutDescription {
    let contentSize = LayoutSize(
      width: size.width.restrictedLength(containingSize.width),
      height: size.height.restrictedLength(containingSize.height)
    )
    let info = content.computeLayout(
      forSize: contentSize
    )
    return LayoutDescription(
      size: info.size,
      items: info.items.map {
        $0.extendPath("RestrictedLayout")
      })
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
