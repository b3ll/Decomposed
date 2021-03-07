//
//  CATransform3DExtensions.swift
//  
//
//  Created by Adam Bell on 5/16/20.
//

import simd
import QuartzCore

public extension CATransform3D {

  /// Returns the identity matrix of `CATransform3D`
  static var identity: CATransform3D {
    return CATransform3DIdentity
  }

  /// Returns the a `CATransform3D` initialized with all zeros.
  static var zero: CATransform3D {
    return CATransform3D(matrix_double4x4.zero)
  }

  /// Intializes a `CATransform3D` with a `matrix_double4x4`.
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

  init(_ matrix: matrix_float4x4) {
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

  /// Returns a `matrix_double4x4` from the contents of this transform.
  internal var matrix: matrix_double4x4 {
    return matrix_double4x4(self)
  }

  /// Returns a `matrix_double4x4.DecomposedTransform` from the contents of this transform.
  internal func _decomposed() -> matrix_double4x4.DecomposedTransform {
    return matrix.decomposed()
  }

  func decomposed() -> DecomposedTransform {
    return DecomposedTransform(_decomposed())
  }

  /// The translation of the transform.
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

  /// Returns a copy by translating the current transform by the given translation amount.
  func translated(by translation: Translation) -> Self {
    var transform = self
    transform.translate(by: translation)
    return transform
  }

  /**
   Returns a copy by translating the current transform by the given translation components.

   - Note: Omitted components have no effect on the translation.
   */
  func translatedBy(x: CGFloat = 0.0, y: CGFloat = 0.0, z: CGFloat = 0.0) -> Self {
    let translation = Translation(x, y, z)
    return self.translated(by: translation)
  }

    /**
     Returns a copy by translating the current transform by the given translation components.

     - Note: Omitted components have no effect on the translation.
     */
    func translated(by translation: CGPoint) -> Self {
        let translation = Translation(translation.x, translation.y, 0.0)
      return self.translated(by: translation)
    }

  /// Translates the current transform by the given translation amount.
  mutating func translate(by translation: Translation) {
    self = CATransform3D(matrix.translated(by: translation.storage))
  }

    /// Translates the current transform by the given translation amount.
    mutating func translate(by translation: CGPoint) {
        let translation = Translation(translation.x, translation.y, 0.0)
        translate(by: translation)
    }

  /// The scale of the transform.
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

  /// Returns a copy by scaling the current transform by the given scale.
  func scaled(by scale: Scale) -> Self {
    var transform = self
    transform.scale(by: scale)
    return transform
  }

    /// Returns a copy by scaling the current transform by the given scale.
    func scaled(by scale: CGPoint) -> Self {
        return self.scaled(by: Scale(scale.x, scale.y, 0.0))
    }

  /**
   Returns a copy by scaling the current transform by the given scale.

   - Note: Omitted components have no effect on the scale.
   */
  func scaledBy(x: CGFloat = 1.0, y: CGFloat = 1.0, z: CGFloat = 1.0) -> Self {
    let scale = Scale(x, y, z)
    return self.scaled(by: scale)
  }

  /// Scales the current transform by the given scale.
  mutating func scale(by scale: Scale) {
    self = CATransform3D(matrix.scaled(by: scale.storage))
  }

    /// Scales the current transform by the given scale.
    mutating func scale(by scale: CGPoint) {
        let scale = Scale(scale.x, scale.y, 0.0)
        self.scale(by: scale)
    }

  /// The rotation of the transform (expressed as a quaternion).
  var rotation: CGQuaternion {
    get {
      return CGQuaternion(_decomposed().rotation)
    }
    set {
      var decomposed = _decomposed()
      decomposed.rotation = newValue.storage
      self = CATransform3D(decomposed.recomposed())
    }
  }

  /// Returns a copy by applying a rotation transform (expressed as a quaternion) to the current transform.
  func rotated(by rotation: CGQuaternion) -> Self {
    var transform = self
    transform.rotate(by: rotation)
    return transform
  }

  /** Returns a copy by applying a rotation transform (expressed as a quaternion) to the current transform.

   - Note: Omitted components have no effect on the rotation.
   */
  func rotatedBy(angle: CGFloat = 0.0, x: CGFloat = 0.0, y: CGFloat = 0.0, z: CGFloat = 0.0) -> Self {
    let rotation = CGQuaternion(angle: angle, axis: CGVector3(x, y, z))
    return self.rotated(by: rotation)
  }

  /// Rotates the current rotation by applying a rotation transform (expressed as a quaternion) to the current transform.
  mutating func rotate(by rotation: CGQuaternion) {
    self = CATransform3D(matrix.rotated(by: rotation.storage))
  }

  /// The rotation of the transform, expressed in radians.
  var eulerAngles: CGVector3 {
    get {
      return CGVector3(_decomposed().eulerAngles)
    }
    set {
      var decomposed = _decomposed()
      decomposed.eulerAngles = newValue.storage
      self = CATransform3D(decomposed.recomposed())
    }
  }

  /// Returns a copy by applying a rotation transform (expressed as euler angles, expressed in radians) to the current transform.
  func rotated(by eulerAngles: CGVector3) -> Self {
    var transform = self
    transform.rotate(by: eulerAngles)
    return transform
  }

  /** Returns a copy by applying a rotation transform (expressed as euler angles, expressed in radians) to the current transform.

   - Note: Omitted components have no effect on the rotation.
   */
  func rotatedBy(x: CGFloat = 0.0, y: CGFloat = 0.0, z: CGFloat = 0.0) -> Self {
    let rotation = CGVector3(x, y, z)
    return self.rotated(by: rotation)
  }

  /// Rotates the current rotation by applying a rotation transform (expressed as euler angles, expressed in radians) to the current transform.
  mutating func rotate(by eulerAngles: CGVector3) {
    self = CATransform3D(matrix.rotated(by: eulerAngles.storage))
  }

  /// The skew of the transform.
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

  /// Returns a copy by skewing the current transform by a given skew.
  func skewed(by skew: Skew) -> Self {
    var transform = self
    transform.skew(by: skew)
    return transform
  }

  /**
   Returns a copy by skewing the current transform by the given skew components.

   - Note: Omitted components have no effect on the skew.
   */
  func skewedBy(xy: CGFloat? = nil, xz: CGFloat? = nil, yz: CGFloat? = nil) -> Self {
    let skew = Skew(xy ?? self.skew.xy, xz ?? self.skew.xz, yz ?? self.skew.yz)
    return self.skewed(by: skew)
  }

  mutating func skew(by skew: Skew) {
    self = CATransform3D(matrix.skewed(by: skew.storage))
  }

  /// The perspective of the transform.
  var perspective: Perspective {
    get {
      return Perspective(_decomposed().perspective)
    }
    set {
      var decomposed = _decomposed()
      decomposed.perspective = newValue.storage
      self = CATransform3D(decomposed.recomposed())
    }
  }

  /// Returns a copy by changing the perspective of the current transform.
  func applyingPerspective(_ perspective: Perspective) -> Self {
    var transform = self
    transform.applyPerspective(perspective)
    return transform
  }

  /**
   Returns a copy by changing the perspective of the current transform.

   - Note: Omitted components have no effect on the perspective.
   */
  func applyingPerspective(m14: CGFloat? = nil, m24: CGFloat? = nil, m34: CGFloat? = nil, m44: CGFloat? = nil) -> Self {
    let perspective = Perspective(m14: m14 ?? self.m14, m24: m24 ?? self.m24, m34: m34 ?? self.m34, m44: m44 ?? self.m44)
    return self.applyingPerspective(perspective)
  }

  /// Sets the perspective of the current transform.
  mutating func applyPerspective(_ perspective: Perspective) {
    self = CATransform3D(matrix.applyingPerspective(perspective.storage))
  }

}

// MARK: - DecomposedTransform

public extension CATransform3D {

