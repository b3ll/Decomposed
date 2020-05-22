# Decomposed

Manipulating and using `CATransform3D` for animations and interactions is pretty challenging… Decomposed makes `CATransform3D` and `matrix_simd4x4` much easier to work with.

# Introduction

Typically on iOS if you wanted to transform a `CALayer` you'd do something like:

```swift
let layer: CAlayer = ...
layer.transform = CATransform3DMakeScale(0.5, 0.5, 1.0)
```
However, what if you were given a transform from somewhere else? How would you know what the scale of the layer is? What if you wanted to set the scale or translation of a transform? Without lots of complex linear algebra, it's not easy to do!

Decomposed aims to simplify this by allowing for `CATransform3D` and `matrix_double4x4` to be decomposed, recomposed, and mutated without crazy math.

It's also powered by Accelerate, so it should introduce relatively low overhead for matrix manipulations.

# Usage

Create a transform with a translation of 44pts on the Y-axis, rotated by .pi / 4.0 on the X-axis

```swift
var transform: CATransform3D = .identity
transform.translate(by: [0.0, 88.0, 0.0))
transform.rotateBy(angle: .pi / 4.0, x: 1.0)
```

Change a layer's transform's translation to `(44.0, 44.0, 0.0)` and scale to `(0.75, 0.75, 0.0)`

```swift
let layer = ...
layer.transform.translation = [44.0, 44.0, 0.0]
layer.transform.scale = [0.75, 0.75, 0.0]
```

# DecomposedTransform

Anytime you change a property on a `CATransform3D` or `matrix_double4x4`, it needs to be decomposed, changed, and then recomposed. This can be expensive if done a lot, so it should be limited. If you're making multiple changes at once, it's better to change the `DecomposedTransform` and then call its `recomposed()` function to get a recomposed transform.

```swift
var decomposed = transform.decomposed()
decomposed.translation = [44.0, 44.0, 0.0]
decomposed.scale = [0.75, 0.75, 0.0]
decomposed.rotation = Quaternion(angle: .pi / 4.0, axis: [1.0, 0.0, 0.0])

let changedTransform = decomposed.recomposed()
```

# Interpolatable

It also provides functionality to linearly interpolate from any transform to any transform via the `Interpolatable` protocol.

```swift
var transform: CATransform3D = CATransform3DIdentity
  .translated(by: [44.0, 44.0, 0.0])
  .scaled(by: [1.0, 1.0, 1.0])

let transform2 = CATransform3D
```
