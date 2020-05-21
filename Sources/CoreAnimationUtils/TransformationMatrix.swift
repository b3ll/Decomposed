//
//  TransformationMatrix.swift
//  
//
//  Created by Adam Bell on 5/14/20.
//

// Loose adaption of https://opensource.apple.com/source/WebCore/WebCore-7604.1.38.1.6/platform/graphics/transforms/TransformationMatrix.cpp.auto.html

import QuartzCore
import simd

// MARK: - matrix_double4x4

public extension matrix_double4x4 {

  /// Returns the identity matrix of a simd 4x4 matrix.
  static var identity: matrix_double4x4 {
    return matrix_identity_double4x4
  }

  /// Returns a matrix_double4x4 with all zeros.
  static var zero: matrix_double4x4 {
    return matrix_double4x4()
  }

  /// Initializes a matrix_double4x4 with a CATransform3D.
  init(_ transform: CATransform3D) {
    self.init(
      simd_double4(Double(transform.m11), Double(transform.m12), Double(transform.m13), Double(transform.m14)),
      simd_double4(Double(transform.m21), Double(transform.m22), Double(transform.m23), Double(transform.m24)),
      simd_double4(Double(transform.m31), Double(transform.m32), Double(transform.m33), Double(transform.m34)),
      simd_double4(Double(transform.m41), Double(transform.m42), Double(transform.m43), Double(transform.m44))
    )
  }

  /// Decomposes this matrix into its specific transform attributes (scale, translation, etc.) and returns a Decomposed struct to alter / recompose it.
  func decomposed() -> Decomposed {
    return Decomposed(self)
  }

  var perspective: simd_double4 {
    get {
      return decomposed().perspective
    }
    set {
      self.applyPerspective(newValue)
    }
  }

  func applyingPerspective(_ p: simd_double4) -> Self {
    var matrix = self
    matrix.applyPerspective(p)
    return matrix
  }

  mutating func applyPerspective(_ p: simd_double4)  {
    self[0][3] = p.x
    self[1][3] = p.y
    self[2][3] = p.z
    self[3][3] = p.w
  }

  var translation: simd_double3 {
    get {
      return decomposed().translation
    }
    set {
      self.translate(by: newValue)
    }
  }

  func translated(by translation: simd_double3) -> Self {
    var matrix = self
    matrix.translate(by: translation)
    return matrix
  }

  mutating func translate(by t: simd_double3) {
    var matrix: matrix_double4x4 = .identity
    matrix[3] = simd_double4(t.x, t.y, t.z, 1.0)
    self = matrix_multiply(self, matrix)
  }

  var rotation: simd_quatd {
    get {
      return decomposed().quaternion
    }
    set {
      self.rotate(by: newValue)
    }
  }

  func rotated(by quaternion: simd_quatd) -> Self {
    var matrix = self
    matrix.rotate(by: quaternion)
    return matrix
  }

  mutating func rotate(by q: simd_quatd) {
    let rotationMatrix = matrix_double4x4(q)
    self = matrix_multiply(self, rotationMatrix)
  }

  var skew: simd_double3 {
    get {
      return decomposed().skew
    }
    set {
      self.skew(by: newValue)
    }
  }

  func skewed(by skew: simd_double3) -> Self {
    var matrix = self
    matrix.skew(by: skew)
    return matrix
  }

  mutating func skew(by s: simd_double3) {
    if s.YZ != 0.0 {
      var skewMatrix: matrix_double4x4 = .identity
      skewMatrix[2][1] = s.YZ
      self = matrix_multiply(self, skewMatrix)
    }

    if s.XZ != 0.0 {
      var skewMatrix: matrix_double4x4 = .identity
      skewMatrix[2][0] = s.XZ
      self = matrix_multiply(self, skewMatrix)
    }

    if s.XY != 0.0 {
      var skewMatrix: matrix_double4x4 = .identity
      skewMatrix[1][0] = s.XY
      self = matrix_multiply(self, skewMatrix)
    }
  }

  var scale: simd_double3 {
    get {
      return decomposed().scale
    }
    set {
      self.scale(by: newValue)
    }
  }

