//
//  CompositeLayout.swift
//  Layout2
//
//  Created by Matthew Cheok on 30/7/16.
//  Copyright © 2016 Matthew Cheok. All rights reserved.
//

import Foundation

public protocol CompositeLayout: LayoutProtocol {
  var content: LayoutProtocol { get }
}

public extension CompositeLayout {
  var estimatedLayoutSize: LayoutSize {
    return content.estimatedLayoutSize
  }
  
  func computeLayout(forSize size: LayoutSize) -> LayoutDescription {
    let info = content.computeLayout(forSize: size)
    return LayoutDescription(
      size: info.size,
      items: info.items.map {
        $0.extendPath(String(describing: type(of: self)))
      })
  }
}
