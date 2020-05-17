import CoreAnimationUtils
import XCTest
import simd

@testable import CoreAnimationUtils

final class CoreAnimationUtilsTests: XCTestCase {

  func testTranslation() {
    let testTransformCA = CATransform3DMakeTranslation(2.0, 3.0, 4.0)

    XCTAssertEqual(testTransformCA.translation.x, 2.0);
    XCTAssertEqual(testTransformCA.translation.y, 3.0);
    XCTAssertEqual(testTransformCA.translation.z, 4.0);

    var testTransform = CATransform3DIdentity
    testTransform.translation.x = 2.0
    testTransform.translation.y = 3.0
    testTransform.translation.z = 4.0

    XCTAssertEqual(testTransform, testTransformCA);

    var testTransform2 = CATransform3DIdentity
    testTransform2 = testTransform2.translated(by: simd_double3(2.0, 3.0, 4.0))

    XCTAssertEqual(testTransform2, testTransformCA)
  }

  func testScale() {
    let testTransform = CATransform3DMakeScale(2.0, 3.0, 4.0)

    XCTAssertEqual(testTransform.scale.x, 2.0);
    XCTAssertEqual(testTransform.scale.y, 3.0);
    XCTAssertEqual(testTransform.scale.z, 4.0);

    var testTransform2 = CATransform3DIdentity
    testTransform2.scale.x = 2.0
    testTransform2.scale.y = 3.0
    testTransform2.scale.z = 4.0

    XCTAssertEqual(testTransform, testTransform2);
  }

  func testRotation() {
    let testTransformCAX = CATransform3DMakeRotation(.pi / 4, 1.0, 0.0, 0.0)
    let testTransformCAY = CATransform3DMakeRotation(.pi / 4, 0.0, 1.0, 0.0)
    let testTransformCAZ = CATransform3DMakeRotation(.pi / 4, 0.0, 0.0, 1.0)

    var testTransformX = CATransform3DIdentity
    testTransformX.rotation = simd_quatd(angle: .pi / 4.0, axis: normalize(simd_double3(1.0, 0.0, 0.0)))

    var testTransformY = CATransform3DIdentity
    testTransformY.rotation = simd_quatd(angle: .pi / 4.0, axis: normalize(simd_double3(0.0, 1.0, 0.0)))

    var testTransformZ = CATransform3DIdentity
    testTransformZ.rotation = simd_quatd(angle: .pi / 4.0, axis: normalize(simd_double3(0.0, 0.0, 1.0)))

    XCTAssertEqual(testTransformCAX, testTransformX)
    XCTAssertEqual(testTransformCAY, testTransformY)
    XCTAssertEqual(testTransformCAZ, testTransformZ)

    let testTransformCAXY = CATransform3DRotate(testTransformX, .pi / 4.0, 0.0, 1.0, 0.0)

    var testTransformXY = CATransform3DIdentity
    testTransformXY = testTransformX.rotated(by: simd_quatd(angle: .pi / 4.0, axis: simd_double3(1.0, 0.0, 0.0)))
    testTransformXY = testTransformX.rotated(by: simd_quatd(angle: .pi / 4.0, axis: simd_double3(0.0, 1.0, 0.0)))

    XCTAssertEqual(testTransformCAXY, testTransformXY)
  }

  func testDecompose() {
    let translationTransform = CATransform3DMakeTranslation(1.0, 2.0, 3.0)
    let decomposedTranslationTransform = TransformationMatrix(translationTransform).decomposed

    XCTAssert(decomposedTranslationTransform.translation == simd_double3(1.0, 2.0, 3.0))

    let scaleTransform = CATransform3DMakeScale(1.0, 2.0, 3.0)
    let decomposedScaleTransform = TransformationMatrix(scaleTransform).decomposed

    XCTAssert(decomposedScaleTransform.scale == simd_double3(1.0, 2.0, 3.0))

    let rotationTransformX = CATransform3DMakeRotation(.pi / 4.0, 1.0, 0.0, 0.0)
    let decomposedRotationTransformX = TransformationMatrix(rotationTransformX).decomposed

    XCTAssertEqual(decomposedRotationTransformX.rotation, simd_double3(.pi / 4.0, 0.0, 0.0))

    let rotationTransformY = CATransform3DMakeRotation(.pi / 4.0, 0.0, 1.0, 0.0)
    let decomposedRotationTransformY = TransformationMatrix(rotationTransformY).decomposed

    XCTAssertEqual(decomposedRotationTransformY.rotation, simd_double3(0.0, .pi / 4.0, 0.0))

    let rotationTransformZ = CATransform3DMakeRotation(.pi / 4.0, 0.0, 0.0, 1.0)
    let decomposedRotationTransformZ = TransformationMatrix(rotationTransformZ).decomposed

    XCTAssertEqual(decomposedRotationTransformZ.rotation, simd_double3(0.0, 0.0, .pi / 4.0))

    let rotationTransformQuaternion = CATransform3DMakeRotation(.pi / 4.0, 1.0, 1.0, 1.0)
    let decomposedRotationTransformQuaternion = TransformationMatrix(rotationTransformQuaternion).decomposed

    XCTAssertEqual(decomposedRotationTransformQuaternion.quaternion, simd_quatd(angle: .pi / 4.0, axis: normalize(simd_double3(1.0, 1.0, 1.0))))
  }

