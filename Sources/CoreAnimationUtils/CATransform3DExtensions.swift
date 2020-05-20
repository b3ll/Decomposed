//
//  File.swift
//  
//
//  Created by Adam Bell on 5/16/20.
//

import simd
import QuartzCore

public extension CATransform3D {

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

  internal func _decomposed() -> matrix_double4x4.Decomposed {
    return matrix_double4x4(self).decomposed()
  }

  func decomposed() -> Decomposed {
    return Decomposed(_decomposed())
  }

  var perspective: Perspective {
    get {
      return Perspective(_decomposed().perspective)
    }
    set {
      var decomposed = _decomposed()
      decomposed.perspective = newValue.storage
      self = CATransform3D(_decomposed().recomposed())
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
    self = CATransform3D(matrix.applyingPerspective(perspective.storage))
  }

  var translation: Translation {
    get {
      return Translation(_decomposed().translation)
    }
    set {
      var decomposed = _decomposed()
      decomposed.translation = newValue.storage
      self = CATransform3D(decomposed.recomposed())
    }
  }

  func translated(by translation: Translation) -> Self {
    var transform = self
    transform.translate(by: translation)
    return transform
  }

  func translatedBy(x: CGFloat = 0.0, y: CGFloat = 0.0, z: CGFloat = 0.0) -> Self {
    let translation = Translation(x, y, z)
    return self.translated(by: translation)
  }

  mutating func translate(by translation: Translation) {
    self = CATransform3D(matrix.translated(by: translation.storage))
  }

  var rotation: Quaternion {
    get {
      return Quaternion(_decomposed().quaternion)
    }
    set {
      var decomposed = _decomposed()
      decomposed.quaternion = newValue.storage
      self = CATransform3D(decomposed.recomposed())
    }
  }

  func rotated(by rotation: Quaternion) -> Self {
    var transform = self
    transform.rotate(by: rotation)
    return transform
  }

  func rotatedBy(angle: CGFloat, x: CGFloat = 0.0, y: CGFloat = 0.0, z: CGFloat = 0.0) -> Self {
    let rotation = Quaternion(angle: angle, axis: Vector3(x, y, z))
    return self.rotated(by: rotation)
  }

  mutating func rotate(by rotation: Quaternion) {
    self = CATransform3D(matrix.rotated(by: rotation.storage))
  }

  var skew: Skew {
    get {
      return Skew(_decomposed().skew)
    }
    set {
      var decomposed = _decomposed()
      decomposed.skew = newValue.storage
      self = CATransform3D(decomposed.recomposed())
    }
  }

  func skewed(by skew: Skew) -> Self {
    var transform = self
    transform.skew(by: skew)
    return transform
  }

  func skewedBy(XY: CGFloat = 0.0, XZ: CGFloat = 0.0, YZ: CGFloat = 0.0) -> Self {
    let skew = Skew(XY, XZ, YZ)
    return self.skewed(by: skew)
  }

  mutating func skew(by skew: Skew) {
    self = CATransform3D(matrix.skewed(by: skew.storage))
  }

  var scale: Scale {
    get {
      return Scale(_decomposed().scale)
    }
    set {
      var decomposed = _decomposed()
      decomposed.scale = newValue.storage
      self = CATransform3D(decomposed.recomposed())
    }
  }

  func scaled(by scale: Scale) -> Self {
    var transform = self
    transform.scale(by: scale)
    return transform
  }

  func scaledBy(x: CGFloat = 1.0, y: CGFloat = 1.0, z: CGFloat = 1.0) -> Self {
    let scale = Scale(x, y, z)
    return self.scaled(by: scale)
  }

  mutating func scale(by scale: Scale) {
    self = CATransform3D(matrix.scaled(by: scale.storage))
  }

}

public extension Vector4 {

  var m31: CGFloat {
    get { return CGFloat(self.storage[0]) }
    set { self.storage[0] = Double(newValue) }
  }

  var m32: CGFloat {
    get { return CGFloat(self.storage[1]) }
    set { self.storage[1] = Double(newValue) }
  }

  var m33: CGFloat {
    get { return CGFloat(self.storage[2]) }
    set { self.storage[2] = Double(newValue) }
  }

  var m34: CGFloat {
    get { return CGFloat(self.storage[3]) }
    set { self.storage[3] = Double(newValue) }
  }

  init(m31: CGFloat = 0.0, m32: CGFloat = 0.0, m33: CGFloat = 0.0, m34: CGFloat = 0.0) {
    self.init(x: m31, y: m32, z: m33, w: m34)
  }

}

public extension Vector3 {

  var XY: CGFloat {
    get { return CGFloat(self.storage[0]) }
    set { self.storage[0] = Double(newValue) }
  }

  var XZ: CGFloat {
    get { return CGFloat(self.storage[1]) }
    set { self.storage[1] = Double(newValue) }
  }

  var YZ: CGFloat {
    get { return CGFloat(self.storage[2]) }
    set { self.storage[2] = Double(newValue) }
  }

  init(XY: CGFloat = 0.0, XZ: CGFloat = 0.0, YZ: CGFloat = 0.0) {
    self.init(XY, XZ, YZ)
  }

}

public typealias Translation = Vector3
public typealias Scale = Vector3
public typealias Perspective = Vector4
public typealias Skew = Vector3

public extension CATransform3D {

  struct Decomposed {

    var translation: Translation {
      get {
        return Vector3(storage.translation)
      }
      set {
        storage.translation = newValue.storage
      }
    }

    var scale: Translation {
      get {
        return Vector3(storage.scale)
      }
      set {
        storage.scale = newValue.storage
      }
    }

    var rotation: Quaternion {
      get {
        return Quaternion(storage.quaternion)
      }
      set {
        storage.quaternion = newValue.storage
      }
    }

    var skew: Skew {
      get {
        return Skew(storage.skew)
      }
      set {
        storage.skew = newValue.storage
      }
    }

    var perspective: Perspective {
      get {
        return Perspective(storage.perspective)
      }
      set {
        storage.perspective = newValue.storage
      }
    }

    internal var storage: matrix_double4x4.Decomposed

    init(_ decomposed: matrix_double4x4.Decomposed) {
      self.storage = decomposed
    }

    func recomposed() -> CATransform3D {
      return CATransform3D(storage.recomposed())
    }

  }

}
