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

/// This class wraps the Swift interfaces for `CATransform3D.Decomposed` in a means that it can be used from Objective-C.
@objc public class CATransform3DDecomposed: NSObject {

  /// The translation of the transform.
  @objc public var translation: simd_double3 = .zero

  /// The scale of the transform.
  @objc public var scale: simd_double3 = .zero

  /// The rotation of the transform (expressed as a quaternion).
  @objc public var rotation: simd_quatd = simd_quatd(vector: .zero)

  /// The shearing of the transform.
  @objc public var skew: simd_double3 = .zero

  /// The perspective of the transform (e.g. .m34)
  @objc public var perspective: simd_double4 = .zero

  /// Default initializer.
  @objc public init(with transform: CATransform3D) {
    let decomposed = matrix_double4x4(transform).decomposed()

    self.translation = decomposed.translation
    self.scale = decomposed.scale
    self.rotation = decomposed.rotation
    self.skew = decomposed.skew
    self.perspective = decomposed.perspective
  }

  /// Class initializer.
  @objc public class func decomposeTransform(_ transform: CATransform3D) -> CATransform3DDecomposed {
    return CATransform3DDecomposed(with: transform)
  }

  /// Returns a recomposed `CATransform3D`.
  @objc public func recomposed() -> CATransform3D {
    var recomposed: matrix_double4x4 = .identity

    recomposed.applyPerspective(perspective)
    recomposed.translate(by: translation)
    recomposed.rotate(by: rotation)
    recomposed.skew(by: skew)
    recomposed.scale(by: scale)

    return CATransform3D(recomposed)
  }

}
