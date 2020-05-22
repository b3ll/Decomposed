import XCTest

import DecomposedTests

var tests = [XCTestCaseEntry]()
tests += DecomposedTests.allTests()
XCTMain(tests)
