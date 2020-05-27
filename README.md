# Decomposed

Manipulating and using `CATransform3D` for animations and interactions is pretty challenging… Decomposed makes `CATransform3D`, `matrix_double4x4`, and `matrix_float4x4` much easier to work with.

<p align="center">
  <img width="320" height="692" src="https://github.com/b3ll/Decomposed/blob/master/Resources/Decomposed.gif?raw=true">
</p>

**Note**: The API for Decomposed is still heavily being changed / optimized, so please feel free to give feedback and expect breaking changes as time moves on.

# Introduction

Typically on iOS if you wanted to transform a `CALayer` you'd do something like:

```swift
let layer: CAlayer = ...
layer.transform = CATransform3DMakeScale(0.5, 0.5, 1.0)
```

However, what if you were given a transform from somewhere else? How would you know what the scale of the layer is? What if you wanted to set the scale or translation of a transform? Without lots of complex linear algebra, it's not easy to do!

Decomposed aims to simplify this by allowing for `CATransform3D`, `matrix_double4x4`, `matrix_float4x4`, to be decomposed, recomposed, and mutated without crazy math.

Decomposition is the act of breaking something down into smaller components, in this case transformation matrices into things like translation, scale, etc. in a way that they can all be individually changed or reset.

It's also powered by Accelerate, so it should introduce relatively low overhead for matrix manipulations.

# Installation

Currently Decomposed supports Swift Package Manager and being used manually as an Xcode subproject. Pull requests for other dependency systems / build systems are welcome!

- **Swift Package Manager**: Add `.package(url: "http://github.com/b3ll/Decomposed", from: "0.0.1")` to your Package.swift (or through Xcode's GUI).
- **Xcode Subproject**: add `Decomposed.xcodeproj` to your project, and then add `Decomposed.framework` as an embedded framework.

### Requirements

- iOS 13+, macOS 10.15+
- Swift 5.0 or higher

### Objective-C Notes

- Objective-C support is **not** available through Swift Package Manager. Please use the manual Xcode subproject instead.
- You'll want to use `#import <Decomposed/Decomposed.h>` as this contains both the generated Swift interfaces for the Objective-C classes and CALayer categories.
- Not all of the API is available due to limitations of how Swift / Objective-C interop. Sadly the API can't be as nice, but `CATransform3DDecomposed` will allow for decomposition and recomposition of `CATransform3D` (similar classes exist for `matrix_double4x4` and `matrix_float4x4` and are wrappers around their Swift counterparts) as well as convenience categories on `CALayer`.

# Usage

API Documentation is [here](https://b3ll.github.io/Decomposed/).

## Swift

Create a transform with a translation of 44pts on the Y-axis, rotated by .pi / 4.0 on the X-axis

```swift
var transform: CATransform3D = CATransform3DIdentity
  .translatedBy(y: 44.0)
  .rotatedBy(angle: .pi / 4.0, x: 1.0)
```

Change a layer's transform's translation to `(x: 44.0, y: 44.0)` and scale to `(x: 0.75, y: 0.75)`.

```swift
let layer = ...
layer.translation = Translation(44.0, 44.0, 0.0)
layer.scale = Scale(0.75, 0.75, 0.0)
```

## Objective-C

Create a transform with a translation of 44pts on the Y-axis, rotated by .pi / 40 on the X-axis.

```objectivec
CATransform3D transform = CATransform3DIdentity;
CATransform3DDecomposed *decomposed = [CATransform3DDecomposed decomposedTransform:transform];
decomposed.translation = CGPoint(0.0, 44.0);
decomposed.rotation = simd_quaternion(M_PI / 4.0, simd_make_double3(1.0, 0.0, 0.0));
transform = [decomposed recompose];
```

Change a layer's transform's translation to `(x: 44.0, y: 44.0)` and scale to `(x: 0.75, y: 0.75)`.

```objectivec
CALayer *layer = ...
layer.de_translation = CGPointMake(44.0, 44.0);
layer.de_scale = CGPointMake(0.75, 0.75);
```

# CALayer Extensions

Typically when doing interactive gestures with `UIView` and `CALayer` you'll wind up dealing with implicit actions (animations) when changing transforms. Instead of wrapping your code in `CATransactions`'s and disabling actions, Decomposed does this automatically for you.

## Swift

```swift
// In some UIPanGestureRecognizer handling method
layer.translation = panGestureRecognizer.translation(in: self)
```

## Objective-C

```objectivec
// In some UIPanGestureRecognizer handling method
layer.de_translation = [panGestureRecognizer translationInView:self];
```

# DecomposedTransform

Anytime you change a property on a `CATransform3D` or `matrix_double4x4`, it needs to be decomposed, changed, and then recomposed. This can be expensive if done a lot, so it should be limited. If you're making multiple changes at once, it's better to change the `DecomposedTransform` and then call its `recomposed()` function to get a recomposed transform.

```swift
var decomposed = transform.decomposed()
decomposed.translation = Translation(44.0, 44.0, 0.0)
decomposed.scale = Scale(0.75, 0.75, 0.0)
decomposed.rotation = Quaternion(angle: .pi / 4.0, axis: Vector3(1.0, 0.0, 0.0))

let changedTransform = decomposed.recomposed()
```

# Vector3 / Vector4 / Quaternion

Sadly, `simd` doesn't support storing `CGFloat` (even when they're `Double`). To make this library easier to use (i.e. without casting everything to doubles all the time `Double(some CGFloat)` you'll find `Vector3`, `Vector4`, and `Quaternion`, which wrap `simd` counterparts: `simd_double3`, `simd_double4`, and `simd_quatd`, respectively.

`Translation`, `Scale`, etc. are all type aliased (i.e. `Vector3` or `Vector4`), and they all conform to `ArrayLiteralRepresentable` so you can use `Array<CGFloat>` to initialize them.

```swift
layer.translation = [44.0, 44.0, 0.0]
layer.scale = [0.5, 0.75, 0.0]
```

**Note**: This API is questionable in its current form (part of me wants to think everything should be exposed as `simd` types), so I'm happy to take feedback!

# Interpolatable

It also provides functionality to linearly interpolate from any transform to any transform via the `Interpolatable` protocol.

```swift
let transform: CATransform3D = CATransform3DIdentity
  .translated(by: [44.0, 44.0, 0.0])
  .scaled(by: [1.0, 1.0, 1.0])

let transform2 = CATransform3DIdentity
  .translated(by: [120.0, 240.0, 0.0])
  .scaled(by: [0.5, 0.75, 1.0])
  .rotatedBy(angle: .pi / 4.0, x: 1.0)

let interpolatedTransform = transform.lerp(to: transform2, fraction: 0.5)
```

# License

Decomposed is licensed under the [BSD 2-clause license](https://github.com/b3ll/Decomposed/blob/master/LICENSE).

# Contact Info?

Feel free to follow me on twitter: [@b3ll](https://www.twitter.com/b3ll)!
