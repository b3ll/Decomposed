//
//  LERPExtension.swift
//  
//
//  Created by Adam Bell on 5/17/20.
//

import simd
import QuartzCore

public protocol Interpolatable {

  associatedtype FractionType: FloatingPoint

  func lerp(to: Self, fraction: FractionType) -> Self

}

extension SIMD2: Interpolatable where Scalar: FloatingPoint {

  public func lerp(to: Self, fraction: Self.Scalar) -> Self {
    return (self + ((to - self) * fraction))
  }

}

extension SIMD3: Interpolatable where Scalar: FloatingPoint {

  public func lerp(to: Self, fraction: Self.Scalar) -> Self {
    return (self + ((to - self) * fraction))
  }

}

extension SIMD4: Interpolatable where Scalar: FloatingPoint {

  public func lerp(to: Self, fraction: Self.Scalar) -> Self {
    return (self + ((to - self) * fraction))
  }

}

extension simd_quatf: Interpolatable {

  public func lerp(to: Self, fraction: Float) -> simd_quatf {
    return (self + ((to - self) * fraction))
  }

}

extension simd_quatd: Interpolatable {

  public func lerp(to: Self, fraction: Double) -> Self {
    return (self + ((to - self) * fraction))
  }

}

extension matrix_double4x4.Skew: Interpolatable {

  public func lerp(to: Self, fraction: Double) -> Self {
    var copy = self
    copy.storage = copy.storage.lerp(to: to.storage, fraction: fraction)
    return copy
  }

}

extension matrix_double4x4.Decomposed: Interpolatable {

  public func lerp(to: Self, fraction: Double) -> Self {
    return matrix_double4x4.Decomposed(scale: scale.lerp(to: to.scale, fraction: fraction),
                      skew: skew.lerp(to: to.skew, fraction: fraction),
                      rotation: rotation.lerp(to: to.rotation, fraction: fraction),
                      quaternion: quaternion.lerp(to: to.quaternion, fraction: fraction),
                      translation: translation.lerp(to: to.translation, fraction: fraction),
                      perspective: perspective.lerp(to: to.perspective, fraction: fraction))
  }

}

extension matrix_double4x4: Interpolatable {

  public func lerp(to: Self, fraction: Double) -> Self {
    return self.decomposed().lerp(to: to.decomposed(), fraction: Double(fraction)).recomposed()
  }

}

extension CATransform3D.Decomposed: Interpolatable {

  public func lerp(to: Self, fraction: Double) -> Self {
    return CATransform3D.Decomposed(self.storage.lerp(to: to.storage, fraction: Double(fraction)))
  }

}

extension CATransform3D: Interpolatable {

  public func lerp(to: Self, fraction: CGFloat) -> Self {
    return CATransform3D(self._decomposed().lerp(to: to._decomposed(), fraction: Double(fraction)).recomposed())
  }

}
