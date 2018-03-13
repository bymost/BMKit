//
//  UIImageExtention.swift
//  ZLZZKit
//
//  Created by bymost on 2017/8/22.
//  Copyright © 2017年 zlzz. All rights reserved.
//

import UIKit

@objc public extension UIImage {
    /*
     * 根据给定的字节长度压缩图片 只压缩像素 不改变尺寸
     * 注意: 并不一定会将图片压缩到给定的值
     * UIImageJPEGRepresentation(_, _) 压缩图片存在极限值
     * UIImageJPEGRepresentation(_, _) 会严重消耗内存,
     */
    public func dataSmallerThan(dataLength: Int) -> Data {
        var compressionQuality: CGFloat = 1.0;
        var data = UIImageJPEGRepresentation(self, compressionQuality)!
        var limit = 0 //极限值 并不是所有图片都可以压缩到指定大小 压缩到最小后 将不会在进行压缩
        while (data.count > dataLength) && (limit != data.count) {
            compressionQuality *= 0.9
            limit = data.count
            data = UIImageJPEGRepresentation(self, compressionQuality)!
        }
        return data
    }
    
    public func dataForUpload() -> Data{
        return dataSmallerThan(dataLength: 1024 * 1000)// 限制1MB
    }
    
    public class func imageWithColor(color: UIColor) -> UIImage{
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context: CGContext = UIGraphicsGetCurrentContext()!
        context.setFillColor(color.cgColor)
        context.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    /// 获得图片圆角
    ///
    /// - Parameters:
    ///   - size: 需要大小
    ///   - radiu: 圆角半径
    /// - Returns: optional(image)
    public func clipImage(size: CGSize, radiu: CGFloat) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        defer {
            UIGraphicsEndImageContext()
        }
        let rect = CGRect(origin: .zero, size: size)
        if let context = UIGraphicsGetCurrentContext(){
            context.addPath(UIBezierPath(roundedRect: rect, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: radiu, height: radiu)).cgPath)
            context.clip()
            self.draw(in: rect)
            let outImage = UIGraphicsGetImageFromCurrentImageContext()
            return outImage
        }
        return nil
    }
}

