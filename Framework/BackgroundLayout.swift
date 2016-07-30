//
//  BackgroundLayout.swift
//  Layout2
//
//  Created by Matthew Cheok on 31/7/16.
//  Copyright © 2016 Matthew Cheok. All rights reserved.
//

import UIKit

public struct BackgroundLayout: LayoutProtocol {
  let content: LayoutProtocol
  let background: LayoutProtocol
  
  public init(content: LayoutProtocol, background: LayoutProtocol) {
    self.content = content
    self.background = background
  }
  
  public func computeLayout(forSize containingSize: LayoutSize) -> LayoutDescription {
    let contentLayout = content.computeLayout(forSize: containingSize)
    let contentSize = LayoutSize(cgSize: contentLayout.size)
    
    return LayoutDescription(
      size: contentLayout.size,
      items: Array([
        background
          .computeLayout(forSize: contentSize)
          .items,
        contentLayout.items,
        ].flatten()))
  }
  
}
