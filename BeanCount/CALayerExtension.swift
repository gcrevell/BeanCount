//
//  CALayerExtension.swift
//  BeanCount
//
//  Created by Voltmeter Amperage on 8/23/16.
//  Copyright © 2016 Gabriel Revells. All rights reserved.
//

import UIKit

/*
 This code is taken from Stack Overflow user Dmitriiy Mitrophanskiy
 http://stackoverflow.com/questions/27987048/shake-animation-for-uitextfield-uiview-in-swift
 */
extension CALayer {
    
    func shake(duration: TimeInterval = TimeInterval(0.5)) {
        
        let animationKey = "shake"
        removeAnimation(forKey: animationKey)
        
        let kAnimation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        kAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        kAnimation.duration = duration
        
        var needOffset = frame.width * 0.15,
        values = [CGFloat]()
        
        let minOffset = needOffset * 0.1
        
        repeat {
            
            values.append(-needOffset)
            values.append(needOffset)
            needOffset *= 0.5
        } while needOffset > minOffset
        
        values.append(0)
        kAnimation.values = values
        add(kAnimation, forKey: animationKey)
    }
}
