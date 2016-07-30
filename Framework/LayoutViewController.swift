//
//  LayoutViewController.swift
//  Layout
//
//  Created by Matthew Cheok on 30/7/16.
//  Copyright © 2016 Matthew Cheok. All rights reserved.
//

import UIKit

public class LayoutViewController: UIViewController {
  let hostingView = LayoutHostingView()
  public var layout: LayoutProtocol = NilLayout() {
    didSet {
      hostingView.layout = layout
    }
  }
  
  override public func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(hostingView)
  }
  
  override public func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    hostingView.frame = view.bounds
  }
}
