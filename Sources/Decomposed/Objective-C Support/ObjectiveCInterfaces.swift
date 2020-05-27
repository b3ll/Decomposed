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
@objcMembers public class CATransform3DDecomposed: NSObject {

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
  public init(with transform: CATransform3D) {
    self.decomposed = matrix_double4x4(transform).decomposed()
  }

  /// Class initializer.
  public class func decomposedTransform(_ transform: CATransform3D) -> CATransform3DDecomposed {
    return CATransform3DDecomposed(with: transform)
  }

  /// Returns a recomposed `CATransform3D`.
  public func recomposed() -> CATransform3D {
    return CATransform3D(decomposed.recomposed())
  }

}

/// This class wraps the Swift interface for `matrix_double4x4.DecomposedTransform` in a means that it can be used from Objective-C.
@objcMembers public class matrix_double4x4Decomposed: NSObject {

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
  public init(with matrix: matrix_double4x4) {
    self.decomposed = matrix.decomposed()
  }

  /// Class initializer.
  public class func decomposedTransform(_ matrix: matrix_double4x4) -> matrix_double4x4Decomposed {
    return matrix_double4x4Decomposed(with: matrix)
  }

  /// Returns a recomposed `CATransform3D`.
  public func recomposed() -> matrix_double4x4 {
    return decomposed.recomposed()
  }

}

/// This class wraps the Swift interface for `matrix_float4x4.DecomposedTransform` in a means that it can be used from Objective-C.
@objcMembers public class matrix_float4x4Decomposed: NSObject {

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
  public init(with matrix: matrix_float4x4) {
    self.decomposed = matrix.decomposed()
  }

  /// Class initializer.
  public class func decomposedTransform(_ matrix: matrix_float4x4) -> matrix_float4x4Decomposed {
    return matrix_float4x4Decomposed(with: matrix)
  }

  /// Returns a recomposed `CATransform3D`.
  public func recomposed() -> matrix_float4x4 {
    return decomposed.recomposed()
  }

}
