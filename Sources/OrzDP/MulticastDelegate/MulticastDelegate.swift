//
//  MulticastDelegate.swift
//  
//
//  Created by joker on 2020/11/9.
//


/// 多播代理范型辅助类
public class MulticastDelegate<ProtocolType> {
    
    /// 内部类，用来解耦辅助类和实际代理对象的引用关系，成员弱引用代理对象，相当于对代理对象做了一层包装
    private class DelegateWrapper {
        
        weak var delegate: AnyObject?
        
        init(_ delegate: AnyObject) {
            
            self.delegate = delegate
        }
    }
    
    /// 代理对象包装数组，内部持有
    private var delegateWrappers: [DelegateWrapper]

    /// 初始化
    /// - Parameter delegates: 代理对象数组
    public init(delegates: [ProtocolType] = []) {
        delegateWrappers = delegates.map {
            // 将代理通过成员变量弱引用包装一层
            DelegateWrapper($0 as AnyObject)
        }
    }
    
    /// 获取所有的代理对象
    public var delegates: [ProtocolType] {
        
        delegateWrappers.filter {
            // 过滤已经被释放的代理
            $0.delegate != nil
        }
        .map {
            // 将代理包装拆包
            $0.delegate as! ProtocolType
        }
    }

    /// 添加单个代理对象到代理包装数组中
    /// - Parameter delegate: 要添加的代理对象
    public func addDelegate(_ delegate: ProtocolType) {
        let wrapper = DelegateWrapper(delegate as AnyObject)
        delegateWrappers.append(wrapper)
    }
    
    /// 从代理包装数组中移除单个代理对象
    /// - Parameter delegate: 要移除的代理对象
    public func removeDelegate(_ delegate: ProtocolType) {
        guard let index = delegateWrappers.firstIndex(where: {
            // 指针地址相同的代理对象
            $0.delegate === (delegate as AnyObject)
        }) else {
            return
        }
        delegateWrappers.remove(at: index)
    }
    
    /// 遍历所有的代理对象，并对它们进行操作
    /// - Parameter closure: 要对代理对象进行的操作
    public func invokeDelgates(_ closure: (ProtocolType) -> Void) {
        delegates.forEach {
            closure($0)
        }
    }
}