  func testRecompose() {
    let transform = CATransform3DMakeRotation(.pi / 4.0, 1.0, 0.0, 0.0)

    XCTAssertEqual(transform.rotation, simd_quatd(angle: .pi / 4.0, axis: normalize(simd_double3(1.0, 0.0, 0.0))))

    let m = TransformationMatrix(CATransform3DIdentity)
    var decomposed = m.decomposed
    decomposed.quaternion = simd_quatd(angle: .pi / 4.0, axis: normalize(simd_double3(1.0, 0.0, 0.0)))
    let recomposed = CATransform3D(decomposed.recomposed)

    XCTAssertEqual(transform, recomposed)

    var m2 = CATransform3DIdentity
    m2.rotation = simd_quatd(angle: .pi / 4.0, axis: normalize(simd_double3(1.0, 0.0, 0.0)))
    XCTAssertEqual(transform, m2)
  }

  func testComposition() {
    var transform = CATransform3DIdentity
    transform = CATransform3DTranslate(transform, 2.0, 4.0, 6.0)
    transform = CATransform3DScale(transform, 1.0, 2.0, 3.0)
    transform = CATransform3DRotate(transform, .pi / 4.0, 1.0, 0.0, 0.0)

    let transform2 = CATransform3DIdentity
      .translated(by: simd_double3(2.0, 4.0, 6.0))
      .scaled(by: simd_double3(1.0, 2.0, 3.0))
      .rotated(by: simd_quatd(angle: .pi / 4.0, axis: normalize(simd_double3(1.0, 0.0, 0.0))))

    XCTAssertEqual(transform, transform2)
  }

  func testLERP() {
    let a = simd_double4(1.0, 10.0, 100.0, 1000.0)
    let b = a * 2.0

    XCTAssertEqual(a.lerp(to: b, percent: 0.0), a)
    XCTAssertEqual(a.lerp(to: b, percent: 0.5), simd_double4(1.5, 15.0, 150.0, 1500.0))
    XCTAssertEqual(a.lerp(to: b, percent: 1.0), b)

    // TODO: Enable these when I figure out what's wrong.
//    let c = simd_quatd(angle: 0.0, axis: simd_double3(0.0, 0.0, 0.0))
//    let d = simd_quatd(angle: .pi / 4.0, axis: simd_double3(0.0, 1.0, 0.0))
//
//    XCTAssertEqual(c.lerp(to: d, percent: 0.0), c)
//    XCTAssertEqual(c.lerp(to: d, percent: 0.5), d / 2.0)
//    XCTAssertEqual(c.lerp(to: d, percent: 1.0), d)
  }

  static var allTests = [
    ("testTranslation", testTranslation),
  ]

}

internal func XCTAssertEqual(_ lhs: simd_double3, _ rhs: simd_double3, accuracy: Double = 0.00001) {
  XCTAssertEqual(lhs[0], rhs[0], accuracy: accuracy)
  XCTAssertEqual(lhs[1], rhs[1], accuracy: accuracy)
  XCTAssertEqual(lhs[2], rhs[2], accuracy: accuracy)
}

internal func XCTAssertEqual(_ lhs: simd_double4, _ rhs: simd_double4, accuracy: Double = 0.00001) {
  XCTAssertEqual(lhs[0], rhs[0], accuracy: accuracy)
  XCTAssertEqual(lhs[1], rhs[1], accuracy: accuracy)
  XCTAssertEqual(lhs[2], rhs[2], accuracy: accuracy)
  XCTAssertEqual(lhs[3], rhs[3], accuracy: accuracy)
}

internal func XCTAssertEqual(_ lhs: simd_quatd, _ rhs: simd_quatd, accuracy: Double = 0.00001) {
  XCTAssertEqual(lhs.vector, rhs.vector, accuracy: accuracy)
}

internal func XCTAssertEqual(_ lhs: CATransform3D, _ rhs: CATransform3D, accuracy: CGFloat = 0.00001) {
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
