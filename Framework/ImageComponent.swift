//
//  ImageComponent.swift
//  Layout2
//
//  Created by Matthew Cheok on 31/7/16.
//  Copyright © 2016 Matthew Cheok. All rights reserved.
//

import UIKit

public struct ImageComponent: LayoutProtocol {
  public let image: UIImage?
  public let contentMode: UIViewContentMode
  
  public static func layoutProvider() -> LayoutProviding? {
    return LayoutProvider<UIImageView, ImageComponent>(setup: {
      (view, layout) in
      view.image = layout.image
    })
  }
  
  public init(image: UIImage?, contentMode: UIViewContentMode = .center) {
    self.image = image
    self.contentMode = contentMode
  }
  
  public var estimatedLayoutSize: LayoutSize {
    return LayoutSize(cgSize: image?.size ?? .zero)
  }
  
  public func computeLayout(forSize size: LayoutSize) -> LayoutDescription {
    var result: CGSize = .zero
    
    if let image = image {
      switch (size.width, size.height) {
      case let (.fixed(width), .fixed(height)):
        result = CGSize(width: width, height: height)
      case let (.fixed(width), _):
        result = CGSize(width: width, height: image.size.height / image.size.width * width)
      case let (_, .fixed(height)):
        result = CGSize(width: image.size.width / image.size.height * height, height: height)
      default:
        result = image.size
      }
    }
    
    return LayoutDescription(size: result,
                      items: [
                        LayoutItem(
                          path: "ImageComponent",
                          frame: CGRect(origin: .zero, size: result),
                          layout: self
                        )])
  }
}
