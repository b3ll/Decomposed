//
//  File.swift
//  
//
//  Created by Adam Bell on 5/19/20.
//

import simd

// Perspective

public extension simd_double4 {

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

  init(m31: Double = 0.0, m32: Double = 0.0, m33: Double = 0.0, m34: Double = 0.0) {
    self.init(m31, m32, m33, m34)
  }

}

// Skew

internal extension simd_double3 {

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

  init(XY: Double, XZ: Double, YZ: Double) {
    self.init(XY, XZ, YZ)
  }

}
