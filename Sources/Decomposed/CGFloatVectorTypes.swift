//
//  CGFloatVectorTypes.swift
//  
//
//  Created by Adam Bell on 5/18/20.
//

import Foundation
import simd
import QuartzCore

/**
 This whole file exists basically because SIMD doesn't support CGFloat and without this file, you'd be doing things like `transform.position.x = Double(value)` :(
 So everything here just bridges CGFloats to Doubles and uses their simd equivalents.
 Technically CGFloat can be Float or Double (32bit or 64bit) but everything is 64bit nowadays so, if it's really necessary it can be added later.
 */

public struct CGVector3 {

  internal var storage: simd_double3

  public var x: CGFloat {
    get { return CGFloat(storage.x) }
    set { storage.x = Double(newValue) }
  }

  public var y: CGFloat {
    get { return CGFloat(storage.y) }
    set { storage.y = Double(newValue) }
  }

  public var z: CGFloat {
    get { return CGFloat(storage.z) }
    set { storage.z = Double(newValue) }
  }

  public init(x: CGFloat = 0.0, y: CGFloat = 0.0, z: CGFloat = 0.0) {
    self.init(simd_double3(Double(x), Double(y), Double(z)))
  }

  public init(x: Double = 0.0, y: Double = 0.0, z: Double = 0.0) {
    self.init(simd_double3(x, y, z))
  }

  public init(x: Float = 0.0, y: CGFloat = 0.0, z: CGFloat = 0.0) {
    self.init(simd_double3(Double(x), Double(y), Double(z)))
  }

  public init(_ vector: simd_double3) {
    self.storage = vector
  }

  public init(_ vector: simd_float3) {
    self.init(simd_double3(vector))
  }

}

// MARK: - ExpressibleByArrayLiteral

extension CGVector3: ExpressibleByArrayLiteral {

  public init(arrayLiteral elements: CGFloat...) {
    self.init(x: elements[0], y: elements[1], z: elements[2])
  }

  public init(_ x: CGFloat, _ y: CGFloat, _ z: CGFloat) {
    self.init(x: x, y: y, z: z)
  }

}

public extension simd_double3 {

  init(_ vector: CGVector3) {
    self.init(Double(vector.x), Double(vector.y), Double(vector.z))
  }

}

public extension simd_float3 {

  init(_ vector: CGVector3) {
    self.init(Float(vector.x), Float(vector.y), Float(vector.z))
  }

}

public struct CGVector4 {

  internal var storage: simd_double4

  var x: CGFloat {
    get { return CGFloat(storage.x) }
    set { storage.x = Double(newValue) }
  }

  var y: CGFloat {
    get { return CGFloat(storage.y) }
    set { storage.y = Double(newValue) }
  }

  var z: CGFloat {
    get { return CGFloat(storage.z) }
    set { storage.z = Double(newValue) }
  }

  var w: CGFloat {
    get { return CGFloat(storage.w) }
    set { storage.w = Double(newValue) }
  }

  public init(x: CGFloat = 0.0, y: CGFloat = 0.0, z: CGFloat = 0.0, w: CGFloat = 0.0) {
    self.init(simd_double4(Double(x), Double(y), Double(z), Double(w)))
  }

  public init(x: Double = 0.0, y: Double = 0.0, z: Double = 0.0, w: Double = 0.0) {
    self.init(simd_double4(x, y, z, w))
  }

  public init(x: Float = 0.0, y: Float = 0.0, z: Float = 0.0, w: Float = 0.0) {
    self.init(simd_double4(Double(x), Double(y), Double(z), Double(w)))
  }

  public init(_ vector: simd_double4) {
    self.storage = vector
  }

  public init(_ vector: simd_float4) {
    self.init(simd_double4(vector))
  }

}

// MARK: - ExpressibleByArrayLiteral

extension CGVector4: ExpressibleByArrayLiteral {

  public init(arrayLiteral elements: CGFloat...) {
    self.init(x: elements[0], y: elements[1], z: elements[2], w: elements[3])
  }

  public init(_ x: CGFloat, _ y: CGFloat, _ z: CGFloat, _ w: CGFloat) {
    self.init(x: x, y: y, z: z, w: w)
  }

}

public extension simd_double4 {

  init(_ vector: CGVector4) {
    self.init(Double(vector.x), Double(vector.y), Double(vector.z), Double(vector.w))
  }

}

public extension simd_float4 {

  init(_ vector: CGVector4) {
    self.init(Float(vector.x), Float(vector.y), Float(vector.z), Float(vector.w))
  }

}

public struct CGQuaternion {

  internal var storage: simd_quatd

  public var axis: CGVector3 {
    get { return CGVector3(storage.axis) }
    set { self.storage = simd_quatd(angle: storage.angle, axis: normalize(simd_double3(newValue))) }
  }

  public var angle: CGFloat {
    get { return CGFloat(storage.angle) }
    set { self.storage = simd_quatd(angle: Double(newValue), axis: storage.axis) }
  }

  /**
   Default initializer.

   - Parameter angle: The angle of rotation (specified in radians).
   - Parameter axis: The axis of rotation (this will be normalized automatically)
   */
  public init(angle: CGFloat, axis: CGVector3) {
    self.storage = simd_quatd(angle: Double(angle), axis: normalize(simd_double3(axis)))
  }

  public init(_ quaternion: simd_quatd) {
    self.storage = quaternion
  }

}

public extension simd_quatd {

  init(_ quaternion: CGQuaternion) {
    self.init(angle: Double(quaternion.angle), axis: simd_double3(quaternion.axis))
  }

}

public extension simd_quatf {

  init(_ quaternion: CGQuaternion) {
    self.init(angle: Float(quaternion.angle), axis: simd_float3(quaternion.axis))
  }

}

// MARK: - Interpolatable

extension CGVector3: Interpolatable {

  public func lerp(to: CGVector3, fraction: CGFloat) -> CGVector3 {
    return CGVector3(self.storage.lerp(to: to.storage, fraction: Double(fraction)))
  }

}

extension CGVector4: Interpolatable {

  public func lerp(to: CGVector4, fraction: CGFloat) -> CGVector4 {
    return CGVector4(self.storage.lerp(to: to.storage, fraction: Double(fraction)))
  }

}

extension CGQuaternion: Interpolatable {

  public func lerp(to: CGQuaternion, fraction: CGFloat) -> CGQuaternion {
    return CGQuaternion(self.storage.lerp(to: to.storage, fraction: Double(fraction)))
  }

}

// MARK: - Equatable

fileprivate let accuracy: Double = 0.0001

extension CGVector3: Equatable {

  public static func == (lhs: Self, rhs: Self) -> Bool {
    return abs(rhs.storage[0] - lhs.storage[0]) < accuracy &&
    abs(rhs.storage[1] - lhs.storage[1]) < accuracy &&
    abs(rhs.storage[2] - lhs.storage[2]) < accuracy
  }

}

extension CGVector4: Equatable {

  public static func == (lhs: Self, rhs: Self) -> Bool {
    return abs(rhs.storage[0] - lhs.storage[0]) < accuracy &&
    abs(rhs.storage[1] - lhs.storage[1]) < accuracy &&
    abs(rhs.storage[2] - lhs.storage[2]) < accuracy &&
    abs(rhs.storage[3] - lhs.storage[3]) < accuracy
  }

}

extension CGQuaternion: Equatable {

  public static func == (lhs: Self, rhs: Self) -> Bool {
    return lhs.axis == rhs.axis &&
      abs(rhs.storage.angle - lhs.storage.angle) < accuracy
  }

}
