import XCTest

import OrzSwiftDPTests

var tests = [XCTestCaseEntry]()
tests += OrzSwiftDPTests.allTests()
tests += MulticastDelegateTests.allTests()
XCTMain(tests)
