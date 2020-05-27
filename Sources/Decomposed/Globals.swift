//
//  Globals.swift
//  
//
//  Created by Adam Bell on 5/20/20.
//

import QuartzCore

// The amount of accuracy that should be used when comparing floating point values.
internal let SupportedAccuracy = 0.0001

internal let DisableActions = { (changes: () -> Void) in
  CATransaction.begin()
  CATransaction.setDisableActions(true)
  changes()
  CATransaction.commit()
}
