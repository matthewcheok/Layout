<p align="center">
    <img src="https://github.com/matthewcheok/Layout/raw/master/logo.png" alt="Logo" width="445" height="99">
</p>
<p align="center">
    <img src="https://img.shields.io/badge/language-swift-orange.svg"
         alt="Language">
    <a href="https://github.com/Carthage/Carthage">
        <img src="https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat"
             alt="Carthage">
    </a>
    <img src="https://img.shields.io/badge/license-MIT-000000.svg"
         alt="License">
</p>

#Layout
Functional Layout in Swift

**Layout** brings declarative layout to Swift. Inspired by [ComponentKit](http://componentkit.org), you can express your complex layouts succinctly without heavy geometry calculations.

## Installation

- Simply add the following to your [`Cartfile`](https://github.com/Carthage/Carthage) and run `carthage update`:
```
github "matthewcheok/Layout" ~> 0.1
```

- or clone as a git submodule,

- or just copy files in the ```Framework``` folder into your project.

## Example code

**Layout** was designed for the start to be general enough to handle complex designs. It's tested against real-world UI like the following examples from iOS 10.

<img src="https://github.com/matthewcheok/Layout/raw/master/example-lockscreen.png" width="250" height="445">
<img src="https://github.com/matthewcheok/Layout/raw/master/example-control-center.png" width="250" height="445">
<img src="https://github.com/matthewcheok/Layout/raw/master/example-messages.png" width="250" height="445">

Refer to the included examples in the project for more details.

## Getting Started

Either add `LayoutHostingView` to your view hierarchy or use `LayoutViewController` out of the box. Then set the `layout` property whenever you want to update your UI.

You can use your own code that implements `LayoutProtocol` or any of the built-in `Layouts` (typically do not vend actual views) or `Components` (typically wraps a `UIView` subclass for easy usage) or a mixture of both.

## Tools of the Trade

### StackLayout

This is the powerhouse of the `Layout` library. Similar to `UIStackView`, `StackLayout` allows you to organize your UI in a row or column and specify a range of options regarding how they are laid out.

```
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
)
```

### InsetLayout

`InsetLayout` allows you specify a padding between the child layout and the parent layout.

### BackgroundLayout / OverlayLayout

These layouts lets your position views over or under other views.

### RestrictedLayout

For times when you need more fine-grain control over the size of specific layouts, `RestrictedLayout` allows you to indicate if the child layout should have a fixed or flexible size.

### LabelComponent

This component wraps a `UILabel` and displays text in variety of ways.

### ImageComponent

This component wraps a `UIImageView` and displays images in a variety of ways.

### WrappedComponent

Use this component to wrap a `UIView` subclass that is not supported out of the box.

### CompositeLayout

Use this layout to encapsulate logical groups and make your code more reusable.

## License

`Layout` is under the MIT license.
