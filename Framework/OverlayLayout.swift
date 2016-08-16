//
//  OverlayLayout.swift
//  Layout
//
//  Created by Matthew Cheok on 3/8/16.
//  Copyright © 2016 Matthew Cheok. All rights reserved.
//

import UIKit

public struct OverlayLayout: LayoutProtocol {
  let content: LayoutProtocol
  let overlay: LayoutProtocol
  
  public init(content: LayoutProtocol, overlay: LayoutProtocol) {
    self.content = content
    self.overlay = overlay
  }

  public func computeLayout(forSize containingSize: LayoutSize) -> LayoutDescription {
    let contentLayout = content.computeLayout(forSize: containingSize)
    let contentSize = LayoutSize(cgSize: contentLayout.size)
    
    return LayoutDescription(
      size: contentLayout.size,
      items: Array([
        contentLayout.items,
        overlay
          .computeLayout(forSize: contentSize)
          .items,        
        ].joined()))
  }
  
}
