//
//  CGFloatVectorTypes.swift
//  
//
//  Created by Adam Bell on 5/18/20.
//

import Foundation
import simd
import QuartzCore

// This whole file exists basically because SIMD doesn't support CGFloat :(
// So everything here just bridges CGFloats to Doubles and uses their simd equivalents.
// Technically CGFloat can be Float or Double (32bit or 64bit) but everything is 64bit nowadays so, if it's really necessary it can be added later.

public struct Vector3 {

  internal var storage: simd_double3

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

  public init(x: CGFloat = 0, y: CGFloat = 0, z: CGFloat = 0) {
    self.init(simd_double3(Double(x), Double(y), Double(z)))
  }

  public init(_ vector: simd_double3) {
    self.storage = vector
  }

}

// MARK: - ExpressibleByArrayLiteral

extension Vector3: ExpressibleByArrayLiteral {

  public init(arrayLiteral elements: CGFloat...) {
    self.init(x: elements[0], y: elements[1], z: elements[2])
  }

  public init(_ x: CGFloat, _ y: CGFloat, _ z: CGFloat) {
    self.init(x: x, y: y, z: z)
  }

}

public extension simd_double3 {

  init(_ vector: Vector3) {
    self.init(Double(vector.x), Double(vector.y), Double(vector.z))
  }

}

public struct Vector4 {

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

  public init(x: CGFloat = 0, y: CGFloat = 0, z: CGFloat = 0, w: CGFloat = 0) {
    self.init(simd_double4(Double(x), Double(y), Double(z), Double(w)))
  }

  public init(_ vector: simd_double4) {
    self.storage = vector
  }

}

// MARK: - ExpressibleByArrayLiteral

extension Vector4: ExpressibleByArrayLiteral {

  public init(arrayLiteral elements: CGFloat...) {
    self.init(x: elements[0], y: elements[1], z: elements[2], w: elements[3])
  }

  public init(_ x: CGFloat, _ y: CGFloat, _ z: CGFloat, _ w: CGFloat) {
    self.init(x: x, y: y, z: z, w: w)
  }

}

public extension simd_double4 {

  init(_ vector: Vector4) {
    self.init(Double(vector.x), Double(vector.y), Double(vector.z), Double(vector.w))
  }

}

public struct Quaternion {

  internal var storage: simd_quatd

  var axis: Vector3 {
    get { return Vector3(storage.axis) }
    set { self.storage = simd_quatd(angle: storage.angle, axis: simd_double3(newValue)) }
  }

  var angle: CGFloat {
    get { return CGFloat(storage.angle) }
    set { self.storage = simd_quatd(angle: Double(newValue), axis: storage.axis) }
  }

  public init(angle: CGFloat, axis: Vector3) {
    self.storage = simd_quatd(angle: Double(angle), axis: simd_double3(axis))
  }

  public init(_ quaternion: simd_quatd) {
    self.storage = quaternion
  }

}

public extension simd_quatd {

  init(_ quaternion: Quaternion) {
    self.init(angle: Double(quaternion.angle), axis: simd_double3(quaternion.axis))
  }

}

// MARK: - Convenience Extensions

public typealias Translation = Vector3
public typealias Scale = Vector3
public typealias Perspective = Vector4
public typealias Skew = Vector3

// Perspective

extension Vector4: PerspectiveRepresentable {

  typealias ValueType = CGFloat

  public var m31: CGFloat {
    get { return CGFloat(self.storage[0]) }
    set { self.storage[0] = Double(newValue) }
  }

  public var m32: CGFloat {
    get { return CGFloat(self.storage[1]) }
    set { self.storage[1] = Double(newValue) }
  }

  public var m33: CGFloat {
    get { return CGFloat(self.storage[2]) }
    set { self.storage[2] = Double(newValue) }
  }

  public var m34: CGFloat {
    get { return CGFloat(self.storage[3]) }
    set { self.storage[3] = Double(newValue) }
  }

  public init(m31: CGFloat = 0.0, m32: CGFloat = 0.0, m33: CGFloat = 0.0, m34: CGFloat = 1.0) {
    self.init(m31, m32, m33, m34)
  }

}

// Skew

extension Vector3: SkewRepresentable {

  typealias ValueType = CGFloat

  public var XY: CGFloat {
    get { return CGFloat(self.storage[0]) }
    set { self.storage[0] = Double(newValue) }
  }

  public var XZ: CGFloat {
    get { return CGFloat(self.storage[1]) }
    set { self.storage[1] = Double(newValue) }
  }

  public var YZ: CGFloat {
    get { return CGFloat(self.storage[2]) }
    set { self.storage[2] = Double(newValue) }
  }

  public init(XY: CGFloat = 0.0, XZ: CGFloat = 0.0, YZ: CGFloat = 0.0) {
    self.init(XY, XZ, YZ)
  }

}

// MARK: - Interpolatable

extension Vector3: Interpolatable {

  public func lerp(to: Vector3, fraction: CGFloat) -> Vector3 {
    return Vector3(self.storage.lerp(to: to.storage, fraction: Double(fraction)))
  }

}

extension Vector4: Interpolatable {

  public func lerp(to: Vector4, fraction: CGFloat) -> Vector4 {
    return Vector4(self.storage.lerp(to: to.storage, fraction: Double(fraction)))
  }

}

extension Quaternion: Interpolatable {

  public func lerp(to: Quaternion, fraction: CGFloat) -> Quaternion {
    return Quaternion(self.storage.lerp(to: to.storage, fraction: Double(fraction)))
  }

}

// MARK: - Equatable

fileprivate let accuracy: Double = 0.0001

extension Vector3: Equatable {

  public static func == (lhs: Self, rhs: Self) -> Bool {
    return abs(rhs.storage[0] - lhs.storage[0]) < accuracy &&
    abs(rhs.storage[1] - lhs.storage[1]) < accuracy &&
    abs(rhs.storage[2] - lhs.storage[2]) < accuracy
  }

}

extension Vector4: Equatable {

  public static func == (lhs: Self, rhs: Self) -> Bool {
    return abs(rhs.storage[0] - lhs.storage[0]) < accuracy &&
    abs(rhs.storage[1] - lhs.storage[1]) < accuracy &&
    abs(rhs.storage[2] - lhs.storage[2]) < accuracy &&
    abs(rhs.storage[3] - lhs.storage[3]) < accuracy
  }

}

extension Quaternion: Equatable {

  public static func == (lhs: Self, rhs: Self) -> Bool {
    return lhs.axis == rhs.axis &&
      abs(rhs.storage.angle - lhs.storage.angle) < accuracy
  }

}
