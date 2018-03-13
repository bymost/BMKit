//
//  BMCustomError.swift
//  BMKit
//
//  Created by bymost on 14/03/2018.
//

import UIKit
import SwiftyJSON

public enum BMError: Int{
    case noLogin = -2                /**< 未登录*/
    case noConnectServer = -1004     /**< 不能连接到服务器*/
    case requestFailed = -1006       /**< 请求失败*/
    case requestNotFound = -1011     /**< 未找到服务*/
    case requestTimeout = -1001      /**< 请求超时*/
    case noNetwork = -1009           /**< 无网络连接*/
    case argumentInvalidate = -1016  /**< 参数格式错误*/
    case tokenInvalidate = -10002    /**< taken失效*/
    case othersRequestError = -10099 /**< 其他请求错误*/
    case unknowError = -99999        /**< 默认值 */
}

public struct BMCustomError: CustomNSError{
    public static let errorDomain = "BMAppSwiftError"
    public private(set) var errorCode: Int = 0
    public var errorUserInfo = [String: Any]()
    public var description: String{
        return String(format: "error %@[%d]: %@", ZLCustomError.errorDomain, errorCode, errorUserInfo[NSLocalizedDescriptionKey] as? String ?? "nil")
    }
    public init(reCode: Int?, reMsg: String?) {
        if let _ = reMsg, let code = reCode{
            var message:String?
            var errCode = code
            #if DEBUG
                message = reMsg
            #else
                if let error = BMError.init(rawValue: errCode) {
                    switch error {
                    case BMError.noConnectServer:
                        message = "不能连接到服务器，请稍候再试"
                    case BMError.requestFailed:
                        message = "请求失败"
                    case BMError.requestNotFound:
                        message = "未找到服务，请稍后再试"
                    case BMError.requestTimeout:
                        message = "请求超时，请检查网络"
                    case BMError.noNetwork:
                        message = "无网络连接，请检查网络"
                    case BMError.argumentInvalidate:
                        message = "请求参数格式错误"
                    default:
                        message = reMsg ?? "服务器错误，请稍候再试"
                    }
                }else{
                    message = reMsg ?? "未知错误，请稍候再试"
                    errCode = ZLError.unknowError.rawValue
                }
            #endif
            errorCode = errCode
            errorUserInfo[NSLocalizedDescriptionKey] = message
        }
    }
}
