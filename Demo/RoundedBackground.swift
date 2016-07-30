//
//  ButtonBackground.swift
//  Layout
//
//  Created by Matthew Cheok on 3/8/16.
//  Copyright © 2016 Matthew Cheok. All rights reserved.
//

import UIKit

class RoundedBackground {
  static func image(color: UIColor, cornerRadius: CGFloat, corners: UIRectCorner = .allCorners) -> UIImage {
    let rect = CGRect(x: 0, y: 0, width: cornerRadius * 2 + 1, height: cornerRadius * 2 + 1 )
    let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
    
    UIGraphicsBeginImageContext(rect.size)
    color.setFill()
    path.fill()
    guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
      fatalError()
    }
    UIGraphicsEndImageContext()
    
    return image.resizableImage(withCapInsets: UIEdgeInsets(top: cornerRadius, left: cornerRadius, bottom: cornerRadius, right: cornerRadius))
  }
}
