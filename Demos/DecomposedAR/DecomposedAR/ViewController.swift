//
//  ViewController.swift
//  DecomposedAR
//
//  Created by Adam Bell on 5/23/20.
//  Copyright © 2020 Adam Bell. All rights reserved.
//

import ARKit
import Decomposed
import UIKit

class ViewController: UIViewController, ARSCNViewDelegate {

  var sceneView: ARSCNView!

  var circleLayer: CALayer!

  var displayLink: CADisplayLink!

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.

    view.backgroundColor = .black

    setupARView()

    self.circleLayer = CALayer()
    circleLayer.isDoubleSided = true
    circleLayer.backgroundColor = UIColor.white.cgColor
    view.layer.addSublayer(circleLayer)
  }

  // MARK: - AR Setup

  func setupARView() {
    self.sceneView = ARSCNView(frame: .zero)
    view.addSubview(sceneView)

    sceneView.delegate = self
    sceneView.showsStatistics = true
    sceneView.autoenablesDefaultLighting = true
    sceneView.automaticallyUpdatesLighting = true
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    let configuration = ARWorldTrackingConfiguration()
    configuration.planeDetection = [.horizontal, .vertical]

    let options: ARSession.RunOptions = [.resetTracking, .removeExistingAnchors]
    sceneView.session.run(configuration, options: options)

    self.displayLink = CADisplayLink(target: self, selector: #selector(displayLinkTick))
    displayLink.add(to: .main, forMode: .common)
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()

    sceneView.frame = view.bounds
    circleLayer.bounds = CGRect(origin: .zero, size: CGSize(width: 10.0, height: 10.0))
    circleLayer.anchorPoint = CGPoint(x: 0.0, y: 0.0)
    circleLayer.position = CGPoint(x: 5.0, y: 5.0)
    circleLayer.zPosition = 1.0
  }

  // MARK: - ARSCNViewDelegate

  func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
    guard let planeAnchor = anchor as? ARPlaneAnchor else { return }

    // Create a custom object to visualize the plane geometry and extent.
    let plane = Plane(anchor: planeAnchor, sceneView: sceneView)

    // Add the visualization to the ARKit-managed node so that it tracks
    // changes in the plane anchor as plane estimation continues.
    node.addChildNode(plane)
  }

  func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
    // Update only anchors and nodes set up by `renderer(_:didAdd:for:)`.
    guard let planeAnchor = anchor as? ARPlaneAnchor,
      let plane = node.childNodes.first as? Plane
      else { return }

    // Update ARSCNPlaneGeometry to the anchor's new estimated shape.
    if let planeGeometry = plane.meshNode.geometry as? ARSCNPlaneGeometry {
      planeGeometry.update(from: planeAnchor.geometry)
    }

    // Update extent visualization to the anchor's new bounding rectangle.
    if let extentGeometry = plane.extentNode.geometry as? SCNPlane {
      extentGeometry.width = CGFloat(planeAnchor.extent.x)
      extentGeometry.height = CGFloat(planeAnchor.extent.z)
      plane.extentNode.simdPosition = planeAnchor.center
    }
  }

  // MARK: - DisplayLink

  @objc func displayLinkTick() {
    sceneView.scene.rootNode.enumerateChildNodes { (node, stop) in
      node.geometry?.firstMaterial?.diffuse.contents = UIColor.white
    }

    guard let intersectingAnchor = sceneView.hitTest(CGPoint(x: view.bounds.midX, y: view.bounds.midY), types: [.existingPlaneUsingGeometry]).first else { return }
    guard let anchor = intersectingAnchor.anchor, let anchorNode = sceneView.node(for: anchor) else { return }
    guard let planeNode = anchorNode.childNodes.first as? Plane else { return }

    planeNode.extentNode.geometry?.firstMaterial?.diffuse.contents = UIColor.blue

    guard let translation = sceneView.unprojectPoint(CGPoint(x: sceneView.bounds.midX, y: sceneView.bounds.midY), ontoPlane: anchor.transform) else { return }

    print(translation)

    guard let frame = sceneView.session.currentFrame else { return }

    let camera = frame.camera

    let mx = float4x4(
          [1/Float(100), 0, 0, 0],
          [0, -1/Float(100), 0, 0],    //flip Y axis; it's directed up in 3d world while for CA on iOS it's directed down
          [0, 0, 1, 0],
          [0, 0, 0, 1]
      )

    let model = anchor.transform * simd_float4x4(simd_quatf(angle: .pi / -2.0, axis: normalize(simd_float3(1.0, 0.0, 0.0)))) * mx
    let view = camera.viewMatrix(for: .portrait)
    let proj = camera.projectionMatrix(for: .portrait, viewportSize: sceneView.bounds.size, zNear: 0.01, zFar: 1000)

    let modelViewProjection = simd_mul(proj, simd_mul(view, model))

    var atr = CATransform3D(modelViewProjection)

    let norm = CATransform3DMakeScale(0.5, -0.5, 1)     //on iOS Y axis is directed down, but we flipped it formerly, so return back!
    let shift = CATransform3DMakeTranslation(1, -1, 0)  //we should shift it to another end of projection matrix output before flipping
    let screen_scale = CATransform3DMakeScale(sceneView.bounds.size.width, sceneView.bounds.size.height, 1)
    atr = CATransform3DConcat(CATransform3DConcat(atr, shift), norm)
//    atr = CATransform3DConcat(atr, CATransform3DMakeAffineTransform(frame.displayTransform(for: .portrait, viewportSize: sceneView.bounds.size)))

    atr = CATransform3DConcat(atr, screen_scale)    //scale back to pixels

    CATransaction.begin()
    CATransaction.setDisableActions(true)
    circleLayer.transform = atr
    CATransaction.commit()

    print(circleLayer.frame)
  }

}
