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
var transform: CATransform3D = CATransform3DIdentity
  .translatedBy(y: 44.0)
  .rotatedBy(angle: .pi / 4.0, x: 1.0)
```

Change a layer's transform's translation to `(x: 44.0, y: 44.0)` and scale to `(x: 0.75, y: 0.75)`

```swift
let layer = ...
layer.transform.translation = Translation(44.0, 44.0, 0.0)
layer.transform.scale = Scale(0.75, 0.75, 0.0)
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

Sadly, `simd` doesn't support storing `CGFloat` (even when they're `Double`) so to make this library easier to use (i.e. without casting everything to doubles all the time `Double(some CGFloat)` you'll find `Vector3`, `Vector4`, and `Quaternion`, which wrap `simd` counterparts: `simd_double3`, `simd_double4`, and `simd_quatd`, respectively.

`Translation`, `Scale`, etc. are all type aliased (i.e. `Vector3`  or `Vector4`), and they all conform to `ArrayLiteralRepresentable` so you can use Array<CGFloat> to initialize them.

```swift
layer.translation = [44.0, 44.0, 0.0]
layer.scale = [0.5, 0.75, 0.0]
```

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
