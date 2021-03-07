//
//  SIMDDecomposed.swift
//  
//
//  Created by Adam Bell on 5/14/20.
//

// Loose adaption of https://opensource.apple.com/source/WebCore/WebCore-7604.1.38.1.6/platform/graphics/transforms/TransformationMatrix.cpp.auto.html

import QuartzCore
import simd

// MARK: - matrix_double4x4

public extension matrix_double4x4 {

  /// Returns the identity matrix of a `matrix_double4x4`.
  static var identity: matrix_double4x4 {
    return matrix_identity_double4x4
  }

  /// Returns a `matrix_double4x4` with all zeros.
  static var zero: matrix_double4x4 {
    return matrix_double4x4()
  }

  /// Initializes a `matrix_double4x4` with a CATransform3D.
  init(_ transform: CATransform3D) {
    self.init(
      simd_double4(Double(transform.m11), Double(transform.m12), Double(transform.m13), Double(transform.m14)),
      simd_double4(Double(transform.m21), Double(transform.m22), Double(transform.m23), Double(transform.m24)),
      simd_double4(Double(transform.m31), Double(transform.m32), Double(transform.m33), Double(transform.m34)),
      simd_double4(Double(transform.m41), Double(transform.m42), Double(transform.m43), Double(transform.m44))
    )
  }

  /// Decomposes this matrix into its specific transform attributes (scale, translation, etc.) and returns a Decomposed struct to alter / recompose it.
  func decomposed() -> DecomposedTransform {
    return DecomposedTransform(self)
  }

  /// The translation of the transformation matrix.
  var translation: simd_double3 {
    get {
      return decomposed().translation
    }
    set {
      self.translate(by: newValue)
    }
  }

  /// Returns a copy by translating the current transformation matrix by the given translation amount.
  func translated(by translation: simd_double3) -> Self {
    var matrix = self
    matrix.translate(by: translation)
    return matrix
  }

  /// Translates the current transformation matrix by the given translation amount.
  mutating func translate(by t: simd_double3) {
    var matrix: matrix_double4x4 = .identity
    matrix[3] = simd_double4(t.x, t.y, t.z, 1.0)
    self = matrix_multiply(self, matrix)
  }

  /// The scale of the transformation matrix.
  var scale: simd_double3 {
    get {
      return decomposed().scale
    }
    set {
      self.scale(by: newValue)
    }
  }

  /// Returns a copy by scaling the current transformation matrix by the given scale.
  func scaled(by scale: simd_double3) -> Self {
    var matrix = self
    matrix.scale(by: scale)
    return matrix
  }

  /// Scales the current transformation matrix by the given scale.
  mutating func scale(by s: simd_double3) {
    self[0] *= s.x
    self[1] *= s.y
    self[2] *= s.z
  }

  /// The rotation of the transformation matrix (expressed as a quaternion).
  var rotation: simd_quatd {
    get {
      return decomposed().rotation
    }
    set {
      self.rotate(by: newValue)
    }
  }

  /// Returns a copy by applying a rotation transform (expressed as a quaternion) to the current transformation matrix.
  func rotated(by quaternion: simd_quatd) -> Self {
    var matrix = self
    matrix.rotate(by: quaternion)
    return matrix
  }

  /// Rotates the current rotation by applying a rotation transform (expressed as a quaternion) to the current transformation matrix.
  mutating func rotate(by q: simd_quatd) {
    if (q.axis.x.isNaN || q.axis.y.isNaN || q.axis.z.isNaN) {
      return
    }
    let rotationMatrix = matrix_double4x4(q)
    self = matrix_multiply(self, rotationMatrix)
  }

  /// The rotation of the transformation matrix (expressed as euler angles, expressed in radians).
  var eulerAngles: simd_double3 {
    get {
      return decomposed().eulerAngles
    }
    set {
      self.rotate(by: newValue)
    }
  }

  /// Returns a copy by applying a rotation transform (expressed as euler angles, expressed in radians) to the current transformation matrix.
  func rotated(by eulerAngles: simd_double3) -> Self {
    var matrix = self
    matrix.rotate(by: eulerAngles)
    return matrix
  }

  /// Rotates the current rotation by applying a rotation transform (expressed as euler angles, expressed in radians) to the current transformation matrix.
  mutating func rotate(by eulerAngles: simd_double3) {
    let quaternion = simd_quatd(eulerAngles)
    self.rotate(by: quaternion)
  }

