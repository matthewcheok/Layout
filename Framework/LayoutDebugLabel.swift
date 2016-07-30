//
//  LayoutDebugInfoView.swift
//  Layout2
//
//  Created by Matthew Cheok on 1/8/16.
//  Copyright © 2016 Matthew Cheok. All rights reserved.
//

import UIKit

class LayoutDebugLabel: UIView {
  let titleLabel = UILabel()
  let minimumSize = CGSize(width: 300, height: 100)
  
  var layoutItem: LayoutItem? {
    didSet {
      if let layoutItem = layoutItem {
        titleLabel.text = "\(layoutItem.path)\n\(layoutItem.frame)"
      } else {
        titleLabel.text = nil
      }
    }
  }
  
  convenience init() {
    self.init(frame: .zero)
    
    isUserInteractionEnabled = false
    backgroundColor = UIColor(white: 0, alpha: 0.7)
    
    titleLabel.numberOfLines = 0
    titleLabel.textColor = .white
    titleLabel.shadowOffset = CGSize(width: 0, height: 1)
    titleLabel.shadowColor = .black
    addSubview(titleLabel)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    let size = titleLabel.sizeThatFits(CGSize(width: bounds.width - 20, height: bounds.height-20))
    titleLabel.frame = CGRect(x: 10, y: 10, width: size.width, height: size.height)
  }
  
  func anchorToView(view: UIView) {
    var inside: Bool = true
    var size = minimumSize
    
    if view.frame.width < minimumSize.width {
      inside = false
    } else {
      size.width = view.frame.width
    }
    
    if view.frame.height < minimumSize.height {
      inside = false
    }
    
    if inside {
      frame = view.frame.insetBy(dx: 2, dy: 2)
    } else {
      guard let parentView = view.superview else {
        return
      }
      
      bounds = CGRect(x: 0, y: 0, width: size.width, height: size.height)
      bounds.size.height = titleLabel.frame.height + 20
      
      if view.frame.maxY + bounds.height < parentView.bounds.maxY {
        frame.origin.y = view.frame.maxY
      } else {
        frame.origin.y = view.frame.minY - bounds.height
      }
      
      if view.frame.minX + bounds.width < parentView.bounds.maxX {
        frame.origin.x = view.frame.minX
      } else if view.frame.maxX - bounds.width > 0 {
        frame.origin.x = view.frame.maxX - bounds.width
      } else {
        center.x = view.frame.midX
      }
    }
  }
  
}
