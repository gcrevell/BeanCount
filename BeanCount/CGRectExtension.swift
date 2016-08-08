//
//  CGRectExtension.swift
//  BeanCount
//
//  Created by Voltmeter Amperage on 8/8/16.
//  Copyright © 2016 Gabriel Revells. All rights reserved.
//

import UIKit

extension CGRect {
    var centerPoint: CGPoint {
        get {
            return CGPoint(x: self.width/2, y: self.height/2)
        }
    }
}
