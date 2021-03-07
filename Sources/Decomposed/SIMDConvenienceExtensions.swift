//
//  SIMDConvenienceExtensions.swift
//  
//
//  Created by Adam Bell on 5/19/20.
//

import simd

// Perspective

public extension SIMD4 {

  var m31: Scalar {
    get { return self[0] }
    set { self[0] = newValue }
  }

  var m32: Scalar {
    get { return self[0] }
    set { self[0] = newValue }
  }

  var m33: Scalar {
    get { return self[0] }
    set { self[0] = newValue }
  }

  var m34: Scalar {
    get { return self[0] }
    set { self[0] = newValue }
  }

  init(m31: Scalar, m32: Scalar, m33: Scalar, m34: Scalar) {
    self.init(m31, m32, m33, m34)
  }

}

// Skew

extension SIMD3 {

  public var xy: Scalar {
    get { return self[0] }
    set { self[0] = newValue }
  }

  public var xz: Scalar {
    get { return self[1] }
    set { self[1] = newValue }
  }

  public var yz: Scalar {
    get { return self[2] }
    set { self[2] = newValue }
  }

  public init(xy: Scalar, xz: Scalar, yz: Scalar) {
    self.init(xy, xz, yz)
  }

}

// Double -> Float Conversion

public extension simd_float3 {

  init(_ vector: simd_double3) {
    self.init(Float(vector[0]), Float(vector[1]), Float(vector[2]))
  }

}

public extension simd_float4 {

  init(_ vector: simd_double4) {
    self.init(Float(vector[0]), Float(vector[1]), Float(vector[2]), Float(vector[3]))
  }

}

public extension simd_quatf {

  init(_ quat: simd_quatd) {
    self.init(vector: simd_float4(Float(quat.vector[0]), Float(quat.vector[1]), Float(quat.vector[2]), Float(quat.vector[3])))
  }

  init(_ eulerAngles: simd_float3) {
    // From: https://en.wikipedia.org/wiki/Conversion_between_quaternions_and_Euler_angles
    let cz = cos(eulerAngles.z * 0.5)
    let sz = sin(eulerAngles.z * 0.5)
    let cy = cos(eulerAngles.y * 0.5)
    let sy = sin(eulerAngles.y * 0.5)
    let cx = cos(eulerAngles.x * 0.5)
    let sx = sin(eulerAngles.x * 0.5)

    self.init(vector: [
      sx * cy * cz - cx * sy * sz, // x
      cx * sy * cz + sx * cy * sz, // y
      cx * cy * sz - sx * sy * cz, // z
      cx * cy * cz + sx * sy * sz, // w
    ])
  }

}

public extension simd_double4x4 {

  init(_ matrix: simd_float4x4) {
    self.init(simd_double4(matrix[0]), simd_double4(matrix[1]), simd_double4(matrix[2]), simd_double4(matrix[3]))
  }

}

// Float -> Double Conversions

public extension simd_double3 {

  init(_ vector: simd_float3) {
    self.init(Double(vector[0]), Double(vector[1]), Double(vector[2]))
  }

}

public extension simd_double4 {

  init(_ vector: simd_float4) {
    self.init(Double(vector[0]), Double(vector[1]), Double(vector[2]), Double(vector[3]))
  }

}

public extension simd_quatd {

  init(_ quat: simd_quatf) {
    self.init(vector: simd_double4(Double(quat.vector[0]), Double(quat.vector[1]), Double(quat.vector[2]), Double(quat.vector[3])))
  }

  init(_ eulerAngles: simd_double3) {
    // From: https://en.wikipedia.org/wiki/Conversion_between_quaternions_and_Euler_angles
    let cz = cos(eulerAngles.z * 0.5)
    let sz = sin(eulerAngles.z * 0.5)
    let cy = cos(eulerAngles.y * 0.5)
    let sy = sin(eulerAngles.y * 0.5)
    let cx = cos(eulerAngles.x * 0.5)
    let sx = sin(eulerAngles.x * 0.5)

    self.init(vector: [
      sx * cy * cz - cx * sy * sz, // x
      cx * sy * cz + sx * cy * sz, // y
      cx * cy * sz - sx * sy * cz, // z
      cx * cy * cz + sx * sy * sz, // w
    ])
  }

}

public extension simd_float4x4 {

  init(_ matrix: simd_double4x4) {
    self.init(simd_float4(matrix[0]), simd_float4(matrix[1]), simd_float4(matrix[2]), simd_float4(matrix[3]))
  }

}