  /// The skew of the transformation matrix.
  var skew: simd_double3 {
    get {
      return decomposed().skew
    }
    set {
      self.skew(by: newValue)
    }
  }

  /// Returns a copy by skewing the current transformation matrix by a given skew.
  func skewed(by skew: simd_double3) -> Self {
    var matrix = self
    matrix.skew(by: skew)
    return matrix
  }

  /// Skews the current transformation matrix by the given skew.
  mutating func skew(by s: simd_double3) {
    if s.yz != 0.0 {
      var skewMatrix: matrix_double4x4 = .identity
      skewMatrix[2][1] = s.yz
      self = matrix_multiply(self, skewMatrix)
    }

    if s.xz != 0.0 {
      var skewMatrix: matrix_double4x4 = .identity
      skewMatrix[2][0] = s.xz
      self = matrix_multiply(self, skewMatrix)
    }

    if s.xy != 0.0 {
      var skewMatrix: matrix_double4x4 = .identity
      skewMatrix[1][0] = s.xy
      self = matrix_multiply(self, skewMatrix)
    }
  }

  /// The perspective of the transformation matrix.
  var perspective: simd_double4 {
    get {
      return decomposed().perspective
    }
    set {
      self.applyPerspective(newValue)
    }
  }

  /// Returns a copy by changing the perspective of the current transformation matrix.
  func applyingPerspective(_ p: simd_double4) -> Self {
    var matrix = self
    matrix.applyPerspective(p)
    return matrix
  }

  /// Sets the perspective of the current transformation matrix.
  mutating func applyPerspective(_ p: simd_double4)  {
    self[0][3] = p.x
    self[1][3] = p.y
    self[2][3] = p.z
    self[3][3] = p.w
  }

}

// MARK: - DecomposedTransform

public extension matrix_double4x4 {
  
  /**
   A type to break down a `matrix_double4x4` into its specific transformation attributes / properties (i.e. scale, translation, etc.).
   
   Instantiate this using: `matrix_float4x4.decomposed()`.
   */
  struct DecomposedTransform {

    /// The translation of a transformation matrix.
    public var translation: simd_double3 = .zero

    /// The scale of a transformation matrix.
    public var scale: simd_double3 = .zero

    /// The rotation of a transformation matrix (expressed as a quaternion ).
    public var rotation: simd_quatd = simd_quatd()

    /// The rotation of a transformation matrix (expressed as a euler angles).
    public var eulerAngles: simd_double3 = .zero {
      didSet {
        self.rotation = simd_quatd(eulerAngles)
      }
    }

    /// The shearing of a transformation matrix.
    public var skew: simd_double3 = .zero

    /// The perspective of a transformation matrix (e.g. .m34).
    public var perspective: simd_double4 = .zero

    /**
     Designated initializer.

     - Note: You'll want to use `matrix_double4x4.decomposed()` instead.
     */
    internal init(translation: simd_double3, scale: simd_double3, rotation: simd_quatd, eulerAngles: simd_double3, skew: simd_double3, perspective: simd_double4) {
      self.scale = scale
      self.skew = skew
      self.rotation = rotation
      self.eulerAngles = eulerAngles
      self.translation = translation
      self.perspective = perspective
    }

