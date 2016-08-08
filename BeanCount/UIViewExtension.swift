//
//  UIViewExtension.swift
//  BeanCount
//
//  Created by Voltmeter Amperage on 8/8/16.
//  Copyright © 2016 Gabriel Revells. All rights reserved.
//

import UIKit

extension UIView {
    func removeAllSubviews() {
        for view in self.subviews {
            view.removeFromSuperview()
        }
    }
}
