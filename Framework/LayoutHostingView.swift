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
  let debugPress = UILongPressGestureRecognizer()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .white
    
    let tap = UITapGestureRecognizer(target: self, action: #selector(debugViewTapped))
    debugView.addGestureRecognizer(tap)
    
    debugPress.addTarget(self, action: #selector(handlePress(press:)))
    debugPress.isEnabled = false
    addGestureRecognizer(debugPress)
  }
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Debugging
  
  public var debugging: Bool = false {
    didSet {
      debugPress.isEnabled = debugging
    }
  }
  
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
  
  var layoutProviders = [String: LayoutProviding]()
  
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
      let provider: LayoutProviding
      if let p = layoutProviders[String(item.layout.dynamicType)] {
        provider = p
      } else {
        guard let p = item.layout.dynamicType.layoutProvider() else {
          continue
        }
        
        layoutProviders[String(item.layout.dynamicType)] = p
        provider = p
      }
      
      let view: UIView
      if let (_, oldView) = layoutChildren[item.path] {
        view = oldView
      } else if let dequeuedView = layoutManager.dequeueView(layoutType: item.layout.dynamicType) {
        view = dequeuedView
      } else  {
        view = provider.create()
      }
      
      provider.setup(view: view, with: item.layout)
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
