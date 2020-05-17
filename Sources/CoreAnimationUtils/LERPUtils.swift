//
//  File.swift
//  
//
//  Created by Adam Bell on 5/17/20.
//

import simd
import QuartzCore

extension SIMD where Self.Scalar: FloatingPoint  {

  public func lerp(to: Self, percent: Self.Scalar) -> Self {
      return (self + ((to - self) * percent))
  }

}

extension simd_quatf {

  public func lerp(to: Self, percent: Float) -> Self {
    return (self + ((to - self) * percent))
  }

}

extension simd_quatd {

  public func lerp(to: Self, percent: Double) -> Self {
    return (self + ((to - self) * percent))
  }

}
