//
//  RoundedTextField.swift
//  BeanCount
//
//  Created by Voltmeter Amperage on 8/6/16.
//  Copyright © 2016 Gabriel Revells. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedTextField: UITextField {
    
    @IBInspectable var cornerRadius: CGFloat = 3 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    
    @IBInspectable override var placeholder: String? {
        get {
            return super.placeholder
        }
        set {
            super.placeholder = newValue
            if newValue != nil {
                self.attributedPlaceholder = NSAttributedString(string: newValue!,
                                                                attributes: [NSFontAttributeName : UIFont(name: themeFont, size: 16)!])
            }
        }
    }
    
    @IBInspectable var leftImage: UIImage? {
        didSet {
            if leftImage == nil {
                leftImageView = nil
                leftImageContainer = nil
                leftView = nil
                
                return
            }
            
            if renderLeftTemplate {
                leftImage = leftImage?.withRenderingMode(.alwaysTemplate)
            } else {
                leftImage = leftImage?.withRenderingMode(.alwaysOriginal)
            }
            
            leftImageContainer = UIView(frame: CGRect(x: 0,
                                                      y: 0,
                                                      width: 41,
                                                      height: 41))
            leftImageView = UIImageView(frame: CGRect(x: 9,
                                                      y: 9,
                                                      width: 23,
                                                      height: 23))
            
            leftImageView?.image = leftImage
            leftImageView?.contentMode = .scaleAspectFit
            leftImageContainer?.addSubview(leftImageView!)
            leftImageContainer?.backgroundColor = UIColor(white: 0.9, alpha: 1)
            self.leftViewMode = UITextFieldViewMode.always
            self.leftView = leftImageContainer
        }
    }
    
    var leftImageView: UIImageView?
    var leftImageContainer: UIView?
    @IBInspectable var renderLeftTemplate: Bool = false {
        didSet {
            if renderLeftTemplate {
                leftImage = leftImage?.withRenderingMode(.alwaysTemplate)
            } else {
                leftImage = leftImage?.withRenderingMode(.alwaysOriginal)
            }
        }
    }
    
    var rightImage: UIImage? {
        didSet {
            if rightImage == nil {
                rightImageView = nil
                rightImageContainer = nil
                rightView = nil
                
                return
            }
            
            if renderRightTemplate {
                rightImage = rightImage?.withRenderingMode(.alwaysTemplate)
            } else {
                rightImage = rightImage?.withRenderingMode(.alwaysOriginal)
            }
            
            rightImageContainer = UIView(frame: CGRect(x: 0,
                                                      y: 0,
                                                      width: 41,
                                                      height: 41))
            rightImageView = UIImageView(frame: CGRect(x: 9,
                                                      y: 9,
                                                      width: 23,
                                                      height: 23))
            
            rightImageView?.image = rightImage
            rightImageView?.contentMode = .scaleAspectFit
            rightImageContainer?.addSubview(rightImageView!)
            rightImageContainer?.backgroundColor = UIColor(white: 0.9, alpha: 1)
            self.rightViewMode = UITextFieldViewMode.always
            self.rightView = rightImageContainer
        }
    }
    
    var rightImageView: UIImageView?
    var rightImageContainer: UIView?
    @IBInspectable var renderRightTemplate: Bool = false {
        didSet {
            if renderRightTemplate {
                rightImage = rightImage?.withRenderingMode(.alwaysTemplate)
            } else {
                rightImage = rightImage?.withRenderingMode(.alwaysOriginal)
            }
        }
    }
    
    override func awakeFromNib() {
        self.cornerRadius = 3
        self.font = UIFont(name: themeFont, size: 16)
        self.backgroundColor = .white
    }
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}
