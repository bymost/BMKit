//
//  StringExtension.swift
//  tttw
//
//  Created by bymost on 2017/6/6.
//  Copyright © 2017年 zlzz. All rights reserved.
//

import UIKit

extension String{
    /// 截取字符串
    ///
    /// - Parameters:
    ///   - start: 开始位置
    ///   - length: 长度， -1为全部
    /// - Returns: 截取的字符串
    public func subString(start:Int, length: Int = -1) -> String {
        var len = length
        if len == -1 {
            len = count - start
        }
        let start = self.index(startIndex, offsetBy: start)
        let end = self.index(start, offsetBy: len)
        let range = start ..< end
        //        return substring(with: range)
        return String(self[range])
    }
    
    
    
    // MARK: - 时间格式化
    
    /// 自定义时间格式化
    ///
    /// - Parameters:
    ///   - formatter: 格式
    /// - Returns: 格式化后的时间
    public func toDateFormatter(formatter: String) -> String {
        return toDateFormatter(from: "yyyy-MM-dd", to: formatter)
    }
    
    public func toDateFormatter(from fromFormatter: String, to toFormatter: String) -> String {
        let dateFormat: DateFormatter = DateFormatter.init()
        dateFormat.dateFormat = fromFormatter
        dateFormat.timeZone = TimeZone.init(identifier: "UTC")
        if let date = dateFormat.date(from: self){
            dateFormat.dateFormat = toFormatter
            return dateFormat.string(from: date)
        }
        return self
    }
    
    //MARK:- 正则匹配
    /// - Parameters:
    ///   - pattern: 需要匹配的正则表达式字符串
    ///   - Returns: 是否匹配成功
    public func match(pattern : String) -> Bool {
        do {
            let regex = try NSRegularExpression.init(pattern: pattern, options: .caseInsensitive)
            let matches = regex.matches(in: self, options: [], range: NSMakeRange(0, self.utf16.count))
            return matches.count > 0
        } catch {
            return false
        }
    }
    /// 密码判断 密码不能是纯数字或纯字母 长度大于6位
    public func isRightPassword() -> Bool {
        let passwordPattern = "^(?:\\d+|[a-zA-Z]+)$"
        let lengthPattern = "^\\S{1,5}$"
        return !match(pattern: passwordPattern) && !match(pattern: lengthPattern)
    }
    
    //MD5 加密
    public var md5: String{
        if let data = self.data(using: .utf8, allowLossyConversion: true) {
            let message = data.withUnsafeBytes { (bytes) -> [UInt8] in
                return Array(UnsafeBufferPointer(start: bytes, count: data.count))
            }
            
            let MD5Calculate = MD5(message)
            let MD5Data = MD5Calculate.calculate()
            
            var MD5String = String()
            for c in MD5Data {
                MD5String += String(format: "%02x", c)
            }
            return MD5String
        }else{
            return self
        }
    }
}



