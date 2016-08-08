//
//  FillButtonView.swift
//  BeanCount
//
//  Created by Voltmeter Amperage on 8/1/16.
//  Copyright © 2016 Gabriel Revells. All rights reserved.
//

import UIKit

//@IBDesignable

class FillButtonView: UIView {
    
    var active: Bool = true
    
    let AD = UIApplication.shared.delegate as! AppDelegate
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        #if !TARGET_INTERFACE_BUILDER
            // this code will run in the app itself
            let color = AD.myThemeColor()
            let size = rect.width
        #else
            // this code will execute only in IB
            let color = UIColor.blue
            let size = 25
        #endif
        
        let outer = CGRect(x: 1, y: 1, width: size - 2, height: size - 2)
        
        var path = UIBezierPath(ovalIn: outer)
        color.setStroke()
        path.lineWidth = 2
        path.stroke()
        
        if active {
            let inner = CGRect(x: 5, y: 5, width: size - 10, height: size - 10)
            
            path = UIBezierPath(ovalIn: inner)
            color.setFill()
            path.fill()
        }
    }
    
}
