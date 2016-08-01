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

func waitScene(ofSize size: CGSize) -> UIView {
    let overlay = UIView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: size))
    overlay.backgroundColor = UIColor(white: 0.2, alpha: 0.6)
    
    let whiteBackground = UIView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 141, height: 51)))
    whiteBackground.center = overlay.center
    whiteBackground.backgroundColor = UIColor.white()
    overlay.addSubview(whiteBackground)
    
    let greenBackground = UIView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 135, height: 45)))
    greenBackground.center = CGPoint(x: whiteBackground.frame.width / 2, y: whiteBackground.frame.height / 2)
    greenBackground.backgroundColor = UIColor(red: 161/255, green: 191/255, blue: 58/255, alpha: 1)
    whiteBackground.addSubview(greenBackground)
    
    let waitLabel = UILabel(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 135, height: 45)))
    waitLabel.text = "Please wait..."
    waitLabel.textColor = UIColor.white()
    waitLabel.textAlignment = .center
    waitLabel.font = UIFont(name: "Avenir-Black", size: 19)
    waitLabel.center = CGPoint(x: greenBackground.frame.width / 2, y: greenBackground.frame.height / 2)
    greenBackground.addSubview(waitLabel)
    
    return overlay
}