  func scaled(by scale: simd_double3) -> Self {
    var matrix = self
    matrix.scale(by: scale)
    return matrix
  }

  mutating func scale(by s: simd_double3) {
    self[0] *= s.x
    self[1] *= s.y
    self[2] *= s.z
  }

}

// MARK: - Decomposed

/// A type to break down a matrix_double4x4 into its specific transformation attributes and properties.
public extension matrix_double4x4 {

  struct Decomposed {

    /// The translation of a transformation matrix.
    public var translation: simd_double3 = .zero

    /// The scale of a transformation matrix.
    public var scale: simd_double3 = .zero

    /// The rotation of a transformation matrix expressed as euler angles.
    public var rotation: simd_double3 = .zero

    /// The rotation of a transformation matrix expressed as a quaternion.
    public var quaternion: simd_quatd = simd_quatd(vector: .zero)

    /// The shearing of a transformation matrix.
    public var skew: simd_double3 = .zero

    /// The perspective of a transformation matrix (e.g. .m34)
    public var perspective: simd_double4 = .zero

    /**
     Designated initializer.

     Note: You'll want to use matrix_double4x4.decomposed() instead.
     */
    internal init(scale: simd_double3, skew: simd_double3, rotation: simd_double3, quaternion: simd_quatd, translation: simd_double3, perspective: simd_double4) {
      self.scale = scale
      self.skew = skew
      self.rotation = rotation
      self.quaternion = quaternion
      self.translation = translation
      self.perspective = perspective
    }

    /**
     Designated initializer.

     Note: You'll want to use matrix_double4x4.decomposed() instead.
     */
    internal init(_ matrix: matrix_double4x4) {
      var local = matrix

      guard local[3][3] != 0.0 else { return }

      local = matrix_scale(1.0 / local.columns.3.w, local)

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

      self.skew.XY = dot(rotationLocal[0], rotationLocal[1])
      rotationLocal[1] = simd_linear_combination(1.0, rotationLocal[1], -skew.XY, rotationLocal[0])

      self.scale.y = simd_length(rotationLocal[1])
      rotationLocal[1] = normalize(rotationLocal[1])
      self.skew.XY /= scale.y

      self.skew.XZ = dot(rotationLocal[0], rotationLocal[2])
      rotationLocal[2] = simd_linear_combination(1.0, rotationLocal[2], -skew.XZ, rotationLocal[0])
      self.skew.YZ = dot(rotationLocal[1], rotationLocal[2])
      rotationLocal[2] = simd_linear_combination(1.0, rotationLocal[2], -skew.YZ, rotationLocal[1])

      self.scale.z = length(rotationLocal[2])
      rotationLocal[2] = normalize(rotationLocal[2])
      self.skew.XZ /= scale.z
      self.skew.YZ /= scale.z

      if simd_determinant(rotationLocal) < 0 {
        self.scale *= -1.0

        rotationLocal[0] *= -1.0
        rotationLocal[1] *= -1.0
        rotationLocal[2] *= -1.0
      }

      // get rotation
      self.rotation.y = asin(-rotationLocal[0][2])
      if cos(rotation.y) != 0.0 {
        self.rotation.x = atan2(rotationLocal[1][2], rotationLocal[2][2])
        self.rotation.z = atan2(rotationLocal[0][1], rotationLocal[0][0])
      } else {
        self.rotation.x = atan2(-rotationLocal[2][0], rotationLocal[1][1])
        self.rotation.z = 0.0
      }

      self.quaternion = simd_quatd(rotationLocal)
    }

    public func recomposed() -> matrix_double4x4 {
      var recomposed: matrix_double4x4 = .identity

      recomposed.applyPerspective(perspective)
      recomposed.translate(by: translation)
      recomposed.rotate(by: quaternion)
      recomposed.skew(by: skew)
      recomposed.scale(by: scale)

      return recomposed
    }

  }

}

// MARK: - Utils

internal func simd_linear_combination(_ ascl: Double, _ a: simd_double3, _ bscl: Double, _ b: simd_double3) -> simd_double3 {
  return simd_double3((ascl * a[0]) + (bscl * b[0]), (ascl * a[1]) + (bscl * b[1]), (ascl * a[2]) + (bscl * b[2]))
}
