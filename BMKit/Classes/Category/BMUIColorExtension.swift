//
//  BMUIColorExtension.swift
//  BMKit
//
//  Created by bymost on 14/03/2018.
//

import UIKit

@objc extension UIColor{
    /// HEX TO RGBA
    ///
    /// - Parameter rgba: RGBA's String
    public convenience init(rgba: String){
        var red:   CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue:  CGFloat = 0.0
        var alpha: CGFloat = 1.0
        
        if rgba.hasPrefix("#") {
            let hex = rgba.subString(start: 1, length: -1)
            let scanner = Scanner(string: hex)
            var hexValue: CUnsignedLongLong = 0
            if scanner.scanHexInt64(&hexValue) {
                switch (hex.count) {
                case 3:
                    red   = CGFloat((hexValue & 0xF00) >> 8) / 15.0
                    green = CGFloat((hexValue & 0x0F0) >> 4) / 15.0
                    blue  = CGFloat((hexValue & 0x00F)) / 15.0
                case 4:
                    red   = CGFloat((hexValue & 0xF000) >> 12) / 15.0
                    green = CGFloat((hexValue & 0x0F00) >> 8)  / 15.0
                    blue  = CGFloat((hexValue & 0x00F0) >> 4)  / 15.0
                    alpha  = CGFloat((hexValue & 0x000F)) / 15.0
                case 6:
                    red   = CGFloat((hexValue & 0xFF0000) >> 16) / 255.0
                    green = CGFloat((hexValue & 0x00FF00) >> 8) / 255.0
                    blue  = CGFloat((hexValue & 0x0000FF)) / 255.0
                case 8:
                    red   = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
                    green = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
                    blue  = CGFloat((hexValue & 0x0000FF00) >> 8) / 255.0
                    alpha = CGFloat((hexValue & 0x0000FF00)) / 255.0
                default:
                    print("Invalid RGB string, number of characters after '#' should be either 3, 4, 6 or 8", terminator: "")
                }
            } else {
                print("Scan hex error")
            }
        }else {
            print("Invalid RGB string, missing '#' as prefix", terminator: "")
        }
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    public class func getPixelColor(location point: CGPoint, inImage image: UIImage) -> UIColor?{
        guard let imageRef = image.cgImage else{ return nil}
        
        let width = imageRef.width
        let height = imageRef.height
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let rawData: UnsafeMutablePointer<CGFloat> = UnsafeMutablePointer<CGFloat>.allocate(capacity: 4 * height * width)
        defer{
            free(rawData)
        }
        let bytesPerPixel = 4
        let bitsPerCompontent = 8
        let bytesPerRow = bytesPerPixel * width
        
        let context: CGContext = CGContext.init(data: rawData, width: width, height: height, bitsPerComponent: bitsPerCompontent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: CGBitmapInfo.init(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue).rawValue)!
        
        //图片rect
        let rect = CGRect(x: 0, y: 0, width: width, height: height)
        
        // 画到位图中
        context.draw(imageRef, in: rect)
        // 获得数据
        let data = unsafeBitCast(context.data, to: UnsafeMutablePointer<CUnsignedChar>.self)
        
        // 根据当前所选择的点计算出对应位图数据的index
        let offset = 4 * (imageRef.width * Int(point.y) + Int(point.x))
        
        let alpha = (data + offset).pointee
        let red = (data + offset + 1).pointee
        let green = (data + offset + 2).pointee
        let blue = (data + offset + 3).pointee
        
        let color = UIColor.init(red: CGFloat(red)/255, green: CGFloat(green)/255, blue: CGFloat(blue)/255, alpha: CGFloat(alpha)/255)
        return color
    }
    
    /// 颜色相似度对比
    ///
    /// - Parameters:
    ///   - compareColor: 对比颜色
    ///   - similar: 相似度， 0 - 1 相似度递减
    /// - Returns: 是否符合相似度
    public func isSimilarColor(compareColor: UIColor, similar: CGFloat) -> Bool{
        if similar >= 1.0 {
            return self.cgColor == compareColor.cgColor
        }else{
            let diff = getSimilar(compareColor: compareColor)
            return diff <= similar
        }
    }
    
    /// 判断颜色相似度
    ///
    /// - Parameter compareColor: 对比颜色(色域空间为4)
    /// - Returns: 相似du
    public func getSimilar(compareColor: UIColor) -> CGFloat{
        guard self.cgColor.numberOfComponents == 4, compareColor.cgColor.numberOfComponents == 4 else {
            return 0
        }
        let alpha1 = self.cgColor.components![0]
        let red1 = self.cgColor.components![1] * 255
        let green1 = self.cgColor.components![2] * 255
        let blue1 = self.cgColor.components![3] * 255
        print(alpha1, red1, green1, blue1)
        
        let alpha2 = compareColor.cgColor.components![0]
        let red2 = compareColor.cgColor.components![1] * 255
        let green2 = compareColor.cgColor.components![2] * 255
        let blue2 = compareColor.cgColor.components![3] * 255
        print(alpha2, red2, green2, blue2)
        
        let diff = pow(pow((red1 - red2), 2) + pow((green1 - green2), 2) + pow((blue1 - blue2), 2), 0.5) / 441.7
        return diff
    }
}
