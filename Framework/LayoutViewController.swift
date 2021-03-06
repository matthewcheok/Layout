//
//  LayoutViewController.swift
//  Layout
//
//  Created by Matthew Cheok on 30/7/16.
//  Copyright © 2016 Matthew Cheok. All rights reserved.
//

import UIKit

open class LayoutViewController: UIViewController {
  public let hostingView = LayoutHostingView()
  
  public var layout: LayoutProtocol = NilLayout() {
    didSet {
      hostingView.layout = layout
    }
  }
  
  override open func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(hostingView)
  }
  
  override open func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    hostingView.frame = view.bounds
  }
}
