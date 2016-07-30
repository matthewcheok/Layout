//
//  LayoutHostingView.swift
//  Layout
//
//  Created by Matthew Cheok on 30/7/16.
//  Copyright © 2016 Matthew Cheok. All rights reserved.
//

import UIKit

public class LayoutHostingView: UIView {
  
  let debugView = LayoutDebugView()
  let debugLabel = LayoutDebugLabel()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    backgroundColor = .white
    
    let tap = UITapGestureRecognizer(target: self, action: #selector(debugViewTapped))
    debugView.addGestureRecognizer(tap)
    
    let press = UILongPressGestureRecognizer(target: self, action: #selector(handlePress(press:)))
    addGestureRecognizer(press)
  }
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Debugging
  
  func handlePress(press: UILongPressGestureRecognizer) {
    let location = press.location(in: self)
    for item in layoutDescription.items.reversed() {
      if item.frame.contains(location) {
        attachDebugView(item: item)
        break
      }
    }
  }
  
  func debugViewTapped() {
    debugView.removeFromSuperview()
    debugLabel.removeFromSuperview()
  }
  
  func attachDebugView(item: LayoutItem) {
    addSubview(debugView)
    debugView.depth = item.path.components(separatedBy: ".").count
    debugView.frame = item.frame
    
    addSubview(debugLabel)
    debugLabel.layoutItem = item
    debugLabel.anchorToView(view: debugView)
  }
  
  // MARK: - Layout
  
  var layout: LayoutProtocol = NilLayout() {
    didSet {
      computeItemChanges(layout)
    }
  }
  
  var layoutDescription: LayoutDescription = LayoutDescription(size: .zero, items: []) {
    didSet {
      applyViewChanges(layoutDescription.items)
      applyFrameChanges()
    }
  }
  
  var layoutChildren = [String: (LayoutItem, UIView)]()
  let layoutManager = LayoutManager()
  
  private func computeItemChanges(_ layout: LayoutProtocol)  {
    let contentSize = LayoutSize(cgSize: bounds.size)
    layoutDescription = layout.computeLayout(forSize: contentSize)
  }
  
  private func applyViewChanges(_ items: [LayoutItem]) {
    let newPaths = items.map { $0.path }
    let removedPaths = Set(layoutChildren.keys).subtracting(Set(newPaths))
    for path in removedPaths {
      if let (item, view) = layoutChildren[path] {
        layoutManager.enqueueView(view: view, layoutType: item.layout.dynamicType)
        view.removeFromSuperview()
      }
      layoutChildren[path] = nil
    }
    
    for item in items {
      guard let provider = item.layout.dynamicType.layoutProvider() else {
        continue
      }
      
      let view: UIView
      if let (_, oldView) = layoutChildren[item.path] {
        view = oldView
      } else if let dequeuedView = layoutManager.dequeueView(layoutType: item.layout.dynamicType) {
        view = dequeuedView
      } else  {
        view = provider.createView()
      }
      
      provider.setupView(view: view, layout: item.layout)
      layoutChildren[item.path] = (item, view)
      addSubview(view)
    }
  }
  
  private func applyFrameChanges() {
    for (_, (item, view)) in layoutChildren {
      view.frame = item.frame
    }
  }
  
  override public var frame: CGRect {
    didSet {
      computeItemChanges(layout)
    }
  }
  
  override public func sizeThatFits(_ size: CGSize) -> CGSize {
    let layoutSize = LayoutSize(cgSize: size)
    return layout.computeLayout(forSize: layoutSize).size
  }
  
}
