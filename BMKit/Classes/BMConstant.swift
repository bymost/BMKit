//
//  BMConstant.swift
//  BMKit
//
//  Created by bymost on 14/03/2018.
//


import UIKit

// 个推
let CONSTANT_GETUI_CLIENT_ID = "GeTuiClientId"

/// swift处理成功闭包
public typealias requestSuccessCompletionBlock = (_ object: Any) -> Void
public typealias requestSuccsssCompletionBlockWithPages = (_ object: Any, _ pages: Int) -> Void
/// swift处理失败闭包
public typealias requestFailureBlock = (_ error: Error) -> Void
/// swift上传进度闭包
public typealias uploadProgressBlock = (_ progress: Progress) -> Void
// 参数
public typealias Paramters = [String : Any]

// MARK: - 打印
///
/// - Parameter item: 输入
public func BMPrint(_ item: @autoclosure () -> Any){
    #if DEBUG
        print("BMKit INFO |", item())
    #endif
}

public func BMPrintError(_ item: @autoclosure () -> Any){
    #if DEBUG
        print("BMKit ERROR | ", item())
    #endif
}

/// - Parameter item: 输入
public func BMDebugPrint(_ item: @autoclosure () -> Any){
    #if DEBUG
        debugPrint("BMKit INFO |", item())
    #endif
}

public func BMDebugPrintError(_ item: @autoclosure () -> Any){
    #if DEBUG
        debugPrint("BMKit ERROR | ", item())
    #endif
}


// MARK: -- 动态关联方法
// How to Use
//private var propertyKey: UInt8 = 0
//extension object{
//    var property: Object{
//        get{
//            return associatedObject(base: self, key: &propertyKey, initialiser: {
//                return object.Instance.self
//            })
//        }
//        set{
//            return associatedObject(base: self, key: &propertyKey, value: newValue)
//        }
//    }
//}

/// 动态关联类型方法
///     valueType : 关联对象类型
/// - Parameters:
///   - base: self
///   - key: UnsafePointer<UInt8>
///   - initialiser: () -> ValueType
/// - Returns: valueType
func associatedObject<ValueType : AnyObject>(base : AnyObject, key : UnsafePointer<UInt8>, initialiser: @escaping () -> ValueType) -> ValueType{
    if let associated = objc_getAssociatedObject(base, key) as? ValueType{
        return associated
    }
    let associated = initialiser()
    objc_setAssociatedObject(base, key, associated, .OBJC_ASSOCIATION_RETAIN)
    return associated
}

/// 动态关联类型方法
///     valueType : 关联对象类型
/// - Parameters:
///   - base: self
///   - key: UnsafePointer<UInt8>
///   - value: valueType
func associatedObject<ValueType : AnyObject>(base : AnyObject, key : UnsafePointer<UInt8>, value : ValueType){
    objc_setAssociatedObject(base, key, value, .OBJC_ASSOCIATION_RETAIN)
}


