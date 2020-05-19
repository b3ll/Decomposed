//
//  File.swift
//  
//
//  Created by Adam Bell on 5/18/20.
//

import Foundation
import simd
import QuartzCore

public typealias SupportedVectorType = FloatingPoint & BinaryInteger

public struct Vector3<T: SupportedVectorType> {

  internal var storage: simd_double3

  var x: T {
    get { return T(storage.x) }
    set { storage.x = Double(newValue) }
  }

  var y: T {
    get { return T(storage.y) }
    set { storage.y = Double(newValue) }
  }

  var z: T {
    get { return T(storage.z) }
    set { storage.z = Double(newValue) }
  }

  public init(x: T = 0, y: T = 0, z: T = 0) {
    self.init(simd_double3(Double(x), Double(y), Double(z)))
  }

  public init(_ vector: simd_double3) {
    self.storage = vector
  }

}

public extension simd_double3 {

  init<T: SupportedVectorType>(_ vector: Vector3<T>) {
    self.init(Double(vector.x), Double(vector.y), Double(vector.z))
  }

}

public struct Vector4<T: SupportedVectorType> {

  internal var storage: simd_double4

  var x: T {
    get { return T(storage.x) }
    set { storage.x = Double(newValue) }
  }

  var y: T {
    get { return T(storage.y) }
    set { storage.y = Double(newValue) }
  }

  var z: T {
    get { return T(storage.z) }
    set { storage.z = Double(newValue) }
  }

  var w: T {
    get { return T(storage.w) }
    set { storage.w = Double(newValue) }
  }

  public init(x: T = 0, y: T = 0, z: T = 0, w: T = 0) {
    self.init(simd_double4(Double(x), Double(y), Double(z), Double(w)))
  }

  public init(_ vector: simd_double4) {
    self.storage = vector
  }

}

public extension simd_double4 {

  init<T: SupportedVectorType>(_ vector: Vector4<T>) {
    self.init(Double(vector.x), Double(vector.y), Double(vector.z), Double(vector.w))
  }

}

public struct Quaternion<T: SupportedVectorType> {

  internal var storage: simd_quatd

  var axis: Vector3<T> {
    get { return Vector3<T>(storage.axis) }
    set { self.storage = simd_quatd(angle: storage.angle, axis: simd_double3(newValue)) }
  }

  var angle: CGFloat {
    get { return CGFloat(storage.angle) }
    set { self.storage = simd_quatd(angle: Double(newValue), axis: storage.axis) }
  }

  public init(angle: CGFloat, axis: Vector3<T>) {
    self.storage = simd_quatd(angle: Double(angle), axis: simd_double3(axis))
  }

  public init(_ quaternion: simd_quatd) {
    self.storage = quaternion
  }

}

public extension simd_quatd {

  init<T: SupportedVectorType>(_ quaternion: Quaternion<T>) {
    self.init(angle: Double(quaternion.angle), axis: simd_double3(quaternion.axis))
  }

}

// MARK: - Interpolatable

extension Vector3: Interpolatable {

  public func lerp(to: Vector3<T>, fraction: T) -> Vector3<T> {
    return Vector3<T>(self.storage.lerp(to: to.storage, fraction: Double(fraction)))
  }

}

extension Vector4: Interpolatable {

  public func lerp(to: Vector4<T>, fraction: T) -> Vector4<T> {
    return Vector4<T>(self.storage.lerp(to: to.storage, fraction: Double(fraction)))
  }

}

extension Quaternion: Interpolatable {

  public func lerp(to: Quaternion<T>, fraction: T) -> Quaternion<T> {
    return Quaternion<T>(self.storage.lerp(to: to.storage, fraction: Double(fraction)))
  }

}
