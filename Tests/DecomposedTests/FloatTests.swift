import Decomposed
import XCTest
import simd

@testable import Decomposed

final class FloatTests: XCTestCase {

  func testTranslation() {
    let testTransformCA = CATransform3DMakeTranslation(2.0, 3.0, 4.0)

    XCTAssertEqual(testTransformCA.translation.x, 2.0);
    XCTAssertEqual(testTransformCA.translation.y, 3.0);
    XCTAssertEqual(testTransformCA.translation.z, 4.0);

    var testTransform2 = CATransform3DIdentity
    testTransform2.translation.x = 2.0
    testTransform2.translation.y = 3.0
    testTransform2.translation.z = 4.0

    XCTAssertEqual(testTransform2, testTransformCA);

    let testTransform3 = CATransform3DIdentity.translated(by: CGVector3(x: 2.0, y: 3.0, z: 4.0))

    XCTAssertEqual(testTransform3, testTransformCA)

    testTransform2.translation.z = 0.0
    let testTransform4 = CATransform3DIdentity.translated(by: CGPoint(x: 2.0, y: 3.0))
    XCTAssertEqual(testTransform4, testTransform2)

    var testTransform5 = CATransform3DIdentity
    testTransform5.translate(by: CGPoint(x: 2.0, y: 3.0))
    XCTAssertEqual(testTransform5, testTransform2)
  }

  func testScale() {
    let testTransformCA = CATransform3DMakeScale(2.0, 3.0, 4.0)

    XCTAssertEqual(testTransformCA.scale.x, 2.0);
    XCTAssertEqual(testTransformCA.scale.y, 3.0);
    XCTAssertEqual(testTransformCA.scale.z, 4.0);

    var testTransform2 = CATransform3DIdentity
    testTransform2.scale.x = 2.0
    testTransform2.scale.y = 3.0
    testTransform2.scale.z = 4.0

    XCTAssertEqual(testTransform2, testTransformCA);

    let testTransform3 = CATransform3DIdentity.scaled(by: CGVector3(x: 2.0, y: 3.0, z: 4.0))
    XCTAssertEqual(testTransform3, testTransformCA)

    testTransform2.scale.z = 0.0

    let testTransform4 = CATransform3DIdentity.scaled(by: CGPoint(x: 2.0, y: 3.0))
    XCTAssertEqual(testTransform4, testTransform2)

    var testTransform5 = CATransform3DIdentity
    testTransform5.scale(by: CGPoint(x: 2.0, y: 3.0))
    XCTAssertEqual(testTransform5, testTransform2)
  }

  func testRotation() {
    let testRotateXCA = CATransform3DMakeRotation(.pi / 4, 1.0, 0.0, 0.0)
    let testRotateYCA = CATransform3DMakeRotation(.pi / 4, 0.0, 1.0, 0.0)
    let testRotateZCA = CATransform3DMakeRotation(.pi / 4, 0.0, 0.0, 1.0)

    var testTransformX = CATransform3DIdentity
    testTransformX.rotation = CGQuaternion(angle: .pi / 4.0, axis: CGVector3(normalize(simd_float3(1.0, 0.0, 0.0))))

    var testTransformY = CATransform3DIdentity
    testTransformY.rotation = CGQuaternion(angle: .pi / 4.0, axis: CGVector3(normalize(simd_float3(0.0, 1.0, 0.0))))

    var testTransformZ = CATransform3DIdentity
    testTransformZ.rotation = CGQuaternion(angle: .pi / 4.0, axis: CGVector3(normalize(simd_float3(0.0, 0.0, 1.0))))

    XCTAssertEqual(testTransformX, testRotateXCA)
    XCTAssertEqual(testTransformY, testRotateYCA)
    XCTAssertEqual(testTransformZ, testRotateZCA)

    let testTransformXYCA = CATransform3DMakeRotation(.pi / 4.0, 1.0, 1.0, 0.0)
    let testTransformXY = CATransform3DIdentity.rotated(by: CGQuaternion(angle: .pi / 4.0, axis: CGVector3(normalize(simd_float3(x: 1.0, y: 1.0, z: 0.0)))))

    XCTAssertEqual(testTransformXY, testTransformXYCA)
  }

