//
//  UIImageExtension.swift
//  BeanCount
//
//  Created by Voltmeter Amperage on 8/31/16.
//  Copyright © 2016 Gabriel Revells. All rights reserved.
//

import UIKit

extension UIImage {
    enum Image: String {
        case redX = "red x.png"
        case greenCheck = "green check.png"
    }
    
    convenience init(_ image: Image) {
        self.init(named: image.rawValue)!
    }
}
