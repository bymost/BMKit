//
//  ArrayExtension.swift
//  ZLZZKit
//
//  Created by bymost on 2017/8/28.
//  Copyright © 2017年 zlzz. All rights reserved.
//

import UIKit

extension Array{
    /// 去重
    public func filterDuplicates<E: Equatable>(_ filter: (Element) -> E) -> [Element] {
        var result = [Element]()
        for value in self {
            let key = filter(value)
            if !result.map({ filter($0)}).contains(key) {
                result.append(value)
            }
        }
        return result
    }
}

