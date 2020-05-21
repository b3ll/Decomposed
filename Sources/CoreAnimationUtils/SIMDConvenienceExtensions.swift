//
//  File.swift
//  
//
//  Created by Adam Bell on 5/19/20.
//

import simd

// Perspective

protocol PerspectiveRepresentable {

  associatedtype ValueType: Numeric

  var m31: ValueType { get set }
  var m32: ValueType { get set }
  var m33: ValueType { get set }
  var m34: ValueType { get set }

  init(m31: ValueType, m32: ValueType, m33: ValueType, m34: ValueType)
  
}

extension simd_double4: PerspectiveRepresentable {

  typealias ValueType = Double

  var m31: Double {
    get { return self[0] }
    set { self[0] = Double(newValue) }
  }

  var m32: Double {
    get { return self[1] }
    set { self[1] = Double(newValue) }
  }

  var m33: Double {
    get { return self[2] }
    set { self[2] = Double(newValue) }
  }

  var m34: Double {
    get { return self[3] }
    set { self[3] = Double(newValue) }
  }

  init(m31: Double = 0.0, m32: Double = 0.0, m33: Double = 0.0, m34: Double = 1.0) {
    self.init(m31, m32, m33, m34)
  }

}

// Skew

protocol SkewRepresentable {

  associatedtype ValueType: Numeric

  var XY: ValueType { get set }
  var XZ: ValueType { get set }
  var YZ: ValueType { get set }

  init(XY: ValueType, XZ: ValueType, YZ: ValueType)

}

extension simd_double3: SkewRepresentable {

  typealias Number = Double

  var XY: Double {
    get { return self[0] }
    set { self[0] = newValue }
  }

  var XZ: Double {
    get { return self[1] }
    set { self[1] = newValue }
  }

  var YZ: Double {
    get { return self[2] }
    set { self[2] = newValue }
  }

  init(XY: Double = 0.0, XZ: Double = 0.0, YZ: Double = 0.0) {
    self.init(XY, XZ, YZ)
  }

}
