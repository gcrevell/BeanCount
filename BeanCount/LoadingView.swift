//
//  LoadingView.swift
//  BeanCount
//
//  Created by Voltmeter Amperage on 8/22/16.
//  Copyright © 2016 Gabriel Revells. All rights reserved.
//

import UIKit

@IBDesignable
class LoadingView: UIView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let blur = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: nil)
        blurView.frame = frame
        self.addSubview(blurView)
        
        UIView.animate(withDuration: 0.3, animations: {
            blurView.effect = blur
        }) { (completed) in
            self.addSubview(self.pleaseWaitBlock())
        }
    }
    
    override func prepareForInterfaceBuilder() {
        awakeFromNib()
    }
    
    func pleaseWaitBlock() -> UIView {
        let whiteBackground = UIView(frame: CGRect(origin: CGPoint(x: 0,
                                                                   y: 0),
                                                   
                                                   size: CGSize(width: 139,
                                                                height: 49)))
        whiteBackground.center = self.center
        whiteBackground.backgroundColor = UIColor.white
        
        let greenBackground = UIView(frame: CGRect(origin: CGPoint(x: 0,
                                                                   y: 0),
                                                   
                                                   size: CGSize(width: 135,
                                                                height: 45)))
        greenBackground.center = CGPoint(x: whiteBackground.frame.width / 2,
                                         y: whiteBackground.frame.height / 2)
        greenBackground.backgroundColor = UIColor(red: 161/255,
                                                  green: 191/255,
                                                  blue: 58/255,
                                                  alpha: 1)
        whiteBackground.addSubview(greenBackground)
        
        let waitLabel = UILabel(frame: CGRect(origin: CGPoint(x: 0,
                                                              y: 0),
                                              
                                              size: CGSize(width: 135,
                                                           height: 45)))
        waitLabel.text = "Please wait..."
        waitLabel.textColor = UIColor.white
        waitLabel.textAlignment = .center
        waitLabel.font = UIFont(name: themeFontBold,
                                size: 19)
        waitLabel.center = CGPoint(x: greenBackground.frame.width / 2,
                                   y: greenBackground.frame.height / 2)
        greenBackground.addSubview(waitLabel)
        
        return whiteBackground
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
