//
//  File.swift
//  
//
//  Created by Adam Bell on 5/25/20.
//

//import Decomposed
import XCTest
import simd

@testable import Decomposed

// MARK: - Equality with Accuracy Checks

// MARK: - Double

internal func XCTAssertEqual(_ lhs: simd_double3, _ rhs: simd_double3, accuracy: Double = SupportedAccuracy) {
  XCTAssertEqual(lhs[0], rhs[0], accuracy: accuracy)
  XCTAssertEqual(lhs[1], rhs[1], accuracy: accuracy)
  XCTAssertEqual(lhs[2], rhs[2], accuracy: accuracy)
}

internal func XCTAssertEqual(_ lhs: simd_double4, _ rhs: simd_double4, accuracy: Double = SupportedAccuracy) {
  XCTAssertEqual(lhs[0], rhs[0], accuracy: accuracy)
  XCTAssertEqual(lhs[1], rhs[1], accuracy: accuracy)
  XCTAssertEqual(lhs[2], rhs[2], accuracy: accuracy)
  XCTAssertEqual(lhs[3], rhs[3], accuracy: accuracy)
}

internal func XCTAssertEqual(_ lhs: simd_quatd, _ rhs: simd_quatd, accuracy: Double = SupportedAccuracy) {
  XCTAssertEqual(lhs.vector, rhs.vector, accuracy: accuracy)
}

// MARK: - Float

internal func XCTAssertEqual(_ lhs: simd_float3, _ rhs: simd_float3, accuracy: Float = Float(SupportedAccuracy)) {
  XCTAssertEqual(lhs[0], rhs[0], accuracy: accuracy)
  XCTAssertEqual(lhs[1], rhs[1], accuracy: accuracy)
  XCTAssertEqual(lhs[2], rhs[2], accuracy: accuracy)
}

internal func XCTAssertEqual(_ lhs: simd_float4, _ rhs: simd_float4, accuracy: Float = Float(SupportedAccuracy)) {
  XCTAssertEqual(lhs[0], rhs[0], accuracy: accuracy)
  XCTAssertEqual(lhs[1], rhs[1], accuracy: accuracy)
  XCTAssertEqual(lhs[2], rhs[2], accuracy: accuracy)
  XCTAssertEqual(lhs[3], rhs[3], accuracy: accuracy)
}

internal func XCTAssertEqual(_ lhs: simd_quatf, _ rhs: simd_quatf, accuracy: Float = Float(SupportedAccuracy)) {
  XCTAssertEqual(lhs.vector, rhs.vector, accuracy: accuracy)
}

// MARK: - CGFloat

internal func XCTAssertEqual(_ lhs: CATransform3D, _ rhs: CATransform3D, accuracy: CGFloat = CGFloat(SupportedAccuracy)) {
  XCTAssertEqual(lhs.m11, rhs.m11, accuracy: accuracy)
  XCTAssertEqual(lhs.m12, rhs.m12, accuracy: accuracy)
  XCTAssertEqual(lhs.m13, rhs.m13, accuracy: accuracy)
  XCTAssertEqual(lhs.m14, rhs.m14, accuracy: accuracy)

  XCTAssertEqual(lhs.m21, rhs.m21, accuracy: accuracy)
  XCTAssertEqual(lhs.m22, rhs.m22, accuracy: accuracy)
  XCTAssertEqual(lhs.m23, rhs.m23, accuracy: accuracy)
  XCTAssertEqual(lhs.m24, rhs.m24, accuracy: accuracy)

  XCTAssertEqual(lhs.m31, rhs.m31, accuracy: accuracy)
  XCTAssertEqual(lhs.m32, rhs.m32, accuracy: accuracy)
  XCTAssertEqual(lhs.m33, rhs.m33, accuracy: accuracy)
  XCTAssertEqual(lhs.m34, rhs.m34, accuracy: accuracy)

  XCTAssertEqual(lhs.m41, rhs.m41, accuracy: accuracy)
  XCTAssertEqual(lhs.m42, rhs.m42, accuracy: accuracy)
  XCTAssertEqual(lhs.m43, rhs.m43, accuracy: accuracy)
  XCTAssertEqual(lhs.m44, rhs.m44, accuracy: accuracy)
}
