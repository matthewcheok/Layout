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
  func create() -> UIView
  
  /// Called to setup a view for display.
  /// This is the right hook to transfer relevant properties from the
  /// layout to the view.
  /// - Parameter view: An instance of `UIView` returned in `createView()`.
  /// - Parameter layout: The layout to be configured.
  func setup(view: UIView, with layout: LayoutProtocol)
  
  /// Determines where subviews are mounted in the view instance.
  /// - Parameter view: An instance of `UIView` returned in `createView()`.
  /// - Returns: An instance of `UIView` in the view hierarchy of `view`.
  func mount(in view: UIView) -> UIView
}

public struct LayoutProvider<View: UIView, Layout: LayoutProtocol>: LayoutProviding {
  public typealias CreateClosure = () -> View
  public typealias SetupClosure = (view: View, with: Layout) -> Void
  public typealias MountClosure = (in: View) -> UIView
  
  let createClosure: CreateClosure
  let setupClosure: SetupClosure
  let mountClosure: MountClosure
  
  public init(create: CreateClosure = { View() }, setup: SetupClosure, mount: MountClosure = { $0 }) {
    self.createClosure = create
    self.setupClosure = setup
    self.mountClosure = mount
  }
  
  public func create() -> UIView {
    return createClosure()
  }
  
  public func setup(view: UIView, with layout: LayoutProtocol) {
    guard let view = view as? View else {
      fatalError()
    }
    
    guard let layout = layout as? Layout else {
      fatalError()
    }
    
    setupClosure(view: view, with: layout)
  }
  
  public func mount(in view: UIView) -> UIView {
    return mountClosure(in: view as! View)
  }
}

private var cachedViews = [String: UIView]()

/// Makes the infrastructure instantiate an extra copy of the view
/// to calculate size information.
public struct DefaultLayoutProvider<View: UIView, Layout: LayoutProtocol>: LayoutProviding {
  public typealias CreateClosure = () -> View
  public typealias SetupClosure = (view: View, with: Layout) -> Void
  
  let createClosure: CreateClosure
  let setupClosure: SetupClosure
  
  public init(create: CreateClosure = { View() }, setup: SetupClosure) {
    self.createClosure = create
    self.setupClosure = setup
  }
  
  public func create() -> UIView {
    return createClosure()
  }
  
  public func setup(view: UIView, with layout: LayoutProtocol) {
    guard let view = view as? View else {
      fatalError()
    }
    
    guard let layout = layout as? Layout else {
      fatalError()
    }
    
    setupClosure(view: view, with: layout)
  }
  
  func sizeThatFits(layout: Layout) -> CGSize {
    let view: View
    if let sample = cachedViews[String(self.dynamicType)] as? View {
      view = sample
    } else {
      view = create() as! View
      cachedViews[String(self.dynamicType)] = view
    }
    
    setup(view: view, with: layout)
    let size = view.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
    return size
  }
  
  public func mount(in view: UIView) -> UIView {
    return view
  }
}
