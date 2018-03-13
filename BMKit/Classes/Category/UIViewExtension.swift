//
//  UIViewExtension.swift
//  tttw
//
//  Created by bymost on 2017/10/16.
//  Copyright © 2017年 zlzz. All rights reserved.
//

import UIKit

@objc extension UIView{
    
    class func getCurrentViewShot(view: UIView) -> UIImage?{
        UIGraphicsBeginImageContextWithOptions(view.frame.size, false, 0)
        let context = UIGraphicsGetCurrentContext()
        view.layer.render(in: context!)
        if view.drawHierarchy(in: view.bounds, afterScreenUpdates: true){
            let image = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            return image
        }
        return nil
    }
    
    /// 获取屏幕截图 webView不适用
    ///
    /// - Returns: 截图
    class func getFullScreenImage() -> UIImage{
        let window = UIApplication.shared.keyWindow!
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(window.frame.size, false, scale)
        let context = UIGraphicsGetCurrentContext()!
        window.layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
    class func getScrollViewShot(scrollView: UIScrollView) -> UIImage?{
        let savedContentOffset = scrollView.contentOffset
        let savedFrame = scrollView.frame
        scrollView.contentOffset = CGPoint.zero
        scrollView.frame = CGRect(x: 0, y: 0, width: scrollView.contentSize.width, height: scrollView.contentSize.height)
        let image = self.getCurrentViewShot(view: scrollView)
    
        scrollView.contentOffset = savedContentOffset
        scrollView.frame = savedFrame
        return image
    }
    
    
    /// 获得屏幕截图 适用webViewController
    ///
    /// - Returns: 截图
    class func getFullScreenSnapshot() -> UIImage?{
        guard let data = getDataWithSnapshotPNGFormat() else { return nil }
        return UIImage.init(data: data)
    }
    
    class func getDataWithSnapshotPNGFormat() -> Data?{
        var imageSize = CGSize.zero
        let orientation = UIApplication.shared.statusBarOrientation
        if UIInterfaceOrientationIsPortrait(orientation) {
            imageSize = UIScreen.main.bounds.size
        }else{
            imageSize = CGSize(width: UIScreen.main.bounds.height, height: UIScreen.main.bounds.width)
        }
        
        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0)
        guard let context = UIGraphicsGetCurrentContext() else { return nil}
        
        for window in UIApplication.shared.windows {
            context.saveGState()
            context.translateBy(x: window.center.x, y: window.center.y)
            context.concatenate(window.transform)
            context.translateBy(x: -window.bounds.width * window.layer.anchorPoint.x, y: -window.bounds.height * window.layer.anchorPoint.y)
            if orientation == .landscapeLeft{
                context.rotate(by: .pi/2)
                context.translateBy(x: 0, y: -imageSize.width)
            }else if orientation == .landscapeRight{
                context.rotate(by: -.pi/2)
                context.translateBy(x: -imageSize.height, y: 0)
            }else if orientation == .portraitUpsideDown{
                context.rotate(by: .pi)
                context.translateBy(x: -imageSize.width, y: -imageSize.height)
            }
            if window.responds(to: #selector(drawHierarchy(in:afterScreenUpdates:))){
                window.drawHierarchy(in: window.bounds, afterScreenUpdates: true)
            }else{
                window.layer.render(in: context)
            }
            context.restoreGState()
        }
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if image == nil { return nil }
        return UIImagePNGRepresentation(image!)
    }
}
