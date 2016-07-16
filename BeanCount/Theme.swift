//
//  Theme.swift
//  BeanCount
//
//  Created by Voltmeter Amperage on 7/16/16.
//  Copyright © 2016 Gabriel Revells. All rights reserved.
//

import UIKit

func style(segmentedControl: UISegmentedControl, fontName: String, selectedColor: UIColor, unselectedColor: UIColor, dividerColor: UIColor) {
    let font = UIFont(name: fontName, size: 13)
    
    let segBG = drawImage(ofSize: CGSize(width: 50, height: 30), andColor: unselectedColor)
    let segSelectedBG = drawImage(ofSize: CGSize(width: 50, height: 30), andColor: selectedColor)
    let segDividerImage = drawImage(ofSize: CGSize(width: 1, height: 30), andColor: dividerColor)
    
    segmentedControl.setBackgroundImage(segBG, for: [], barMetrics: .default)
    segmentedControl.setBackgroundImage(segSelectedBG, for: .selected, barMetrics: .default)
    segmentedControl.setDividerImage(segDividerImage, forLeftSegmentState: [], rightSegmentState: [], barMetrics: .default)
    
    let shadow = NSShadow()
    shadow.shadowOffset = CGSize(width: 0, height: 0)
    
    segmentedControl.setTitleTextAttributes([NSForegroundColorAttributeName : UIColor.lightGray(),
                                          NSFontAttributeName : font!,
                                          NSShadowAttributeName : shadow], for: [])
    
    segmentedControl.setTitleTextAttributes([NSForegroundColorAttributeName : UIColor.white(),
                                          NSFontAttributeName : font!,
                                          NSShadowAttributeName : shadow], for: .selected)
}

func drawImage(ofSize size:CGSize, andColor color:UIColor) -> UIImage {
    UIGraphicsBeginImageContext(size)
    let currentContext = UIGraphicsGetCurrentContext()
    let fillRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
    
    currentContext?.setFillColor(color.cgColor)
    currentContext?.fill(fillRect)
    
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return image!
}
