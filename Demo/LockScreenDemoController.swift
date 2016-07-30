//
//  ViewController.swift
//  Layout
//
//  Created by Matthew Cheok on 30/7/16.
//  Copyright © 2016 Matthew Cheok. All rights reserved.
//

import UIKit
import Layout

struct ProgressComponent: CompositeLayout {
  let content: LayoutProtocol =
    StackLayout(
      direction: .vertical,
      align: .center,
      justify: .stretch,
      spacing: 2,
      children: [
        SliderComponent(
          thumbImage: UIImage(named: "slider-thumb-small")
        ),
        StackLayout(
          direction: .horizontal,
          align: .stretch,
          justify: .center,
          children: [
            LabelComponent(
              text: "0:14",
              font: .systemFont(ofSize: 13),
              color: .white,
              alignment: .left
            ),
            LabelComponent(
              text: "-3:10",
              font: .systemFont(ofSize: 13),
              color: .white,
              alignment: .right
            )
          ]
        )
      ]
  )
}

struct PagingComponent: CompositeLayout {
  let content: LayoutProtocol =
    StackLayout(
      direction: .horizontal,
      align: .center,
      justify: .center,
      spacing: 10,
      children: [
        ImageComponent(image: UIImage(named: "paging-active")),
        ImageComponent(image: UIImage(named: "paging-inactive")),
        ImageComponent(image: UIImage(named: "paging-camera")),
        ])
}

class LockScreenDemoController: DemoViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    
    layout =
      BackgroundLayout(
        content:
        InsetLayout(
          insets: UIEdgeInsets(
            top: 40,
            left: 30,
            bottom: 10,
            right: 30
          ),
          content:
          StackLayout(
            direction: .vertical,
            align: .center,
            justify: .stretch,
            spacing: 16,
            children: [
              ProgressComponent(),
              StackLayout(
                direction: .vertical,
                align: .center,
                justify: .stretch,
                spacing: 0,
                children: [
                  LabelComponent(
                    text: "This is What You Came For (feat. Ri",
                    font: .systemFont(ofSize: 20),
                    color: .white,
                    alignment: .center
                  ),
                  LabelComponent(
                    text: "Calvin Harris - This is What You Ca",
                    font: .systemFont(ofSize: 20),
                    color: UIColor(red:0.66, green:0.66, blue:0.66, alpha:1.0),
                    alignment: .center
                  )
                ]
              ),
              StackLayout(
                direction: .horizontal,
                align: .center,
                justify: .center,
                spacing: 70,
                children: [
                  ButtonComponent(image: UIImage(named: "icon-rewind"), action: {}),
                  ButtonComponent(image: UIImage(named: "icon-pause"), action: {}),
                  ButtonComponent(image: UIImage(named: "icon-forward"), action: {})
                ]
              ),
              SliderComponent(
                minimumValueImage: UIImage(named: "icon-volume-less"),
                maximumValueImage: UIImage(named: "icon-volume-more")
              ),
              StackLayout(
                direction: .horizontal,
                align: .stretch,
                justify: .center,
                children: [
                  ImageComponent(
                    image: UIImage(named: "background-album"),
                    contentMode: .scaleAspectFill
                  )
                ]
              ),
              LabelComponent(
                text: "Press home to open",
                font: UIFont.boldSystemFont(ofSize: 15),
                color: .white,
                alignment: .center
              ),
              PagingComponent()
            ]
          )
          
        ),
        background:
        ImageComponent(
          image: UIImage(named: "background-blur"),
          contentMode: .scaleAspectFill
        )
    )
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
}