  /// Represents a decomposed CATransform3D in which the transform is broken down into its transform attributes (scale, translation, etc.).
  struct DecomposedTransform {

    // This is just a simple wrapper overtop `matrix_double4x4.DecomposedTransform`.
    internal var storage: matrix_double4x4.DecomposedTransform

    /// The translation of the transform.
    public var translation: Translation {
      get {
        return CGVector3(storage.translation)
      }
      set {
        storage.translation = newValue.storage
      }
    }

    /// The scale of the transform.
    public var scale: Translation {
      get {
        return CGVector3(storage.scale)
      }
      set {
        storage.scale = newValue.storage
      }
    }

    /// The rotation of the transform (exposed as a quaternion).
    public var rotation: CGQuaternion {
      get {
        return CGQuaternion(storage.rotation)
      }
      set {
        storage.rotation = newValue.storage
      }
    }

    /// The skew of the transform.
    public var skew: Skew {
      get {
        return Skew(storage.skew)
      }
      set {
        storage.skew = newValue.storage
      }
    }

    /// The perspective of the transform.
    public var perspective: Perspective {
      get {
        return Perspective(storage.perspective)
      }
      set {
        storage.perspective = newValue.storage
      }
    }

    /**
      Designated initializer.

      - Note: You'll probably want to use `CATransform3D.decomposed()` instead.
      */
    public init(_ decomposed: matrix_double4x4.DecomposedTransform) {
      self.storage = decomposed
    }

    /// Merges all the properties of the the decomposed transform into a `CATransform3D`.
    public func recomposed() -> CATransform3D {
      return CATransform3D(storage.recomposed())
    }

  }

}

// MARK: - CATransform3D Extensions

extension CATransform3D.DecomposedTransform: Interpolatable {

  public func lerp(to: Self, fraction: Double) -> Self {
    return CATransform3D.DecomposedTransform(self.storage.lerp(to: to.storage, fraction: Double(fraction)))
  }

}

extension CATransform3D: Interpolatable {

  public func lerp(to: Self, fraction: CGFloat) -> Self {
    return CATransform3D(self._decomposed().lerp(to: to._decomposed(), fraction: Double(fraction)).recomposed())
  }

}
