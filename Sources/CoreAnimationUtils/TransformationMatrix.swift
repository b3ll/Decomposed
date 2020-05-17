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

public struct Decomposed {
  public struct Skew {
    private var storage: simd_double3

    public var XY: Double {
      get {
        return storage[0]
      }
      set {
        storage[0] = newValue
      }
    }

    public var XZ: Double {
      get {
        return storage[1]
      }
      set {
        storage[1] = newValue
      }
    }

    public var YZ: Double {
      get {
        return storage[2]
      }
      set {
        storage[2] = newValue
      }
    }

    init(XY: Double, XZ: Double, YZ: Double) {
      self.storage = simd_double3(XY, XZ, YZ)
    }

    public static var zero: Skew {
      return Skew(XY: 0.0, XZ: 0.0, YZ: 0.0)
    }

    static func + (left: Self, right: Self) -> Self {
      var skew = left
      skew.storage += right.storage
      return skew
    }

    static func += (left: inout Self, right: Self) {
      left.storage += right.storage
    }
  }

  public var scale: simd_double3 = .zero
  public var skew: Skew = .zero
  public var rotation: simd_double3 = .zero
  public var quaternion: simd_quatd = simd_quatd(vector: .zero)
  public var translation: simd_double3 = .zero
  public var perspective: simd_double4 = .zero

  public var recomposed: matrix_double4x4 {
    var recomposed: matrix_double4x4 = .identity

    recomposed.applyPerspective(perspective)
    recomposed.translate(by: translation)
    recomposed.rotate(by: quaternion)
    recomposed.skew(by: skew)
    recomposed.scale(by: scale)

    return recomposed
  }

}

public extension matrix_double4x4 {

  static var identity: matrix_double4x4 {
    return matrix_identity_double4x4
  }

  static var zero: matrix_double4x4 {
    return matrix_double4x4()
  }

  init(_ transform: CATransform3D) {
    self.init(
      simd_double4(Double(transform.m11), Double(transform.m12), Double(transform.m13), Double(transform.m14)),
      simd_double4(Double(transform.m21), Double(transform.m22), Double(transform.m23), Double(transform.m24)),
      simd_double4(Double(transform.m31), Double(transform.m32), Double(transform.m33), Double(transform.m34)),
      simd_double4(Double(transform.m41), Double(transform.m42), Double(transform.m43), Double(transform.m44))
    )
  }

  var transform: CATransform3D {
    return CATransform3D(self)
  }

  var decomposed: Decomposed {
    var local = self
    var decomposed = Decomposed()

    guard local[3][3] != 0.0 else { return decomposed }

    local = matrix_scale(1.0 / local.columns.3.w, local)

    var perspective = local
    perspective[0][3] = 0.0
    perspective[1][3] = 0.0
    perspective[2][3] = 0.0
    perspective[3][3] = 1.0

    // solve for perspective
    guard simd_determinant(perspective) != 0.0 else { return decomposed }

    if (local[0][3] != 0.0) || (local[1][3] != 0.0) || (local[2][3] != 0.0) {
      let rhs = simd_double4(local[0][3], local[1][3], local[2][3], local[3][3])
      let transposedPerspective = perspective.inverse.transpose
      decomposed.perspective = matrix_multiply(transposedPerspective, rhs)

      local[0][3] = 0.0
      local[1][3] = 0.0
      local[2][3] = 0.0
      local[3][3] = 1.0
    } else {
      decomposed.perspective.w = 1.0
    }

    // get translation
    decomposed.translation = simd_double3(local[3][0], local[3][1], local[3][2])
    local[3][0] = 0.0
    local[3][1] = 0.0
    local[3][2] = 0.0

    // get scale and shear
    var rotationLocal = matrix_double3x3(
      simd_double3(local[0][0], local[0][1], local[0][2]),
      simd_double3(local[1][0], local[1][1], local[1][2]),
      simd_double3(local[2][0], local[2][1], local[2][2])
    )

    decomposed.scale.x = length(rotationLocal[0])
    rotationLocal[0] = normalize(rotationLocal[0])

    decomposed.skew.XY = dot(rotationLocal[0], rotationLocal[1])
    rotationLocal[1] = simd_linear_combination(1.0, rotationLocal[1], -decomposed.skew.XY, rotationLocal[0])

    decomposed.scale.y = simd_length(rotationLocal[1])
    rotationLocal[1] = normalize(rotationLocal[1])
    decomposed.skew.XY /= decomposed.scale.y

    decomposed.skew.XZ = dot(rotationLocal[0], rotationLocal[2])
    rotationLocal[2] = simd_linear_combination(1.0, rotationLocal[2], -decomposed.skew.XZ, rotationLocal[0])
    decomposed.skew.YZ = dot(rotationLocal[1], rotationLocal[2])
    rotationLocal[2] = simd_linear_combination(1.0, rotationLocal[2], -decomposed.skew.YZ, rotationLocal[1])

    decomposed.scale.z = length(rotationLocal[2])
    rotationLocal[2] = normalize(rotationLocal[2])
    decomposed.skew.XZ /= decomposed.scale.z
    decomposed.skew.YZ /= decomposed.scale.z

    if simd_determinant(rotationLocal) < 0 {
      decomposed.scale *= -1.0

      rotationLocal[0] *= -1.0
      rotationLocal[1] *= -1.0
      rotationLocal[2] *= -1.0
    }

    // get rotation
    decomposed.rotation.y = asin(-rotationLocal[0][2])
    if cos(decomposed.rotation.y) != 0.0 {
      decomposed.rotation.x = atan2(rotationLocal[1][2], rotationLocal[2][2])
      decomposed.rotation.z = atan2(rotationLocal[0][1], rotationLocal[0][0])
    } else {
      decomposed.rotation.x = atan2(-rotationLocal[2][0], rotationLocal[1][1])
      decomposed.rotation.z = 0.0
    }

    decomposed.quaternion = simd_quatd(rotationLocal)

    return decomposed
  }

  var perspective: simd_double4 {
    get {
      return decomposed.perspective
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
      return decomposed.translation
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
      return decomposed.quaternion
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

  var skew: Decomposed.Skew {
    get {
      return decomposed.skew
    }
    set {
      self.skew(by: newValue)
    }
  }

  func skewed(by skew: Decomposed.Skew) -> Self {
    var matrix = self
    matrix.skew(by: skew)
    return matrix
  }

  mutating func skew(by s: Decomposed.Skew) {
    if s.YZ != 0.0 {
      var skewMatrix: matrix_double4x4 = .zero
      skewMatrix[2][1] = s.YZ
      self = matrix_multiply(self, skewMatrix)
    }

    if s.XZ != 0.0 {
      var skewMatrix: matrix_double4x4 = .zero
      skewMatrix[2][0] = s.XZ
      self = matrix_multiply(self, skewMatrix)
    }

    if s.XY != 0.0 {
      var skewMatrix: matrix_double4x4 = .zero
      skewMatrix[1][0] = s.XY
      self = matrix_multiply(self, skewMatrix)
    }
  }

  var scale: simd_double3 {
    get {
      return decomposed.scale
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

// MARK: - Utils

fileprivate func simd_linear_combination(_ ascl: Double, _ a: simd_double3, _ bscl: Double, _ b: simd_double3) -> simd_double3 {
  return simd_double3((ascl * a[0]) + (bscl * b[0]), (ascl * a[1]) + (bscl * b[1]), (ascl * a[2]) + (bscl * b[2]))
}
