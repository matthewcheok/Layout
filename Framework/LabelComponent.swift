//
//  LabelComponent.swift
//  Layout
//
//  Created by Matthew Cheok on 30/7/16.
//  Copyright © 2016 Matthew Cheok. All rights reserved.
//

import UIKit

public struct LabelComponent: LayoutProtocol {
  public let text: String
  public let font: UIFont
  public let color: UIColor
  public let alignment: NSTextAlignment
  
  public static func layoutProvider() -> LayoutProviding? {
    return LayoutProvider<UILabel, LabelComponent>(setup: {
      (view, layout) in
      view.numberOfLines = 0
      view.text = layout.text
      view.font = layout.font
      view.textColor = layout.color
      view.textAlignment = layout.alignment
    })
  }
  
  public init(text: String, font: UIFont = .systemFont(ofSize: 17), color: UIColor = .black, alignment: NSTextAlignment = .left) {
    self.text = text
    self.font = font
    self.color = color
    self.alignment = alignment
  }
  
  public func computeLayout(forSize containingSize: LayoutSize) -> LayoutDescription {
    let width: CGFloat
    switch containingSize.width {
    case let .fixed(length):
      width = length
    case let .maximum(length):
      width = length
    case .flexible:
      preconditionFailure("Cannot layout text without known width")
    }
    
    let paragraphStyle: NSMutableParagraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
    paragraphStyle.lineBreakMode = .byWordWrapping
    paragraphStyle.alignment = alignment
    
    let rect = (text as NSString).boundingRect(
      with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude),
      options: [.usesLineFragmentOrigin],
      attributes: [
        NSFontAttributeName: font,
        NSParagraphStyleAttributeName: paragraphStyle,
        ],
      context: nil)
    
    let frame: CGRect
    switch containingSize.width {
    case .fixed:
      frame = CGRect(x: 0, y: 0, width: width, height: rect.size.height)
    case .maximum:
      frame = rect
    default:
      fatalError()
    }
    
    return LayoutDescription(
      size: frame.size,
      items: [
        LayoutItem(
          path: "LabelComponent",
          frame: frame,
          layout: self
        )
      ])
  }
}