  func testRotationEulerAngles() {
    let testRotateXCA = CATransform3DMakeRotation(.pi / 4, 1.0, 0.0, 0.0)
    let testRotateYCA = CATransform3DMakeRotation(.pi / 4, 0.0, 1.0, 0.0)
    let testRotateZCA = CATransform3DMakeRotation(.pi / 4, 0.0, 0.0, 1.0)

    var testTransformX = CATransform3DIdentity
    testTransformX.eulerAngles.x = .pi / 4

    var testTransformY = CATransform3DIdentity
    testTransformY.eulerAngles.y = .pi / 4

    var testTransformZ = CATransform3DIdentity
    testTransformZ.eulerAngles.z = .pi / 4

    XCTAssertEqual(testTransformX, testRotateXCA)
    XCTAssertEqual(testTransformY, testRotateYCA)
    XCTAssertEqual(testTransformZ, testRotateZCA)

    var testTransformXYCA = CATransform3DMakeRotation(.pi / 4.0, 1.0, 0.0, 0.0)
    testTransformXYCA = CATransform3DConcat(testTransformXYCA, CATransform3DMakeRotation(.pi / 4.0, 0.0, 1.0, 0.0))
    let testTransformXY = CATransform3DIdentity.rotated(by: CGVector3(.pi / 4.0, .pi / 4.0, 0.0))

    XCTAssertEqual(testTransformXY, testTransformXYCA)
  }

  func testSkew() {
    // CA doesn't really provide any default Skew manipulations so, just make sure that the skew works as intended.
    let transform1 = CATransform3DIdentity.skewedBy(xy: 0.25, xz: 0.25, yz: 0.25)
    XCTAssertEqual(transform1.m21, 0.25, accuracy: CGFloat(SupportedAccuracy))
    XCTAssertEqual(transform1.m31, 0.25, accuracy: CGFloat(SupportedAccuracy))
    XCTAssertEqual(transform1.m32, 0.25, accuracy: CGFloat(SupportedAccuracy))
  }

  func testPerspective() {
    // CA doesn't really provide any default Skew manipulations so, just make sure that the skew works as intended.
    let transform1 = CATransform3DIdentity.applyingPerspective(m14: 0.11, m24: 0.22, m34: 0.33, m44: 0.44)
    XCTAssertEqual(transform1.m14, 0.11, accuracy: CGFloat(SupportedAccuracy))
    XCTAssertEqual(transform1.m24, 0.22, accuracy: CGFloat(SupportedAccuracy))
    XCTAssertEqual(transform1.m34, 0.33, accuracy: CGFloat(SupportedAccuracy))
    XCTAssertEqual(transform1.m44, 0.44, accuracy: CGFloat(SupportedAccuracy))
  }

  func testDecompose() {
    let translationTransform = CATransform3DMakeTranslation(1.0, 2.0, 3.0)
    let decomposedTranslationTransform = translationTransform.decomposed()
    XCTAssertEqual(decomposedTranslationTransform.translation, CGVector3(1.0, 2.0, 3.0))

    let scaleTransform = CATransform3DMakeScale(1.0, 2.0, 3.0)
    let decomposedScaleTransform = scaleTransform.decomposed()
    XCTAssertEqual(decomposedScaleTransform.scale, Scale(1.0, 2.0, 3.0))

    let rotationTransformQuaternion = CATransform3DMakeRotation(.pi / 4.0, 1.0, 1.0, 1.0)
    let decomposedRotationTransformQuaternion = rotationTransformQuaternion.decomposed()
    XCTAssertEqual(decomposedRotationTransformQuaternion.rotation, CGQuaternion(angle: .pi / 4.0, axis: CGVector3(normalize(simd_float3(1.0, 1.0, 1.0)))))

    var combinedTransform = CATransform3DMakeTranslation(1.0, 2.0, 3.0)
    combinedTransform = CATransform3DScale(combinedTransform, 2.0, 2.0, 2.0)
    combinedTransform = CATransform3DRotate(combinedTransform, .pi, 1.0, 0.0, 0.0)

    let decomposedCombinedTransform = combinedTransform.decomposed()
    XCTAssertEqual(decomposedCombinedTransform.translation, CGVector3(1.0, 2.0, 3.0))
    XCTAssertEqual(decomposedCombinedTransform.scale, CGVector3(2.0, 2.0, 2.0))
    XCTAssertEqual(decomposedCombinedTransform.rotation, CGQuaternion(angle: .pi, axis: CGVector3(x: 1.0, y: 0.0, z: 0.0)))
  }

