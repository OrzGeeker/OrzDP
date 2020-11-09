import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(OrzSwiftDPTests.allTests),
        testCase(MulticastDelegateTests.allTests),
    ]
}
#endif
