//
//  CALayerExtensions.swift
//  
//
//  Created by Adam Bell on 5/26/20.
//

import Foundation
import QuartzCore

// MARK: - Interaction Enhancements

fileprivate let DisableActions = { (changes: () -> Void) in
  CATransaction.begin()
  CATransaction.setDisableActions(true)
  changes()
  CATransaction.commit()
}

public extension CALayer {

  var translation: CGPoint {
    get {
      let translation = transform.translation
      return CGPoint(x: translation.x, y: translation.y)
    }
    set {
      transform.translation = Translation(newValue.x, newValue.y, transform.translation.z)
    }
  }

  var translationXYZ: Translation {
    get {
      return transform.translation
    }
    set {
      DisableActions {
        transform.translation = newValue
      }
    }
  }

  var scale: CGSize {
    get {
      let scale = transform.scale
      return CGSize(width: scale.x, height: scale.y)
    }
    set {
      DisableActions {
        transform.scale = Scale(newValue.width, newValue.height, transform.scale.z)
      }
    }
  }

  var scaleXYZ: Scale {
    get {
      return transform.scale
    }
    set {
      DisableActions {
        transform.scale = newValue
      }
    }
  }

  var rotation: Quaternion {
    get {
      return transform.rotation
    }
    set {
      DisableActions {
        transform.rotation = newValue
      }
    }
  }

  var skew: Skew {
    get {
      return transform.skew
    }
    set {
      DisableActions {
        transform.skew = newValue
      }
    }
  }

  var perspective: Perspective {
    get {
      return transform.perspective
    }
    set {
      DisableActions {
        transform.perspective = newValue
      }
    }
  }

}