    /**
     Designated initializer.

     - Note: You'll want to use `matrix_double4x4.decomposed()` instead.
     */
    internal init(_ matrix: matrix_double4x4) {
      var local = matrix

      // Normalize the matrix if needed.
      if local[3][3] != 0.0 {
        local = matrix_scale(1.0 / local.columns.3.w, local)
      }

      var perspective = local
      perspective[0][3] = 0.0
      perspective[1][3] = 0.0
      perspective[2][3] = 0.0
      perspective[3][3] = 1.0

      // solve for perspective
      guard simd_determinant(perspective) != 0.0 else { return }

      if (local[0][3] != 0.0) || (local[1][3] != 0.0) || (local[2][3] != 0.0) {
        let rhs = simd_double4(local[0][3], local[1][3], local[2][3], local[3][3])
        let transposedPerspective = perspective.inverse.transpose
        self.perspective = matrix_multiply(transposedPerspective, rhs)

        local[0][3] = 0.0
        local[1][3] = 0.0
        local[2][3] = 0.0
        local[3][3] = 1.0
      } else {
        self.perspective[3] = 1.0
      }

      // get translation
      self.translation = simd_double3(local[3][0], local[3][1], local[3][2])
      local[3][0] = 0.0
      local[3][1] = 0.0
      local[3][2] = 0.0

      // get scale and shear
      var rotationLocal = matrix_double3x3(
        simd_double3(local[0][0], local[0][1], local[0][2]),
        simd_double3(local[1][0], local[1][1], local[1][2]),
        simd_double3(local[2][0], local[2][1], local[2][2])
      )

      self.scale.x = length(rotationLocal[0])
      rotationLocal[0] = normalize(rotationLocal[0])

      self.skew.xy = dot(rotationLocal[0], rotationLocal[1])
      rotationLocal[1] = simd_linear_combination(1.0, rotationLocal[1], -skew.xy, rotationLocal[0])

      self.scale.y = simd_length(rotationLocal[1])
      rotationLocal[1] = normalize(rotationLocal[1])
      self.skew.xy /= scale.y

      self.skew.xz = dot(rotationLocal[0], rotationLocal[2])
      rotationLocal[2] = simd_linear_combination(1.0, rotationLocal[2], -skew.xz, rotationLocal[0])
      self.skew.yz = dot(rotationLocal[1], rotationLocal[2])
      rotationLocal[2] = simd_linear_combination(1.0, rotationLocal[2], -skew.yz, rotationLocal[1])

      self.scale.z = length(rotationLocal[2])
      rotationLocal[2] = normalize(rotationLocal[2])
      self.skew.xz /= scale.z
      self.skew.yz /= scale.z

      if simd_determinant(rotationLocal) < 0 {
        self.scale *= -1.0

        rotationLocal[0] *= -1.0
        rotationLocal[1] *= -1.0
        rotationLocal[2] *= -1.0
      }

      // get rotation
      self.eulerAngles.y = asin(-rotationLocal[0][2])
      if cos(eulerAngles.y) != 0.0 {
        self.eulerAngles.x = atan2(rotationLocal[1][2], rotationLocal[2][2])
        self.eulerAngles.z = atan2(rotationLocal[0][1], rotationLocal[0][0])
      } else {
        self.eulerAngles.x = atan2(-rotationLocal[2][0], rotationLocal[1][1])
        self.eulerAngles.z = 0.0
      }

      self.rotation = simd_quatd(rotationLocal)
    }

    /// Merges all the properties of the the decomposed transform into a `matrix_double4x4` transform.
    public func recomposed() -> matrix_double4x4 {
      var recomposed: matrix_double4x4 = .identity

      recomposed.applyPerspective(perspective)
      recomposed.translate(by: translation)
      recomposed.rotate(by: rotation)
      recomposed.skew(by: skew)
      recomposed.scale(by: scale)

      return recomposed
    }

  }

}

extension matrix_double4x4.DecomposedTransform: Interpolatable {

  public func lerp(to: Self, fraction: Double) -> Self {
    return matrix_double4x4.DecomposedTransform(translation: translation.lerp(to: to.translation, fraction: fraction),
                                                scale: scale.lerp(to: to.scale, fraction: fraction),
                                                rotation: rotation.lerp(to: to.rotation, fraction: fraction),
                                                eulerAngles: eulerAngles.lerp(to: to.eulerAngles, fraction: fraction),
                                                skew: skew.lerp(to: to.skew, fraction: fraction),
                                                perspective: perspective.lerp(to: to.perspective, fraction: fraction))
  }

}

extension matrix_double4x4: Interpolatable {

  public func lerp(to: Self, fraction: Double) -> Self {
    return self.decomposed().lerp(to: to.decomposed(), fraction: Double(fraction)).recomposed()
  }

}

// MARK: - matrix_float4x4 Support

public extension matrix_float4x4 {

  /// Returns the identity matrix of a `matrix_double4x4`.
  static var identity: matrix_float4x4 {
    return matrix_identity_float4x4
  }

  /// Returns a `matrix_double4x4` with all zeros.
  static var zero: matrix_float4x4 {
    return matrix_float4x4()
  }

  /// Initializes a `matrix_double4x4` with a CATransform3D.
  init(_ transform: CATransform3D) {
    self.init(
      simd_float4(Float(transform.m11), Float(transform.m12), Float(transform.m13), Float(transform.m14)),
      simd_float4(Float(transform.m21), Float(transform.m22), Float(transform.m23), Float(transform.m24)),
      simd_float4(Float(transform.m31), Float(transform.m32), Float(transform.m33), Float(transform.m34)),
      simd_float4(Float(transform.m41), Float(transform.m42), Float(transform.m43), Float(transform.m44))
    )
  }

