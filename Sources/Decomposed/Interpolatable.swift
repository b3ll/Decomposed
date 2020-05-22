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

// MARK: - SIMD Extensions

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
    return simd_slerp(self, to, fraction)
  }

}
