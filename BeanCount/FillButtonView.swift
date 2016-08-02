//
//  FillButtonView.swift
//  BeanCount
//
//  Created by Voltmeter Amperage on 8/1/16.
//  Copyright © 2016 Gabriel Revells. All rights reserved.
//

import UIKit

@IBDesignable

class FillButtonView: UIView {
    
    var active: Bool = true
    
    let AD = UIApplication.shared().delegate as! AppDelegate
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        let color = AD.myThemeColor()
        
        let outer = CGRect(x: 1, y: 1, width: rect.width - 2, height: rect.height - 2)
        
        var path = UIBezierPath(ovalIn: outer)
        color.setStroke()
        path.lineWidth = 2
        path.stroke()
        
        if active {
            let inner = CGRect(x: 5, y: 5, width: rect.width - 10, height: rect.height - 10)
            
            path = UIBezierPath(ovalIn: inner)
            color.setFill()
            path.fill()
        }
    }
    
}