  /// Decomposes this matrix into its specific transform attributes (scale, translation, etc.) and returns a Decomposed struct to alter / recompose it.
  func decomposed() -> DecomposedTransform {
    return DecomposedTransform(self)
  }

  /// The translation of the transformation matrix.
  var translation: simd_float3 {
    get {
      return decomposed().translation
    }
    set {
      self.translate(by: newValue)
    }
  }

  /// Returns a copy by translating the current transformation matrix by the given translation amount.
  func translated(by translation: simd_float3) -> Self {
    var matrix = self
    matrix.translate(by: translation)
    return matrix
  }

  /// Translates the current transformation matrix by the given translation amount.
  mutating func translate(by t: simd_float3) {
    var matrix: matrix_float4x4 = .identity
    matrix[3] = simd_float4(t.x, t.y, t.z, 1.0)
    self = matrix_multiply(self, matrix)
  }

  /// The scale of the transformation matrix.
  var scale: simd_float3 {
    get {
      return decomposed().scale
    }
    set {
      self.scale(by: newValue)
    }
  }

  /// Returns a copy by scaling the current transformation matrix by the given scale.
  func scaled(by scale: simd_float3) -> Self {
    var matrix = self
    matrix.scale(by: scale)
    return matrix
  }

  /// Scales the current transformation matrix by the given scale.
  mutating func scale(by s: simd_float3) {
    self[0] *= s.x
    self[1] *= s.y
    self[2] *= s.z
  }

  /// The rotation of the transformation matrix (expressed as a quaternion).
  var rotation: simd_quatf {
    get {
      return decomposed().rotation
    }
    set {
      self.rotate(by: newValue)
    }
  }

  /// Returns a copy by applying a rotation transform (expressed as a quaternion) to the current transformation matrix.
  func rotated(by quaternion: simd_quatf) -> Self {
    var matrix = self
    matrix.rotate(by: quaternion)
    return matrix
  }

  /// Rotates the current rotation by applying a rotation transform (expressed as a quaternion) to the current transformation matrix.
  mutating func rotate(by q: simd_quatf) {
    let rotationMatrix = matrix_float4x4(q)
    self = matrix_multiply(self, rotationMatrix)
  }

  /// The rotation of the transformation matrix (expressed as euler angles, expressed in radians).
  var eulerAngles: simd_float3 {
    get {
      return decomposed().eulerAngles
    }
    set {
      self.rotate(by: newValue)
    }
  }

  /// Returns a copy by applying a rotation transform (expressed as euler angles, expressed in radians) to the current transformation matrix.
  func rotated(by eulerAngles: simd_float3) -> Self {
    var matrix = self
    matrix.rotate(by: eulerAngles)
    return matrix
  }

  /// Rotates the current rotation by applying a rotation transform (expressed as euler angles, expressed in radians) to the current transformation matrix.
  mutating func rotate(by eulerAngles: simd_float3) {
    let quaternion = simd_quatf(eulerAngles)
    self.rotate(by: quaternion)
  }

  /// The skew of the transformation matrix.
  var skew: simd_float3 {
    get {
      return decomposed().skew
    }
    set {
      self.skew(by: newValue)
    }
  }

  /// Returns a copy by skewing the current transformation matrix by a given skew.
  func skewed(by skew: simd_float3) -> Self {
    var matrix = self
    matrix.skew(by: skew)
    return matrix
  }

  /// Skews the current transformation matrix by the given skew.
  mutating func skew(by s: simd_float3) {
    if s.yz != 0.0 {
      var skewMatrix: matrix_float4x4 = .identity
      skewMatrix[2][1] = s.yz
      self = matrix_multiply(self, skewMatrix)
    }

    if s.xz != 0.0 {
      var skewMatrix: matrix_float4x4 = .identity
      skewMatrix[2][0] = s.xz
      self = matrix_multiply(self, skewMatrix)
    }

    if s.xy != 0.0 {
      var skewMatrix: matrix_float4x4 = .identity
      skewMatrix[1][0] = s.xy
      self = matrix_multiply(self, skewMatrix)
    }
  }

  /// The perspective of the transformation matrix.
  var perspective: simd_float4 {
    get {
      return decomposed().perspective
    }
    set {
      self.applyPerspective(newValue)
    }
  }

  /// Returns a copy by changing the perspective of the current transformation matrix.
  func applyingPerspective(_ p: simd_float4) -> Self {
    var matrix = self
    matrix.applyPerspective(p)
    return matrix
  }

