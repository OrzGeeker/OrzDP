import XCTest

import OrzDPTests

var tests = [XCTestCaseEntry]()
tests += OrzDPTests.allTests()
tests += MulticastDelegateTests.allTests()
XCTMain(tests)
