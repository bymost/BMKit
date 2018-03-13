//
//  IBExtension.swift
//  tttw
//
//  Created by bymost on 2017/9/1.
//  Copyright © 2017年 zlzz. All rights reserved.
//

import UIKit

//Mark: - localizeKey

extension UILabel{
    @IBInspectable var localizeKey: String?{
        get { return text}
        set {
            guard let newValue = newValue else { return }
            text = NSLocalizedString(newValue, comment: "")
        }
    }
}


extension UIButton {
    @IBInspectable var localizeKey: String?{
        get { return titleLabel?.text }
        set {
            guard let newValue = newValue else { return }
            setTitle(NSLocalizedString(newValue, comment: ""), for: .normal)
        }
    }
}

extension UITextField {
    @IBInspectable var localizeKey: String? {
        get { return placeholder }
        set {
            guard let newValue = newValue else { return }
            placeholder = NSLocalizedString(newValue, comment: "")
        }
    }
}


// Mark: - cornerRadius
extension UIView{
    @IBInspectable var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
}