  /// Sets the perspective of the current transformation matrix.
  mutating func applyPerspective(_ p: simd_float4)  {
    self[0][3] = p.x
    self[1][3] = p.y
    self[2][3] = p.z
    self[3][3] = p.w
  }

}

// MARK: - DecomposedTransform

public extension matrix_float4x4 {

  /**
   A type to break down a `matrix_float4x4` into its specific transformation attributes / properties (i.e. scale, translation, etc.).

   Instantiate this using: `matrix_float4x4.decomposed()`.

   - Note: Under the hood this does a conversion to represent its contents as `matrix_double4x4` which could be expensive when done frequently.
   */
  struct DecomposedTransform {

    /// The translation of a transformation matrix.
    public var translation: simd_float3 = .zero

    /// The scale of a transformation matrix.
    public var scale: simd_float3 = .zero

    /// The rotation of a transformation matrix (expressed as a quaternion).
    public var rotation: simd_quatf = simd_quatf()

    /// The rotation of a transformation matrix (expressed as euler angles).
    public var eulerAngles: simd_float3 = .zero {
      didSet {
        self.rotation = simd_quatf(eulerAngles)
      }
    }

    /// The shearing of a transformation matrix.
    public var skew: simd_float3 = .zero

    /// The perspective of a transformation matrix (e.g. .m34).
    public var perspective: simd_float4 = .zero

    /**
     Designated initializer.

     - Note: You'll want to use `matrix_float4x4.decomposed()` instead.
     */
    internal init(translation: simd_float3, scale: simd_float3, rotation: simd_quatf, eulerAngles: simd_float3, skew: simd_float3, perspective: simd_float4) {
      self.scale = scale
      self.skew = skew
      self.rotation = rotation
      self.eulerAngles = eulerAngles
      self.translation = translation
      self.perspective = perspective
    }

    /**
     Designated initializer.

     - Note: You'll want to use `matrix_float4x4.decomposed()` instead.
     */
    internal init(_ decomposed: matrix_double4x4.DecomposedTransform) {
      self.init(translation: simd_float3(decomposed.translation),
                scale: simd_float3(decomposed.scale),
                rotation: simd_quatf(decomposed.rotation),
                eulerAngles: simd_float3(decomposed.eulerAngles),
                skew: simd_float3(decomposed.skew),
                perspective: simd_float4(decomposed.perspective))
    }

    /**
     Designated initializer.

     - Note: You'll want to use `matrix_float4x4.decomposed()` instead.
     */
    internal init(_ matrix: matrix_float4x4) {
      let local = matrix_double4x4(matrix)
      let decomposed = local.decomposed()
      self.init(decomposed)
    }

    /// Merges all the properties of the the decomposed transform into a `matrix_float4x4` transform.
    public func recomposed() -> matrix_float4x4 {
      var recomposed: matrix_float4x4 = .identity

      recomposed.applyPerspective(perspective)
      recomposed.translate(by: translation)
      recomposed.rotate(by: rotation)
      recomposed.skew(by: skew)
      recomposed.scale(by: scale)

      return recomposed
    }

  }

}

extension matrix_float4x4.DecomposedTransform: Interpolatable {

  public func lerp(to: Self, fraction: Float) -> Self {
    return matrix_float4x4.DecomposedTransform(translation: translation.lerp(to: to.translation, fraction: fraction),
                                                scale: scale.lerp(to: to.scale, fraction: fraction),
                                                rotation: rotation.lerp(to: to.rotation, fraction: fraction),
                                                eulerAngles: eulerAngles.lerp(to: to.eulerAngles, fraction: fraction),
                                                skew: skew.lerp(to: to.skew, fraction: fraction),
                                                perspective: perspective.lerp(to: to.perspective, fraction: fraction))
  }

}

extension matrix_float4x4: Interpolatable {

  public func lerp(to: Self, fraction: Float) -> Self {
    return self.decomposed().lerp(to: to.decomposed(), fraction: fraction).recomposed()
  }

}

// MARK: - Utils

fileprivate func simd_linear_combination(_ ascl: Double, _ a: simd_double3, _ bscl: Double, _ b: simd_double3) -> simd_double3 {
  return simd_double3((ascl * a[0]) + (bscl * b[0]), (ascl * a[1]) + (bscl * b[1]), (ascl * a[2]) + (bscl * b[2]))
}
