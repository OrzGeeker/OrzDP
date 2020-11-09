import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(OrzDPTests.allTests),
        testCase(MulticastDelegateTests.allTests),
    ]
}
#endif
