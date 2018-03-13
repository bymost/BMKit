//
//  Reusable.swift
//  ZLZZKit
//
//  Created by mac on 17/8/21.
//  Copyright © 2017年 zlzz. All rights reserved.
//

import UIKit

public protocol Reusable: class {
    static var reuseIdentifier: String{get}
}

extension Reusable{
    public static var reuseIdentifier: String{
        return String(describing: Self.self)
    }
}
