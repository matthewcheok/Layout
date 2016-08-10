//
//  Layout.swift
//  Layout
//
//  Created by Matthew Cheok on 30/7/16.
//  Copyright © 2016 Matthew Cheok. All rights reserved.
//

import UIKit

/// The base protocol conformed to by layouts and components
public protocol LayoutProtocol {
  /// The hint provided to container layouts before `computeLayout(forSize:)` is called.
  var estimatedLayoutSize: LayoutSize { get }
  
  /// Computes the frames for the layout in the containing size
  ///
  /// - Parameter containingSize: The containing size to layout in.
  /// - Returns: The layout description containing the final size and layout items.
  func computeLayout(forSize containingSize: LayoutSize) -> LayoutDescription
  
  /// If not nil, the layout is rendered using this provider
  /// - Returns: A type conforming to `LayoutProviding`.
  static func layoutProvider() -> LayoutProviding?
}

public extension LayoutProtocol {
  /// Defaults to flexible
  var estimatedLayoutSize: LayoutSize {
    return .flexible
  }
  
  /// Defaults to `UIView`-less layout
  static func layoutProvider() -> LayoutProviding? {
    return nil
  }
}

/// Provides an empty layout
public struct NilLayout: LayoutProtocol {
  public func computeLayout(forSize containingSize: LayoutSize) -> LayoutDescription {
    return LayoutDescription(size: .zero, items: [])
  }
}

/// Describes how a layout should be rendered.
public struct LayoutDescription {
  /// The size of the layout
  public let size: CGSize
  
  /// The layout items (possibly more than one for a container layout)
  public let items: [LayoutItem]
  
  public init(size: CGSize, items: [LayoutItem]) {
    self.size = size
    self.items = items
  }
}

/// Describes how each layout child should be rendered
public struct LayoutItem {
  /// A string describing the position of this layout item in the hierarchy
  public let path: String
  
  /// The frame to be set
  public let frame: CGRect
  
  /// The layout that was used to generate this description
  public let layout: LayoutProtocol
  
  public init(path: String, frame: CGRect, layout: LayoutProtocol) {
    self.path = path
    self.frame = frame
    self.layout = layout
  }
  
  /// Prefixes the path of the item (typically used in container layouts)
  public func extendPath(_ prefix: String) -> LayoutItem {
    return LayoutItem(path: "\(prefix).\(path)",
                      frame: frame,
                      layout: layout)
  }
  
  /// Displaces the item with an offset (typically used in container layouts)
  public func offsetOrigin(_ offset: CGPoint) -> LayoutItem {
    return LayoutItem(path: path,
                      frame: CGRect(x: frame.origin.x + offset.x, y: frame.origin.y + offset.y, width: frame.size.width, height: frame.size.height),
                      layout: layout)
  }
}

/// Describes the size of the layout
public struct LayoutSize {
  public var width: LayoutDimension
  public var height: LayoutDimension
  
  static let flexible = LayoutSize(width: .flexible, height: .flexible)

  public init(width: LayoutDimension, height: LayoutDimension) {
    self.width = width
    self.height = height
  }
  
  public init(width: CGFloat) {
    self.width = .fixed(width)
    self.height = .flexible
  }

  public init(height: CGFloat) {
    self.width = .flexible
    self.height = .fixed(height)
  }

  public init(cgSize: CGSize) {
    self.width = .fixed(cgSize.width)
    self.height = .fixed(cgSize.height)
  }
}

/// Describes the length of a dimension of a layout
/// - fixed: the layout must occupy strictly
/// - maximum: the layout could occupy up to the given value
/// - flexible: the layout is not constrained
public enum LayoutDimension: Equatable {
  case fixed(CGFloat)
  case maximum(CGFloat)
  case flexible
  
  public static func ==(lhs: LayoutDimension, rhs: LayoutDimension) -> Bool {
    switch (lhs, rhs) {
    case let (.fixed(leftSize), .fixed(rightSize)):
      return leftSize == rightSize
    case let (.maximum(leftSize), .maximum(rightSize)):
      return leftSize == rightSize
    case (.flexible, .flexible):
      return true
    default:
      return false
    }
  }
}
