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

extension Vector4: PerspectiveRepresentable {

  public typealias ValueType = CGFloat

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

  public typealias ValueType = CGFloat

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
