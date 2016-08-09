//
//  DemoViewController.swift
//  Layout
//
//  Created by Matthew Cheok on 2/8/16.
//  Copyright © 2016 Matthew Cheok. All rights reserved.
//

import UIKit
import Layout

class DemoViewController: LayoutViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let tap = UITapGestureRecognizer(target: self, action: #selector(_didTap))
    view.addGestureRecognizer(tap)
    
    hostingView.debugging = true
  }
  
  func _didTap() {
    dismiss(animated: true, completion: nil)
  }
}
