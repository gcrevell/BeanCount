//
//  RoundedSegmentedControl.swift
//  BeanCount
//
//  Created by Voltmeter Amperage on 8/9/16.
//  Copyright © 2016 Gabriel Revells. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedSegmentedControl: UISegmentedControl {
    
    var cornerRadius: CGFloat {
        set {
            
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }
    
    override func prepareForInterfaceBuilder() {
        awakeFromNib()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.clipsToBounds = true
        cornerRadius = 3
        
        let segBG = drawImage(ofSize: CGSize(width: 50, height: 30), andColor: UIColor.white)
        
        let selectedSegBackground = drawImage(ofSize: CGSize(width: 50,
                                                             height: 30),
                                              andColor: UIColor(red: 58/255,
                                                                green: 58/255,
                                                                blue: 58/255,
                                                                alpha: 1))
        
        let divider = drawImage(ofSize: CGSize(width: 1,
                                               height: 30),
                                andColor: UIColor(red: 192/255,
                                                  green: 192/255,
                                                  blue: 192/255,
                                                  alpha: 1))
        
        self.setBackgroundImage(segBG, for: [], barMetrics: .default)
        self.setBackgroundImage(selectedSegBackground, for: [.selected], barMetrics: .default)
        self.setDividerImage(divider, forLeftSegmentState: [], rightSegmentState: [], barMetrics: .default)
        
        #if !TARGET_INTERFACE_BUILDER
            
            print(NSFontAttributeName)
            
//            self.setTitleTextAttributes([NSForegroundColorAttributeName : UIColor.lightGray,
//                                         NSFontAttributeName : themeFontBold], for: [])
//            self.setTitleTextAttributes([NSForegroundColorAttributeName : UIColor.lightGray,
//                                         NSFontAttributeName : themeFontBold], for: .selected)
            
            self.setTitleTextAttributes([NSForegroundColorAttributeName : UIColor.lightGray], for: [.normal, .selected])
            
            let AD = UIApplication.shared.delegate as! AppDelegate
            self.selectedSegmentIndex = AD.selectedTheme != Theme.None ? AD.selectedTheme!.rawValue - 1 : 0
            
            self.addTarget(self, action: #selector(updateValue), for: .valueChanged)
        #endif
    }
    
    func updateValue() {
        let AD = UIApplication.shared.delegate as! AppDelegate
        AD.selectedTheme = Theme(rawValue: self.selectedSegmentIndex + 1)
    }
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}
