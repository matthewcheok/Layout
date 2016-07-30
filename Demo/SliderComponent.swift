//
//  SliderComponent.swift
//  Layout2
//
//  Created by Matthew Cheok on 31/7/16.
//  Copyright © 2016 Matthew Cheok. All rights reserved.
//

import UIKit
import Layout

struct SliderComponent: LayoutProtocol {
  let minimumValueImage: UIImage?
  let maximumValueImage: UIImage?
  let thumbImage: UIImage?
  
  static func layoutProvider() -> LayoutProviding.Type? {
    return SliderComponentProvider.self
  }
  
  init(minimumValueImage: UIImage? = nil, maximumValueImage: UIImage? = nil, thumbImage: UIImage? = nil) {
    self.minimumValueImage = minimumValueImage
    self.maximumValueImage = maximumValueImage
    self.thumbImage = thumbImage
  }
  
  func computeLayout(forSize size: LayoutSize) -> LayoutDescription {
    guard case let .fixed(width) = size.width else {
      preconditionFailure("Cannot layout without known width")
    }
    
    let height = thumbImage?.size.height ?? 44
    
    return LayoutDescription(
      size: CGSize(width: width, height: height),
      items: [
        LayoutItem(
          path: "SliderComponent",
          frame: CGRect(x: 0, y: 0, width: width, height: height),
          layout: self
        )
      ])
  }
}

class SliderComponentProvider: LayoutProviding {
  typealias Layout = SliderComponent
  typealias View = UISlider
  
  static func createView() -> UIView {
    return View()
  }
  
  static func setupView(view: UIView, layout: LayoutProtocol) {
    guard let view = view as? View else {
      fatalError()
    }
    
    guard let layout = layout as? Layout else {
      fatalError()
    }
    
    view.value = 0.4
    view.setMinimumTrackImage(UIImage(named: "slider-track-min"), for: .normal)
    view.setMaximumTrackImage(UIImage(named: "slider-track-max"), for: .normal)
    view.minimumValueImage = layout.minimumValueImage
    view.maximumValueImage = layout.maximumValueImage
    view.setThumbImage(layout.thumbImage, for: .normal)
  }
}
