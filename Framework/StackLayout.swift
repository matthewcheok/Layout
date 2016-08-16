//
//  StackLayout.swift
//  Layout
//
//  Created by Matthew Cheok on 30/7/16.
//  Copyright © 2016 Matthew Cheok. All rights reserved.
//

import UIKit

public struct StackLayout: LayoutProtocol {
  public enum Direction {
    case vertical
    case horizontal
  }
  
  public enum Alignment {
    case start
    case center
    case end
    case stretch
  }
  
  let direction: Direction
  let align: Alignment
  let justify: Alignment
  let spacing: CGFloat
  let children: [LayoutProtocol]
  
  public init(direction: Direction, align: Alignment, justify: Alignment, spacing: CGFloat = 0, children: [LayoutProtocol]) {
    self.direction = direction
    self.align = align
    self.justify = justify
    self.spacing = spacing
    self.children = children
  }
  
  private func computeSizeAndInfo(childSize: LayoutSize) -> (CGSize, [LayoutDescription]) {
    return children
      .enumerated()
      .map {
        (index, child) -> (Int, LayoutDescription) in        
        var sizeToUse: LayoutSize = .flexible
        if child.estimatedLayoutSize.length(inDirection: direction) == .flexible {
          sizeToUse.setLength(length: childSize.length(inDirection: direction), inDirection: direction)
        }
        if child.estimatedLayoutSize.length(inOtherDirection: direction) == .flexible {
          sizeToUse.setLength(length: childSize.length(inOtherDirection: direction), inOtherDirection: direction)
        }
        
        return (index, child.computeLayout(forSize: sizeToUse))
      }
      .reduce((CGSize(direction: direction, align: -spacing, cross: 0), []), { (partialResult, next) -> (CGSize, [LayoutDescription]) in
        
        let (contentSize, items) = partialResult
        let (index, childInfo) = next
        
        let (align, cross) = contentSize.measure(inDirection: direction)
        let (alignChild, crossChild) = childInfo.size.measure(inDirection: direction)
        
        let newSize = CGSize(direction: direction, align: align + spacing + alignChild, cross: max(cross, crossChild))
        let newItems = childInfo.items
          .map { $0.offset(inDirection: direction, amount: align + spacing) }
          .map { $0.extendPath("StackLayout[\(index)]") }
        return (newSize, items + [LayoutDescription(size: childInfo.size, items: newItems)])
      })
  }
  
  public func computeLayout(forSize size: LayoutSize) -> LayoutDescription {
    
    // 1: Compute containing size for child layouts
    var childSize = size
    let (occupiedLength, numberOfFlexible) = children.reduce((0.0, 0), { (partialResult, child) -> (CGFloat, Int) in
      let (occupiedLength, numberOfFlexible) = partialResult
      switch child.estimatedLayoutSize.length(inDirection: direction) {
      case .flexible:
        return (occupiedLength, numberOfFlexible + 1)
      case .maximum:
        return (occupiedLength, numberOfFlexible + 1)
      case .fixed(let length):
        return (occupiedLength + length, numberOfFlexible)
      }
    })
    
    if case .fixed(let length) = size.length(inDirection: direction) {
      let innerSpacing = spacing * CGFloat(children.count - 1)
      let newLength = (length - innerSpacing - occupiedLength) / CGFloat(numberOfFlexible)
      if align == .stretch {
        childSize.setLength(length: .fixed(newLength), inDirection: direction)
      } else {
        childSize.setLength(length: .maximum(newLength), inDirection: direction)
      }
    } else {
      childSize.makeFlexible(inDirection: direction)
    }
    
    if justify != .stretch {
      childSize.makeFlexible(inOtherDirection: direction)
    }
    
    // 2: Enumerate child layouts
    var sizeAndInfo = computeSizeAndInfo(childSize: childSize)
    // We require a second pass if we need to justify the cross length
    if justify == .stretch && childSize.length(inOtherDirection: direction) == .flexible {
      let (_, otherLength) = sizeAndInfo.0.measure(inDirection: direction)
      childSize.setLength(length: .fixed(otherLength), inOtherDirection: direction)
      sizeAndInfo = computeSizeAndInfo(childSize: childSize)
    }
    
    // We need to apply the following passes (align and justify)
    // while keeping the items grouped by stack children so they
    // are adjusted correctly
    let (contentSize, childrenInfo) = sizeAndInfo
    var adjustedInfo = childrenInfo
    
    // 3: Align
    if case .fixed(let alignSize) = size.length(inDirection: direction) {
      let (length, _) = contentSize.measure(inDirection: direction)
      if length < alignSize {
        switch align {
        case .center:
          adjustedInfo = adjustedInfo.map {
            LayoutDescription(size: $0.size, items: $0.items.map { $0.offset(inDirection: direction, amount: (alignSize - length) / 2) })
          }
        case .end:
          adjustedInfo = adjustedInfo.map {
            LayoutDescription(size: $0.size, items: $0.items.map { $0.offset(inDirection: direction, amount: (alignSize - length)) })
          }
        case .stretch:
          let spacing = (alignSize - length) / CGFloat(adjustedInfo.count - 1)
          adjustedInfo = adjustedInfo.enumerated().map {
            (index, info) in
            LayoutDescription(size: info.size, items: info.items.map {
              $0.offset(inDirection: direction, amount: spacing * CGFloat(index))
              })
          }
        default:
          ()
        }
      }
    }
    
    // 4: Justify
    let crossSize: CGFloat
    if case .fixed(let length) = size.length(inOtherDirection: direction) {
      crossSize = length
    } else {
      (_, crossSize) = contentSize.measure(inDirection: direction)
    }

    adjustedInfo = adjustedInfo.map {
      info in
      let (_, length) = info.size.measure(inDirection: direction)
      if length < crossSize {
        switch justify {
        case .center:
          return LayoutDescription(size: info.size, items: info.items.map {
              $0.offset(inOtherDirection: direction, amount: (crossSize - length) / 2)
            })
        case .end:
          return LayoutDescription(size: info.size, items: info.items.map {
            $0.offset(inOtherDirection: direction, amount: (crossSize - length))
            })
        default:
          return info
        }
      } else {
        return info
      }
    }

    // 5: Debug information
    var result = contentSize
    if case let .fixed(width) = size.width {
      result.width = width
    }
    if case let .fixed(height) = size.height {
      result.height = height
    }

    let debugItem = LayoutItem(
      path: "StackLayout",
      frame: CGRect(origin: .zero, size: result),
      layout: self)
    return LayoutDescription(size: result, items: [debugItem] + adjustedInfo.map { $0.items }.joined())
  }
  
}

