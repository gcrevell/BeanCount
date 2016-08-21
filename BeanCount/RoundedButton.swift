//
//  RoundedButton.swift
//  BeanCount
//
//  Created by Voltmeter Amperage on 8/6/16.
//  Copyright © 2016 Gabriel Revells. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedButton: UIButton {
    
    var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
        get {
            return layer.cornerRadius
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // Initialization code
        cornerRadius = 3
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        cornerRadius = 3
    }
    
    override func prepareForInterfaceBuilder() {
        awakeFromNib()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setTitleColor(UIColor.white, for: [])
        self.setTitleColor(UIColor(white: 1, alpha: 0.5), for: .highlighted)
        self.titleLabel?.font = UIFont(name: themeFontBold, size: 20)
        self.backgroundColor = UIColor(red: 246/255, green: 175/255, blue: 41/255, alpha: 1)
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
     */

}
