//
//  LayoutProvider.swift
//  Layout
//
//  Created by Matthew Cheok on 30/7/16.
//  Copyright © 2016 Matthew Cheok. All rights reserved.
//

import UIKit

/// Manages and configures `UIView` subclasses for a layout
public protocol LayoutProviding {
  /// Called if there is no view available for this component.
  /// - Returns: An instance of a `UIView` subclass.
  func createView() -> UIView
  
  /// Called to setup a view for display.
  /// This is the right hook to transfer relevant properties from the
  /// layout to the view.
  /// - Parameter view: An instance of `UIView` returned in `createView()`.
  /// - Parameter layout: The layout to be configured.
  func setupView(view: UIView, layout: LayoutProtocol)
}

public struct LayoutProvider<View: UIView, Layout: LayoutProtocol>: LayoutProviding {
  public typealias CreateClosure = () -> View
  public typealias SetupClosure = (view: View, layout: Layout) -> Void
  
  let create: CreateClosure
  let setup: SetupClosure
  
  public init(create: CreateClosure = { View() }, setup: SetupClosure) {
    self.create = create
    self.setup = setup
  }
  
  public func createView() -> UIView {
    return create()
  }
  
  public func setupView(view: UIView, layout: LayoutProtocol) {
    guard let view = view as? View else {
      fatalError()
    }
    
    guard let layout = layout as? Layout else {
      fatalError()
    }
    
    setup(view: view, layout: layout)
  }
}

private var cachedViews = [String: UIView]()

/// Makes the infrastructure instantiate an extra copy of the view
/// to calculate size information.
public struct DefaultLayoutProvider<View: UIView, Layout: LayoutProtocol>: LayoutProviding {
  public typealias CreateClosure = () -> View
  public typealias SetupClosure = (view: View, layout: Layout) -> Void
  
  let create: CreateClosure
  let setup: SetupClosure
  
  public init(create: CreateClosure = { View() }, setup: SetupClosure) {
    self.create = create
    self.setup = setup
  }
  
  public func createView() -> UIView {
    return create()
  }
  
  public func setupView(view: UIView, layout: LayoutProtocol) {
    guard let view = view as? View else {
      fatalError()
    }
    
    guard let layout = layout as? Layout else {
      fatalError()
    }
    
    setup(view: view, layout: layout)
  }
  
  func sizeThatFits(layout: Layout) -> CGSize {
    let view: View
    if let sample = cachedViews[String(self.dynamicType)] as? View {
      view = sample
    } else {
      view = createView() as! View
      cachedViews[String(self.dynamicType)] = view
    }
    
    setupView(view: view, layout: layout)
    let size = view.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
    return size
  }
}
