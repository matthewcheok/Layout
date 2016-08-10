//
//  MessagesDemoController.swift
//  Layout
//
//  Created by Matthew Cheok on 4/8/16.
//  Copyright © 2016 Matthew Cheok. All rights reserved.
//

import UIKit
import Layout

struct MessageBubbleComponent: CompositeLayout {
  enum Direction {
    case incoming
    case outgoing
  }
  
  let direction: Direction
  let body: String
  let displaysTail: Bool
  
  init(direction: Direction, body: String, displaysTail: Bool = true) {
    self.direction = direction
    self.body = body
    self.displaysTail = displaysTail
  }
  
  var content: LayoutProtocol {
    var insets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
    let textColor: UIColor
    let backgroundImage: UIImage?
    let align: StackLayout.Alignment
    
    switch direction {
    case .incoming:
      insets.left += 5
      textColor = .black
      backgroundImage = UIImage(named: "bubble-incoming")
      align = .start
    case .outgoing:
      insets.right += 5
      textColor = .white
      backgroundImage = UIImage(named: "bubble-outgoing")
      align = .end
    }
    
    return StackLayout(
      direction: .horizontal,
      align: align,
      justify: .center,
      children: [
        RestrictedLayout(
          maxWidth: 240,
          content:
          BackgroundLayout(
            content:
            InsetLayout(
              insets: insets,
              content:
              LabelComponent(
                text: body,
                font: UIFont.systemFont(ofSize: 17),
                color: textColor
              )
            ),
            background:
            ImageComponent(
              image: backgroundImage
            )
          )
        )
      ]
    )
  }
}

struct PaletteComponent: CompositeLayout {
  let color: UIColor
  
  var content: LayoutProtocol {
    return RestrictedLayout(
      size: CGSize(width: 26, height: 26),
      content: ImageComponent(
        image: RoundedBackground.image(
          color: color,
          cornerRadius: 13)
      )
    )
  }
}

struct PaletteContainerComponent: CompositeLayout {
  var content: LayoutProtocol {
    let children = [
      PaletteComponent(color: UIColor(red:0.93, green:0.11, blue:0.14, alpha:1.0)),
      PaletteComponent(color: UIColor(red:0.00, green:0.73, blue:1.00, alpha:1.0)),
      PaletteComponent(color: UIColor(red:1.00, green:0.50, blue:0.00, alpha:1.0)),
      PaletteComponent(color: UIColor(red:0.05, green:1.00, blue:0.00, alpha:1.0)),
      PaletteComponent(color: UIColor(red:1.00, green:0.99, blue:0.00, alpha:1.0)),
      PaletteComponent(color: UIColor(red:1.00, green:0.00, blue:0.99, alpha:1.0)),
      PaletteComponent(color: .white),
      ]
      .enumerated()
      .map {
        (index, child) -> LayoutProtocol in
        let left: CGFloat
        let right: CGFloat
        if index % 2 == 0 {
          left = 40
          right = 0
        } else {
          left = 0
          right = 40
        }
        
        return InsetLayout(
          insets: UIEdgeInsets(top: 0, left: left, bottom: 0, right: right),
          content: child
        )

      }
    
    return StackLayout(
      direction: .vertical,
      align: .center,
      justify: .center,
      spacing: -4,
      children: children
    )
  }
}

struct ComposerComponent: CompositeLayout {
  var content: LayoutProtocol {
    return RestrictedLayout(
      height: 36,
      content:
      BackgroundLayout(
        content:
        InsetLayout(
          insets: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 5),
          content:
          StackLayout(
            direction: .horizontal,
            align: .stretch,
            justify: .center,
            spacing: 30,
            children: [
              LabelComponent(
                text: "iMessage",
                color: UIColor(red:0.78, green:0.78, blue:0.80, alpha:1.0)
              ),
              ImageComponent(image: UIImage(named: "icon-microphone")),
            ]
          )
        ),
        background:
        ImageComponent(image: UIImage(named: "background-textfield"))
      )
    )
  }
}

struct TrayComponent: CompositeLayout {
  var content: LayoutProtocol {
    return RestrictedLayout(
      height: 44,
      content:
      InsetLayout(
        insets: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10),
        content:
        StackLayout(
          direction: .horizontal,
          align: .stretch,
          justify: .center,
          spacing: 30,
          children: [
            ButtonComponent(image: UIImage(named: "icon-camera"), action: {}),
            ButtonComponent(image: UIImage(named: "icon-digital-touch"), action: {}),
            ButtonComponent(image: UIImage(named: "icon-appstore"), action: {}),
            ComposerComponent()
          ]
        )
      )
    )
  }
}

struct DoodleComponent: CompositeLayout {
  let content: LayoutProtocol =
    RestrictedLayout(
      height: 258,
      content:
      BackgroundLayout(
        content:
        InsetLayout(
          insets: UIEdgeInsets(top: 15, left: 0, bottom: 15, right: 0),
          content:
          StackLayout(
            direction: .horizontal,
            align: .stretch,
            justify: .stretch,
            children: [
              PaletteContainerComponent(),
              RestrictedLayout(
                width: 194,
                content:                
                ImageComponent(
                  image: RoundedBackground.image(color: .black, cornerRadius: 4)
                )
              ),
              StackLayout(
                direction: .vertical,
                align: .center,
                justify: .center,
                children: [
                  ImageComponent(image: UIImage(named: "Gestures"))
                ]
              )
            ]
          )
        ),
        background:
        WrappedComponent<UIView>(setup: { (view) in
          view.backgroundColor = UIColor(red:0.10, green:0.10, blue:0.10, alpha:1.0)
        })
      )
    )
}

class MessagesDemoController: DemoViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    
    layout =
      StackLayout(
        direction: .vertical,
        align: .stretch,
        justify: .stretch,
        children: [
          InsetLayout(
            insets: UIEdgeInsets(
              top: 40,
              left: 15,
              bottom: 10,
              right: 15
            ),
            content:
            StackLayout(
              direction: .vertical,
              align: .start,
              justify: .stretch,
              spacing: 2,
              children: [
                MessageBubbleComponent(
                  direction: .outgoing,
                  body: "So this is pretty great, it makes complex layouts easy..."
                ),
                LabelComponent(
                  text: "Delivered",
                  font: UIFont.boldSystemFont(ofSize: 11),
                  color: UIColor(red:0.56, green:0.56, blue:0.58, alpha:1.0),
                  alignment: .right
                ),
                MessageBubbleComponent(
                  direction: .incoming,
                  body: "Yes, that's pretty great.",
                  displaysTail: false
                ),
                MessageBubbleComponent(
                  direction: .incoming,
                  body: "Anyways, do you wanna watch some Silicon Valley today? I've heard the third season is pretty crazy."
                )
              ]
            )
          ),
          TrayComponent(),
          DoodleComponent()
        ]
    )
  }
  
}
