//
//  LayoutManager.swift
//  Layout
//
//  Created by Matthew Cheok on 30/7/16.
//  Copyright © 2016 Matthew Cheok. All rights reserved.
//

import UIKit

class LayoutManager {
  private var cache = [String: [UIView]]()
  
  func dequeueView(layoutType: Any.Type) -> UIView? {
    guard var views = cache[String(describing: layoutType)] else {
      return nil
    }
    
    guard let view = views.popLast() else {
      return nil
    }
    cache[String(describing: layoutType)] = views
    
    return view
  }
  
  func enqueueView(view: UIView, layoutType: Any.Type) {
    var views = cache[String(describing: layoutType)] ?? []
    views.append(view)
    cache[String(describing: layoutType)] = views
  }
}
