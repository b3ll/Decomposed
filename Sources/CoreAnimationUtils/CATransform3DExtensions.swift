//
//  File.swift
//  
//
//  Created by Adam Bell on 5/16/20.
//

import simd
import QuartzCore

public extension CATransform3D {

  typealias Translation = Vector3
  typealias Scale = Vector3

  struct Perspective {

    internal var storage: Vector4

    public var m31: CGFloat {
      get { return CGFloat(self.storage.storage[0]) }
      set { self.storage.storage[0] = Double(newValue) }
    }

    public var m32: CGFloat {
      get { return CGFloat(self.storage.storage[1]) }
      set { self.storage.storage[1] = Double(newValue) }
    }

    public var m33: CGFloat {
      get { return CGFloat(self.storage.storage[2]) }
      set { self.storage.storage[2] = Double(newValue) }
    }

    public var m34: CGFloat {
      get { return CGFloat(self.storage.storage[3]) }
      set { self.storage.storage[3] = Double(newValue) }
    }

    public init(m31: CGFloat = 0.0, m32: CGFloat = 0.0, m33: CGFloat = 0.0, m34: CGFloat = 0.0) {
      self.storage = Vector4(x: m31, y: m32, z: m33, w: m34)
    }

    public init(_ vector: simd_double4) {
      self.storage = Vector4(vector)
    }

  }

  struct Skew {

    internal var storage: Decomposed.Skew

    public var XY: CGFloat {
      get { return CGFloat(storage.XY) }
      set { storage.XY = Double(newValue) }
    }

    public var XZ: CGFloat {
      get { return CGFloat(storage.XZ) }
      set { storage.XZ = Double(newValue) }
    }

    public var YZ: CGFloat {
      get { return CGFloat(storage.YZ) }
      set { storage.YZ = Double(newValue) }
    }

    public init(XY: CGFloat = 0.0, XZ: CGFloat = 0.0, YZ: CGFloat = 0.0) {
      self.storage = Decomposed.Skew(XY: Double(XY), XZ: Double(XZ), YZ: Double(YZ))
    }

    public init(_ skew: Decomposed.Skew) {
      self.storage = skew
    }

  }

  init(_ matrix: matrix_double4x4) {
    self = CATransform3DIdentity
    self.m11 = CGFloat(matrix[0][0])
    self.m12 = CGFloat(matrix[0][1])
    self.m13 = CGFloat(matrix[0][2])
    self.m14 = CGFloat(matrix[0][3])

    self.m21 = CGFloat(matrix[1][0])
    self.m22 = CGFloat(matrix[1][1])
    self.m23 = CGFloat(matrix[1][2])
    self.m24 = CGFloat(matrix[1][3])

    self.m31 = CGFloat(matrix[2][0])
    self.m32 = CGFloat(matrix[2][1])
    self.m33 = CGFloat(matrix[2][2])
    self.m34 = CGFloat(matrix[2][3])

    self.m41 = CGFloat(matrix[3][0])
    self.m42 = CGFloat(matrix[3][1])
    self.m43 = CGFloat(matrix[3][2])
    self.m44 = CGFloat(matrix[3][3])
  }

  internal var matrix: matrix_double4x4 {
    return matrix_double4x4(self)
  }

  var decomposed: Decomposed {
    return matrix_double4x4(self).decomposed
  }

  var perspective: Perspective {
    get {
      return Perspective(decomposed.perspective)
    }
    set {
      var decomposed = self.decomposed
      decomposed.perspective = newValue.storage.storage
      self = CATransform3D(decomposed.recomposed)
    }
  }

  func applyingPerspective(m31: CGFloat? = nil, m32: CGFloat? = nil, m33: CGFloat? = nil, m34: CGFloat? = nil) -> Self {
    let perspective = Perspective(m31: m31 ?? self.m31, m32: m32 ?? self.m32, m33: m33 ?? self.m33, m34: m34 ?? self.m34)
    return self.applyingPerspective(perspective)
  }

  func applyingPerspective(_ perspective: Perspective) -> Self {
    var transform = self
    transform.applyPerspective(perspective)
    return transform
  }

  mutating func applyPerspective(_ perspective: Perspective) {
    self = matrix.applyingPerspective(perspective.storage.storage).transform
  }

  var translation: Translation {
    get {
      return Translation(decomposed.translation)
    }
    set {
      var decomposed = self.decomposed
      decomposed.translation = newValue.storage
      self = CATransform3D(decomposed.recomposed)
    }
  }

  func translated(by translation: Translation) -> Self {
    var transform = self
    transform.translate(by: translation)
    return transform
  }

  func translatedBy(x: CGFloat = 0.0, y: CGFloat = 0.0, z: CGFloat = 0.0) -> Self {
    let translation = Translation(x: x, y: y, z: z)
    return self.translated(by: translation)
  }

  mutating func translate(by translation: Translation) {
    self = matrix.translated(by: translation.storage).transform
  }

  var rotation: Quaternion {
    get {
      return Quaternion(decomposed.quaternion)
    }
    set {
      var decomposed = self.decomposed
      decomposed.quaternion = newValue.storage
      self = CATransform3D(decomposed.recomposed)
    }
  }

  func rotated(by rotation: Quaternion) -> Self {
    var transform = self
    transform.rotate(by: rotation)
    return transform
  }

  func rotatedBy(angle: CGFloat, x: CGFloat = 0.0, y: CGFloat = 0.0, z: CGFloat = 0.0) -> Self {
    let rotation = Quaternion(angle: angle, axis: Vector3(x: x, y: y, z: z))
    return self.rotated(by: rotation)
  }

  mutating func rotate(by rotation: Quaternion) {
    self = matrix.rotated(by: rotation.storage).transform
  }

  var skew: Skew {
    get {
      return Skew(decomposed.skew)
    }
    set {
      var decomposed = self.decomposed
      decomposed.skew = newValue.storage
      self = CATransform3D(decomposed.recomposed)
    }
  }

  func skewed(by skew: Skew) -> Self {
    var transform = self
    transform.skew(by: skew)
    return transform
  }

  func skewedBy(XY: CGFloat = 0.0, XZ: CGFloat = 0.0, YZ: CGFloat = 0.0) -> Self {
    let skew = Skew(XY: XY, XZ: XZ, YZ: YZ)
    return self.skewed(by: skew)
  }

  mutating func skew(by skew: Skew) {
    self = matrix.skewed(by: skew.storage).transform
  }

  var scale: Scale {
    get {
      return Scale(decomposed.scale)
    }
    set {
      var decomposed = self.decomposed
      decomposed.scale = newValue.storage
      self = CATransform3D(decomposed.recomposed)
    }
  }

  func scaled(by scale: Scale) -> Self {
    var transform = self
    transform.scale(by: scale)
    return transform
  }

  func scaledBy(x: CGFloat = 1.0, y: CGFloat = 1.0, z: CGFloat = 1.0) -> Self {
    let scale = Scale(x: x, y: y, z: z)
    return self.scaled(by: scale)
  }

  mutating func scale(by scale: Scale) {
    self = matrix.scaled(by: scale.storage).transform
  }

}
