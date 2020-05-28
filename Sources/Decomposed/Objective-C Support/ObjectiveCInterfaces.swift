//
//  ObjectiveC.swift
//  
//
//  Created by Adam Bell on 5/26/20.
//

import Accelerate
import simd
import Foundation
import QuartzCore

/// This class wraps the Swift interface for `CATransform3D.DecomposedTransform` in a means that it can be used from Objective-C.
@objcMembers public class DEDecomposedCATransform3D: NSObject {

  /// The translation of the transform.
  public var translation: simd_double3 {
    get { return decomposed.translation }
    set { decomposed.translation = newValue }
  }

  /// The scale of the transform.
  public var scale: simd_double3 {
    get { return decomposed.scale }
    set { decomposed.scale = newValue }
  }

  /// The rotation of the transform (expressed as a quaternion).
  public var rotation: simd_quatd {
    get { return decomposed.rotation }
    set { decomposed.rotation = newValue }
  }

  /// The rotation of the transform (expressed as euler angles, expressed in radians).
  public var eulerAngles: simd_double3 {
    get { return decomposed.eulerAngles }
    set { decomposed.eulerAngles = newValue }
  }

  /// The shearing of the transform.
  public var skew: simd_double3 {
    get { return decomposed.skew }
    set { decomposed.skew = newValue }
  }

  /// The perspective of the transform (e.g. .m34).
  public var perspective: simd_double4{
    get { return decomposed.perspective }
    set { decomposed.perspective = newValue }
  }

  @nonobjc private var decomposed: matrix_double4x4.DecomposedTransform

  /// Default initializer.
  @objc(initWithTransform:)
  public init(_ transform: CATransform3D) {
    self.decomposed = matrix_double4x4(transform).decomposed()
  }

  /// Class initializer.
  public class func decomposedTransformWith(transform: CATransform3D) -> DEDecomposedCATransform3D {
    return DEDecomposedCATransform3D(transform)
  }

  /// Returns a recomposed `CATransform3D`.
  public func recomposed() -> CATransform3D {
    return CATransform3D(decomposed.recomposed())
  }

}

/// This class wraps the Swift interface for `matrix_double4x4.DecomposedTransform` in a means that it can be used from Objective-C.
@objcMembers public class DEDecomposedMatrixDouble4x4: NSObject {

  /// The translation of the transformation matrix.
  public var translation: simd_double3 {
    get { return decomposed.translation }
    set { decomposed.translation = newValue }
  }

  /// The scale of the transformation matrix.
  public var scale: simd_double3 {
    get { return decomposed.scale }
    set { decomposed.scale = newValue }
  }
  /// The rotation of the transformation matrix (expressed as a quaternion).
  public var rotation: simd_quatd {
    get { return decomposed.rotation }
    set { decomposed.rotation = newValue }
  }

  /// The rotation of the transformation matrix (expressed as euler angles, expressed in radians).
  public var eulerAngles: simd_double3 {
    get { return decomposed.eulerAngles }
    set { decomposed.eulerAngles = newValue }
  }

  /// The shearing of the transformation matrix.
  public var skew: simd_double3 {
    get { return decomposed.skew }
    set { decomposed.skew = newValue }
  }

  /// The perspective of the transformation matrix (e.g. .m34).
  public var perspective: simd_double4{
    get { return decomposed.perspective }
    set { decomposed.perspective = newValue }
  }

  @nonobjc private var decomposed: matrix_double4x4.DecomposedTransform

  /// Default initializer.
  @objc(initWithMatrixDouble4x4:)
  public init(_ matrix: matrix_double4x4) {
    self.decomposed = matrix.decomposed()
  }

  /// Class initializer.
  public class func decomposedMatrixWith(_ matrix: matrix_double4x4) -> DEDecomposedMatrixDouble4x4 {
    return DEDecomposedMatrixDouble4x4(matrix)
  }

  /// Returns a recomposed `CATransform3D`.
  public func recomposed() -> matrix_double4x4 {
    return decomposed.recomposed()
  }

}

/// This class wraps the Swift interface for `matrix_float4x4.DecomposedTransform` in a means that it can be used from Objective-C.
@objcMembers public class DEDecomposedMatrixFloat4x4: NSObject {

  /// The translation of the transformation matrix.
  public var translation: simd_float3 {
    get { return decomposed.translation }
    set { decomposed.translation = newValue }
  }

  /// The scale of the transformation matrix.
  public var scale: simd_float3 {
    get { return decomposed.scale }
    set { decomposed.scale = newValue }
  }

  /// The rotation of the transformation matrix (expressed as a quaternion).
  public var rotation: simd_quatf {
    get { return decomposed.rotation }
    set { decomposed.rotation = newValue }
  }

  /// The rotation of the transformation matrix (expressed as euler angles, expressed in radians).
  public var eulerAngles: simd_float3 {
    get { return decomposed.eulerAngles }
    set { decomposed.eulerAngles = newValue }
  }

  /// The shearing of the transformation matrix.
  public var skew: simd_float3 {
    get { return decomposed.skew }
    set { decomposed.skew = newValue }
  }

  /// The perspective of the transformation matrix (e.g. .m34).
  public var perspective: simd_float4{
    get { return decomposed.perspective }
    set { decomposed.perspective = newValue }
  }

  @nonobjc private var decomposed: matrix_float4x4.DecomposedTransform

  /// Default initializer.
  @objc(initWithMatrixFloat4x4:)
  public init(_ matrix: matrix_float4x4) {
    self.decomposed = matrix.decomposed()
  }

  /// Class initializer.
  public class func decomposedTransformWith(_ matrix: matrix_float4x4) -> DEDecomposedMatrixFloat4x4 {
    return DEDecomposedMatrixFloat4x4(matrix)
  }

  /// Returns a recomposed `CATransform3D`.
  public func recomposed() -> matrix_float4x4 {
    return decomposed.recomposed()
  }

}
