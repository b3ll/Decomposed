import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
  return [
    testCase(DoubleTests.allTests),
    testCase(FloatTests.allTests),
  ]
}
#endif
