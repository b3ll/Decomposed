//
//  Plane.swift
//  DecomposedAR
//
//  Created by Adam Bell on 5/24/20.
//  Copyright © 2020 Adam Bell. All rights reserved.
//

import ARKit
import SceneKit
import UIKit

class Plane: SCNNode {

  let anchor: ARPlaneAnchor
  let sceneView: ARSCNView

  let meshNode: SCNNode
  let extentNode: SCNNode

  init(anchor: ARPlaneAnchor, sceneView: ARSCNView) {
    self.anchor = anchor
    self.sceneView = sceneView

    guard let meshGeometry = ARSCNPlaneGeometry(device: sceneView.device!)
        else { fatalError("Can't create plane geometry") }
    meshGeometry.update(from: anchor.geometry)
    self.meshNode = SCNNode(geometry: meshGeometry)

    // Create a node to visualize the plane's bounding rectangle.
    let extentPlane: SCNPlane = SCNPlane(width: CGFloat(anchor.extent.x), height: CGFloat(anchor.extent.z))
    self.extentNode = SCNNode(geometry: extentPlane)
    extentNode.simdPosition = anchor.center
    extentNode.opacity = 0.5
    // `SCNPlane` is vertically oriented in its local coordinate space, so
    // rotate it to match the orientation of `ARPlaneAnchor`.
    extentNode.eulerAngles.x = -.pi / 2

    super.init()

//    addChildNode(meshNode)
    addChildNode(extentNode)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
