//
//  LayoutDebugView.swift
//  Layout2
//
//  Created by Matthew Cheok on 1/8/16.
//  Copyright © 2016 Matthew Cheok. All rights reserved.
//

import UIKit

private struct Color {
  static let red = UIColor(red:1.00, green:0.20, blue:0.29, alpha:1.0)
  static let green = UIColor(red:0.19, green:1.00, blue:0.65, alpha:1.0)
  static let blue = UIColor(red:0.13, green:0.43, blue:1.00, alpha:1.0)
  static let yellow = UIColor(red:1.00, green:1.00, blue:0.60, alpha:1.0)
  static let all: [UIColor] = [Color.red, Color.green, Color.blue, Color.yellow]
}

class LayoutDebugView: UIView {
  var depth: Int = 0 {
    didSet {
      let color = Color.all[depth % Color.all.count]
      backgroundColor = color.withAlphaComponent(0.5)
      layer.borderColor = color.cgColor
    }
  }
  
  convenience init() {
    self.init(frame: .zero)
    layer.borderWidth = 2
  }
}