private extension CGSize {
  init(direction: StackLayout.Direction, align: CGFloat, cross: CGFloat) {
    switch direction {
    case .vertical:
      self = CGSize(width: cross, height: align)
    case .horizontal:
      self = CGSize(width: align, height: cross)
    }
  }
  
  func measure(inDirection direction: StackLayout.Direction) -> (align: CGFloat, cross: CGFloat) {
    switch direction {
    case .vertical:
      return (height, width)
    case .horizontal:
      return (width, height)
    }
  }
}

private extension LayoutSize {
  mutating func makeFlexible(inDirection direction: StackLayout.Direction) {
    switch direction {
    case .vertical:
      height = .flexible
    case .horizontal:
      width = .flexible
    }
  }
  
  mutating func makeFlexible(inOtherDirection otherDirection: StackLayout.Direction) {
    switch otherDirection {
    case .horizontal:
      height = .flexible
    case .vertical:
      width = .flexible
    }
  }
  
  func length(inDirection direction: StackLayout.Direction) -> LayoutDimension {
    switch direction {
    case .vertical:
      return self.height
    case .horizontal:
      return self.width
    }
  }
  
  func length(inOtherDirection otherDirection: StackLayout.Direction) -> LayoutDimension {
    switch otherDirection {
    case .horizontal:
      return self.height
    case .vertical:
      return self.width
    }
  }
  
  mutating func setLength(length: LayoutDimension, inDirection direction: StackLayout.Direction) {
    switch direction {
    case .vertical:
      self.height = length
    case .horizontal:
      self.width = length
    }
  }
  
  mutating func setLength(length: LayoutDimension, inOtherDirection otherDirection: StackLayout.Direction) {
    switch otherDirection {
    case .horizontal:
      self.height = length
    case .vertical:
      self.width = length
    }
  }
}

private extension LayoutItem {
  func offset(inDirection direction: StackLayout.Direction, amount: CGFloat) -> LayoutItem {
    switch direction {
    case .vertical:
      return LayoutItem(path: self.path,
                        frame: CGRect(x: self.frame.origin.x,
                                      y: self.frame.origin.y + amount,
                                      width: self.frame.size.width,
                                      height: self.frame.size.height),
                        layout: self.layout)
    case .horizontal:
      return LayoutItem(path: self.path,
                        frame: CGRect(x: self.frame.origin.x + amount,
                                      y: self.frame.origin.y,
                                      width: self.frame.size.width,
                                      height: self.frame.size.height),
                        layout: self.layout)
    }
  }
  
  func offset(inOtherDirection otherDirection: StackLayout.Direction, amount: CGFloat) -> LayoutItem {
    switch otherDirection {
    case .horizontal:
      return LayoutItem(path: self.path,
                        frame: CGRect(x: self.frame.origin.x,
                                      y: self.frame.origin.y + amount,
                                      width: self.frame.size.width,
                                      height: self.frame.size.height),
                        layout: self.layout)
    case .vertical:
      return LayoutItem(path: self.path,
                        frame: CGRect(x: self.frame.origin.x + amount,
                                      y: self.frame.origin.y,
                                      width: self.frame.size.width,
                                      height: self.frame.size.height),
                        layout: self.layout)
    }
  }
}
