//
//  UILabelExtension.swift
//  BeanCount
//
//  Created by Voltmeter Amperage on 8/28/16.
//  Copyright © 2016 Gabriel Revells. All rights reserved.
//

import UIKit

extension UILabel {
    
    func setTextWithTypeAnimation(typedText: String, characterInterval: TimeInterval = 0.25) {
        text = ""
        
        DispatchQueue(label: "").async {
            for character in typedText.characters {
                DispatchQueue.main.async {
                    self.text = self.text! + String(character)
                }
                Thread.sleep(forTimeInterval: characterInterval)
            }
        }
    }
    
    func deleteTextWithAnimation(characterInterval: TimeInterval) {
        DispatchQueue(label: "").async {
            for _ in 0..<self.text!.characters.count {
                DispatchQueue.main.async {
                    self.text!.remove(at: self.text!.startIndex)
                }
                Thread.sleep(forTimeInterval: characterInterval)
            }
        }
    }
}