  func testRecompose() {
    var startTransform = CATransform3DMakeRotation(.pi / 4.0, 1.0, 0.0, 0.0)
    startTransform = CATransform3DScale(startTransform, 2.0, 2.0, 2.0)
    startTransform = CATransform3DTranslate(startTransform, 2.0, 2.0, 2.0)

    let decomposedThenRecomposedTransform = startTransform.decomposed().recomposed()
    XCTAssertEqual(startTransform, decomposedThenRecomposedTransform)

    let rotationTransform = CATransform3DMakeRotation(.pi / 4.0, 1.0, 0.0, 0.0)

    let m = CATransform3DIdentity
    var decomposed = m.decomposed()
    decomposed.rotation = CGQuaternion(angle: .pi / 4.0, axis: CGVector3(normalize(simd_float3(1.0, 0.0, 0.0))))
    let recomposedRotationTransform = decomposed.recomposed()

    XCTAssertEqual(rotationTransform, recomposedRotationTransform)

    var m2 = CATransform3DIdentity
    m2.rotation = CGQuaternion(angle: .pi / 4.0, axis: CGVector3(normalize(simd_float3(1.0, 0.0, 0.0))))
    XCTAssertEqual(rotationTransform, m2)
  }

  func testComposition() {
    var transform = CATransform3DIdentity
    transform = CATransform3DTranslate(transform, 2.0, 4.0, 6.0)
    transform = CATransform3DScale(transform, 1.0, 2.0, 3.0)
    transform = CATransform3DRotate(transform, .pi / 4.0, 1.0, 0.0, 0.0)

    let transform2 = CATransform3DIdentity
      .translated(by: CGVector3(x: 2.0, y: 4.0, z: 6.0))
      .scaled(by: CGVector3(x: 1.0, y: 2.0, z: 3.0))
      .rotated(by: CGQuaternion(angle: .pi / 4.0, axis: CGVector3(normalize(simd_float3(1.0, 0.0, 0.0)))))

    XCTAssertEqual(transform, transform2)
  }

  func testLERP() {
    let a = simd_float4(1.0, 10.0, 100.0, 1000.0)
    let b = a * 2.0

    XCTAssertEqual(a.lerp(to: b, fraction: 0.0), a)
    XCTAssertEqual(a.lerp(to: b, fraction: 0.5), simd_float4(1.5, 15.0, 150.0, 1500.0))
    XCTAssertEqual(a.lerp(to: b, fraction: 1.0), b)

    let c = simd_quatf(angle: 0.0, axis: simd_float3(0.0, 0.0, 0.0))
    let d = simd_quatf(angle: .pi / 4.0, axis: simd_float3(0.0, 1.0, 0.0))

    XCTAssertEqual(c.lerp(to: d, fraction: 0.0), c)
    XCTAssertEqual(c.lerp(to: d, fraction: 0.5), simd_quatf(angle: d.angle * 0.5, axis: d.axis))
    XCTAssertEqual(c.lerp(to: d, fraction: 1.0), d)
  }

  static var allTests = [
    ("testTranslation", testTranslation),
    ("testScale", testScale),
    ("testRotation", testRotation),
    ("testSkew", testSkew),
    ("testDecompose", testDecompose),
    ("testRecompose", testRecompose),
    ("testComposition", testComposition),
    ("testLERP", testLERP),
  ]

}
