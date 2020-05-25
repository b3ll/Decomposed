//
//  CATransform3DConvenienceExtensions.swift
//  
//
//  Created by Adam Bell on 5/21/20.
//

import Foundation
import QuartzCore

// MARK: - Convenience Extensions

public typealias Translation = Vector3
public typealias Scale = Vector3
public typealias Perspective = Vector4
public typealias Skew = Vector3

// Perspective

public extension Vector4 {

  var m31: CGFloat {
    get { return CGFloat(self.storage[0]) }
    set { self.storage[0] = Double(newValue) }
  }

  var m32: CGFloat {
    get { return CGFloat(self.storage[1]) }
    set { self.storage[1] = Double(newValue) }
  }

  var m33: CGFloat {
    get { return CGFloat(self.storage[2]) }
    set { self.storage[2] = Double(newValue) }
  }

  var m34: CGFloat {
    get { return CGFloat(self.storage[3]) }
    set { self.storage[3] = Double(newValue) }
  }

  init(m31: CGFloat = 0.0, m32: CGFloat = 0.0, m33: CGFloat = 0.0, m34: CGFloat = 1.0) {
    self.init(m31, m32, m33, m34)
  }

  init(m31: Double = 0.0, m32: Double = 0.0, m33: Double = 0.0, m34: Double = 1.0) {
    self.init(CGFloat(m31), CGFloat(m32), CGFloat(m33), CGFloat(m34))
  }

  init(m31: Float = 0.0, m32: Float = 0.0, m33: Float = 0.0, m34: Float = 1.0) {
    self.init(CGFloat(m31), CGFloat(m32), CGFloat(m33), CGFloat(m34))
  }

}

// Skew

public extension Vector3 {

  var XY: CGFloat {
    get { return CGFloat(self.storage[0]) }
    set { self.storage[0] = Double(newValue) }
  }

  var XZ: CGFloat {
    get { return CGFloat(self.storage[1]) }
    set { self.storage[1] = Double(newValue) }
  }

  var YZ: CGFloat {
    get { return CGFloat(self.storage[2]) }
    set { self.storage[2] = Double(newValue) }
  }

  init(XY: CGFloat = 0.0, XZ: CGFloat = 0.0, YZ: CGFloat = 0.0) {
    self.init(XY, XZ, YZ)
  }
  
  init(XY: Double = 0.0, XZ: Double = 0.0, YZ: Double = 0.0) {
    self.init(CGFloat(XY), CGFloat(XZ), CGFloat(YZ))
  }
  
  init(XY: Float = 0.0, XZ: Float = 0.0, YZ: Float = 0.0) {
    self.init(CGFloat(XY), CGFloat(XZ), CGFloat(YZ))
  }

}
