//
//  Interpolatable.swift
//  
//
//  Created by Adam Bell on 5/17/20.
//

import simd
import QuartzCore

/// A type that can be linearly interpolated.
public protocol Interpolatable {

  /// The type of the fraction that will be used to linearly interpolate `Self`.
  associatedtype FractionType: FloatingPoint

  /**
   Linearly interpolates `Self` to another instance of `Self` based on a given fraction.

   - Parameter to: The end value to interpolate to.
   - Parameter fraction: The fraction to interpolate between the two values (i.e. 0% is 0.0, 100% is 1.0).

   - Returns: An interpolated instance of `Self`.
   */
  func lerp(to: Self, fraction: FractionType) -> Self

}

/**
 - TODO: I would love to collapse these into a single generic for both `Double` and `Float` using `simd_mix` but I still haven't quite figured it out yet. PRs would be awesome!
 */

// MARK: - SIMD Extensions

extension SIMD2: Interpolatable where Scalar: FloatingPoint & SIMDScalar {

  // I would really like to use simd_mix here but for some reason it doesn't support SIMD2<Scalar> as an argument :(
  public func lerp(to: Self, fraction: Self.Scalar) -> Self {
    return self + ((to - self) * Self(repeating: fraction))
  }

}

extension SIMD3: Interpolatable where Scalar: FloatingPoint & SIMDScalar {

  public func lerp(to: Self, fraction: Self.Scalar) -> Self {
    return self + ((to - self) * Self(repeating: fraction))
  }

}

extension SIMD4: Interpolatable where Scalar: FloatingPoint & SIMDScalar {

  public func lerp(to: Self, fraction: Self.Scalar) -> Self {
    return self + ((to - self) * Self(repeating: fraction))
  }

}

extension simd_quatf: Interpolatable {

  public func lerp(to: Self, fraction: Float) -> simd_quatf {
    return simd_slerp(self, to, fraction)
  }

}

extension simd_quatd: Interpolatable {

  public func lerp(to: Self, fraction: Double) -> Self {
    return simd_slerp(self, to, fraction)
  }

}
