# Decomposed

![Tests](https://github.com/b3ll/Decomposed/workflows/Tests/badge.svg)
![Docs](https://github.com/b3ll/Decomposed/workflows/Docs/badge.svg)

Manipulating and using `CATransform3D` for animations and interactions is pretty challenging… Decomposed makes `CATransform3D`, `matrix_double4x4`, and `matrix_float4x4` much easier to work with.

<p align="center">
  <img width="240" height="519" src="https://github.com/b3ll/Decomposed/blob/master/Resources/Decomposed.gif?raw=true">
  <img width="240" height="519" src="https://github.com/b3ll/Decomposed/blob/master/Resources/Decomposed2.gif?raw=true">
</p>

**Note**: The API for Decomposed is still heavily being changed / optimized, so please feel free to give feedback and expect breaking changes as time moves on.

Specifically, I really want to figure out what to do about the Vector types introduced in this repository. If there are any issues with them please let me know; I'm actively sourcing ways to make it better.

- [Introduction](#introduction)
- [Usage](#usage)
  - [Transform Modifications](#transform-modifications)
  - [CALayer Extensions](#calayer-extensions)
  - [DecomposedTransform](#decomposedtransform)
  - [CGVector3 / CGVector4 / CGQuaternion](#cgvector3--cgvector4--cgquaternion)
  - [Interpolatable](#interpolatable)
- [Installation](#installation)
- [Other Recommendations](#other-recommendations)
  - [Advance](#advance)
- [License](#license)
- [Contact Info](#contact-info)

# Introduction

Typically on iOS if you wanted to transform a `CALayer` you'd do something like:

```swift
let layer: CAlayer = ...
layer.transform = CATransform3DMakeScale(0.5, 0.5, 1.0)
```

However, what if you were given a transform from somewhere else? How would you know what the scale of the layer is? What if you wanted to set the scale or translation of a transform? Without lots of complex linear algebra, it's not easy to do!

Decomposed aims to simplify this by allowing for `CATransform3D`, `matrix_double4x4`, and `matrix_float4x4`, to be decomposed, recomposed, and mutated without complex math.

Decomposition is the act of breaking something down into smaller components, in this case transformation matrices into things like translation, scale, etc. in a way that they can all be individually changed or reset. The following are supported:

- Translation
- Scale
- Rotation (using Quaternions or Euler Angles)
- Skew
- Perspective

It's also powered by Accelerate, so it should introduce relatively low overhead for matrix manipulations.

# Usage

API Documentation is [here](https://b3ll.github.io/Decomposed/).

## Transform Modifications

### Swift

Create a transform with a translation of 44pts on the Y-axis, rotated by .pi / 4.0 on the X-axis

```swift
var transform: CATransform3D = CATransform3DIdentity
  .translatedBy(y: 44.0)
  .rotatedBy(angle: .pi / 4.0, x: 1.0)
```

### Objective-C

Create a transform with a translation of 44pts on the Y-axis, rotated by .pi / 40 on the X-axis.

```objectivec
CATransform3DDecomposed *decomposed = [DEDecomposedCATransform3D decomposedTransformWithTransform:CATransform3DIdentity];
decomposed.translation = CGPoint(0.0, 44.0);
decomposed.rotation = simd_quaternion(M_PI / 4.0, simd_make_double3(1.0, 0.0, 0.0));
transform = [decomposed recompose];
```

## CALayer Extensions

Typically when doing interactive gestures with `UIView` and `CALayer` you'll wind up dealing with implicit actions (animations) when changing transforms. Instead of wrapping your code in `CATransactions`'s and disabling actions, Decomposed does this automatically for you.

### Swift

```swift
// In some UIPanGestureRecognizer handling method
layer.translation = panGestureRecognizer.translation(in: self)
layer.scale = CGPoint(x: 0.75, y: 0.75)
```

### Objective-C

Since namespace collision happens in Objective-C, you're able to do similar changes via the `transformProxy` property. Changes to this proxy object will be applied to the layer's transform with implicit animations disabled.

```objectivec
// In some UIPanGestureRecognizer handling method
layer.transformProxy.translation = [panGestureRecognizer translationInView:self];
layer.transformProxy.scale = CGPoint(x: 0.75, y: 0.75);
```

## DecomposedTransform

Anytime you change a property on a `CATransform3D` or `matrix_double4x4`, it needs to be decomposed, changed, and then recomposed. This can be expensive if done a lot, so it should be limited. If you're making multiple changes at once, it's better to change the `DecomposedTransform` and then call its `recomposed()` function to get a recomposed transform.

### Swift

```swift
var decomposed = transform.decomposed()
decomposed.translation = Translation(44.0, 44.0, 0.0)
decomposed.scale = Scale(0.75, 0.75, 0.0)
decomposed.rotation = CGQuaternion(angle: .pi / 4.0, axis: CGVector3(1.0, 0.0, 0.0))

let changedTransform = decomposed.recomposed()
```

### Objective-C

```objectivec
DEDecomposedCATransform3D *decomposed = [DEDecomposedCATransform3D decomposedTransformWithTransform:transform];
decomposed.translation = CGPointMake(44.0, 44.0);
decomposed.scale = CGPointMake(0.75, 0.75);
decomposed.rotation = simd_quaternion(M_PI / 4.0, simd_make_double3(1.0, 0.0, 0.0));

CATransform3D changedTransform = [decomposed recomposed];
```

## CGVector3 / CGVector4 / CGQuaternion

Sadly, `simd` doesn't support storing `CGFloat` (even when they're `Double`). To make this library easier to use (i.e. without casting everything to doubles all the time `Double(some CGFloat)` you'll find `CGVector3`, `CGVector4`, and `CGQuaternion`, which wrap `simd` counterparts: `simd_double3`, `simd_double4`, and `simd_quatd`, respectively.

`Translation`, `Scale`, etc. are all type aliased (i.e. `CGVector3` or `CGVector4`), and they all conform to `ArrayLiteralRepresentable` so you can use `Array<CGFloat>` to initialize them.

```swift
layer.translation = Translation(44.0, 44.0, 0.0)
layer.scale = Scale(0.5, 0.75, 0.0)
```

**Note**: This API is questionable in its current form as it collides with Swift's `Vector` types (which are just simd types and part of me thinks everything should be exposed as `simd` types), so I'm happy to take feedback!

## Interpolatable

It also provides functionality to linearly interpolate from any transform to any transform via the `Interpolatable` protocol. This lets you easily animate / transition between transforms in a controlled manner.

```swift
let transform: CATransform3D = CATransform3DIdentity
  .translatedBy(x: 44.0, y: 44.0)

let transform2 = CATransform3DIdentity
  .translatedBy(x: 120.0, y: 240.0)
  .scaled(by: [0.5, 0.75, 1.0])
  .rotatedBy(angle: .pi / 4.0, x: 1.0)

let interpolatedTransform = transform.lerp(to: transform2, fraction: 0.5)
```

# Installation

## Requirements

- iOS 13+, macOS 10.15+
- Swift 5.0 or higher

Currently Decomposed supports Swift Package Manager, CocoaPods, Carthage, being used as an xcframework, and being used manually as an Xcode subproject. Pull requests for other dependency systems / build systems are welcome!

## Swift Package Manager

Add the following to your `Package.swift` (or add it via Xcode's GUI):

```swift
.package(url: "https://github.com/b3ll/Decomposed", from: "0.0.1")
```

## CocoaPods

Add the following to your `Podfile`:

`pod 'Decomposed'`

## xcframework

A built xcframework is available for each tagged release.

#### Notes

For some reason, when using CocoaPods and the Objective-C parts of this library, you may see an error like:

`Declaration of 'DEDecomposedCATransform3D' must be imported from module 'Decomposed.Swift' before it is required`.

To fix this, you'll need to use Objective-C++ files (i.e. rename from `.m` to `.mm`) or change your imports to:

```objective
#import <Decomposed/Decomposed.h>
#import <Decomposed/Decomposed-Swift.h>
```

I don't have any other workarounds at the moment, but if I do, I'll make an update.

## Carthage

Add the following to your `Cartfile`:

`"b3ll/Decomposed"`

## Xcode Subproject

- Add `Decomposed.xcodeproj` to your project
- Add `Decomposed.framework` as an embedded framework (it's a static library, so it should not be embedded).

#### Objective-C Notes

- Objective-C support is **not** available through Swift Package Manager. Please use the manual Xcode subproject instead.
- You'll want to use `#import <Decomposed/Decomposed.h>` as this contains both the generated Swift interfaces for the Objective-C classes and CALayer categories.
- Not all of the API is available due to limitations of how Swift / Objective-C interop. Sadly the API can't be as nice, but `CATransform3DDecomposed` will allow for decomposition and recomposition of `CATransform3D` (similar classes exist for `matrix_double4x4` and `matrix_float4x4` and are wrappers around their Swift counterparts) as well as convenience categories on `CALayer`.

# Other Recommendations

## Motion

This library pairs very nicely with [Advance](https://github.com/b3ll/Motion), an animation engine for gesturally-driven user interfaces, animations, and interactions on iOS, macOS, and tvOS.

Animating a layer on a spring by modifying its transform has never been easier! Usually you'd have to manually wrap things in a `CATransaction` with actions disabled, and usage of `CATransform3DTranslate` gets pretty cumbersome.

With Decomposed + Motion this is super easy.

```swift
let layer = ...
let springAnimation = SpringAnimation<CGPoint>(initialValue: .zero)
springAnimation.onValueChanged(disableActions: true) { [layer] translation in
  layer.translation = translation
}

// In your pan gesture recognizer callback

let translation = panGestureRecognizer.translation(in: self.view)
let velocity = panGestureRecognizer.velocity(in: self.view)

switch panGestureRecognizer.state {
  case .began:
    springAnimation.stop()
    springAnimation.updateValue(to: .zero)
  case .changed:
    springAnimation.updateValue(to: translation)
    layer.translation = translation
  case .ended:
    springAnimation.velocity = velocity
    springAnimation.toValue = CGPoint(x: 200.0, y: 200.0) // wherever you want it to go
    springAnimation.start()
  default:
    break
}
```

See the DraggingCard demo for a good example of this :)

# License

Decomposed is licensed under the [BSD 2-clause license](https://github.com/b3ll/Decomposed/blob/master/LICENSE).

# Contact Info

Feel free to follow me on twitter: [@b3ll](https://www.twitter.com/b3ll)!
