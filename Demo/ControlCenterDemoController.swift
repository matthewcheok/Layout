//
//  ControlCenterDemoController.swift
//  Layout
//
//  Created by Matthew Cheok on 2/8/16.
//  Copyright © 2016 Matthew Cheok. All rights reserved.
//

import UIKit
import Layout

private let kBackgroundColor = UIColor(white: 0.68, alpha: 1)

struct CircleButtonComponent: CompositeLayout {
  enum State {
    case normal
    case selected
  }
  
  let image: UIImage?
  let state: State
  
  var content: LayoutProtocol {
    let color = self.state == .selected ? UIColor(red:0.00, green:0.48, blue:1.00, alpha:1.0) : kBackgroundColor
    return RestrictedLayout(
      size: CGSize(width: 48, height: 48),
      content:
      ButtonComponent(title: nil, image: image, background: RoundedBackground.image(color: color, cornerRadius: 24), action: {
      })
    )
  }
}

struct RoundedButtonComponent: CompositeLayout {
  let image: UIImage?
  
  var content: LayoutProtocol {
    return RestrictedLayout(
      size: CGSize(width: 60, height: 60),
      content:
      ButtonComponent(title: nil, image: image, background: RoundedBackground.image(color: kBackgroundColor, cornerRadius: 12), action: {
      })
    )
  }
}

struct RoundedRowComponent: CompositeLayout {
  let image: UIImage?
  let title: String
  let selected: Bool
  let corners: UIRectCorner
  
  init(image: UIImage?, title: String, selected: Bool = false, corners: UIRectCorner = .allCorners) {
    self.image = image
    self.title = title
    self.selected = selected
    self.corners = corners
  }
  
  var content: LayoutProtocol {
    return BackgroundLayout(
      content:
      InsetLayout(
        insets: UIEdgeInsets(top: 15, left: 20, bottom: 15, right: 20),
        content:
        StackLayout(
          direction: .horizontal,
          align: .center,
          justify: .center,
          spacing: 10,
          children: [
            ImageComponent(image: image),
            LabelComponent(text: title, font: UIFont.systemFont(ofSize: 15), color: selected ? .white : .black),
          ]
        )
      ),
      background:
      ButtonComponent(background: RoundedBackground.image(color: kBackgroundColor, cornerRadius: 12, corners: corners), action: { 
      })
    )
  }
}

struct ControlCenterComponent: CompositeLayout {
  var content: LayoutProtocol =
    BackgroundLayout(
      content:
      InsetLayout(
        insets: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20),
        content:
        StackLayout(
          direction: .vertical,
          align: .center,
          justify: .stretch,
          spacing: 25,
          children:[
            StackLayout(
              direction: .horizontal,
              align: .stretch,
              justify: .center,
              children:[
                CircleButtonComponent(image: UIImage(named: "icon-airplane"), state: .normal),
                CircleButtonComponent(image: UIImage(named: "icon-wifi"), state: .selected),
                CircleButtonComponent(image: UIImage(named: "icon-bluetooth"), state: .selected),
                CircleButtonComponent(image: UIImage(named: "icon-night-mode"), state: .normal),
                CircleButtonComponent(image: UIImage(named: "icon-orientation-lock"), state: .selected)
              ]
            ),
            SliderComponent(
              minimumValueImage: UIImage(named: "icon-brightness-less"),
              maximumValueImage: UIImage(named: "icon-brightness-more"),
              thumbImage: UIImage(named: "slider-thumb-medium")
            ),
            StackLayout(direction: .horizontal, align: .stretch, justify: .stretch, spacing: 1, children: [
              RoundedRowComponent(
                image: UIImage(named: "icon-airplay"),
                title: "AirPlay",
                corners: [.topLeft, .bottomLeft]
              ),
              RoundedRowComponent(
                image: UIImage(named: "icon-airdrop"),
                title: "AirDrop: Everyone",
                selected: true,
                corners: [.topRight, .bottomRight]
              ),
              ]),
            RoundedRowComponent(
              image: UIImage(named: "icon-brightness-more"),
              title: "Night Shift: Off"
            ),
            StackLayout(
              direction: .horizontal,
              align: .stretch,
              justify: .center,
              children:[
                RoundedButtonComponent(image: UIImage(named: "icon-flashlight")),
                RoundedButtonComponent(image: UIImage(named: "icon-clock")),
                RoundedButtonComponent(image: UIImage(named: "icon-calculator")),
                RoundedButtonComponent(image: UIImage(named: "icon-camera-2")),
                ]
            )
          ]
        )
      ),
      background:
      WrappedComponent<UIView> {
        $0.backgroundColor = UIColor(white: 1, alpha: 0.8)
        $0.layer.cornerRadius = 12
      }
  )
}

class ControlCenterDemoController: DemoViewController {
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    layout =
      BackgroundLayout(
        content:
        InsetLayout(
          insets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10),
          content:
          StackLayout(
            direction: .vertical,
            align: .end,
            justify: .stretch,
            children:[
              ControlCenterComponent()
            ]
          )
        ),
        background:
        OverlayLayout(
          content:
          ImageComponent(image: UIImage(named: "background-lockscreen")),
          overlay:
          WrappedComponent<UIView> {
            $0.backgroundColor = UIColor(white: 0, alpha: 0.5)
          }
        )
    )
  }
}
