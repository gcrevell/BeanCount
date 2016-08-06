//
//  StudentTagTableViewCell.swift
//  BeanCount
//
//  Created by Voltmeter Amperage on 8/3/16.
//  Copyright © 2016 Gabriel Revells. All rights reserved.
//

import UIKit

class StudentTagTableViewCell: UITableViewCell {

    @IBOutlet weak var mainTextField: UITextField!
    var displayedTag: StudentTags = .otherBook
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        mainTextField.addTarget(self, action: #selector(textFieldTyped), for: .allEditingEvents)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateTag() {
        mainTextField.leftView?.removeAllSubviews()
        
        mainTextField.placeholder = getTextPlaceholder(of: displayedTag)
        
        let imageView = UIImageView(frame: CGRect(x: 9, y: 9, width: 24, height: 24))
        imageView.image = getImage(of: displayedTag).withRenderingMode(.alwaysTemplate)
        imageView.contentMode = .scaleAspectFit
        
        mainTextField.leftView?.addSubview(imageView)
        
        if displayedTag == .phoneNumber {
            mainTextField.keyboardType = .phonePad
//            textFieldTyped()
        } else {
            mainTextField.keyboardType = .default
        }
    }
    
    func textFieldTyped() {
        if mainTextField.text?.characters.count == 0 {
            return
        }
        
        if displayedTag == .phoneNumber {
            let text = mainTextField.text!
            let numbers = text.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
            
            let characters = numbers.characters
            let formattedNumber = formatNumber(fromCharacters: characters)
            
            var index = characters.count + 1
            
            if characters.count > 2 {
                index += 2
            }
            
            if characters.count > 5 {
                index += 1
            }
            
            mainTextField.text = formattedNumber
            
            if let newPosition = mainTextField.position(from: mainTextField.beginningOfDocument, in: UITextLayoutDirection.right, offset: index) {
                
                mainTextField.selectedTextRange = mainTextField.textRange(from: newPosition, to: newPosition)
            }
        }
    }
    
    func formatNumber(fromCharacters _characters: String.CharacterView) -> String {
        var characters = _characters
        var finishedText = ""
        
        if characters.count > 10 {
            finishedText += "+"
            
            for character in characters {
                finishedText += "\(character)"
            }
            
            return finishedText
        }
        
        while characters.count < 10 {
            characters.append("_")
        }
        
        finishedText += "("
        
        var index = characters.startIndex
        var count = 0
        
        while count < 3 {
            finishedText += "\(characters[index])"
            index = characters.index(after: index)
            count += 1
        }
        
        finishedText += ") "
        
        while count < 6 {
            finishedText += "\(characters[index])"
            index = characters.index(after: index)
            count += 1
        }
        
        finishedText += "-"
        
        while count < 10 {
            finishedText += "\(characters[index])"
            index = characters.index(after: index)
            count += 1
        }
        
        return finishedText
    }

}
