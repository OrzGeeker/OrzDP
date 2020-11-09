//
//  MulticastDelegateTests.swift
//  
//
//  Created by joker on 2020/11/9.
//

import XCTest
@testable import OrzDP

final class MulticastDelegateTests: XCTestCase {
    
    /// 紧急事件处理系统
    static var dispatch: DispatchSystem? = DispatchSystem()
    /// 警察局
    static var policeStation: PoliceStation? = PoliceStation()
    /// 消防局
    static var fireStation: FireStation? = FireStation()
    
    override class func setUp() {
        super.setUp()
     
        // 紧急事件发生时，紧急事件处理系统会让警察局和消防局来处理问题
        if let policeStation = policeStation {
            dispatch?.multicastDelegate.addDelegate(policeStation)
        }
        
        if let fireStation = fireStation {
            dispatch?.multicastDelegate.addDelegate(fireStation)
        }
    }
    
    override class func tearDown() {
        super.tearDown()
        
        if let policeStation = policeStation {
            dispatch?.multicastDelegate.removeDelegate(policeStation)
        }
        
        if let fireStation = fireStation {
            dispatch?.multicastDelegate.removeDelegate(fireStation)
        }
    }
    
    func testMulticastDelegatePattern() {
        
        var ret = [String]()
        var location = "我的家里"
        var expect = [
            "通知警察我的家里发生火灾",
            "通知消防员我的家里发生火灾",
        ]
        // 家里发生火灾
        MulticastDelegateTests.dispatch?.multicastDelegate.invokeDelgates {
            ret.append($0.notifyFire(at: location))
        }
        XCTAssertEqual(ret.count, expect.count)
        for (index, item) in ret.enumerated() {
            XCTAssertEqual(item, expect[index])
        }
        
        // 消防局不工作时
        MulticastDelegateTests.fireStation = nil
        
        ret.removeAll()
        location = "马路上"
        expect = [
            "通知警察\(location)发生车祸",
        ]
        
        // 马路上发生车祸
        MulticastDelegateTests.dispatch?.multicastDelegate.invokeDelgates {
            ret.append($0.notifyCarCrash(at: location))
        }
        
        XCTAssertEqual(ret.count, expect.count)
        for (index, item) in ret.enumerated() {
            XCTAssertEqual(item, expect[index])
        }
    }
    
    static var allTests = [
        ("testFuncation", testMulticastDelegatePattern),
    ]
}


// MARK: 测试用例辅助

/// 定义一个紧急事件处理协议
public protocol EmergencyResponding {
    
    /// 通知某地发生火灾
    /// - Parameter location: 发生火灾的地点
    func notifyFire(at location: String) -> String
    
    /// 通知某地发生车祸
    /// - Parameter location: 发生车祸的地点
    func notifyCarCrash(at location: String) -> String
}

/// 消防局类
public class FireStation: EmergencyResponding {
    
    public func notifyFire(at location: String) -> String {
        return "通知消防员\(location)发生火灾"
    }
    
    public func notifyCarCrash(at location: String) -> String {
        return "通知消防员\(location)发生车祸"
    }
}

/// 警察局类
public class PoliceStation: EmergencyResponding {
    
    public func notifyFire(at location: String) -> String {
        return "通知警察\(location)发生火灾"
    }
    
    public func notifyCarCrash(at location: String) -> String {
        return "通知警察\(location)发生车祸"
    }
    
}

/// 紧急事件处理系统
public class DispatchSystem {
    let multicastDelegate = MulticastDelegate<EmergencyResponding>()
}
